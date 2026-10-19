//
//  CardManager.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/23/25.
//

import Foundation
import SwiftUI
import OSLog
import Forge

@Observable
class CardManager {
    
    private let client: any SFClient
    
    private(set) var card: SFCard?
    
    private(set) var prints: [SFCard] = []
    private(set) var rulings: [SFRuling] = []
    private(set) var otherParts: [SFCard] = []
    private(set) var set: SFSet? = nil
    
    var filteredParts: [SFCard] {
        return otherParts.filter({ !$0.name.hasPrefix("A-")})
    }
    
    var appState: AppState = .loading
    
    enum AppState: Equatable {
        case loading
        case success
        case failure(String)
    }
    
    init(
        card: SFCard? = nil,
        client: SFClient = ForgeClient(session: .scryfallSession())
    ) {
        self.client = client
        self.card = card
        self.appState = (card == nil) ? .loading : .success
    }
    
    // MARK: - Setup
    func setup(initialCard: SFCard?, identifier: CardIdentifier?) async {
        if let initialCard {
            self.card = initialCard
            self.appState = .success
        } else if let identifier {
            self.appState = .loading
            await loadCard(for: identifier)
        }
        
        if case .success = appState {
            await fetchAllSecondaryData()
        }
    }
    
    // MARK: - Load card from string or scryfallID
    func loadCard(for identifier: CardIdentifier) async {
        do {
            switch identifier {
            case .scryfallID(let scryfallID):
                let fetchedCard = try await client.getSpecificCard(id: scryfallID)
                card = fetchedCard
                appState = .success
            case .rawString(let rawString):
                
                /*
                 reminder to future me:
                 .rawString option is needed to support scryfall's autocomplete endpoint as it only returns strings
                 this path loads all matches for the tapped string and then filters down to the only result that has the same exact name
                 */
                
                let fetchedCards = try await client.getCardsSearch(query: rawString)
                
                /*
                 this is dumb
                 
                 - user searches for "the one ring"
                 - https://api.scryfall.com/cards/autocomplete?q=the-one-ring returns
                 "the one ring"
                 "a-the one ring"
                 - https://api.scryfall.com/cards/search?q=the-one-ring returns an array with "a-the one ring" at index zero
                 
                 so we need to match the selected string with the name of the card object in the array rather than be lazy and do .first
                 */
                
                guard let match = fetchedCards.first(where: { $0.name == rawString }) else {
                    appState = .failure("No match found")
                    return
                }
                card = match
                appState = .success
                debugLog.log("Card loaded: \(match.name)")
            }
        } catch let error as FetchError {
            appState = .failure(error.errorDescription)
        } catch let error as URLError {
            appState = .failure(error.localizedDescription)
        } catch {
            appState = .failure("An unknown error occurred.")
        }

    }
    
    // MARK: - card extras
    func fetchRulings() async {
        guard let card else { return }
        
        do {
            let fetchedRulings = try await client.fetchRulingsForCard(rulingURL: card.rulingsURI)
            self.rulings = fetchedRulings
            debugLog.log("Rulings fetched for \(card.name): \(self.rulings.count)")
        } catch {
            debugLog.error("Error fetching rulings: \(error)")
        }
    }
    
    func fetchPrints() async {
        guard let card else { return }
        
        do {
            let fetchedPrints = try await client.fetchSpecificURLMultiple(url: card.printsSearchURI)
            let filteredPrints = fetchedPrints.filter { $0.id != card.id}
            self.prints = filteredPrints
            debugLog.log("Prints fetched for \(card.name): \(self.prints.count)")
        } catch {
            debugLog.error("Error fetching prints: \(error)")
        }
    }
    
    func fetchAllParts() async {
        guard let card, let allParts = card.allParts else { return }
        guard otherParts.isEmpty else { return }
        
        do {
            async let fetchedParts: [SFCard] = withTaskGroup(of: SFCard?.self) { group in
                for part in allParts where part.name != card.name {
                    group.addTask {
                        try? await self.client.fetchSpecificURLSingle(cardURL: part.uri)
                    }
                }
                var results: [SFCard] = []
                for await result in group {
                    if let result { results.append(result) }
                }
                return results
            }
            otherParts = await fetchedParts
        }
    }
    
    func fetchSet() async {
        guard let card else { return }
        
        do {
            let fetchedSet = try await client.fetchSpecificSet(setURI: card.setURI)
            self.set = fetchedSet
            debugLog.log("Set fetched: \(fetchedSet.name)")
        } catch {
            debugLog.error("Error fetching set: \(error)")
        }
    }
    
    func fetchAllSecondaryData() async {
        
        guard prints.isEmpty, rulings.isEmpty, otherParts.isEmpty else { return }
        
        async let prints = fetchPrints()
        async let set = fetchSet()
        async let rulings = fetchRulings()
        async let parts = fetchAllParts()
        _ = await (prints, set, rulings, parts)
    }
        
}


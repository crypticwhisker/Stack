//
//  SearchManager.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/12/25.
//

import Foundation
import SwiftUI
import Observation
import OSLog
import Forge

@Observable
class SearchManager {
    
//    private let client: SFClient = .shared
    private let client: ForgeClient = .shared
    
    var query: String = ""
    var searchHistory: [String] = []
    
    private(set) var result: SFList<SFCard>? = nil
    private(set) var cards: [SFCard] = []
    private(set) var sets: [SFSet] = []
    private(set) var prints: [SFCard] = []
    
    private(set) var randomCard: SFCard? = nil
    
    var appState: AppState = .loading
    var pagination: Pagination = .loadedNextPage
    
    enum AppState {
        case loading
        case success
        case failure(String)
    }
    
    enum Pagination {
        case loadingNextPage
        case loadedNextPage
        case endReached
    }
    
    // Random card
    func fetchRandomCard() async {
        do {
            let randomCardResult = try await client.fetchRandomCard()
            randomCard = randomCardResult
        } catch {
            debugLog.error("\(error.localizedDescription)")
        }
    }
    
    // Search results
    func fetchSearchResults(for query: String) async {
        do {
            self.query = query
            let searchResults = try await client.getCardsSearch(for: query)
            result = searchResults
            cards = searchResults.data
            appState = .success
        } catch let error as FetchError {
            cards = []
            appState = .failure(error.errorDescription)
        } catch {
            appState = .failure(error.localizedDescription)
        }
    }
    
    // Set list
    func fetchSetList() async {
        do {
            let allSets = try await client.fetchAllSets()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let validSets = allSets
                .filter { $0.cardCount > 0 }
                .compactMap { set -> (SFSet, Date)? in
                    guard let dateString = set.releasedAt, let date = dateFormatter.date(from: dateString) else { return nil }
                    return (set, date)
                }
                .map { $0.0 } // first element of tuple
            
            appState = .success
            sets = validSets
        } catch let error as FetchError {
            appState = .failure(error.errorDescription)
        } catch {
            appState = .failure("An unknown error occurred.")
        }
    }
    
    // Cards for tapped set
    func fetchSetCards(for set: SFSet) async {
        do {
            let fetchedSetCards = try await client.fetchSpecificURL(for: set.searchURI)
            result = fetchedSetCards
            cards = fetchedSetCards.data
            appState = .success
        } catch let error as FetchError {
            appState = .failure(error.errorDescription)
        } catch {
            appState = .failure("An unknown error occurred.")
        }
    }
    
    // Pagination
    func fetchNextPage(for nextPageURL: String) async {

        guard pagination != .loadingNextPage else { return }
        
        pagination = .loadingNextPage
        
        do {
            let nextPage = try await client.fetchSpecificURL(for: nextPageURL)
            result = nextPage
            cards.append(contentsOf: nextPage.data)
            pagination = nextPage.hasMore ? .loadedNextPage : .endReached
        } catch {
            debugLog.error("\(error.localizedDescription)")
        }
    }
    
    // Debounced quick search
    func debounceSearch(for input: String) async -> [String] {
        
//        guard !input.contains(":") else { return [] }
        guard input.rangeOfCharacter(from: CharacterSet(charactersIn: "!:><=")) == nil else { return [] }
        
        do {
            try await Task.sleep(for: .seconds(0.5)) // matches rate limit of scryfall
            return try await client.fetchAutoComplete(for: input)
        } catch is CancellationError {
            debugLog.info("User is still typing, search task was cancelled")
        } catch {
            debugLog.error("Autocomplete errror: \(error)")
        }
        return []
    }
    
}

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
    
    private let client: any SFClient
    
    /// Sets the search value so that other views such as SearchResults can show what was searched
    private(set) var query: String = ""
    /// Result property is used to carry additional details, such as SFList.hasMore or SFList.nextPage
    private(set) var result: SFList<SFCard>? = nil
    private(set) var cards: [SFCard] = []
    private(set) var sets: [SFSet] = []
    private(set) var randomCard: SFCard? = nil
    
    private(set) var quickResults: [String] = []
    private(set) var searchHistory: [String] = []
    
    private(set) var appState: AppState = .loading
    private(set) var paginationState: PaginationState = .loadedNextPage
    
    enum AppState {
        case loading
        case success
        case failure(String)
    }
    
    enum PaginationState {
        case loadingNextPage
        case loadedNextPage
        case endReached
    }
    
    init(
        client: SFClient = ForgeClient(session: .scryfallSession())
    ) {
        self.client = client
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
            let searchResults = try await client.getCardsSearch(query: query)
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
            let fetchedSetCards = try await client.fetchSpecificURLMultiple(url: set.searchURI)
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

        guard paginationState != .loadingNextPage else { return }
        
        paginationState = .loadingNextPage
        
        do {
            let nextPage = try await client.fetchSpecificURLMultiple(url: nextPageURL)
            result = nextPage
            cards.append(contentsOf: nextPage.data)
            paginationState = nextPage.hasMore ? .loadedNextPage : .endReached
        } catch {
            debugLog.error("\(error.localizedDescription)")
        }
    }
    
    // Debounced quick search
    func debounceQuickSearch(for input: String) async {
        
        guard input.rangeOfCharacter(from: CharacterSet(charactersIn: "!:><=")) == nil else {
            debugLog.info("Syntax operator found, returning empty quick search array")
            self.quickResults = []
            return
        }
        
        do {
            try await Task.sleep(for: .seconds(0.5)) // matches rate limit of scryfall
            let results = try await client.fetchAutoComplete(query: input)
            self.quickResults = results
        } catch is CancellationError {
            debugLog.info("User is still typing, search task was cancelled")
        } catch {
            debugLog.error("Autocomplete errror: \(error)")
        }
    }
    
    func parseSearchStringAtCursor(
        string: String,
        cursor: String.Index
    ) -> ParsedSearchToken? {
        
        // Find the current token boundaries
        let leftBound = string[..<cursor]
            .lastIndex(of: " ")
            .map { string.index(after: $0) }
        ?? string.startIndex
        
        let rightBound = string[cursor...]
            .firstIndex(of: " ")
        ?? string.endIndex
        
        let token = string[leftBound..<rightBound]
        
        // Find the operator
        let operators = SyntaxOperator.allCases.sorted { $0.rawValue.count > $1.rawValue.count }
        
        guard
            let matchedOperator = operators.first(where: { token.range(of: $0.rawValue) != nil }),
            let operatorRange = token.range(of: matchedOperator.rawValue)
                else {
            return nil
        }
        
        // Extract the key and value around the operator
        let key = String(token[..<operatorRange.lowerBound])
        let value = String(token[operatorRange.upperBound...])
        let valueRange = operatorRange.upperBound..<rightBound
        
        // Find the syntax definition for this key
        guard
            let syntax = SyntaxCatalog.all.first(where: { $0.key.matches(key) }),
            syntax.operators.contains(matchedOperator)
                else {
            return nil
        }
        
        // Build suggestions
        let recommendations: [String]
        
        if value.isEmpty {
            recommendations = syntax.validValues.map(\.value)
        } else {
            
            // First check for matching aliases so that strings like "color:u" will recommend "blue"
            let aliasMatches = syntax.validValues.filter { item in
                item.aliases.contains {
                    $0.localizedCaseInsensitiveCompare(value) == .orderedSame
                }
            }
            
            if !aliasMatches.isEmpty {
                recommendations = aliasMatches.map(\.value)
            } else {
                recommendations = syntax.validValues.filter { item in
                    item.value.range(of: value, options: [.anchored, .caseInsensitive]) != nil &&
                    item.value.localizedCaseInsensitiveCompare(value) != .orderedSame
                }
                .map(\.value)
            }
        }
        
        return ParsedSearchToken(
            key: key,
            op: matchedOperator,
            value: value,
            recommendations: recommendations,
            replacementRange: valueRange
        )
    }
 
    func addToSearchHistory(_ string: String) {
        searchHistory.append(string)
    }
    
    func clearSearchHistory() {
        searchHistory.removeAll()
    }
    
    func clearQuickResults() {
        quickResults.removeAll()
    }
        
}

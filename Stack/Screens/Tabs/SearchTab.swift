//
//  SearchTab.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/6/25.
//

import SwiftUI

struct SearchTab: View {
    
    @Environment(Router.self) private var router
    
    @State private var isShowingSettings = false
    @State private var isSearching = false
    
    @State private var searchManager = SearchManager()
    @State private var searchText = ""
    @State private var searchSelection: TextSelection?
    
    private var parsedSearchToken: ParsedSearchToken? {
        guard
            isSearching,
            !searchText.isEmpty,
            let searchSelection,
            case let .selection(range) = searchSelection.indices
        else {
            return nil
        }
        
        let cursor = range.lowerBound
        
        guard cursor == searchText.endIndex || searchText.indices.contains(cursor) else {
            return nil
        }
        
        return searchManager.parseSearchStringAtCursor(
            string: searchText,
            cursor: cursor
        )
    }
    
    private var syntaxSuggestions: [String] {
        parsedSearchToken?.recommendations ?? []
    }
    
    var body: some View {
        List {
            if let parsedSearchToken, !parsedSearchToken.recommendations.isEmpty {
                Section("Syntax suggestions") {
                    ForEach(parsedSearchToken.recommendations, id: \.self) { suggestion in
                        Button(suggestion) {
                            searchText.replaceSubrange(parsedSearchToken.replacementRange, with: suggestion)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            if !searchManager.quickResults.isEmpty {
                Section("Quick results") {
                    ForEach(searchManager.quickResults, id: \.self) { match in
                        NavigationLink(value: Route.cardScreenFromIdentifier(.rawString(match))) {
                            Text(match)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, isPresented: $isSearching, prompt: "Search for a card")
        .searchSelection($searchSelection)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .onSubmit(of: .search) {
            router.searchTabRouter.navigationPath.append(Route.searchResults(searchText))
            if !searchManager.searchHistory.contains(searchText) {
                searchManager.addToSearchHistory(searchText)
            }
        }
        .customDarkMode()
        .task(id: searchText) {
            guard !searchText.isEmpty else {
                searchManager.clearQuickResults()
                return
            }
            await searchManager.debounceQuickSearch(for: searchText)
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
        .overlay {
            if searchManager.quickResults.isEmpty && syntaxSuggestions.isEmpty {
                ContentUnavailableView {
                    Label(searchManager.searchHistory.isEmpty ? "Start Typing" : "Search History", systemImage: "magnifyingglass")
                } description: {
                    if searchManager.searchHistory.isEmpty {
                        Text("Start typing for quick results or press enter to see full search results")
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(searchManager.searchHistory, id: \.self) { searchHistory in
                                Button {
                                    router.searchTabRouter.navigationPath.append(Route.searchResults(searchHistory))
                                } label: {
                                    Label(searchHistory, systemImage: "arrow.up.forward.circle")
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                }
                                .buttonStyle(.plain)
                                .font(.system(.caption, design: .monospaced))
                            }
                        }
                        .padding(.vertical, 10)
                    }
                } actions: {
                    if !searchManager.searchHistory.isEmpty {
                        Button {
                            searchManager.clearSearchHistory()
                        } label: {
                            Label {
                                Text("Clear search history")
                            } icon: {
                                Image(systemName: "x.circle")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(10)
                        .glassEffect()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Settings", systemImage: "gear") {
                    isShowingSettings.toggle()
                }
            }
            ToolbarItem(placement: .automatic) {
                Button("Random card", systemImage: "dice") {
                    Task {
                        await searchManager.fetchRandomCard()
                        if let randomCard = searchManager.randomCard {
                            router.searchTabRouter.navigationPath.append(Route.cardScreenFromCard(randomCard))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SearchTab()
        .environment(Router())
}

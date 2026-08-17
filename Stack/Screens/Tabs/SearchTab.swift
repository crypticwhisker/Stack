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
    @State private var isShowingProgressOverlay = false
    @State private var isSearching = false
    @State private var searchTabManager = SearchManager()
    @State private var searchText = ""
    @State private var debouncedMatches: [String] = []
    
    var body: some View {
        List {
            if isSearching && !debouncedMatches.isEmpty {
                Section("Quick results") {
                    ForEach(debouncedMatches, id: \.self) { match in
                        NavigationLink(value: Route.cardScreenFromIdentifier(.rawString(match))) {
                            Text(match)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, isPresented: $isSearching, prompt: "Search for a card")
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .onSubmit(of: .search) {
            router.searchTabRouter.navigationPath.append(Route.searchResults(searchText))
            if !searchTabManager.searchHistory.contains(searchText) {
                searchTabManager.searchHistory.append(searchText)
            }
        }
        .customDarkMode()
        .task(id: searchText) {
            if !searchText.isEmpty {
                debouncedMatches = await searchTabManager.debounceSearch(for: searchText)
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            if newValue.isEmpty {
                debouncedMatches.removeAll()
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
        .overlay {
            if isShowingProgressOverlay {
                CustomProgressView()
            }
        }
        .overlay {
            if debouncedMatches.isEmpty {
                ContentUnavailableView {
                    Label(searchTabManager.searchHistory.isEmpty ? "Start Typing" : "Search History", systemImage: "magnifyingglass")
                } description: {
                    if searchTabManager.searchHistory.isEmpty {
                        Text("Start typing for quick results or press enter to see full search results")
                    } else {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(searchTabManager.searchHistory, id: \.self) { searchHistory in
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
                    if !searchTabManager.searchHistory.isEmpty {
                        Button {
                            searchTabManager.searchHistory.removeAll()
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
                        isShowingProgressOverlay.toggle()
                        await searchTabManager.fetchRandomCard()
                        isShowingProgressOverlay.toggle()
                        if let randomCard = searchTabManager.randomCard {
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

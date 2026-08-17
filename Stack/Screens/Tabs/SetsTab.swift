//
//  SetsTab.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/17/25.
//

import SwiftUI
import Forge

struct SetsTab: View {
    
    @State private var searchManager = SearchManager()
    @State private var setSearchText = ""
    
    @AppStorage("SortOption") var sortOption: SortOption = .releasedAt
    @AppStorage("SetType") var setType: SFSetType = .expansion
    @AppStorage("Ascending") var ascending: Bool = false
    
    @Environment(TagManager.self) var tagManager: TagManager
    
    enum SortOption: String, CaseIterable, Identifiable {
        case name = "Name"
        case releasedAt  = "Release Date"
        case block = "Block/Group"
        case cardCount = "Card Count"
        
        var id: Self { self }
        
        var systemImage: String {
            switch self {
            case .name: return "textformat"
            case .releasedAt: return "calendar"
            case .block: return "cube.fill"
            case .cardCount: return "number"
            }
        }
    }
        
    var filteredSets: [SFSet] {
        
        let typeBase = setType.rawValue == "any" ? searchManager.sets : searchManager.sets.filter { $0.setType == setType.rawValue }

        let base = setSearchText.isEmpty ? typeBase : typeBase.filter { $0.name.localizedCaseInsensitiveContains(setSearchText) }
        
        let sorted: [SFSet]
        
        switch sortOption {
        case .name:
            sorted =  base.sorted { $0.name < $1.name }
        case .releasedAt:
            sorted =  base.sorted { ($0.releasedAt ?? "") < ($1.releasedAt ?? "") }
        case .block:
            sorted = base.sorted { ($0.block ?? "") < ($1.block ?? "") }
        case .cardCount:
            sorted = base.sorted { $0.cardCount < $1.cardCount }
        }
        
        return ascending ? sorted : sorted.reversed()
        
    }
    
    var body: some View {
        Group {
            switch searchManager.appState {
            case .failure(let error):
                SearchError(error: error)
            case .loading:
                CustomProgressView()
            case .success:
                List(filteredSets, id: \.self) { set in
                    NavigationLink(value: Route.setGrid(set)) {
                        HStack{
                            AsyncSetIcon(svgURIString: set.iconSvgURI)
                            Text("\(set.name)")
                        }
                    }
                }
                .searchable(text: $setSearchText)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort by", selection: $sortOption) {
                                ForEach(SortOption.allCases) { option in
                                    Label(option.rawValue, systemImage: option.systemImage)
                                        .tag(option)
                                }
                            }
                            .menuActionDismissBehavior(.disabled)
                            Divider()
                            Picker("Order", selection: $ascending) {
                                Label("Ascending", systemImage: "arrow.up.square")
                                    .tag(true)
                                Label("Descending", systemImage: "arrow.down.square")
                                    .tag(false)
                            }
                            .pickerStyle(.inline)
                            .menuActionDismissBehavior(.disabled)
                            Menu("Set Type", systemImage: "scroll") {
                                Picker("Set Type", selection: $setType) {
                                    ForEach(SFSetType.allCases) { option in
                                        Text(option.prettyName)
                                            .tag(option)
                                    }
                                }
                                .menuActionDismissBehavior(.disabled)
                            }
                            Divider()
                            Button("Reset", systemImage: "arrow.counterclockwise.circle") {
                                resetSortOptions()
                            }
                        }
                    }
                }
            }
        }
        .customDarkMode()
        .task {
            guard searchManager.sets.isEmpty else { return }
            await searchManager.fetchSetList()
        }
        .task {
            guard tagManager.tags.isEmpty else { return }
            await tagManager.getLatestTags()
        }
    }
    
    // MARK: - Functions
    private func resetSortOptions() {
        sortOption = .releasedAt
        setType = .expansion
        ascending = false
    }
}

#Preview {
    SetsTab()
}

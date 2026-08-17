//
//  SetView.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/17/25.
//

import SwiftUI
import Forge

struct SetView: View {
    
    @Environment(Router.self) var router
    
    @State private var searchText = ""
    @State private var manager: SearchManager = SearchManager()
    
    let set: SFSet

    var filteredCards: [SFCard] {
        searchText.isEmpty ? manager.cards : manager.cards.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        Group {
            switch manager.appState {
            case .failure(let error):
                SearchError(error: error)
            case .loading:
                CustomProgressView()
            case .success:
                Grist(cards: filteredCards, manager: manager)
                    .navigationTitle("\(set.name) \\(\(set.code.uppercased())\\)")
                    .navigationSubtitle("\(set.cardCount) cards • \(set.releaseInfo)")
                    .searchable(text: $searchText)
                    .scrollDismissesKeyboard(.immediately)
            }
        }
        .customDarkMode()
        .onFirstAppear {
            Task {
                await manager.fetchSetCards(for: set)
            }
        }
    }
}

#Preview {
    #warning("TODO: Preview provider")
}

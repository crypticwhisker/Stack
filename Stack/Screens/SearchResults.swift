//
//  SearchResults.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/6/25.
//

import SwiftUI
import Forge

struct SearchResults: View {
    
    @Environment(Router.self) var router
    
    @State var manager: SearchManager = SearchManager()
    
    var input: String
    
    var body: some View {
        Group {
            switch manager.appState {
            case .failure(let error):
                SearchError(error: error)
            case .loading:
                CustomProgressView()
            case .success:
                Grist(cards: manager.cards, manager: manager)
                    .navigationTitle("Search Results") // not redundant, used to provide title for "hold to go back gesture"
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                Text("^[\(manager.result?.totalCards ?? 0) card](inflect:true)")
                                Text(manager.query)
                                    .font(.system(.caption, design: .monospaced))
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .glassEffect(in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                    }
            }
        }
        .customDarkMode()
        .onFirstAppear {
            Task {
                await manager.fetchSearchResults(for: input)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchResults(manager: SearchManager(), input: "id:grixis game:paper is:commander")
            .environment(Router())
    }
}

//
//  CardContextMenu.swift
//  Stack
//
//  Created by Jacobs, Joe on 12/10/25.
//

import SwiftUI
import SwiftData
import Forge

// There's some duplication here from CardToolbarMenu
// Certain features, like showing a sheet from a context menu don't work

struct CardContextMenu: View {
    
    @Environment(Router.self) var router: Router
    @Environment(\.modelContext) var modelContext
    
    @Query private var listCardFolders: [ListCardFolder]
    
    var manager: SavedCardManager {
        SavedCardManager(context: modelContext)
    }
    
    let card: SFCard
    
    var body: some View {
        Menu("Add to list", systemImage: "list.dash") {
            ForEach(listCardFolders) { folder in
                Button("\(folder.name)", systemImage: "list.dash") {
                    Task {
                        let newCard = ListCard(card: card, collection: folder)
                        manager.addCardToCollection(card: newCard, collection: folder)
                    }
                }
            }
        }
        ShareLink(item: card.scryfallURI) {
            Label("Share link", systemImage: "square.and.arrow.up")
        }
    }
}

#Preview {
//    CardContextMenu()
}

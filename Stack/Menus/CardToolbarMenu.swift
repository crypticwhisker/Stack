//
//  CardToolbarMenu.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/18/25.
//

import SwiftUI
import SwiftData
import Forge

struct CardToolbarMenu: View {
    
    @Environment(\.modelContext) var modelContext
    
    @State private var noFolderAlert = false
    @State private var folderName = ""
    
    @Query private var listCardFolders: [ListCardFolder]
    
    var manager: SavedCardManager {
        SavedCardManager(context: modelContext)
    }
        
    let card: SFCard
    
    var cannotPurchase: Bool {
        card.storeLinks.isEmpty
    }
    
    var body: some View {
        HStack {
            Menu("Add to list", systemImage: "list.dash") {
                ForEach(listCardFolders) { folder in
                    Button("\(folder.name)", systemImage: "folder") {
                        let newCard = ListCard(card: card, collection: folder)
                        manager.addCardToCollection(card: newCard, collection: folder)
                    }
                }
                Divider()
                Button("Add to new list", systemImage: "text.badge.plus") {
                    noFolderAlert.toggle()
                }
            }
            Menu("Card Actions", systemImage: "ellipsis.circle") {
                if let url = card.relatedURIs.edhrec {
                    Link(destination: URL(string: url)!) {
                        Label("EDHREC", systemImage: "arrow.up.forward.app")
                    }
                }
                Link(destination: card.scryfallTaggerURL) {
                    Label("Scryfall Tagger", systemImage: "arrow.up.forward.app")
                }
                ShareLink(item: card.scryfallURI) {
                    Label("Share link", systemImage: "square.and.arrow.up")
                }
                // Nested purchase menu
                Menu("Purchase", systemImage: "dollarsign.square") {
                    if let _ = card.purchaseURIs {
                        ForEach(card.storeLinks) { store in
                            if let url = URL(string: store.url) {
                                Link(destination: url) {
                                    Text("\(store.id)")
                                }
                            }
                        }
                    }
                }
                .disabled(cannotPurchase)
            }
            .alert("New List", isPresented: $noFolderAlert) {
                TextField("New List", text: $folderName)
                Button("Cancel", role: .cancel) { }
                Button("Create", role: .confirm) {
//                    let newFolder = manager.createCollection(name: folderName, type: ListCardFolder.self)
                    let newFolder = manager.createCollection(name: folderName)
                    let newCard = ListCard(card: card, collection: newFolder)
                    manager.addCardToCollection(card: newCard, collection: newFolder)
                    folderName = ""
                }
            } message: {
                Text("Enter a name for this list")
            }
        }
        .handleOpenURLInApp()
    }
}

#Preview {
//    CardToolbarMenu()
}

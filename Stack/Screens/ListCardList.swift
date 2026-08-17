//
//  ListCardList.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/29/25.
//

import SwiftUI
import SwiftData

struct ListCardList: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var cards: [ListCard]
    @Query var listCardFolders: [ListCardFolder]
    
    let folder: ListCardFolder
    
    var manager: SavedCardManager {
        SavedCardManager(context: modelContext)
    }
    
    var availableFolders: [ListCardFolder] {
        listCardFolders.filter { $0.internalID != folder.internalID }
    }
    
    var totalPriceForFolder: String {
        let total = cards.reduce(0) { $0 + $1.price }
        return total.formatted(.currency(code: "USD"))
    }
    
    // REMINDER: custom init because @Query is initialized before the rest of the struct and can't reference the folder property unless it's in an initializer
    init(for folder: ListCardFolder) {
        self.folder = folder
        let id = folder.internalID
        self._cards = Query(filter: #Predicate { card in
            card.collection.internalID == id
        }, sort: [SortDescriptor(\ListCard.dateAdded, order: .reverse)]
        )
    }
    
    var body: some View {
        List {
            ForEach(cards) { card in
                NavigationLink(value: Route.cardScreenFromIdentifier(.scryfallID(card.scryfallID))) {
                    HStack {
                        StaticCardThumbFromURL(card: card, suppressShadow: true)
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size * 0.3
                            }
                            .padding(.trailing, 10)
                        VStack(alignment: .leading) {
                            Text(card.name)
                                .font(.headline)
                                .padding(.bottom, 1)
                            Text("\(card.finish) • #\(card.collectorNumber)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 1)
                            Text("\(card.price.formatted(.currency(code: "USD")))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onAppear {
                        Task {
                            await manager.updateSavedCard(card: card)                            
                        }
                    }
                    .contextMenu {
                        Menu("Move", systemImage: "folder") {
                            ForEach(availableFolders) { folder in
                                Button(folder.name) {
                                    manager.moveCardToDifferentCollection(card: card, to: folder)
                                }
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .onDelete { indexSet in
                manager.removeCardFromCollection(at: indexSet, for: cards)
            }
        }
        .customDarkMode()
        .navigationTitle(folder.name)
        .navigationSubtitle("^[\(cards.count) card](inflect:true) • \(totalPriceForFolder)")
    }
}

#Preview {
    #warning("TODO: Preview provider")
}

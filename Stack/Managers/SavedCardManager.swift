//
//  CustomCardManager.swift
//  Stack
//
//  Created by Jacobs, Joe on 12/10/25.
//

import Foundation
import SwiftData
import SwiftUI
import Forge

class SavedCardManager {
    
    let context: ModelContext
    let client: ForgeClient = .shared
    
    init (
        context: ModelContext
    ) {
        self.context = context
    }
    
    func addCardToCollection(card: ListCard, collection: ListCardFolder) {
        context.insert(card)
        collection.cards.append(card)
    }
    
    func createCollection(name: String) -> ListCardFolder {
        let collection = ListCardFolder(name: name)
        context.insert(collection)
        return collection
    }
    
    func removeCollection(at offsets: IndexSet, for folders: [ListCardFolder]) {
        for index in offsets {
            let folder = folders[index]
            context.delete(folder)
        }
    }
    
    func renameCollection(for collectionToRename: ListCardFolder, to collectionRename: String) {
        collectionToRename.name = collectionRename
    }
   
    func renameCollection<C: CardCollection>(for collectionToRename: C, to collectionRename: String) {
        collectionToRename.name = collectionRename
    }

    func moveCardToDifferentCollection(card: ListCard, to newCollection: ListCardFolder) {
        card.collection = newCollection
    }
    
    func moveCardToDifferentCollection<C: SavedCard>(card: C, to newCollection: C.ContainerType) {
        card.collection = newCollection
    }
    
    func removeCardFromCollection(at offsets: IndexSet, for cards: [ListCard]) {
        for index in offsets {
            let card = cards[index]
            context.delete(card)
        }
    }
    
//    func removeCardFromCollection<C: SavedCard>(at offsets: IndexSet, for cards: [C]) where C: PersistentModel {
//        for index in offsets {
//            let card = cards[index]
//            context.delete(card)
//        }
//    }
    
    func updateSavedCard(card: ListCard) async {
        print("Checking if card price needs to be updated...")
        guard card.lastUpdated.timeIntervalSinceNow >= 86400, let response = try? await client.fetchSpecificURLSingle(for: card.cardURL) else {
            print("Price is up-to-date, skipping")
            return
        }
        print("Updating card price")
        card.price = response.priceAsDouble
        try? context.save()
    }
    
//    func updateSavedCard<C: SavedCard>(card: inout C) async {
//        print("Checking if card price needs to be updated...")
//        guard card.lastUpdated.timeIntervalSinceNow >= 86400, let response = try? await client.fetchSpecificURLSingle(for: card.cardURL) else {
//            print("Price is up-to-date, skipping")
//            return
//        }
//        print("Updating card price")
//        card.price = response.priceAsDouble
//        try? context.save()
//    }

    func updateMultipleSavedCards<C: SavedCard>(cards: [C]) async {
        // Need to investigate how to best update model objects in the background
        // https://useyourloaf.com/blog/swiftdata-background-tasks/
        // https://www.massicotte.org/model-actor/
        // https://www.hackingwithswift.com/quick-start/swiftdata/how-swiftdata-works-with-swift-concurrency
    }
    
}

//
//  ListCard.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/25/25.
//

import Foundation
import SwiftData
import SwiftUI
import Forge

@Model
nonisolated class ListCard: SavedCard {
    
    // API data
    var name: String
    var price: Decimal
    var scryfallID: String
    var cardURL: String
    var collectorNumber: String
    var finish: String
    
    // User data
    var collection: ListCardFolder
    
    // Internal only
    var dateAdded: Date
    var lastUpdated: Date
    var internalID: UUID
    
    required init(
        card: SFCard,
        collection: ListCardFolder
    ) {
        self.name = card.name
        self.price = card.priceAsDecimal
        self.scryfallID = card.id
        self.cardURL = card.uri
        self.collectorNumber = card.collectorNumber
        self.finish = card.cardFinish
        self.collection = collection
        self.dateAdded = .now
        self.lastUpdated = .now
        self.internalID = .init()
    }
}

extension ListCard {
    var priceAsString: String {
        guard price > 0 else { return "No price data" }
        return price.formatted(.currency(code: "USD"))
    }
}

extension ListCard: ModelDisplayable { }

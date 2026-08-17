//
//  ListCardFolder.swift
//  Stack
//
//  Created by Jacobs, Joe on 3/10/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
nonisolated class ListCardFolder: CardCollection, Identifiable {
    
    // User data
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \ListCard.collection) var cards: [ListCard]
    
    // Internal only
    var internalID: UUID
    var dateAdded: Date
    
    required init(
        name: String
    ) {
        self.name = name
        self.cards = []
        self.internalID = .init()
        self.dateAdded = .now
    }
}

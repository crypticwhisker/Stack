//
//  CollectionCardProtocols.swift
//  Stack
//
//  Created by Jacobs, Joe on 4/15/26.
//

import Foundation
import SwiftData
import Forge

nonisolated protocol CardCollection: PersistentModel {
    associatedtype CardType: SavedCard
    var name: String { get set }
    var cards: [CardType] { get set }
    
    init(name: String)
}

nonisolated protocol SavedCard: PersistentModel {
    associatedtype ContainerType: CardCollection
    var name: String { get }
    var price: Double { get set }
    var cardURL: String { get set}
    var lastUpdated: Date { get set }
    var collection: ContainerType { get set }
    
    init(card: SFCard, collection: ContainerType)
}

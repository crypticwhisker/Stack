//
//  CardBottom.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/20/26.
//

import SwiftUI
import Forge

struct CardBottom: View {
    
    @AppStorage("ShowTags") var showTags = false
    
    let card: SFCard
    let manager: CardManager
    
    var body: some View {
        LazyVStack {
            CardText(card: card)
            CardDetailsSection(card: card, manager: manager)
            if !manager.filteredParts.isEmpty {
                OtherPartsSection(cards: manager.filteredParts)
            }
            if !manager.prints.isEmpty {
                PrintsSection(parentCard: card, prints: manager.prints)
            }
            LegalitiesSection(card: card)
            if !manager.rulings.isEmpty {
                RulingsSection(rulings: manager.rulings)
            }
            if showTags == true {
                OracleTagSection(card: card)
            }            
        }
    }
}


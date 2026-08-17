//
//  SetType.swift
//  Stack
//
//  Created by Jacobs, Joe on 3/19/26.
//

import Foundation
import Forge

extension SFSet {
    var releaseInfo: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        guard let releasedAt, let date = dateFormatter.date(from: releasedAt)
        else { return "Unknown release date" }

        let isFuture = date > .now
        let verb = isFuture ? "Releases" : "Released"
        return "\(verb) \(date.formatted(.dateTime.month().day().year()))"
    }
}

enum SFSetType: String, CaseIterable, Identifiable, Codable {
    case any
    case core
    case expansion
    case masters
    case eternal
    case alchemy
    case masterpiece
    case arsenal
    case fromTheVault = "from_the_vault"
    case spellbook
    case premiumDeck = "premium_deck"
    case duelDeck = "duel_deck"
    case draftInnovation = "draft_innovation"
    case treasureChest = "treasure_chest"
    case commander
    case planechase
    case archenemy
    case vanguard
    case funny
    case starter
    case box
    case promo
    case token
    case memorabilia
    case minigame
    
    var id: Self { self }
    
    var prettyName: String {
        switch self {
        case .any: return "Any"
        case .core: return "Core"
        case .expansion: return "Expansion"
        case .masters: return "Masters"
        case .eternal: return "Eternal"
        case .alchemy: return "Alchemy"
        case .masterpiece: return "Masterpiece"
        case .arsenal: return "Arsenal"
        case .fromTheVault: return "From the Vault"
        case .spellbook: return "Spellbook"
        case .premiumDeck: return "Premium Deck"
        case .duelDeck: return "Duel Deck"
        case .draftInnovation: return "Draft Innovation"
        case .treasureChest: return "Treasure Chest"
        case .commander: return "Commander"
        case .planechase: return "Planechase"
        case .archenemy: return "Archenemy"
        case .vanguard: return "Vanguard"
        case .funny: return "Funny"
        case .starter: return "Starter"
        case .box: return "Box"
        case .promo: return "Promo"
        case .token: return "Token"
        case .memorabilia: return "Memorabilia"
        case .minigame: return "Minigame"
        }
    }
}

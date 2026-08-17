//
//  CardExtensions.swift
//  Stack
//
//  Created by Jacobs, Joe on 3/19/26.
//

import Foundation
import SwiftUI
import Forge

// MARK: - Misc useful extensions
extension SFCard {

    enum CallOutOptions {
        case reserved
        case gamechanger
        case both
        case none
    }

    var isGC: Bool {
        gameChanger ?? false
    }
    
    var needsCallOut: Bool {
        isGC || isReserved
    }
    
    var callOutMode: CallOutOptions {
        switch (isGC, isReserved) {
        case (true, true):  .both
        case (false, true): .reserved
        case (true, false): .gamechanger
        default: .none
        }
    }
    
    var hasContentWarning: Bool {
        contentWarning ?? false
    }
    
    nonisolated var priceAsDouble: Double {
        guard let price = prices.usd, let dp = Double(price) else { return 0 }
        return dp
    }
    
    var priceAsString: String {
        guard priceAsDouble > 0 else { return "No price data" }
        return priceAsDouble.formatted(.currency(code: "USD"))
    }
    
    var hasReleased: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releasedAt) else { return true }
        return date < .now
    }
    
    var releaseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releasedAt)
        else { return "Unknown release date" }
        
        return "\(date.formatted(.dateTime.month().day().year()))"
    }
    
    /// Non-API URL
    /// URI typecast from string to URL
    var scryfallURL: URL {
        return URL(string: scryfallURI)!
    }
    
    var scryfallTaggerURL: URL {
        let baseURL = "https://tagger.scryfall.com/card/\(self.set)/\(collectorNumber)"
        
        return URL(string: baseURL)!
    }
}

// MARK: - Card finish
extension SFCard {
    nonisolated var cardFinish: String {
        
        /* API response for this is bad, so we have to define manually
        PromoTypes is everytyhing we care about in the promo_types property array
        Etched is a special case where it shows up in the finishes property array
        Could also approach this by negating everything we don't want in the promo_types array but the formatting is fugly that way
         */
        
        enum PromoTypes: String, CaseIterable {
            case surgefoil
            case doublerainbow
            case textured
            case confettifoil
            case galaxyfoil
            case gilded
            case halofoil
            case invisibleink // Looks like even scryfall doesn't display this correctly
            case neonink
            case oilslick
            case stepandcompleat
            case metal
                
            var displayName: String {
                switch self {
                case .surgefoil: return "Surge Foil"
                case .doublerainbow: return "Double Rainbow"
                case .textured: return "Textured"
                case .confettifoil: return "Confetti Foil"
                case .galaxyfoil: return "Galaxy Foil"
                case .gilded: return "Gilded Foil"
                case .halofoil: return "Halo Foil"
                case .invisibleink: return "Invisible Ink"
                case .neonink: return "Neon Ink"
                case .oilslick: return "Oil Slick"
                case .stepandcompleat: return "Step and Compleat"
                case .metal: return "Metal"
                }
            }
        }
        
        // Both
        if foil && nonfoil {
            return "Regular/Foil"
        }
        
        // Non-Foil only
        if !foil && nonfoil {
            return "Non-Foil"
        }
        
        if !foil && !nonfoil {
            return "Etched"
        }
        
        // Foil
        if foil && !nonfoil {
            guard let promoTypes else { return "Foil" }

            if let match = PromoTypes.allCases.first(where: { promoTypes.contains($0.rawValue) }) {
                return match.displayName
            } else {
                return "Foil"
            }
        }
    
        return "Unknown Finish"
    }
}


// MARK: - Purchase menu
extension SFCard {
    struct StoreLink: Identifiable {
        let id: String
        let url: String
    }

    var manapoolURL: String {
        return "https://manapool.com/card/\(`set`)/\(collectorNumber)"
    }
    
    var storeLinks: [StoreLink] {
        guard let uris = purchaseURIs else { return [] }

        return [
            ("Manapool", manapoolURL),
            ("TCGplayer", uris.tcgplayer),
            ("Cardmarket", uris.cardmarket),
            ("Cardhoarder", uris.cardhoarder)
        ]
        .compactMap { key, value in
            guard let value else { return nil }
            return StoreLink(id: key, url: value)
        }
    }
}

// MARK: - Transform behaviors
extension SFCard {
    public enum Orientation {
        case rotate(degrees: Double)
        case flipOver
        case flipOverAndRotate
        case none
    }
    
    public var appearBehavior: Orientation {
        switch self.layout {
        case .transform where typeLine?.contains("Battle") ?? false:
            return .rotate(degrees: 90)
        case .split where keywords?.contains("Aftermath") ?? false:
            return .rotate(degrees: -90)
        case .split, .artSeries, .planar:
            return .rotate(degrees: 90)
        default:
            return .none
        }
    }
    
    public var transformBehavior: Orientation {
        switch self.layout {
        case .transform where typeLine?.contains("Battle") ?? false:
            return .flipOverAndRotate
        case .transform, .doubleFacedToken, .modalDFC, .reversibleCard:
            return .flipOver
        case .split where keywords?.contains("Aftermath") ?? false:
            return .rotate(degrees: -90)
        case .split, .artSeries:
            return .rotate(degrees: 90)
        case .flip:
            return .rotate(degrees: 180)
        default:
            return .none
        }
    }
    
    public var transformLabels: (buttonLabel: String, imageLabel: String)? {
        switch self.layout {
        case .transform: return (buttonLabel: "Transform", imageLabel: "arrow.trianglehead.2.counterclockwise.rotate.90")
        case .doubleFacedToken, .modalDFC, .reversibleCard: return (buttonLabel: "Flip", imageLabel: "arrow.trianglehead.2.counterclockwise.rotate.90")
        case .flip, .split, .artSeries: return (buttonLabel: "Rotate", imageLabel: "arrow.clockwise")
        default: return nil
        }
    }
    
    public var shouldTransformOnAppear: Bool {
        switch self.layout {
        case .transform where typeLine?.contains("Battle") ?? false: return true
        case .split, .planar: return true
        default : return false
        }
    }
}

//
//  LegalitiesSection.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/20/25.
//

import SwiftUI
import Forge

struct LegalalityPill: View {
    let card: SFCard
    let format: Format

    private var legality: SFCard.Legality {
      return card.legality(for: format)
    }
    
    private var fillColor: Color {
        switch legality {
        case .legal: return .legalGreen
        case .gameChanger: return .gcGreen
        case .banned: return .bannedRed
        case .restricted: return .restrictedBlue
        default: return .notLegalGray
        }
    }

    var body: some View {
        Text(legality.label)
            .foregroundStyle(.white)
            .font(.caption.smallCaps())
            .padding(5)
            .frame(width: 75)
            .background(fillColor, in: RoundedRectangle(cornerRadius: 5))
    }
}

struct LegalitiesSection: View {
    
    let card: SFCard
    let formats = Format.allCases

    var body: some View {
        GroupBox("Legalities") {
            if card.hasReleased {
                ForEach(formats, id: \.self) { format in
                    LabeledContent {
                        LegalalityPill(card: card, format: format)
                    } label: {
                        Text(format.rawValue.capitalized)
                    }
                    if format.rawValue != formats.last?.rawValue {
                        Divider()
                    }
                }
            } else {
                Text("This card will be released on \(card.releaseDate) and is not currently legal in any format.")
            }
        }
        .groupBoxStyle(.outsideLabel)
    }
}

#Preview {
    #warning("TODO: Preview provider")
}

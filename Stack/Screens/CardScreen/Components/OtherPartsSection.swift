//
//  OtherPartsSection.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/10/25.
//

import SwiftUI
import Forge

struct OtherPartsSection: View {
    
    let cards: [SFCard]
    let partCountToShow = 5
    
    var body: some View {
        GroupBox("Other parts") {
            ForEach(cards.prefix(partCountToShow)) { card in
                ChevronButton(value: Route.cardScreenFromCard(card)) {
                    StaticCardThumb(card: card)
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.15
                        }
                    Text(card.name)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }
                if card.name != cards.last?.name {
                    Divider()
                    .padding(.vertical, 10)
                }
            }
            if cards.count > partCountToShow {
                ChevronButton(value: Route.extrasGrid("Other Parts", cards)) {
                    Text("Show all parts")
                        .foregroundStyle(.primary)
                }
                .padding(.top, 10)
            }
        }
        .groupBoxStyle(.outsideLabel)
    }
}

#Preview {
    @Previewable @State var manager = CardManager(client: MockClient())

    ScrollView {
        if let card = manager.card {
            OtherPartsSection(cards: manager.otherParts)
                .padding(.vertical, 10)
                .customDarkMode()
        } else {
            ProgressView()
        }
    }
    .task {
        await manager.setup(initialCard: nil, identifier: .rawString("Sauron, the Dark Lord"))
    }
}

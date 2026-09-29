//
//  PrintsSection.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/5/25.
//

import SwiftUI
import Forge

struct PrintsSection: View {
    
    let parentCard: SFCard
    let prints: [SFCard]
    let printCountToShow = 5
    
    var body: some View {
        GroupBox("Prints") {
            ForEach(prints.prefix(printCountToShow)) { card in
                ChevronButton(value: Route.cardScreenFromCard(card)) {
                    StaticCardThumb(card: card)
                        .containerRelativeFrame(.horizontal) { size, axis in
                            size * 0.15
                        }
                    HStack {
                        VStack(alignment: .leading) {
                            Text(card.setName + " #" + card.collectorNumber)
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, 1)
                            Group {
                                Text(card.cardFinish)
                                    .padding(.bottom, 1)
                                Text(card.priceAsString)
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .disabled(card.id == parentCard.id) // using .hidden() here causes a compiler error... likely due to needing to check on each loop
                if card.id != prints.last?.id {
                    Divider()
                    .padding(.vertical, 10)
                }
            }
            if prints.count > printCountToShow {
                ChevronButton(value: Route.extrasGrid("Prints", prints)) {
                    Text("Show all prints")
                        .foregroundStyle(.primary)
                }
            }
        }
        .groupBoxStyle(.outsideLabel)
    }
}


#Preview {
    @Previewable @State var manager = CardManager(client: MockClient())

    ScrollView {
        if let card = manager.card {
            PrintsSection(parentCard: card, prints: manager.prints)
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

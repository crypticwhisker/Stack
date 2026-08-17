//
//  Grist.swift
//  Stack
//
//  Created by Jacobs, Joe on 5/14/26.
//

import SwiftUI
import Forge

struct Grist: View {
    
    @State private var viewMode: ViewMode = .doubleGrid

    var cards: [SFCard]
    let manager: SearchManager?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: viewMode.columns, spacing: 16) {
                ForEach(cards) { card in
                    if viewMode != .list {
                        NavigationLink(value: Route.cardScreenFromCard(card)) {
                            StaticCardThumb(card: card)
                                .contextMenu {
                                    CardContextMenu(card: card)
                                }
                        }
                    } else {
                        GroupBox {
                            ChevronButton(value: Route.cardScreenFromCard(card)) {
                                StaticCardThumb(card: card, suppressShadow: true)
                                    .containerRelativeFrame(.horizontal) { size, axis in
                                        size * 0.25
                                    }
                                    .padding(.trailing, 5)
                                VStack(alignment: .leading) {
                                    Text(card.name)
                                        .font(.headline)
                                        .padding(.bottom, 1)
                                    Text("\(card.setName) \\(\(card.set.uppercased())\\)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                        .padding(.bottom, 1)
                                    Text(card.priceAsString)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .groupBoxStyle(.cardListStyle)
                        .buttonStyle(.plain)
                        .contextMenu {
                            CardContextMenu(card: card)
                        }
                    }
                }
                if let manager {
                    PaginationLoader(manager: manager)
                }
            }
            .padding(.horizontal)
        }
        .animation(.easeInOut, value: viewMode)
        .toolbar {
            GridOptions(viewMode: $viewMode)
        }
    }
}

#Preview {
    NavigationStack {
        #warning("TODO: Preview provider")
    }
}

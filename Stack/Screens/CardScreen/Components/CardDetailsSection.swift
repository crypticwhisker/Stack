//
//  CardDetailsSection.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/27/25.
//

import SwiftUI
import Forge

struct CardDetailsSection: View {
    
    @Environment(Router.self) private var router
    
    let card: SFCard
    let manager: CardManager
    
    var body: some View {
        if let set = manager.set {
            GroupBox {
                ChevronButton(value: Route.setGrid(set)) {
                    AsyncSetIcon(svgURIString: manager.set?.iconSvgURI ?? "")
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        Text("\(card.setName) \\(\(card.set.uppercased())\\)")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                        Group {
                            Text("\(card.cardFinish) • \(card.priceAsString)")
                            Text("#\(card.collectorNumber) • \(card.rarity.capitalized)")
                        }
                        .foregroundStyle(.secondary)
                    }
                }
                if card.isReserved {
                    HStack {
                        Button("Reserved", systemImage: "lifepreserver") {
                            router.searchTabRouter.navigationPath.append(Route.searchResults("is:reserved"))
                            router.activeTab = .search
                        }
                        .buttonStyle(.glass)
//                        Spacer()
                        Link("?", destination: URL(string: "https://mtg.wiki/page/Reserved_List")!)
                            .buttonStyle(.glass)
                            .handleOpenURLInApp()
                    }
                    .padding(.top, 10)
                }
            }
            .groupBoxStyle(.outsideLabel)
        }
    }
}

#Preview {
    @Previewable @State var manager = CardManager(client: MockClient())

    ScrollView {
        if let card = manager.card {
            CardDetailsSection(card: card, manager: manager)
                .padding(.vertical, 10)
                .customDarkMode()
                .environment(Router())
        } else {
            ProgressView()
        }
    }
    .task {
        await manager.setup(initialCard: nil, identifier: .rawString("Sauron, the Dark Lord"))
    }
}

//
//  CardText.swift
//  Stack
//
//  Created by Jacobs, Joe on 12/23/25.
//

import SwiftUI
import Forge

struct CardTextSection: View {
    
    let cardLike: CardLike
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    ForEach(CardParts.allCases) { part in
                        partView(part)
                    }
                }
                if let lights = cardLike.attractionLights {
                    UNFLights(lightsON: lights)
                        .offset(x: 5)
                }
            }
        }
    }
    
    enum CardParts: CaseIterable, Identifiable {
        case titleBar // card name and mana cost
        case typeLine // card type and expansion symbol
        case textBox // card text box w/oracle text
        case flavorText // card text box w/flavor text
        case powerLine // power/toughness or loyalty or defense
        
        var id: Self { self }
    }
    
    @ViewBuilder
    private func partView(_ part: CardParts) -> some View {
        switch part {
        case .titleBar:
            VStack {
                HStack {
                    Text(cardLike.name)
                        .padding(.bottom, 3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.headline)
                    if let mana = cardLike.manaCost {
//                        ManaCost(stringToParse: mana)
                        InlineSVGTest(string: mana)
                            .shadow(color: .black, radius: 0.5, x: -0.5, y: 1.5)
                    }
                }
            }
        case .typeLine:
            if let typeLine = cardLike.typeLine {
                Text(typeLine)
                    .padding(.bottom, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)
            }
        case .textBox:
            if let oracleText = cardLike.oracleText {
//                MixedCardString(stringToNS: oracleText)
                InlineSVGTest(string: oracleText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 15)
            }
        case .flavorText:
            if let flavorText = cardLike.flavorText {
                Text(flavorText)
                    .padding(.bottom, 3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(.body, design: .serif))
                    .italic()
            }
        case .powerLine:
            if let powerLine = cardLike.pt {
                Text(powerLine)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.bold)
            }
            if let loyalty = cardLike.loyalty {
                Text(loyalty)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
}

struct CardText: View {
    let card: SFCard
    
    var body: some View {
        GroupBox {
            ForEach(card.displayFaces, id: \.id) { face in
                CardTextSection(cardLike: face)
                if face.name != card.displayFaces.last?.name {
                    Divider()
                        .padding(.top, 5)
                        .padding(.bottom, 20)
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
            CardText(card: card)
                .padding(.vertical, 10)
                .customDarkMode()
        } else {
            ProgressView()
        }
    }
    .task {
        await manager.loadCard(for: .rawString("Sauron, the Dark Lord"))
    }
}

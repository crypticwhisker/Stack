//
//  MixedCardString.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/17/26.
//

import SwiftUI

struct MixedCardString: View {
    
    let string: String
    
    var body: some View {
        parseToSymbols(string: string)
    }
    
    @ViewBuilder
    private func parseToSymbols(string: String) -> some View {
        let paragraphs = string.components(separatedBy: "\n")

        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, paragraph in
                let parsed = paragraph.parseManaString()

                var result = Text("")

                for part in parsed {
                    switch part {
                    case .text(let text):
                        result = Text("\(result)\(text)")

                    case .token(let token):
                        let image = Image(token.lowercased())
                            .symbolRenderingMode(.multicolor)

                        result = Text("\(result)\(image)")
                    }
                }

                return result
                
            }
        }
    }
    
}

#Preview {

    let exampleCard = "Trample, haste\nWhen The Balrog of Moria dies, you may exile it. When you do, for each opponent, exile up to one target creature that player controls.\nCycling {3}{R} ({3}{R}, Discard this card: Draw a card.)\nWhen you cycle this card, create two Treasure tokens."

    MixedCardString(string: exampleCard)
}

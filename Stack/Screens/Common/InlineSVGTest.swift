//
//  InlineSVGTest.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/17/26.
//

import SwiftUI

struct InlineSVGTest: View {
    
    let string: String
    
    var body: some View {
        let parsed = parseToSymbols(string: string)
        parsed
            .lineLimit(nil)
    }
    
    func parseToSymbols(string: String) -> Text {
        
        let parsed = string.parseManaString()
        
        var textArr: [Text] = []
        for part in parsed {
            switch part {
            case .text(let text):
                textArr.append(Text(text))
            case .token(let token):
                let lower = token.lowercased()
                let clean = lower.trimmingCharacters(in: .init(charactersIn: "{}"))
                textArr.append(
                    Text(
                        Image(clean)
                            .symbolRenderingMode(.multicolor)
                    )
                )
            }
        }
        
        return textArr.reduce(Text(""), +)
    
    }
}

#Preview {

    let exampleCard = "Trample, haste\nWhen The Balrog of Moria dies, you may exile it. When you do, for each opponent, exile up to one target creature that player controls.\nCycling {3}{R} ({3}{R}, Discard this card: Draw a card.)\nWhen you cycle this card, create two Treasure tokens."

    InlineSVGTest(string: exampleCard)
}

//
//  ManaCost.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/16/25.
//

import SwiftUI

// Used to show the cost in the upper right corner of a card, does not worked w/mixed strings
// Use MixedCardString for mixed strings

struct ManaCost: View {
    
    let stringToParse: String
    
    var body: some View {
        let parsed = stringToParse.parseManaString()
        HStack(spacing: 2) {
            ForEach(parsed.enumerated(), id: \.offset) { _, part in
                switch part {
                case .text:
                    EmptyView()
                case .token(let symbol):
                    Image(symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                        .scaledToFit()
                        .shadow(color: .black, radius: 0.5, x: -0.5, y: 1.5)
                }
            }
        }
    }
}

#Preview {
    ManaCost(stringToParse: "{3}{U}{B}{R}")
}

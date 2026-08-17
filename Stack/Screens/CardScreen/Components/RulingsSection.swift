//
//  RulingsSection.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/4/25.
//

import SwiftUI
import Forge

struct RulingsSection: View {
    
    let rulings: [SFRuling]
    
    var body: some View {
        GroupBox("Rulings") {
            ForEach(rulings, id: \.self) { ruling in
                VStack {
                    MixedCardString(stringToNS: ruling.comment)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(ruling.publishedAt)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .italic()
                }
                if ruling.comment != rulings.last?.comment {
                    Divider()
                    .padding(.vertical, 5)
                }
            }
        }
        .groupBoxStyle(.outsideLabel)
    }
}

#Preview {
    #warning("TODO: Preview provider")
}

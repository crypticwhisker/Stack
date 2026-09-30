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
                    MixedCardString(string: ruling.comment)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 5)
                    Text("\(ruling.publishedAt) • \(ruling.source.uppercased())")
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
    @Previewable @State var manager = CardManager(client: MockClient())

    ScrollView {
        if let card = manager.card {
            RulingsSection(rulings: manager.rulings)
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

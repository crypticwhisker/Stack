//
//  ExtrasGrid.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/23/25.
//

import SwiftUI
import Forge

struct ExtrasGrid: View {
        
    let navTitle: String // property because this view is used both for "Other parts" and "Prints"
    let cards: [SFCard]
    
    var body: some View {
        Grist(cards: cards, manager: nil)
            .customDarkMode()
            .navigationTitle(navTitle)
    }
}

#Preview {
    @Previewable @State var manager = CardManager(client: MockClient())

    ScrollView {
        if let card = manager.card {
            ExtrasGrid(navTitle: "Prints", cards: manager.prints)
        } else {
            ProgressView()
        }
    }
    .task {
        await manager.setup(initialCard: nil, identifier: .rawString("Sauron, the Dark Lord"))
    }
    
}

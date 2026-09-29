//
//  StaticCardThumb.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/19/25.
//

import SwiftUI
import Kingfisher
import Forge

struct StaticCardThumb: View {
    
    var card: SFCard
    var displayBack = false
    var suppressShadow = false
    
    private var imageURL: URL? {
        displayBack ? card.backImageURL : card.frontImageURL
    }
    
    var body: some View {
        KFImage(imageURL)
            .placeholder {
                CardBack()
            }
            .resizable()
            .scaledToFit()
            .contentWarning(card: card)
            .perfectEdges()
            .shadow(
                color: suppressShadow ? .clear : .black,
                radius: suppressShadow ? 0 : 3,
                x: 0,
                y: suppressShadow ? 0 : 5
            )
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    if let sample: SFCard = try? SampleDataDecoder.load("card_sauron") {
        StaticCardThumb(card: sample)
            .padding(10)
    } else {
        ContentUnavailableView(
            "Could not load card",
            systemImage: "slash.circle",
            description: Text("Could not load requested sample card")
        )
    }
}

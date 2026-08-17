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

#Preview {
    #warning("TODO: Preview provider")
}

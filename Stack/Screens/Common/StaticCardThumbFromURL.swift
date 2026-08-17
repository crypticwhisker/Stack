//
//  StaticCardThumbFromURL.swift
//  Stack
//
//  Created by Jacobs, Joe on 3/19/26.
//

import SwiftUI
import Kingfisher

struct StaticCardThumbFromURL<T: ModelDisplayable>: View {
    
    let card: T
    var suppressShadow = false
        
    var body: some View {
        KFImage(card.imageURL)
            .placeholder {
                CardBack()
            }
            .resizable()
            .scaledToFit()
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

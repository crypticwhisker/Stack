//
//  AnimatedCardThumb.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/19/25.
//

import SwiftUI
import Forge

// https://github.com/bpisano/Sticker if i ever want to do foil effects

struct AnimatedCardThumb: View {
    
    @Environment(\.colorScheme) var colorScheme
        
    @State private var isFlipped = false
    @State private var isRotated = false
    @State private var isScaled = false
    @State private var flipDegrees = 0.0
    @State private var rotationDegrees = 0.0
    
    let card: SFCard
    
    var body: some View {
        VStack {
            ZStack {
                if card.isDualSided {
                    let front = StaticCardThumb(card: card, suppressShadow: true)
                    let back = StaticCardThumb(card: card, displayBack: true, suppressShadow: true)
                    
                    front
                        .opacity(isFlipped ? 0 : 1)
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    back
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0)) // Flips card so it isn't backwards
                } else {
                    StaticCardThumb(card: card, suppressShadow: true)
                }
            }
            .containerRelativeFrame(.horizontal) { size, axis in
                size * 0.9
            }
            .rotationEffect(.degrees(isRotated ? rotationDegrees : 0)) // needs to be before 3D effect so the axes work correctly
            .rotation3DEffect(
                .degrees(flipDegrees),
                axis: (x: 0, y: 1, z: 0)
            )
            .scaleEffect(isScaled ? 0.75 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: isRotated)
            .shadow(color: .black, radius: 3, x: 0, y: 5)
            .padding(20)
       
            if card.hasMultipleFaces || card.isDualSided {
                if let labels = card.transformLabels {
                    Button("\(labels.buttonLabel)", systemImage: "\(labels.imageLabel)") {
                        transformCard(behavior: card.transformBehavior)
                    }
                    .buttonStyle(.glassProminent)
                }
            }
        }
        .onFirstAppear {
            if card.shouldTransformOnAppear {
                transformCard(behavior: card.appearBehavior)
            }
        }
    }
    
    // MARK: - Functions
    private func transformCard(behavior: SFCard.Orientation) {
        switch behavior {
        case .rotate(let degrees):
            withAnimation(.easeInOut(duration: 0.6)) {
                rotationDegrees = degrees
            }
            isRotated.toggle()
            // Prefer the look outside the above animation block
            if abs(rotationDegrees) == 90 {
                isScaled.toggle()
            }
        case .flipOver:
            withAnimation(.easeInOut(duration: 0.6)) {
                flipDegrees = isFlipped ? -0 : 180
            }
            // Delays so the back side shows right as the front side hits the halfway mark
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFlipped.toggle()
            }
        case .flipOverAndRotate:
            withAnimation(.easeInOut(duration: 0.8)) {
                flipDegrees = isFlipped ? -0 : 180
                rotationDegrees = isRotated ? 0 : 90
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFlipped.toggle()
            }
            isRotated.toggle()
            if abs(rotationDegrees) == 90 || abs(rotationDegrees) == 0 {
                isScaled.toggle()
            }
        case .none:
            break
        }
    }
}

#Preview {
    @Previewable @State var manager = CardManager(client: MockClient())

    ScrollView {
        if let card = manager.card {
            AnimatedCardThumb(card: card)
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

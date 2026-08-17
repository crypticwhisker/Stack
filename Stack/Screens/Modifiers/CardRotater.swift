//
//  CardRotater.swift
//  Stack
//
//  Created by Jacobs, Joe on 2/24/26.
//

import SwiftUI

struct CardRotater: ViewModifier {
    
    @State private var dragAmount = CGSize.zero
    @State private var isDragging = false
    
    func body(content: Content) -> some View {
        
        // Increase this number to make the animation less sensitive
        let rotationAngleX = Double(dragAmount.height / 30)
        let rotationAngleY = Double(-dragAmount.width / 30)
        
        content
            .rotation3DEffect(
                .degrees(rotationAngleX),
                axis: (x: 1, y: 0, z: 0))
            .rotation3DEffect(
                .degrees(rotationAngleY),
                axis: (x: 0, y: 1, z: 0))
            .scaleEffect(isDragging ? 1.05 : 1.0) // How much of the effect you get
            .animation(.easeInOut(duration: 0.2), value: dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragAmount = value.translation
                        isDragging = true
                    }
                    .onEnded { _ in
                        dragAmount = .zero
                        isDragging = false
                    }
            )
            
    }
}

extension View {
    func cardRotater() -> some View {
            modifier(CardRotater())
    }
}


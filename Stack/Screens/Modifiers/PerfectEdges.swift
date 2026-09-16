//
//  PerfectEdges.swift
//  Stack
//
//  Created by Jacobs, Joe on 12/17/25.
//

import SwiftUI

struct PerfectEdges: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(PerfectCornerShape())
    }
}

struct PerfectCornerShape: Shape {
    nonisolated func path(in rect: CGRect) -> Path {
        let radius = rect.height / (89 / 3.1)
        var path = Path()
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: radius, height: radius), style: .continuous)
        
        return path
    }
}

extension View {
    func perfectEdges() -> some View {
            modifier(PerfectEdges())
    }
}

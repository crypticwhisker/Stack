//
//  AdaptiveView.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/21/26.
//

import SwiftUI

struct AdaptiveView<C: View, R: View>: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder let compact: C
    @ViewBuilder let regular: R
    
    var body: some View {
        if horizontalSizeClass == .compact {
            compact
        } else {
            regular
        }
    }
}

#Preview {
    AdaptiveView {
        Text("Compact")
    } regular: {
        Text("Regular")
    }
}

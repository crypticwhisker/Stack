//
//  ChevronButton.swift
//  Stack
//
//  Created by Jacobs, Joe on 5/14/26.
//

import SwiftUI

struct ChevronButton<P: Hashable, Content: View>: View {
    
    let value: P
    
    @ViewBuilder let content: Content
    
    var body: some View {
        NavigationLink(value: value) {
            HStack {
                content
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
        .tint(.primary)
    }
}

#Preview {
    #warning("TODO: Preview provider")
}

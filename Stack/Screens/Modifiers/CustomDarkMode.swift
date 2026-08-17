//
//  CustomDarkMode.swift
//  Stack
//
//  Created by Jacobs, Joe on 12/3/25.
//

import SwiftUI

struct CustomDarkMode: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .scrollContentBackground(.hidden)
            .background(colorScheme == .dark ? .quaternary : .quinary)
    }
}

extension View {
    func customDarkMode() -> some View {
        modifier(CustomDarkMode())
    }
}

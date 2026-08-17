//
//  OnFirstAppear.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/14/25.
//

// https://www.swiftjectivec.com/swiftui-run-code-only-once-versus-onappear-or-task/

import SwiftUI

private struct FirstAppear: ViewModifier {
    let action: () -> ()
    
    // Use this to only fire your block one time
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}

public extension View {
    func onFirstAppear(_ action: @escaping () -> ()) -> some View {
        modifier(FirstAppear(action: action))
    }
}

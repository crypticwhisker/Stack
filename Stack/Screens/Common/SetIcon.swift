//
//  SetIcon.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/3/25.
//

import SwiftUI

struct SetIcon: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let iconName: String
    let iconSize = CGFloat(40)
    
    var body: some View {
        
        let iconName = iconExists(for: iconName) ? iconName : "default"
    
        if colorScheme == .light {
            Image("\(iconName)")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
        } else {
            Image("\(iconName)")
                .resizable()
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
                .colorInvert()
        }
    }
    
    private func iconExists(for name: String) -> Bool {
        UIImage(named: name) != nil
    }
    
}

#Preview {
    SetIcon(iconName: "ltr")
}

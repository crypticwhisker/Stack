//
//  UNFLights.swift
//  Stack
//
//  Created by Jacobs, Joe on 1/15/26.
//

import SwiftUI

struct UNFLights: View {
    
    let lightsON: [Int]
    
    private let lightColors: [Color] = [
        .light1, .light2, .light3, .light4, .light5, .light6
    ]
 
    var body: some View {
        HStack {
            ForEach(1...6, id: \.self) { index in
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(height: 22)
//                        .scaledToFit()
                        .shadow(color: .black, radius: 1.5)
                    Circle()
                        .fill(lightsON.contains(index) ? lightColors[index - 1] : .light1)
                        .frame(height: 18)
//                        .scaledToFit()
                    Text(index.description)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    UNFLights(lightsON: [2,5])
}

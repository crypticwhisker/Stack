//
//  AsyncSetIcon.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/10/26.
//

import SwiftUI
import SwiftDraw

struct AsyncSetIcon: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let iconSize = CGFloat(40)
    let svgURIString: String
    
    var svgURI: URL? {
        URL(string: svgURIString)
    }
    
    var body: some View {
        AsyncSVGView(url: svgURI) { phase in
            switch phase {
            case .empty:
                Image("default")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
            case .success(let svg):
                if colorScheme == .light {
                    SVGView(svg: svg)
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                } else {
                    SVGView(svg: svg)
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .colorInvert()
                }
            case .failure:
                Image("default")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
            }
        }
    }
}

#Preview {
    // Not sure if it's worth setting up a preview here given set icon URIs are behind a CDN
}

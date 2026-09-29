//
//  ContentWarning.swift
//  Stack
//
//  Created by Jacobs, Joe on 12/17/25.
//

import SwiftUI
import Forge

struct SmallWarning: View {
    var body: some View {
        ZStack {
            Color.black
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundStyle(.white)
        }
    }
}

struct MediumWarning: View {
    
    @Binding var showContentWarning: Bool
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .padding(.bottom, 5)
                Text("This card does not meet Magic community standards.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                Button("View") {
                    showContentWarning = false
                }
                .buttonStyle(.glass)
                Link("More Info", destination: URL(string: "https://scryfall.com/docs/faqs/why-do-some-cards-have-content-warnings-20")!)
                    .buttonStyle(.glass)
                    .handleOpenURLInApp()
            }
            .padding(.horizontal)
            .foregroundStyle(.white)
        }
    }
}

struct LargeWarning: View {
    
    @Binding var showContentWarning: Bool
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .padding(.bottom, 5)
                Text("This card does not meet Magic community standards. It may perpetuate racism, contain harmful stereotypes, or depict a sensitive real‑world event.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                Button("View") {
                    showContentWarning = false
                }
                .buttonStyle(.glass)
                Link("More Info", destination: URL(string: "https://scryfall.com/docs/faqs/why-do-some-cards-have-content-warnings-20")!)
                    .buttonStyle(.glass)
                    .handleOpenURLInApp()
            }
            .padding(.horizontal)
            .foregroundStyle(.white)
        }
    }
}

struct ContentWarning: ViewModifier {
    
    @State private var showContentWarning = false
    
    var card: SFCard
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if showContentWarning {
                    ViewThatFits(in: .vertical) {
                        LargeWarning(showContentWarning: $showContentWarning)
                        MediumWarning(showContentWarning: $showContentWarning)
                        SmallWarning()
                    }
                }
            }
            .onFirstAppear {
                showContentWarning = card.hasContentWarning
            }
    }
}

extension View {
    func contentWarning(card: SFCard) -> some View {
        modifier(ContentWarning(card: card))
    }
}

#Preview {
    SmallWarning()
}

#Preview {
    MediumWarning(showContentWarning: .constant(true))
}

#Preview {
    LargeWarning(showContentWarning: .constant(true))
}

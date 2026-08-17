//
//  MixedCardString.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/15/25.
//

import SwiftUI

struct AttributedTextView: UIViewRepresentable {
    
    let attributedString: NSAttributedString
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedString
    }
    
    static func dismantleUIView(_ uiView: UILabel, coordinator: ()) {
        uiView.attributedText = nil
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        let targetWidth = proposal.width ?? UIScreen.main.bounds.width
        return uiView.sizeThatFits(CGSize(width: targetWidth, height: .greatestFiniteMagnitude))
    }
    
}

// Used to render a string with both plain text and mana symbols such as {U} or {3}
// UIViewRepresentable is needed for now as SwiftUI doesn't handle images inline w/text very well

struct MixedCardString: View {
    
    let stringToNS: String
    
    var body: some View {
        let ns = stringToNS.makeNSAttributed()
        AttributedTextView(attributedString: ns)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(3)
    }
}

#Preview {
    
    let exampleCard = "Trample, haste\nWhen The Balrog of Moria dies, you may exile it. When you do, for each opponent, exile up to one target creature that player controls.\nCycling {3}{R} ({3}{R}, Discard this card: Draw a card.)\nWhen you cycle this card, create two Treasure tokens."
    
    MixedCardString(stringToNS: exampleCard)
        .padding()
}

//
//  OracleTagSection.swift
//  Stack
//
//  Created by Jacobs, Joe on 7/9/26.
//

import SwiftUI
import Forge

struct TagLabel: View {
    let tag: SFTag
    var body: some View {
        VStack(alignment: .leading) {
            Label(tag.label, systemImage: "tag")
                .padding(.bottom, 5)
            if let description = tag.description {
                Text(description)
                    .multilineTextAlignment(.leading)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
    }
}

struct OracleTagSection: View {
    
    @Environment(Router.self) var router: Router
    @Environment(TagManager.self) var tagManager: TagManager
    
    let card: SFCard
    
    private var matchingTags: [SFTag] {
        tagManager.tagsByOracleID[card.oracleID ?? ""] ?? []
    }
    
    var body: some View {
        GroupBox("Oracle Tags") {
            if matchingTags.isEmpty {
                Text("No tags found for this card. Tags from recently spoiled cards may not be available from Scryfall yet.")
            } else {
                ForEach(matchingTags, id: \.self) { tag in
                    ChevronButton(value: Route.searchResults("otag:\(tag.slug)")) {
                        TagLabel(tag: tag)
                    }
                    if tag.id != matchingTags.last?.id {
                        Divider()
                            .padding(.bottom, 5)
                    }
                }
            }
        }
        .groupBoxStyle(.outsideLabel)
    }
}

#Preview {
    // maybe some day lol
}

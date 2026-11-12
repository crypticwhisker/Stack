//
//  SyntaxCatalog.swift
//  Stack
//
//  Created by Jacobs, Joe on 11/9/26.
//

import Foundation

// https://scryfall.com/docs/syntax
// https://scryfall.com/docs/api/catalogs/card-types

struct SyntaxCatalog {
    
    // This is not the same list as the one provided by Forge
    static let formats: [SyntaxToken] = {
        [
            SyntaxToken("standard"),
            SyntaxToken("future"),
            SyntaxToken("historic"),
            SyntaxToken("timeless"),
            SyntaxToken("gladiator"),
            SyntaxToken("pioneer"),
            SyntaxToken("modern"),
            SyntaxToken("legacy"),
            SyntaxToken("pauper"),
            SyntaxToken("vintage"),
            SyntaxToken("penny"),
            SyntaxToken("commander"),
            SyntaxToken("oathbreaker"),
            SyntaxToken("standardbrawl"),
            SyntaxToken("brawl"),
            SyntaxToken("competitivebrawl"),
            SyntaxToken("alchemy"),
            SyntaxToken("paupercommander"),
            SyntaxToken("predh"),
            SyntaxToken("tlr"),
        ]
    }()
    
    static let all: [Syntax] = {
        [
            Syntax(
                description: "Search by card color",
                key: SyntaxToken("color", aliases: ["c"]),
                operators: Set(SyntaxOperator.allCases),
                validValues: [
                    SyntaxToken("white", aliases: ["w"]),
                    SyntaxToken("blue", aliases: ["u"]),
                    SyntaxToken("black", aliases: ["b"]),
                    SyntaxToken("red", aliases: ["r"]),
                    SyntaxToken("green", aliases: ["g"])
                ]),
            Syntax(
                description: "Search by what a card is ie. \"permanent\" or \"spell\"",
                key: SyntaxToken("is"),
                operators: [.contains],
                validValues: [
                    SyntaxToken("reserved"),
                    SyntaxToken("spell"),
                    SyntaxToken("permanent"),
                    SyntaxToken("partner"),
                    SyntaxToken("commander"),
                    SyntaxToken("brawler"),
                    SyntaxToken("companion"),
                    SyntaxToken("duelcommander"),
                    SyntaxToken("oathbreaker"),
                    SyntaxToken("flip"),
                    SyntaxToken("modal"),
                    SyntaxToken("meld"),
                    SyntaxToken("meldpart"),
                    SyntaxToken("meldresult"),
                    SyntaxToken("leveler"),
                    SyntaxToken("mdfc"),
                    SyntaxToken("funny"),
                    SyntaxToken("vanilla"),
                    SyntaxToken("frenchvanilla"),
                    SyntaxToken("bear"),
                    SyntaxToken("party"),
                    SyntaxToken("manland"),
                    SyntaxToken("historic"),
                    SyntaxToken("outlaw")
                ]),
            Syntax(
                description: "Search by rarity",
                key: SyntaxToken("rarity", aliases: ["r"]),
                operators: Set(SyntaxOperator.allCases),
                validValues: [
                    SyntaxToken("common"),
                    SyntaxToken("uncommon"),
                    SyntaxToken("rare"),
                    SyntaxToken("special"),
                    SyntaxToken("mythic"),
                    SyntaxToken("bonus")
                ]),
            Syntax(
                description: "Search by cube type",
                key: SyntaxToken("cube"),
                operators: [.contains],
                validValues: [
                    SyntaxToken("arena"),
                    SyntaxToken("grixis"),
                    SyntaxToken("legacy"),
                    SyntaxToken("chuck"),
                    SyntaxToken("twisted"),
                    SyntaxToken("april"),
                    SyntaxToken("protour"),
                    SyntaxToken("uncommon"),
                    SyntaxToken("modern"),
                    SyntaxToken("amaz"),
                    SyntaxToken("tinkerer"),
                    SyntaxToken("livethedream"),
                    SyntaxToken("chromatic"),
                    SyntaxToken("vintage"),
                    SyntaxToken("apcube"),
                ]),
            Syntax(
                description: "Find cards legal in a format",
                key: SyntaxToken("format", aliases: ["f"]),
                operators: [.contains],
                validValues: formats
                ),
            Syntax(
                description: "Find cards banned in a format",
                key: SyntaxToken("banned"),
                operators: [.contains],
                validValues: formats
            ),
            Syntax(
                description: "Find cards restricted in a format",
                key: SyntaxToken("restricted"),
                operators: [.contains],
                validValues: formats
            )
        ]
    }()
}

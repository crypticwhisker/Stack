//
//  MockManager.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/23/26.
//

import Foundation
import Forge

protocol SFClient: Sendable {
    
    func getSpecificCard(id: String) async throws -> SFCard
    func fetchRulingsForCard(rulingURL: String) async throws -> [SFRuling]
    func fetchSpecificURLMultiple(url: String) async throws -> SFList<SFCard>
    func fetchSpecificURLSingle(cardURL: String) async throws -> SFCard
    func fetchSpecificSet(setURI: String) async throws -> SFSet
    
    func getCardsSearch(
        query: String,
        unique: EndpointUnique?,
        order: EndpointOrder?,
        dir: EndpointDirection?,
        includeExtras: Bool?,
        includeMultilingual: Bool?,
        includeVariations: Bool?
    ) async throws -> SFList<SFCard>
    
}

extension SFClient {
    
    func getCardsSearch(
        query: String,
        unique: EndpointUnique? = nil,
        order: EndpointOrder? = nil,
        dir: EndpointDirection? = nil,
        includeExtras: Bool? = nil,
        includeMultilingual: Bool? = nil,
        includeVariations: Bool? = nil
    ) async throws -> SFList<SFCard> {
        try await getCardsSearch(
            query: query,
            unique: unique,
            order: order,
            dir: dir,
            includeExtras: includeExtras,
            includeMultilingual: includeMultilingual,
            includeVariations: includeVariations
        )
    }
    
}

extension ForgeClient: SFClient {}

struct SampleDataDecoder {

    enum Error: Swift.Error {
        case missing(String)
    }

    static func load<T: Decodable>(_ name: String, as type: T.Type = T.self) throws -> T {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw Error.missing("Sample resource \(name) not found")
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}


final class MockClient: SFClient {
    
    func getSpecificCard(id: String) async throws -> Forge.SFCard {
        try SampleDataDecoder.load("card_sauron")
    }
    
    func fetchRulingsForCard(rulingURL: String) async throws -> [Forge.SFRuling] {
        try SampleDataDecoder.load("rulings_sauron")
    }
    
    func fetchSpecificURLMultiple(url: String) async throws -> Forge.SFList<Forge.SFCard> {
        try SampleDataDecoder.load("prints_sauron")
    }
    
    func fetchSpecificURLSingle(cardURL: String) async throws -> Forge.SFCard {
        switch cardURL {
        case "https://api.scryfall.com/cards/6943f966-fd21-427c-a13f-44727edcaa4b":
            return try SampleDataDecoder.load("part_sauron_orc")
        case "https://api.scryfall.com/cards/7215460e-8c06-47d0-94e5-d1832d0218af":
            return try SampleDataDecoder.load("part_sauron_rty")
        case "https://api.scryfall.com/cards/2a845583-5698-4650-9493-ad264d7674d2":
            return try SampleDataDecoder.load("part_sauron")
        default:
            return try SampleDataDecoder.load("card_sauron")
        }
    }
    
    func fetchSpecificSet(setURI: String) async throws -> Forge.SFSet {
        try SampleDataDecoder.load("set_ltr")
    }
    
    func getCardsSearch(query: String, unique: Forge.EndpointUnique?, order: Forge.EndpointOrder?, dir: Forge.EndpointDirection?, includeExtras: Bool?, includeMultilingual: Bool?, includeVariations: Bool?) async throws -> Forge.SFList<Forge.SFCard> {
        try SampleDataDecoder.load("search_results_sauron")
    }
    
}

//
//  MockClient.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/23/26.
//

import Foundation
import Forge

final class MockClient: SFClient {
    
    func fetchAutoComplete(query: String, includeExtras: Bool?) async throws -> [String] {
        try SampleDataDecoder.load("autocomplete_sauron")
        
    }
    
    func fetchAllSets() async throws -> [Forge.SFSet] {
        try SampleDataDecoder.load("sets_all")
        
    }
    
    func fetchRandomCard() async throws -> Forge.SFCard {
        try SampleDataDecoder.load("card_led")
    }
    
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

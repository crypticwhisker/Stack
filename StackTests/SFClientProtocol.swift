//
//  File.swift
//  StackTests
//
//  Created by Jacobs, Joe on 10/1/26.
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
    
    func fetchAutoComplete(query: String, includeExtras: Bool?) async throws -> [String]
    func fetchAllSets() async throws -> [SFSet]
    func fetchRandomCard() async throws -> SFCard
    
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
    
    func fetchAutoComplete(query: String, includeExtras: Bool? = nil) async throws -> [String] {
        try await fetchAutoComplete(query: query, includeExtras: includeExtras)
    }
    
}

extension ForgeClient: SFClient {}

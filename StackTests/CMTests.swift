//
//  CMTests.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/24/26.
//

import Testing
import Forge
@testable import Stack

@MainActor
struct CMTests {

    @Test func canLoadCardByScryfallID() async throws {
        let expectedCard: SFCard = try SampleDataDecoder.load("card_sauron")

        let sut = CardManager(client: MockClient())

        await sut.loadCard(
            for: .scryfallID(expectedCard.id)
        )

        #expect(sut.card?.id == expectedCard.id)
        #expect(sut.appState == .success)
    }
    
    @Test func canLoadCardByRawString() async throws {

        let mock = CardManager(client: MockClient())
        await mock.loadCard(for: .rawString("Frodo, Sauron's Bane"))

        #expect(mock.card?.name == "Frodo, Sauron's Bane")
        #expect(mock.appState == .success)
    }
    
    @Test func appStateFailureWithNoMatch() async throws {

        let mock = CardManager(client: MockClient())
        await mock.loadCard(for: .rawString("The One Ring"))

        #expect(mock.appState == .failure("No match found"))
    }
    
    @Test func canLoadPrints() async throws {
        
        let mock = CardManager(client: MockClient())
        await mock.loadCard(for: .rawString("Sauron, the Dark Lord"))
        await mock.fetchPrints()
        
        #expect(!mock.prints.isEmpty)
    }
    
    @Test func canLoadSet() async throws {
        
        let mock = CardManager(client: MockClient())
        await mock.loadCard(for: .rawString("Sauron, the Dark Lord"))
        await mock.fetchSet()
        
        #expect(mock.set?.name == "The Lord of the Rings: Tales of Middle-earth")
    }
    
    @Test func canLoadRulings() async throws {
        let mock = CardManager(client: MockClient())
        await mock.loadCard(for: .rawString("Sauron, the Dark Lord"))
        await mock.fetchRulings()
        
        #expect(!mock.rulings.isEmpty)
    }
    
    @Test func canLoadAllParts() async throws {
        let mock = CardManager(client: MockClient())
        await mock.loadCard(for: .rawString("Sauron, the Dark Lord"))
        await mock.fetchAllParts()
        
        #expect(!mock.otherParts.isEmpty)
    }
    
}

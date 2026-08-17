//
//  MockClient.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/12/26.
//

import Foundation
import Forge

protocol MockClientProtocol {
    func getCardsSearch() async throws -> String
}

class MockClient: MockClientProtocol {

    let decoder: JSONDecoder
    
    init(
        decoder: JSONDecoder = .init()
    ) {
        self.decoder = decoder
    }
    
    func decode<T: Decodable>(data: Data, as type: T.Type) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw error
        }
    }
    
//    -> SFList<SFCard>
    func getCardsSearch() async throws -> String {
        return "Test"
    }
    
}

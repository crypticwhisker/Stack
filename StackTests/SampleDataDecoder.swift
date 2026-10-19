//
//  SampleDataDecoder.swift
//  StackTests
//
//  Created by Jacobs, Joe on 10/1/26.
//

import Foundation
import Forge

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

// Static data for when previews may need it
enum PreviewData {
    
    static let card: SFCard = {
        do {
            return try SampleDataDecoder.load("card_led")
        } catch {
            fatalError("Failed to load preview data: \(error)")
        }
    }()
    
    static let set: SFSet = {
        do {
            return try SampleDataDecoder.load("set_ltr")
        } catch {
            fatalError("Failed to load preview data: \(error)")
        }
    }()
}

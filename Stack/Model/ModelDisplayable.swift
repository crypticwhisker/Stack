//
//  ModelDisplayable.swift
//  Stack
//
//  Created by Jacobs, Joe on 3/10/26.
//

import Foundation
import SwiftData
import Forge

protocol ModelDisplayable {
    var scryfallID: String { get }
}

extension ModelDisplayable {
    // Needs to be computed, see https://scryfall.com/blog/upcoming-api-changes-to-scryfall-image-uris-and-download-uris-224
    var imageURL: URL? {
        let endPoint = GetCardsID(
            scryfallID: scryfallID,
            format: .image,
            version: .normal
        )
        
        do {
            let url = try endPoint.makeURL()
            return url
        } catch {
            print(error)
        }
        
        return nil
    }
}

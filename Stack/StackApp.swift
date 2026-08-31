//
//  StackApp.swift
//  Stack
//
//  Created by Jacobs, Joe on 7/16/26.
//

import SwiftUI
import SwiftData
import Kingfisher
import OSLog
import Forge

let debugLog = Logger.init(
    subsystem: "com.ninelives.stack",
    category: "stack.debugging"
)

extension URLSession {
    static func scryfallSession() -> URLSession {
        let cache = URLCache(
            memoryCapacity: 50 * 1024 * 1024, // 50 MB
            diskCapacity: 500 * 1024 * 1024 // 500 MB
        )

        let config = URLSessionConfiguration.default
        config.urlCache = cache
        config.httpAdditionalHeaders = [
            "User-Agent": "Stack/1.0",
            "Accept": "application/json"
        ]

        return URLSession(configuration: config)
    }
}

@main
struct StackApp: App {
    
    init() {
        let cache = KingfisherManager.shared.cache
        cache.diskStorage.config.sizeLimit = 300 * 1024 * 1024
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [ListCard.self])
    }
}

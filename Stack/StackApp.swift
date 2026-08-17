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

let debugLog = Logger.init(
    subsystem: "com.ninelives.stack",
    category: "stack.debugging"
)

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

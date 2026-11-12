//
//  SyntaxSuggestionTests.swift
//  StackTests
//
//  Created by Jacobs, Joe on 10/30/26.
//

import Foundation
import Testing
@testable import Stack

@MainActor
struct SyntaxTest {
    
    @Test func run1() {
    
        let text = "is:me"
        let cursor = text.index(text.startIndex, offsetBy: 3)
        
        let mock = SearchManager()
        let result = #require(mock.parseSearchStringAtCursor(string: text, cursor: cursor))
        
        #expect(result.recommendations.contains("meld"))
        #expect(result.recommendations.contains("meldpart"))
    }
    
}


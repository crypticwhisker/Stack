//
//  ParsedSearchToken.swift
//  Stack
//
//  Created by Jacobs, Joe on 11/9/26.
//

import Foundation

struct ParsedSearchToken {
    let key: String
    let op: SyntaxOperator
    let value: String
    let recommendations: [String]
    let replacementRange: Range<String.Index>
}

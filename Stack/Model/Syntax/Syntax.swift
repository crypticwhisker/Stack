//
//  Syntax.swift
//  Stack
//
//  Created by Jacobs, Joe on 11/9/26.
//

import Foundation

struct Syntax {
    let description: String
    let key: SyntaxToken
    let operators: Set<SyntaxOperator>
    let validValues: [SyntaxToken]
}

struct SyntaxToken: Hashable {
    let value: String
    let aliases: [String]

    init(_ value: String, aliases: [String] = []) {
        self.value = value
        self.aliases = aliases
    }

    func matches(_ input: String) -> Bool {
        value.localizedCaseInsensitiveCompare(input) == .orderedSame ||
        aliases.contains {
            $0.localizedCaseInsensitiveCompare(input) == .orderedSame
        }
    }
}

enum SyntaxOperator: String, CaseIterable, Hashable {
    case contains = ":"
    case equals = "="
    case notEquals = "!="
    case greaterThanOrEqual = ">="
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case lessThan = "<"
}

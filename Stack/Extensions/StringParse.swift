//
//  StringParse.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/10/26.
//

import Foundation
import SwiftUI

extension String {
    
    enum parsedParts: Hashable {
        case token(String)
        case text(String)
    }
    
    func parseManaString() -> [parsedParts] {
        
        let tokenRegex = #/(?<token>\{[^}]+\})|(?<text>[^{}]+)/#
        
        let parts: [parsedParts] = self.matches(of: tokenRegex).compactMap { match in
            if let token = match.output.token {
                let clean = token.trimmingCharacters(in: .init(charactersIn: "{}")).replacingOccurrences(of: "/", with: "")
                return .token(String(clean))
            }
            if let text = match.output.text {
                return .text(String(text))
            }
            return nil
        }
        
        return parts
    }
    
}

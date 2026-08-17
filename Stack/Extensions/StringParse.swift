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
                return .token(String(clean)) }
            if let text = match.output.text { return .text(String(text)) }
            return nil
        }
        
        return parts
    }
    
    func makeNSAttributed() -> NSAttributedString {
        let result = NSMutableAttributedString()
        let parsed = parseManaString()
        for part in parsed {
            switch part {
            case .text(let text):
                result.append(NSAttributedString(string: text))
            case .token(let token):
                let clean = token.trimmingCharacters(in: .init(charactersIn: "{}"))
                if let image = UIImage(named: clean) {
                    let attachment = NSTextAttachment()
                    attachment.image = image
                    attachment.bounds = CGRect(x: 0, y: -3, width: 16, height: 16)
                    result.append(NSAttributedString(attachment: attachment))
                }
            }
        }
        
        let paragraphSpacing: CGFloat = 10
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.alignment = .natural
        
        result.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: result.length))
        
        return result
    }
    
}

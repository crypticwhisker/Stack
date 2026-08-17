//
//  GroupBoxStyle.swift
//  Stack
//
//  Created by Jacobs, Joe on 5/13/26.
//

import Foundation
import SwiftUI

struct GBErrorStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .font(.headline)
            configuration.content
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
    }
}

struct GBCardListStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct GBOutsideLabel: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        Group {
            configuration.label
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading) {
                configuration.content
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

extension GroupBoxStyle where Self == GBErrorStyle {
    static var errorStyle: GBErrorStyle { .init() }
}

extension GroupBoxStyle where Self == GBCardListStyle {
    static var cardListStyle: GBCardListStyle { .init() }
}

extension GroupBoxStyle where Self == GBOutsideLabel {
    static var outsideLabel: GBOutsideLabel { .init() }
}

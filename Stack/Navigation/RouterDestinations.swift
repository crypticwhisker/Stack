//
//  RouterDestinations.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/2/25.
//

import SwiftUI

struct RouterDestinations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .cardScreenFromIdentifier(let identifier):
                    CardScreen(initialCard: nil, cardIdentifier: identifier)
                case .cardScreenFromCard(let card):
                    CardScreen(initialCard: card, cardIdentifier: nil)
                case .setGrid(let set):
                    SetView(set: set)
                case .extrasGrid(let navTitle, let cards):
                    ExtrasGrid(navTitle: navTitle, cards: cards)
                case .listCardList(let listCardFolder):
                    ListCardList(for: listCardFolder)
                case .searchResults(let string):
                    SearchResults(input: string)
                }
            }
    }
}

extension View {
    func withRouteNavigation() -> some View {
        self.modifier(RouterDestinations())
    }
}

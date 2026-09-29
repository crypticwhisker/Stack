//
//  CardScreen.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/18/25.
//

import SwiftUI
import SwiftData
import Forge

struct CardScreen: View {
    
    @AppStorage("ShowTags") var showTags = false
    
    @Environment(Router.self) var router: Router
    
    @State private var manager: CardManager = CardManager()
    
    init(
        manager: CardManager = CardManager(),
        initialCard: SFCard?,
        cardIdentifier: CardIdentifier?
    ) {
        _manager = State(initialValue: manager)
        self.initialCard = initialCard
        self.cardIdentifier = cardIdentifier
    }
    
    let initialCard: SFCard?
    let cardIdentifier: CardIdentifier?
    
    var body: some View {
        Group {
            switch manager.appState {
            case .failure(let error): // only method in CardManager that can trigger this is .loadCard
                SearchError(error: error)
            case .loading:
                CustomProgressView()
            case .success:
                if let card = manager.card {
                    ScrollView {
                        LazyVStack {
                            AnimatedCardThumb(card: card)
                                .padding(.bottom, 20)
                            CardText(card: card)
                            CardDetailsSection(card: card, manager: manager)
//                                .redacted(reason: manager.set ==  nil ? .placeholder : [])
                            if !manager.filteredParts.isEmpty {
                                OtherPartsSection(cards: manager.filteredParts)
                            }
                            if !manager.prints.isEmpty {
                                PrintsSection(parentCard: card, prints: manager.prints)
                            }
                            LegalitiesSection(card: card)
                            if !manager.rulings.isEmpty {
                                RulingsSection(rulings: manager.rulings)
                            }
                            if showTags == true {
                                OracleTagSection(card: card)                                
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            CardToolbarMenu(card: card)
                        }
                    }
                }
            }
        }
        .navigationTitle(manager.card?.name ?? "-")
        .navigationBarTitleDisplayMode(.inline)
        .customDarkMode()
        .onFirstAppear {
            Task {
                await manager.setup(initialCard: initialCard, identifier: cardIdentifier)
            }
        }
    }
}

#Preview {
    
    @Previewable @State var manager = CardManager(client: MockClient())
    
    CardScreen(manager: manager, initialCard: nil, cardIdentifier: nil)
        .environment(Router())
        .task {
            await manager.setup(initialCard: nil, identifier: .rawString("Sauron, the Dark Lord"))
        }
    
}

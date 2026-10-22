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
    
    @Environment(Router.self) var router: Router
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
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
                    AdaptiveView {
                        ScrollView {
                            AnimatedCardThumb(card: card)
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            CardBottom(card: card, manager: manager)
                                .padding(.horizontal)
                        }
                        .scrollBounceBehavior(.basedOnSize)
                    } regular: {
                        HStack {
                            AnimatedCardThumb(card: card)
                                .frame(maxHeight: .infinity, alignment: .top)
                                .containerRelativeFrame(.horizontal) { size, axis in
                                    size * 0.4
                                }
                                .padding(.horizontal)
                            ScrollView {
                                CardBottom(card: card, manager: manager)
                                    .padding(.horizontal)
                            }
                            .scrollBounceBehavior(.basedOnSize)
                            .scrollEdgeEffectStyle(.soft, for: .top)
                            .toolbarMinimizationBehavior(.never, for: .navigationBar)
                        }
                    }
                    .toolbar {
                        if #available(anyAppleOS 27.1, *) {
                            ToolbarItemGroup(placement: .primaryAction) {
                                CardToolbarMenu(card: card)
                            }
                            .axisBehavior(.verticalPreferred)
                        } else {
                            ToolbarItemGroup(placement: .primaryAction) {
                                CardToolbarMenu(card: card)
                            }
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
    
    NavigationStack {
        CardScreen(manager: manager, initialCard: nil, cardIdentifier: nil)
            .environment(Router())
            .task {
                await manager.setup(initialCard: nil, identifier: .rawString("Sauron, the Dark Lord"))
            }
    }
    
}

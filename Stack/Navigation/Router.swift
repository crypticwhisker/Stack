//
//  Router.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/18/25.
//

import Foundation
import SwiftUI
import Forge

// https://tanaschita.com/swiftui-navigation-path-with-tabview/

@Observable
class TabRouter<Route: Hashable> {
    var navigationPath = NavigationPath()
}

@Observable
class Router {
    var setTabRouter = TabRouter<Route>()
    var listTabRouter = TabRouter<Route>()
    var collectionTabRouter = TabRouter<Route>()
    var searchTabRouter = TabRouter<Route>()
    
    var activeTab: Tab = .set
    
    enum Tab: Hashable {
        case set
        case customList
        case collection
        case search
    }
}

enum Route: Hashable {
    case cardScreenFromIdentifier(CardIdentifier)
    case cardScreenFromCard(SFCard)
    case extrasGrid(String, [SFCard])
    case setGrid(SFSet)
    case listCardList(ListCardFolder)
    case searchResults(String)
}

enum CardIdentifier: Hashable {
    case scryfallID(String)
    case rawString(String)
}

//
//  RootTabView.swift
//  Stack
//
//  Created by Jacobs, Joe on 7/16/26.
//

import SwiftUI

struct RootTabView: View {
    
    @State private var router = Router()
    @State private var tagManager = TagManager()
    
    var body: some View {
        TabView(selection: $router.activeTab) {
            Tab("Sets", systemImage: "scroll", value: Router.Tab.set) {
                NavigationStack(path: $router.setTabRouter.navigationPath) {
                    SetsTab()
                        .navigationTitle("Sets")
                        .withRouteNavigation()
                }
            }
            Tab("Lists", systemImage: "list.dash", value: Router.Tab.customList) {
                NavigationStack(path: $router.listTabRouter.navigationPath) {
                    ListTab()
                        .navigationTitle("Lists")
                        .withRouteNavigation()
                }
            }
            Tab("Search", systemImage: "magnifyingglass", value: Router.Tab.search, role: .search) {
                NavigationStack(path: $router.searchTabRouter.navigationPath) {
                    SearchTab()
                        .navigationTitle("Search")
                        .withRouteNavigation()
                }
            }
        }
        .environment(router)
        .environment(tagManager)
    }
}

#Preview {
    RootTabView()
}

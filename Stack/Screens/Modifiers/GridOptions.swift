//
//  GridOptions.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/29/25.
//

import SwiftUI

enum ViewMode: String, CaseIterable, Identifiable {
    case singleGrid = "Single Row"
    case doubleGrid = "Medium Grid"
    case tripleGrid = "Small Grid"
    case list = "List"
    
    var id: Self { self }
    
    var systemImage: String {
        switch self {
        case .singleGrid: return "rectangle.portrait"
        case .doubleGrid: return "square.grid.2x2"
        case .tripleGrid: return "square.grid.3x2"
        case .list: return "list.dash"
        }
    }
    
    var columns: [GridItem] {
        switch self {
        case .singleGrid:
            return [GridItem(.flexible())]
        case .doubleGrid:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .tripleGrid:
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        case .list:
            return [GridItem(.flexible())]
        }
    }
}

struct GridOptions: ToolbarContent {
    
    @Binding var viewMode: ViewMode
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Picker("View Mode", selection: $viewMode) {
                ForEach(ViewMode.allCases) { mode in
                    Label(mode.rawValue, systemImage: mode.systemImage)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
}

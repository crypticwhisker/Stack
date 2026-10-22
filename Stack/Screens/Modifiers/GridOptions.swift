//
//  GridOptions.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/29/25.
//

import SwiftUI

enum ViewMode: String, CaseIterable, Identifiable {
    case largeGrid = "Large Grid"
    case mediumGrid = "Medium Grid"
    case smallGrid = "Small Grid"
    case list = "List"
    
    var id: Self { self }
    
    var systemImage: String {
        switch self {
        case .largeGrid: return "rectangle.portrait"
        case .mediumGrid: return "square.grid.2x2"
        case .smallGrid: return "square.grid.3x2"
        case .list: return "list.dash"
        }
    }
    
    func columns(for sizeClass: UserInterfaceSizeClass?) -> [GridItem] {
        
        let count: Int
        let isRegular = sizeClass == .regular
        
        switch self {
        case .largeGrid:
            count = isRegular ? 2 : 1
        case .mediumGrid:
            count = isRegular ? 4 : 2
        case .smallGrid:
            count = isRegular ? 5 : 3
        case .list:
            count = 1
        }
        
        return Array(repeating: GridItem(.flexible()), count: count)
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

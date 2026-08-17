//
//  PaginationLoader.swift
//  Stack
//
//  Created by Jacobs, Joe on 11/5/25.
//

import SwiftUI
import Forge

struct PaginationLoader: View {
    
    /*
     This creates a weird "bug" where the first page is loaded w/175 cards
     User searches which filters .cards which then makes .onAppear trigger
     This repeats until... the exact behavior we want happens
     Only issue is that 6-7 pages of pagination occurs in sequence
     Doesn't seem to cause perf issues currently
     Alternative is to let the user tap a "load more" button but then they need to tap it 6-7 times...
     */
    
    let manager: SearchManager
    
    var body: some View {
        if let hasMore = manager.result, let nextPage = hasMore.nextPage {
            switch manager.pagination {
            case .loadingNextPage:
                CustomProgressView()
            case .loadedNextPage:
                CustomProgressView()
                    .onAppear {
                        Task {
                            print("Loading next page...")
                            await manager.fetchNextPage(for: nextPage)
                        }
                    }
            case .endReached:
                EmptyView()
            }
        }
    }
}

#Preview {
    PaginationLoader(manager: SearchManager())
}

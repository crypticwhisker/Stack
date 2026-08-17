//
//  ListTab.swift
//  Stack
//
//  Created by Jacobs, Joe on 8/22/25.
//

import SwiftUI
import SwiftData

struct ListTab: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query var listCardFolders: [ListCardFolder] = []
    
    @State private var isShowingNewFolderAlert = false
    @State private var isShowingRenameAlert = false
    @State private var folderName = ""
    @State private var folderRename = ""
    @State private var folderToRename: ListCardFolder? = nil
    
    var manager: SavedCardManager {
        SavedCardManager(context: modelContext)
    }
    
    var body: some View {
        List {
            ForEach(listCardFolders) { folder in
                NavigationLink(value: Route.listCardList(folder)) {
                    Text(folder.name)
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button("Rename", systemImage: "pencil") {
                        folderToRename = folder
                        folderRename = folder.name
                        isShowingRenameAlert = true
                    }
                    Button("Delete…", systemImage: "trash", role: .destructive) {
                        if let index = listCardFolders.firstIndex(where: { $0.id == folder.id }) {
                            manager.removeCollection(at: IndexSet(integer: index), for: listCardFolders)
                        }
                    }
                }
            }
            .onDelete { indexSet in
                manager.removeCollection(at: indexSet, for: listCardFolders)
            }
        }
        .customDarkMode()
        .overlay {
            if listCardFolders.isEmpty {
                ContentUnavailableView(
                    "No Lists",
                    systemImage: "list.bullet",
                    description: Text("Add a new List to get started")
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Create New List", systemImage: "text.badge.plus") {
                    isShowingNewFolderAlert.toggle()
                }
            }
        }
        .alert("New List", isPresented: $isShowingNewFolderAlert) {
            TextField("New List", text: $folderName)
            Button("Cancel", role: .cancel) {
                folderName = ""
            }
            Button("Create", role: .confirm) {
//                _ = manager.createCollection(name: folderName, type: ListCardFolder.self)
                _ = manager.createCollection(name: folderName)
                folderName = ""
            }
        } message: {
            Text("Enter a name for this list")
        }
        .alert("New Name", isPresented: $isShowingRenameAlert) {
            TextField("New Name", text: $folderRename)
            Button("Cancel", role: .cancel) { }
            Button("Rename", role: .confirm) {
                if let folder = folderToRename {
                    manager.renameCollection(for: folder, to: folderRename)
                }
            }
        } message: {
            Text("Enter a new name for this folder")
        }
    }
}

#Preview {
    ListTab()
}

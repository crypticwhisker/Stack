//
//  Settings.swift
//  Stack
//
//  Created by Jacobs, Joe on 9/2/25.
//

import SwiftUI
import Kingfisher
import Foundation

struct SettingsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("HideAlchemy") var hideAlchemy = false
    @AppStorage("ShowTags") var showTags = false
    
    @State var cacheSizeResult: Result<UInt, KingfisherError>? = nil
    
    var body: some View {
        NavigationStack {
            List {
//                Section {
//                    Toggle(isOn: $hideAlchemy) {
//                        Text("Hide Alchemy")
//                    }
//                } header: {
//                    Text("Search")
//                } footer: {
//                    Text("When enabled, all searches will filter out Alchemy cards")
//                }
                Section {
                    Toggle(isOn: $showTags) {
                        Text("Show Oracle Tags")
                    }
                } header: {
                    Text("Cards")
                } footer: {
                    Text("Show community managed tags when viewing cards. For example, a card like \"Entomb\" will show tags such as \"tutor-to-graveyard\" and \"tutor-card\".")
                }
                Section {
                    HStack {
                        Button("Clear Image Cache") {
                            KingfisherManager.shared.cache.clearDiskCache {
                                KingfisherManager.shared.cache.calculateDiskStorageSize { result in
                                    Task { @MainActor in
                                        cacheSizeResult = result
                                    }
                                }
                            }
                        }
                        Spacer()
                        if let result = cacheSizeResult {
                            switch result {
                            case .success(let sizeInBytes):
                                let sizeInMB = Double(sizeInBytes) / 1_048_576.0 // 1024^2
                                Text(String(format: "%.2f MB", sizeInMB))
                            case .failure:
                                Text("...")
                            }
                        }
                    }
                } header: {
                    Text("Cache")
                } footer: {
                    Text("Image cache is limited to 500 MB")
                }
                Section {
                    NavigationLink("Acknowledgements") {
                        About()
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                KingfisherManager.shared.cache.calculateDiskStorageSize { result in
                    Task { @MainActor in
                        cacheSizeResult = result
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

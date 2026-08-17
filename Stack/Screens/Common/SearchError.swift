//
//  SearchError.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/9/25.
//

import SwiftUI

struct SearchError: View {

    let error: String
    
    var body: some View {
        GroupBox {
            Text(error)
        } label: {
            Text("Error")
        }
        .groupBoxStyle(.errorStyle)
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    SearchError(error: "All of your terms were ignored.")
}

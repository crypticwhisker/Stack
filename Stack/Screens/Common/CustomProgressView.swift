//
//  CustomProgressView.swift
//  Stack
//
//  Created by Jacobs, Joe on 10/17/25.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
            .padding()
            .glassEffect()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CustomProgressView()
}

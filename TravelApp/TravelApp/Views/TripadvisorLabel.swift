//
//  TripadvisorLabel.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 09/03/2025.
//

import SwiftUI

struct TripadvisorLabel: View {
    var body: some View {
        HStack(spacing: 8) {
            Text("Content provided by")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Image("TripadvisorLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 12)
        }
    }
}

#Preview {
    TripadvisorLabel()
}

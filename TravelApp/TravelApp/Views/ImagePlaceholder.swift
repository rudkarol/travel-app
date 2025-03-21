//
//  ImagePlaceholder.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 25/01/2025.
//

import SwiftUI

struct ImagePlaceholder: View {
    var body: some View {
        ZStack {
            Color.secondary.opacity(0.2)
                .frame(maxWidth: .infinity, idealHeight: 200)
                .cornerRadius(12)
            
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundColor(.secondary)
                .opacity(0.5)
        }
    }
}

#Preview {
    ImagePlaceholder()
}

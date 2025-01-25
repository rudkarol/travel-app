//
//  ImagePlaceholder.swift
//  TravelApp
//
//  Created by osx on 25/01/2025.
//

import SwiftUI

struct ImagePlaceholder: View {
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

#Preview {
    ImagePlaceholder()
}

//
//  ImageACarouselView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 28/02/2025.
//

import SwiftUI
import CachedAsyncImage


struct ImageCarouselView: View {
    
    let photos: [Photo]
    @State private var currentIndex = 0
    
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(0..<photos.count, id: \.self) { index in
                CachedAsyncImage(url: URL(string: photos[index].url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                } placeholder: {
                    ImagePlaceholder()
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 300)
        .cornerRadius(12)
        .padding()
    }
}

#Preview {
    ImageCarouselView(photos: MockDataLocationDetails.sampleLocationDetails.photos!)
}

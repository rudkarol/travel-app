//
//  PlaceListCell.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct PlaceListCell: View {
    
    var location: Location
    var showingAddToFavButton: Bool
    
    @Environment(FavoritesService.self) private var favoritesService
    
    
    init(location: Location, showingAddToFavButton: Bool = true) {
        self.location = location
        self.showingAddToFavButton = showingAddToFavButton
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: location.photos?.first?.url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ImagePlaceholder()
                    .frame(height: 200)
                    .cornerRadius(12)
            }
            .overlay(alignment: .topTrailing) {
                if showingAddToFavButton {
                    Button {
                        Task {
                            try await favoritesService.toggle(location: location)
                        }
                    } label: {
                        Image(systemName: favoritesService.isFavorite(id: location.id) ? "heart.fill" : "heart")
                            .imageScale(.large)
                            .foregroundStyle(Color.red)
                    }
                    .padding()
                }
            }
            
            Text(location.name)
                .bold()
                .padding(.leading)
            
            Text(location.addressObj.country ?? location.addressObj.addressString)
                .padding(.leading)
        }
    }
}


#Preview {
    PlaceListCell(location: MockDataLocationDetails.sampleLocationDetails)
}

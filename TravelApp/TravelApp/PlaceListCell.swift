//
//  PlaceListCell.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct PlaceListCell: View {
    
    let place: LocationBasic
    var showingAddToFavButton: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: URL(string: place.imageUrl)!) {image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                Image("place-placehoilder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
            }
            .overlay(alignment: .topTrailing) {
                if showingAddToFavButton {
                    Button {
                        
                    } label: {
                        Image(systemName: "heart.fill")
                            .imageScale(.large)
                            .foregroundStyle(Color.red)
                    }
                    .padding()
                }
            }

            Text(place.name)
                .bold()
                .padding(.leading)
            Text(place.location)
                .padding(.leading)
        }
    }
}

#Preview {
    PlaceListCell(place: MockDataPlace.samplePlaceOne, showingAddToFavButton: false)
}

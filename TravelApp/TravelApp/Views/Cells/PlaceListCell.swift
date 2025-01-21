//
//  PlaceListCell.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct PlaceListCell: View {
    
    let id: String
    let name: String
    let address: String
    let photos: [Photo]?
    var showingAddToFavButton: Bool = true
    
    var body: some View {
        NavigationLink(destination: LocationDetailsView(locationId: id)) {
            VStack(alignment: .leading) {
                CachedAsyncImage(url: URL(string: photos?.first?.url ?? "")) {image in
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

                Text(name)
                    .bold()
                    .padding(.leading)
                Text(address)
                    .padding(.leading)
            }
        }
    }
}

#Preview {
    PlaceListCell(
        id: "31243",
        name: "Warsaw",
        address: "Warsaw, Poland",
        photos: [Photo(url: "https://picsum.photos/600/400")]
    )
}

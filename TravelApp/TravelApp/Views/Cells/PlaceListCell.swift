//
//  PlaceListCell.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct PlaceListCell: View {
    
    var locationBasicData: LocationBasic? = nil
    var locationDetailsData: LocationDetails? = nil
    var showingAddToFavButton: Bool = true
    
    @Environment(FavoritesManager.self) private var favoritesManager
    private let viewModel: PlaceListCellViewModel
    
    
    init(locationBasicData: LocationBasic? = nil, locationDetailsData: LocationDetails? = nil) {
        self.locationBasicData = locationBasicData
        self.locationDetailsData = locationDetailsData
        
        self.viewModel = PlaceListCellViewModel(locationBasicData: locationBasicData, locationDetailsData: locationDetailsData)
    }
    
    var body: some View {
        NavigationLink(destination: LocationDetailsView(locationBasicData: locationBasicData, locationDetailsData: locationDetailsData)) {
            VStack(alignment: .leading) {
                CachedAsyncImage(url: URL(string: viewModel.photos?.first?.url ?? "")) {image in
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
                            Task {
                                try await favoritesManager.toggle(locationId: viewModel.locationId)
                            }
                            
                            UserDataService.shared.user?.favoritePlaces = favoritesManager.favorites
                        } label: {
                            Image(systemName: favoritesManager.isFavorite(locationId: viewModel.locationId) ? "heart.fill" : "heart")
                                .imageScale(.large)
                                .foregroundStyle(Color.red)
                        }
                        .padding()
                    }
                }

                Text(viewModel.name)
                    .bold()
                    .padding(.leading)
                Text(viewModel.addressObj.addressString)
                    .padding(.leading)
            }
        }
    }
}

#Preview {
    PlaceListCell(locationBasicData: MockDataPlace.samplePlaceOne)
}

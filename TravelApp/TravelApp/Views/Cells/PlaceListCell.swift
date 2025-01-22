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
    
    private let viewModel: PlaceListCellViewModel
    
    
    init(locationBasicData: LocationBasic? = nil, locationDetailsData: LocationDetails? = nil) {
        self.locationBasicData = locationBasicData
        self.locationDetailsData = locationDetailsData
        
        self.viewModel = PlaceListCellViewModel(locationBasicData: locationBasicData, locationDetailsData: locationDetailsData)
    }
    
    var body: some View {
        NavigationLink(destination: LocationDetailsView(locationId: viewModel.locationId)) {
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
                            
                        } label: {
                            Image(systemName: "heart.fill")
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

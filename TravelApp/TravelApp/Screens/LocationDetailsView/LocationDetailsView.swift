//
//  LocationDetailsView.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct LocationDetailsView: View {
    
    let locationBasicData: LocationBasic?
    let locationDetailsData: LocationDetails?
    private let viewModel: LocationDetailsViewModel
    
    
    init(locationBasicData: LocationBasic? = nil, locationDetailsData: LocationDetails? = nil) {
        self.locationBasicData = locationBasicData
        self.locationDetailsData = locationDetailsData
        
        self.viewModel = LocationDetailsViewModel(locationBasicData: locationBasicData, locationDetailsData: locationDetailsData)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    CachedAsyncImage(url: URL(string: viewModel.locationDetailsData?.photos?.first?.url ?? "")) {image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .cornerRadius(8)
                    } placeholder: {
                        Image("place-placehoilder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .cornerRadius(8)
                    }
                    
                    Text(viewModel.locationDetailsData?.name ?? "Name")
                    Text(viewModel.locationDetailsData?.description ?? "")
                    
                    Grid {
                        GridRow {
                            InfoLinkCell(
                                systemName: "1.circle",
                                name: "Safety",
                                url: viewModel.locationDetailsData?.safetyLevel?.link ?? "https://travel.state.gov/content/travel/en/traveladvisories/traveladvisories.html/"
                            )
                            InfoLinkCell(
                                systemName: "lightbulb.max",
                                name: "Nice To Know",
                                url: "https://en.wikivoyage.org/wiki/\(viewModel.locationDetailsData?.addressObj.country ?? "https://google.com")"
                            )
                        }
                        GridRow {
                            InfoLinkCell(
                                systemName: "airplane.departure",
                                name: "Flights",
                                url: "https://google.com"
                            )
                            InfoLinkCell(
                                systemName: "building",
                                name: "Hotels",
                                url: "https://google.com"
                            )
                        }
                    }
                    .padding()
                    
                    Text(viewModel.locationDetailsData?.addressObj.addressString ?? "")
                    
        //            TODO: Map
                }
            }
            .navigationTitle(viewModel.locationDetailsData?.name ?? "Title")
            .task {
                viewModel.getLocationDetails()
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert(
            viewModel.alertData?.title ?? "",
            isPresented: .constant(viewModel.alertData != nil),
            presenting: viewModel.alertData
        ) { alertData in
            Button(alertData.buttonText) {
                viewModel.alertData = nil
            }
        }
    }
}

//#Preview {
//    LocationDetailsView()
//}

//
//  LocationDetailsView.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct LocationDetailsView: View {
    
    let locationId: String
    private let viewmodel = LocationDetailsViewModel()
    
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: URL(string: viewmodel.locationDetails?.photos.first?.url ?? "")) {image in
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
            
            Text(viewmodel.locationDetails?.name ?? "Name")
            Text(viewmodel.locationDetails?.description ?? "")
            
            Grid {
                GridRow {
                    InfoLinkCell(
                        systemName: "1.circle",
                        name: "Safety",
                        url: viewmodel.locationDetails?.safetyLevel.link ?? "https://travel.state.gov/content/travel/en/traveladvisories/traveladvisories.html/"
                    )
                    InfoLinkCell(
                        systemName: "lightbulb.max",
                        name: "Nice To Know",
                        url: "https://en.wikivoyage.org/wiki/\(viewmodel.locationDetails?.addressObj.country ?? "")"
                    )
                }
                GridRow {
                    InfoLinkCell(
                        systemName: "airplane.departure",
                        name: "Flights",
                        url: ""
                    )
                    InfoLinkCell(
                        systemName: "building",
                        name: "Hotels",
                        url: ""
                    )
                }
            }
            .padding()
            
            Text(viewmodel.locationDetails?.addressObj.addressString ?? "")
            
//            TODO: Map
        }
        .task {
            do {
                try await viewmodel.getLocationDetails(locationId: locationId)
            } catch {
                print("error")
            }
        }
    }
}

//#Preview {
//    LocationDetailsView()
//}

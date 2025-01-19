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
    @State private var locationDetails: LocationDetails?
    
    var body: some View {
        VStack {
            CachedAsyncImage(url: URL(string: locationDetails?.photos.first?.url ?? "")) {image in
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
            
            Text(locationDetails?.name ?? "Name")
            Text(locationDetails?.description ?? "")
            
            Grid {
                GridRow {
                    InfoLinkCell(
                        systemName: "1.circle",
                        name: "Safety",
                        url: locationDetails?.safetyLevel.link ?? "https://travel.state.gov/content/travel/en/traveladvisories/traveladvisories.html/"
                    )
                    InfoLinkCell(
                        systemName: "lightbulb.max",
                        name: "Nice To Know",
                        url: "https://en.wikivoyage.org/wiki/\(locationDetails?.addressObj.country ?? "")"
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
            
            Text(locationDetails?.addressObj.addressString ?? "")
            
//            TODO: Map
        }
        .task {
            do {
                locationDetails = try await getLocationDetails(locationId: locationId)
            } catch {
                print("error")
            }
        }
    }
}

//#Preview {
//    LocationDetailsView()
//}

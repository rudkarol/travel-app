//
//  LocationDetailsView.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import SwiftUI
import CachedAsyncImage
import MapKit


struct LocationDetailsView: View {
    
    let location: Location
    
    @Environment(FavoritesService.self) private var favoritesService
    
    
    init(location: Location) {
        self.location = location
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        CachedAsyncImage(url: URL(string: location.photos?.first?.url ?? "")) {image in
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
                        .padding()
                    
                        Text(location.description ?? "")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Grid {
                            GridRow {
                                InfoLinkCell(
                                    systemName: "1.circle",
                                    name: "Safety",
                                    url: location.safetyLevel?.link ?? "https://travel.state.gov/content/travel/en/traveladvisories/traveladvisories.html/"
                                )
                                InfoLinkCell(
                                    systemName: "lightbulb.max",
                                    name: "Nice To Know",
                                    url: "https://en.wikivoyage.org/wiki/\(location.addressObj.country ?? "https://google.com")"
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
                        
                        Text(location.addressObj.addressString)
                        
                        Map {
                            Marker(
                                location.name,
                                coordinate: CLLocationCoordinate2D(
                                    latitude: CLLocationDegrees(location.latitude),
                                    longitude: CLLocationDegrees(location.longitude)
                                )
                            )
                        }
                        .mapControlVisibility(.hidden)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .padding()
                    }
                }
                .navigationTitle(location.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            //                        TODO
                        } label: {
                            Image(systemName: "book")
                                .imageScale(.large)
                        }
                        
                        Button {
                            Task {
                                try await favoritesService.toggle(location: location)
                            }
                        } label: {
                            Image(systemName: favoritesService.isFavorite(id: location.id) ? "heart.fill" : "heart")
                                .imageScale(.large)
                                .foregroundStyle(Color.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LocationDetailsView(location: MockDataLocationDetails.sampleLocationDetails)
}

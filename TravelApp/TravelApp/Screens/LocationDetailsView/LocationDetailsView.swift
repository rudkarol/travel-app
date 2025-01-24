//
//  LocationDetailsView.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import SwiftUI
import CachedAsyncImage

struct LocationDetailsView: View {
    
    let location: Location
    
    @Environment(FavoritesService.self) private var favoritesService
    
    
    init(location: Location) {
        self.location = location
    }
    
    var body: some View {
        ZStack {
            NavigationView {
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
                    
                    Text(location.name)
                    Text(location.description ?? "")
                    
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
                    
        //            TODO: Map
                }
            }
            .navigationTitle(location.name)
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

#Preview {
    LocationDetailsView(location: MockDataLocationDetails.sampleLocationDetails)
}

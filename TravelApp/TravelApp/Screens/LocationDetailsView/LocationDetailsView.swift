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
    @Binding var path: NavigationPath
    
    @Environment(FavoritesService.self) private var favoritesService
    @Environment(PlansService.self) private var plansService
    @Bindable private var viewModel = LocationDetailsViewModel()

    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    CachedAsyncImage(url: URL(string: location.photos?.first?.url ?? "")) {image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .cornerRadius(12)
                    } placeholder: {
                        ImagePlaceholder()
                            .frame(height: 400)
                            .cornerRadius(12)
                    }
                    .padding()
                    
                    Text(location.description ?? "")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if location.climate != nil {
                        ClimateDataView(climateData: location.climate!)
                    }
                    
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
                        viewModel.sheetVisible = true
                        viewModel.isSheetLoading = true
                        
                        Task {
                            do {
                                try await plansService.getUserPlans()
                            } catch let error as AppError {
                                viewModel.alertData = error.alertData
                            } catch {
                                viewModel.alertData = AppError.genericError(error).alertData
                            }
                            
                            viewModel.isSheetLoading = false
                        }
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
            .sheet(isPresented: $viewModel.sheetVisible) {
                AddLocationToPlanMainCard(location: location, isLoading: $viewModel.isSheetLoading)
            }
        }
    }
}


//#Preview {
//    LocationDetailsView(location: MockDataLocationDetails.sampleLocationDetails, path: <#T##Binding<NavigationPath>#>)
//}

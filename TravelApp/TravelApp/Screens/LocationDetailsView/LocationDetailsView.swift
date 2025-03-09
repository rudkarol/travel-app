//
//  LocationDetailsView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 19/01/2025.
//

import SwiftUI
import MapKit


struct LocationDetailsView: View {
    
    let location: Location
    
    @Environment(FavoritesService.self) private var favoritesService
    @Environment(PlansService.self) private var plansService
    @Bindable private var viewModel = LocationDetailsViewModel()

    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    if let photos = location.photos, !photos.isEmpty {
                        ImageCarouselView(photos: photos)
                    } else {
                        ImagePlaceholder()
                            .frame(height: 300)
                            .cornerRadius(12)
                            .padding()
                    }
                    
                    Text(location.description ?? "")
                        .multilineTextAlignment(.center)
//                        .lineLimit(viewModel.isDescriptionExpanded ? nil : 4)
                        .animation(.easeInOut, value: viewModel.isDescriptionExpanded)
                        .padding([.horizontal, .top])
                    
                    TripadvisorLabel()
                        .padding(.bottom)
                    
//                    Button(action: {
//                        viewModel.isDescriptionExpanded.toggle()
//                    }) {
//                        Text(viewModel.isDescriptionExpanded ? "Show less" : "Show more")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                            .padding(.bottom)
//                    }
                    
                    if location.climate != nil {
                        ClimateDataView(climateData: location.climate!)
                    }
                    
                    Grid {
                        GridRow {
                            InfoLinkCell(
                                systemName: location.safetyLevel != nil ? "\(location.safetyLevel!.level).circle" : "questionmark.circle",
                                name: "Safety",
                                url: location.safetyLevel?.link ?? "https://travel.state.gov/content/travel/en/traveladvisories/traveladvisories.html"
                            )
                            InfoLinkCell(
                                systemName: "lightbulb.max",
                                name: "Nice To Know",
                                url: "https://en.wikivoyage.org/wiki/\(location.addressObj.country ?? "https://www.wikivoyage.org/")"
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
                        .multilineTextAlignment(.center)
                        .padding([.top, .horizontal])
                    
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


#Preview {
    LocationDetailsView(location: MockDataLocationDetails.sampleLocationDetails)
}

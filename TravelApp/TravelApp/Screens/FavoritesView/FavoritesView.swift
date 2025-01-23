//
//  FavoritesView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    private let favoritesManager = FavoritesManager()
    private var viewModel = FavoritesViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    List(viewModel.favoritePlaces) { place in
                        PlaceListCell(locationDetailsData: place, showingAddToFavButton: false)
                            .listRowSeparator(.hidden)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    Task {
                                        try await favoritesManager.remove(locationId: place.locationId)
                                    }
                                    viewModel.favoritePlaces.removeAll { $0.locationId == place.locationId }
                                    
                                    print("item deleted")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .listStyle(.plain)
                    
                    if viewModel.favoritePlaces.isEmpty {
                        EmptyState(
                            systemName: "heart.slash",
                            message: "Your favorite places list is empty"
                        )
                    }
                }
                .navigationTitle("Favorite Places")
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
        .task {
            let favorites = favoritesManager.getFavorites()
            
            dump(favorites)
            viewModel.deleteUnliked(ids: favorites)
            await viewModel.loadFavoritePlaces(ids: favorites)
        }
    }
}

#Preview {
    FavoritesView()
}

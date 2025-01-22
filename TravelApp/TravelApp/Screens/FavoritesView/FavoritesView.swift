//
//  FavoritesView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @Environment(FavoritesManager.self) private var favoritesManager
    private var viewModel = FavoritesViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    List(viewModel.favoritePlaces) { place in
                        PlaceListCell(locationDetailsData: place)
                            .listRowSeparator(.hidden)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    Task {
                                        try await favoritesManager.remove(locationId: place.locationId)
                                    }
                                    viewModel.favoritePlaces.removeAll { $0.locationId == place.locationId }
                                    UserDataService.shared.user?.favoritePlaces = favoritesManager.favorites
                                    
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
            await refreshFavoritePlaces()
        }
    }
    
    @MainActor
    private func refreshFavoritePlaces() async {
        favoritesManager.favorites = UserDataService.shared.user?.favoritePlaces ?? []
        dump(favoritesManager.favorites)
        await viewModel.loadFavoritePlaces(ids: favoritesManager.favorites)
    }
}

#Preview {
    FavoritesView()
}

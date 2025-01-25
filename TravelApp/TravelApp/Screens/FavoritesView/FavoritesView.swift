//
//  FavoritesView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @State private var path = NavigationPath()
    
    @Environment(FavoritesService.self) private var favoritesService
    private var viewModel = FavoritesViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                ZStack {
                    List(favoritesService.favorites) { location in
                        NavigationLink(value: location) {
                            PlaceListCell(location: location, showingAddToFavButton: false)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        Task {
                                            try await favoritesService.remove(id: location.id)
                                        }
                                        print("item deleted")
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .navigationDestination(for: Location.self) { location in
                        LocationDetailsView(location: location, path: $path)
                    }
                    .listStyle(.plain)
                    
                    if favoritesService.favorites.isEmpty {
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
    }
}

#Preview {
    FavoritesView()
}

//
//  FavoritesView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    private var viewModel = FavoritesViewModel()
    
    @Environment(FavoritesService.self) private var favoritesService
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    List(favoritesService.favorites) { place in
                        PlaceListCell(location: place, showingAddToFavButton: false)
                            .listRowSeparator(.hidden)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    Task {
                                        try await favoritesService.remove(id: place.id)
                                    }
                                    print("item deleted")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
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

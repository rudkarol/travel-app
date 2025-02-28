//
//  FavoritesView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    
    @State private var isLoading: Bool = false
    @State private var alertData: AlertData?
    
    @Environment(FavoritesService.self) private var favoritesService
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    List(favoritesService.favorites) { location in
                        ZStack {
                            NavigationLink(value: location) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            PlaceListCell(location: location, showingAddToFavButton: false)
                        }
                        .listRowSeparator(.hidden)
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
                    .navigationDestination(for: Location.self) { location in
                        LocationDetailsView(location: location)
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
            
            if isLoading {
                LoadingView()
            }
        }
        .alert(
            alertData?.title ?? "Error",
            isPresented: .constant(alertData != nil),
            presenting: alertData
        ) { alertData in
            Button(alertData.buttonText) {
                self.alertData = nil
            }
        }
    }
}

#Preview {
    FavoritesView()
}

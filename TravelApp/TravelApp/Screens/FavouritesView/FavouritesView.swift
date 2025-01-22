//
//  FavouritesView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct FavouritesView: View {
    
    var viewModel = FavouritesViewModel()
    
    var body: some View {
        ZStack {
            NavigationView{
                ZStack {
                    List(viewModel.favouritePlaces) { place in
                        PlaceListCell(locationDetailsData: place)
                            .listRowSeparator(.hidden)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    //                          TODO: delete
                                    print("item deleted")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .listStyle(.plain)
                    
                    if viewModel.favouritePlaces.isEmpty {
                        EmptyState(
                            systemName: "heart.slash",
                            message: "Your favourite places list is empty"
                        )
                    }
                }
                .navigationTitle("Favourite Places")
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
            await viewModel.loadFavouritePlaces()
            dump(UserDataService.shared.user?.favouritePlaces)
        }
    }
}

#Preview {
    FavouritesView()
}

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
        NavigationView{
            ZStack {
                List(viewModel.favouritePlaces) { place in
                    PlaceListCell(place: place)
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
    }
}

#Preview {
    FavouritesView()
}

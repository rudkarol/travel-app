//
//  AppTabView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem { Label("Home", systemImage: "house") }
            
            FavouritesView()
                .tabItem { Label("Favourites", systemImage: "heart") }
            
            PlansView()
                .tabItem { Label("Plans", systemImage: "book") }
            
            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
        }
    }
}

#Preview {
    AppTabView()
}

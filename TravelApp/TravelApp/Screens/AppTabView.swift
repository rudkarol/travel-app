//
//  AppTabView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            HomePageView()
                .tabItem { Label("Home", systemImage: "house") }
            
            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "heart") }
            
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

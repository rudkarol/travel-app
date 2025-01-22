//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

@main
struct TravelAppApp: App {
    
    @State private var favoritesManager = FavoritesManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesManager)
        }
    }
}

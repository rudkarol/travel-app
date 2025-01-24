//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

@main
struct TravelAppApp: App {
    
    @State var favoritesService = FavoritesService()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesService)
        }
    }
}

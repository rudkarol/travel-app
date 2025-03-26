//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

@main
struct TravelAppApp: App {
    
    @State var favoritesService = FavoritesService()
    @State var plansService = PlansService()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(favoritesService)
                .environment(plansService)
        }
    }
}

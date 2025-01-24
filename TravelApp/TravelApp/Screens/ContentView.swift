//
//  ContentView.swift
//  TravelApp
//
//  Created by osx on 20/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var authManager = AuthManager.shared
    @Environment(FavoritesService.self) private var favoritesService
    

    var body: some View {
        Group {
            if authManager.isLoggedIn {
                AppTabView()
            } else {
                LoginView()
            }
        }
        .task {
            await authManager.checkLoginStatus()
            
            if authManager.isLoggedIn {
                do {
                    try await favoritesService.getUserFavorites()
                } catch {
//                    TODO
                }
            }
        }
    }
}

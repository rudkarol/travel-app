//
//  FavoritesManager.swift
//  TravelApp
//
//  Created by osx on 22/01/2025.
//

import Foundation
import Observation

@Observable
class FavoritesManager {
    var favorites: [String] = []
    
    
    func isFavorite(locationId: String) -> Bool {
        return favorites.contains(locationId)
    }
    
    func remove(locationId: String) async throws {
        favorites.removeAll { $0 == locationId }
        try await updateUserFavorites()
    }
    
    func toggle(locationId: String) async throws {
        if isFavorite(locationId: locationId) {
            try await remove(locationId: locationId)
        } else {
            favorites.append(locationId)
            try await updateUserFavorites()
        }
    }
    
    private func updateUserFavorites() async throws {
        let endpointUrl = "/user/me/favorites"
        
        try await TravelApiRequest.shared.putData(endpointUrl: endpointUrl, body: favorites)
    }
}

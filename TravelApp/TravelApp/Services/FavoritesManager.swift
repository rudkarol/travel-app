//
//  FavoritesManager.swift
//  TravelApp
//
//  Created by osx on 22/01/2025.
//

import Foundation
import Observation


class FavoritesManager {
    
    private let userData = UserDataService.shared
    
    func getFavorites() -> [String] {
        return userData.user?.favoritePlaces ?? []
    }
    
    func isFavorite(locationId: String) -> Bool {
        return userData.user?.favoritePlaces?.contains(locationId) ?? false
    }
    
    func remove(locationId: String) async throws {
        userData.user?.favoritePlaces?.removeAll { $0 == locationId }
        try await updateUserFavoritesRequest()
    }
    
    func toggle(locationId: String) async throws {
        if isFavorite(locationId: locationId) {
            try await remove(locationId: locationId)
        } else {
            userData.user?.favoritePlaces?.append(locationId)
            try await updateUserFavoritesRequest()
        }
    }
    
    private func updateUserFavoritesRequest() async throws {
        let endpointUrl = "/user/me/favorites"
        
        try await TravelApiRequest.shared.putData(endpointUrl: endpointUrl, body: userData.user?.favoritePlaces)
    }
}

//
//  FavoritesService.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 22/01/2025.
//

import Foundation
import Observation


@Observable
class FavoritesService {
    
    var favorites: [Location] = []
    
    
    func isFavorite(id: String) -> Bool {
        return favorites.contains(where: { $0.id == id})
    }
    
    func remove(id: String) async throws {
        favorites.removeAll { $0.id == id }
        try await updateUserFavorites()
    }
    
    func toggle(location: Location) async throws {
        if isFavorite(id: location.id) {
            favorites.removeAll { $0.id == location.id }
        } else {
            favorites.append(location)
        }
        
        try await updateUserFavorites()
    }
    
    func getUserFavorites() async throws {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/user/me/favorites?currency=\(currencyCode ?? "usd")"
        
        let data = try await FastApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            favorites = try decoder.decode([Location].self, from: data)
        } catch {
            print("get favorites decoder error")
            throw AppError.invalidData
        }
    }
    
    private func updateUserFavorites() async throws {
        let endpointUrl = "/user/me/favorites"
        let ids = favorites.map { $0.id }
        
        try await FastApiRequest.shared.putData(endpointUrl: endpointUrl, body: ids)
    }
    
    func clearFavorites() {
        favorites.removeAll()
    }
}

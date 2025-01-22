//
//  FavoritesViewModel.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Observation

@Observable final class FavoritesViewModel {
    
    var favoritePlaces: [LocationDetails] = []
    var isLoading: Bool = false
    var alertData: AlertData?
    
    
    @MainActor
    func loadFavoritePlaces(ids: [String]) async {
        isLoading = true
        
        for id in ids {
            guard !favoritePlaces.contains(where: { $0.locationId == id }) else {
                continue
            }
            
            do {
                let details = try await LocationsService.shared.locationDetailsRequest(locationId: id)
                favoritePlaces.append(details)
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
        }
        
        isLoading = false
    }
}

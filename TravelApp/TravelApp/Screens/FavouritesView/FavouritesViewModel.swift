//
//  FavouritesViewModel.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import Observation

@Observable final class FavouritesViewModel {
    
    var favouritePlaces: [LocationDetails] = []
    var isLoading: Bool = false
    var alertData: AlertData?
    private var favouriteIds = UserDataService.shared.user?.favouritePlaces
    
    func loadFavouritePlaces() {
        isLoading = true
        
        favouriteIds?.forEach { id in
            Task {
                do {
                    let details = try await LocationsService.shared.locationDetailsRequest(locationId: id)
                    favouritePlaces.append(details)
                } catch let error as AppError {
                    alertData = error.alertData
                } catch {
                    alertData = AppError.genericError(error).alertData
                }
            }
        }
        isLoading = false
    }
}

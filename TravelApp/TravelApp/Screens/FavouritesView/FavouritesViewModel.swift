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

    
    @MainActor
    func loadFavouritePlaces() async {
        isLoading = true

        if let favouriteIds = UserDataService.shared.user?.favouritePlaces {
            for id in favouriteIds {
                if !favouritePlaces.contains(where: { $0.locationId == id}) {
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
            }
        }
        
        isLoading = false
    }
}

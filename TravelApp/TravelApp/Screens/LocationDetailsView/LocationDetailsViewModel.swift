//
//  LocationDetailsViewModel.swift
//  TravelApp
//
//  Created by osx on 20/01/2025.
//

import SwiftUI
import Observation

@MainActor @Observable class LocationDetailsViewModel {
    
    var locationDetails: LocationDetails?
    var isLoading: Bool = false
    var alertData: AlertData?
    
    let locationId: String
    
    
    init(locationId: String) {
        self.locationId = locationId
    }
    
    func getLocationDetails() {
        isLoading = true
        
        Task {
            do {
                locationDetails = try await LocationsService.shared.locationDetailsRequest(locationId: locationId)
                isLoading = false
            } catch let error as AppError {
                alertData = error.alertData
                isLoading = false
            } catch {
                alertData = AppError.genericError(error).alertData
                isLoading = false
            }
        }
        
    }
}


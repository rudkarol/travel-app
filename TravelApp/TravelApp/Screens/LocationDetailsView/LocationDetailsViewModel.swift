//
//  LocationDetailsViewModel.swift
//  TravelApp
//
//  Created by osx on 20/01/2025.
//

import SwiftUI
import Observation

@MainActor @Observable class LocationDetailsViewModel {
    
    let locationBasicData: LocationBasic?
    var locationDetailsData: LocationDetails?
    let locationId: String
    var isLoading: Bool = false
    var alertData: AlertData?
    
    
    init(locationBasicData: LocationBasic? = nil, locationDetailsData: LocationDetails? = nil) {

        if let details = locationDetailsData {
            self.locationId = details.locationId
        } else if let basic = locationBasicData {
            self.locationId = basic.locationId
        } else {
            fatalError("LocationDetailsViewModel - two nil arguments")
        }
        
        self.locationBasicData = locationBasicData
        self.locationDetailsData = locationDetailsData
    }
    
    func getLocationDetails() {
        isLoading = true
        
        if locationDetailsData != nil {
            isLoading = false
        } else {
            Task {
                do {
                    locationDetailsData = try await LocationsService.shared.locationDetailsRequest(locationId: locationBasicData!.locationId)
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
}


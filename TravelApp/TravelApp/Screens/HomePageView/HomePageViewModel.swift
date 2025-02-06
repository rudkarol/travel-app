//
//  HomePageViewModel.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI
import Observation


@Observable final class HomePageViewModel {
    
    var recommendedLocations: [Location] = []
    var userSettingsSheetVisible = false
    var isLoading: Bool = false
    var alertData: AlertData?
    
    private let locationsService = LocationsService()
    
    
    func loadRecommendedLocations() async {
        if recommendedLocations.isEmpty {
            isLoading = true
            
            do {
                recommendedLocations = try await locationsService.getRecommendedLocations()
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
            
            isLoading = false
        }
    }
}


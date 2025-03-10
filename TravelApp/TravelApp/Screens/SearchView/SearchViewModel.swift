//
//  SearchViewModel.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 05/02/2025.
//

import Foundation

@Observable final class SearchViewModel {
    
    var searchText: String = ""
    var selectedCategory: SearchCategory? = nil
    var searchResult: [Location] = []
    var isLoading: Bool = false
    var alertData: AlertData?
    
    private let locationsService = LocationsService()
    
    
    func search() async {
        if searchText != "" {
            isLoading = true
            searchResult = []
            
            do {
                searchResult = try await locationsService.searchLocations(query: searchText, category: selectedCategory)
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
            
            isLoading = false
        }
    }
    
}

enum SearchCategory: String, CaseIterable {
    case hotels, attractions, restaurants, geos
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

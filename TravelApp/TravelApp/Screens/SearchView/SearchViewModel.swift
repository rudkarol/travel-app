//
//  SearchViewModel.swift
//  TravelApp
//
//  Created by osx on 05/02/2025.
//

import Foundation

@Observable final class SearchViewModel {
    
    var searchText: String = ""
    var selectedCategory: SearchCategory? = nil
    var searchResult: [LocationBasic] = []
    var isLoading: Bool = false
    var alertData: AlertData?
    
    private let locationsService = LocationsService()
    
    
    func search() async {
        if searchText != "" {
            isLoading = true
            
            do {
                let r = try await locationsService.searchLocations(query: searchText, category: selectedCategory)
                searchResult = r.data
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

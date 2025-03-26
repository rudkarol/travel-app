//
//  LocationsService.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 19/01/2025.
//

import Foundation

final class LocationsService {

    func getRecommendedLocations() async throws -> [Location] {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/home?currency=\(currencyCode ?? "usd")"
        
        let data = try await FastApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            return try decoder.decode([Location].self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
    
    func searchLocations(query: String, category: SearchCategory?) async throws -> [Location] {
        var endpointUrl = "/locations/search?searchQuery=\(query)"
        if category != nil {
            endpointUrl += "&category=\(category!.rawValue)"
        }
        
        let data = try await FastApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            return try decoder.decode([Location].self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
}

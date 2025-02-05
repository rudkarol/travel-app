//
//  LocationsService.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import Foundation

final class LocationsService {

    func getLocationDetails(locationId: String) async throws -> Location {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/location/?location_id=\(locationId)&currency=\(currencyCode ?? "usd")"
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            return try decoder.decode(Location.self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
    
    func getRecommendedLocations() async throws -> [Location] {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/home/?currency=\(currencyCode ?? "usd")"
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            return try decoder.decode([Location].self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
    
    func searchLocations(query: String, category: SearchCategory?) async throws -> SearchLocationResponseModel {
        var endpointUrl = "/locations/search/?searchQuery=\(query)"
        if category != nil {
            endpointUrl += "&category=\(category!.rawValue)"
        }
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder.withFastApiDateDecodingStrategy()
            return try decoder.decode(SearchLocationResponseModel.self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
}

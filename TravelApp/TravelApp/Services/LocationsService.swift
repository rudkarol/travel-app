//
//  LocationsService.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import Foundation

final class LocationsService {
    
    static let shared = LocationsService()
    private init() {}
    
    
    func locationDetailsRequest(locationId: String) async throws -> LocationDetails {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "/location/?location_id=\(locationId)&currency=\(currencyCode ?? "usd")"
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(LocationDetails.self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
}

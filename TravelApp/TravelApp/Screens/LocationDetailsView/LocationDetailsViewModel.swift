//
//  LocationDetailsViewModel.swift
//  TravelApp
//
//  Created by osx on 20/01/2025.
//

import SwiftUI
import Observation

@Observable class LocationDetailsViewModel {
    
    var locationDetails: LocationDetails?
    
    func getLocationDetails(locationId: String) async throws {
        let locale = NSLocale.current
        let currencyCode = locale.currency?.identifier
        let endpointUrl = "http://192.168.18.12:8000/location/?location_id=\(locationId)&currency=\(currencyCode ?? "usd")"
        var accessToken: String
        
        guard let url = URL(string: endpointUrl) else {
            throw ApiRequestError.invalidURL
        }
        
        do {
            accessToken = try await AuthManager.shared.getAccessToken()
        } catch {
            throw ApiRequestError.invalidCredentials
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiRequestError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200:
            print("request successfull")
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.locationDetails = try decoder.decode(LocationDetails.self, from: data)
            } catch {
                print("decoder error")
                throw ApiRequestError.invalidData
            }
        case 401:
            throw ApiRequestError.unauthorized
        case 403:
            throw ApiRequestError.forbidden
        case 404:
            throw ApiRequestError.notFound
        case 500...599:
            throw ApiRequestError.serverError
        default:
            throw ApiRequestError.unexpectedError
        }
    }
}


//
//  LocationsService.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import Foundation

func getLocationDetails(locationId: String) async throws -> LocationDetails {
    
    let locale = NSLocale.current
    let currencyCode = locale.currency?.identifier
    let endpoinUrl = "http://http://192.168.18.12:8000/location?location_id=\(locationId)&currency=\(currencyCode ?? "usd")"
    var accessToken: String
    
    guard let url = URL(string: endpoinUrl) else {
        throw ApiRequestError.invalidURL
    }
    
    do {
        let credentials = try await AuthManager.shared.getCredentials()
        accessToken = credentials.accessToken
    } catch {
        throw ApiRequestError.invalidCredentials
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
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
            return try decoder.decode(LocationDetails.self, from: data)
        } catch {
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

enum ApiRequestError: Error {
    case invalidURL
    case invalidCredentials
    case invalidResponse
    case invalidData
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unexpectedError
}

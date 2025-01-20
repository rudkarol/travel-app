//
//  LocationsService.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import Foundation


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

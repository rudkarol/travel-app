//
//  AlertItem.swift
//  TravelApp
//
//  Created by osx on 21/01/2025.
//

import SwiftUI

struct AlertData: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    var buttonText: String = "OK"
//    var buttonAction: (() -> Void)? = nil
}

enum AppError: Error {
    case invalidURL
    case invalidCredentials
    case invalidResponse
    case invalidData
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case unexpectedError
    case genericError(Error)
    
    var alertData: AlertData {
        switch self {
        case .invalidURL:
            return AlertData(
                title: "Invalid URL",
                message: "The URL is malformed or invalid. Please try again."
            )
        case .invalidCredentials:
            return AlertData(
                title: "Invalid Credentials",
                message: "Your login credentials are incorrect. Please verify and try again."
            )
        case .invalidResponse:
            return AlertData(
                title: "Invalid Response",
                message: "Received an invalid response from the server. Please try again."
            )
        case .invalidData:
            return AlertData(
                title: "Invalid Data",
                message: "The data received from the server is invalid. Please try again."
            )
        case .unauthorized:
            return AlertData(
                title: "Unauthorized Access",
                message: "You are not authorized to perform this action. Please log in again."
            )
        case .forbidden:
            return AlertData(
                title: "Access Forbidden",
                message: "You don't have permission to access this resource."
            )
        case .notFound:
            return AlertData(
                title: "Not Found",
                message: "The requested resource could not be found."
            )
        case .serverError:
            return AlertData(
                title: "Server Error",
                message: "An error occurred on the server. Please try again later."
            )
        case .unexpectedError:
            return AlertData(
                title: "An Error Occurred",
                message: "Please try again later"
            )
        case .genericError(let error):
            return AlertData(
                title: "Unexpected Error",
                message: error.localizedDescription)
        }
    }
}

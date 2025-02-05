//
//  TravelApiRequest.swift
//  TravelApp
//
//  Created by osx on 21/01/2025.
//

import Foundation

class TravelApiRequest {
    static let shared = TravelApiRequest()
    private init() {}
    
    private let baseUrl = "http://192.168.122.1:8000"
    private var accessToken: String = ""
    
    
    func getData(endpointUrl: String) async throws -> Data {
        guard let url = URL(string: self.baseUrl + endpointUrl) else {
            throw AppError.invalidURL
        }
        
        do {
            self.accessToken = try await AuthManager.shared.getAccessToken()
        } catch {
            throw AppError.invalidCredentials
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)

        print("request successful")
        
        return data
    }
    
    func putData(endpointUrl: String, body: Encodable) async throws {
        guard let url = URL(string: self.baseUrl + endpointUrl) else {
            throw AppError.invalidURL
        }
        
        do {
            self.accessToken = try await AuthManager.shared.getAccessToken()
        } catch {
            throw AppError.invalidCredentials
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            print("encoder error")
            throw AppError.invalidData
        }
        
        let (_, _) = try await URLSession.shared.data(for: request)

        print("request successful")
    }
    
    func postData(endpointUrl: String, body: Encodable) async throws -> Data {
        guard let url = URL(string: self.baseUrl + endpointUrl) else {
            throw AppError.invalidURL
        }
        
        do {
            self.accessToken = try await AuthManager.shared.getAccessToken()
        } catch {
            throw AppError.invalidCredentials
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            print("encoder error")
            throw AppError.invalidData
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)

        print("request successful")
        
        return data
    }
}

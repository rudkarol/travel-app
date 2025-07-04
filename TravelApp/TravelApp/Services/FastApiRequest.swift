//
//  TravelApiRequest.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 21/01/2025.
//

import Foundation

class FastApiRequest {
    static let shared = FastApiRequest()
    private init() {}
    
    private let baseUrl = "http://127.0.0.1:8000"
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
            let encoder = JSONEncoder.withFastApiDateEncodingStrategy()
            let jsonData = try encoder.encode(body)
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
            let encoder = JSONEncoder.withFastApiDateEncodingStrategy()
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            print("encoder error")
            throw AppError.invalidData
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)

        print("request successful")
        
        return data
    }
    
    func patchData(endpointUrl: String, body: Encodable) async throws {
        guard let url = URL(string: self.baseUrl + endpointUrl) else {
            throw AppError.invalidURL
        }
        
        do {
            self.accessToken = try await AuthManager.shared.getAccessToken()
        } catch {
            throw AppError.invalidCredentials
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder.withFastApiDateEncodingStrategy()
            let jsonData = try encoder.encode(body)
            request.httpBody = jsonData
        } catch {
            print("encoder error")
            throw AppError.invalidData
        }
        
        let (_ , _) = try await URLSession.shared.data(for: request)

        print("request successful")
    }
    
    func deleteData(endpointUrl: String) async throws {
        guard let url = URL(string: self.baseUrl + endpointUrl) else {
            throw AppError.invalidURL
        }
        
        do {
            self.accessToken = try await AuthManager.shared.getAccessToken()
        } catch {
            throw AppError.invalidCredentials
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "delete"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
        
        let (_ , _) = try await URLSession.shared.data(for: request)

        print("request successful")
    }
}

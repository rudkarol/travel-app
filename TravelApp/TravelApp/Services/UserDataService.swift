//
//  UserDataService.swift
//  TravelApp
//
//  Created by osx on 21/01/2025.
//

import Foundation


final class UserDataService {
    
    static let shared = UserDataService()
    private init() {}
    
    
    func getUserRequest() async throws -> User {
        let endpointUrl = "/user/me/"
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(User.self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
}

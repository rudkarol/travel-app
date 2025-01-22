//
//  UserDataService.swift
//  TravelApp
//
//  Created by osx on 21/01/2025.
//

import Foundation


@Observable final class UserDataService {
    
    var user: User?
    
    static let shared = UserDataService()
    private init() {}
    
    
    func getUserRequest() async throws {
        let endpointUrl = "/user/me/"
        
        let data = try await TravelApiRequest.shared.getData(endpointUrl: endpointUrl)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            user = try decoder.decode(User.self, from: data)
        } catch {
            print("decoder error")
            throw AppError.invalidData
        }
    }
}

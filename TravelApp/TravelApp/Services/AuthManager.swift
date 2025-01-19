//
//  AuthManager.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import Foundation
import Auth0

class AuthManager {
    static let shared = AuthManager() // Singleton - dostęp w całej aplikaacji
    private let credentialsManager: CredentialsManager
    private var credentials: Credentials?
    
    private init() {
        self.credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    }
    
    func login() async {
        do {
            let credentials = try await Auth0
                .webAuth()
                .scope("openid profile email offline_access")
                .start()
            
            let isSaved = credentialsManager.store(credentials: credentials)
            
            if isSaved {
                self.credentials = credentials
                print("Obtained credentials: \(self.credentials!)")
            }
        } catch {
            print("Failed login with: \(error)")
        }
    }
    
    func logout() async {
        do {
            try await Auth0.webAuth().clearSession()
            _ = credentialsManager.clear()
            self.credentials = nil
            
            print("Session cookie cleared")
        } catch {
            print("Failed logout with: \(error)")
        }
    }
    
    func isAuthenticated() -> Bool {
        return credentialsManager.canRenew()
    }
    
    func getCredentials() async throws -> Credentials {
        do {
            let credentials = try await credentialsManager.credentials()
            print("Renewed credentials: \(credentials)")
            return credentials
        } catch {
            print("Failed to renew credentials with: \(error)")
            throw error
        }
    }

}

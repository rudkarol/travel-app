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
            let credentials = try await Auth0.webAuth().start()
            let isSaved = credentialsManager.store(credentials: credentials)
            
            if isSaved {
                self.credentials = credentials
                print("Obtained credentials: \(self.credentials!)")
            }
        } catch {
            print("Failed with: \(error)")
        }
    }
    
    func logout() async {
        do {
            try await Auth0.webAuth().clearSession()
            _ = credentialsManager.clear()
            self.credentials = nil
            
            print("Session cookie cleared")
        } catch {
            print("Failed with: \(error)")
        }
    }
    
    func isAuthenticated() -> Bool {
//        return credentialsManager.canRenew()
        return credentialsManager.hasValid()
    }
}

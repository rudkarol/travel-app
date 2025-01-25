//
//  AuthManager.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import Foundation
import Auth0
import Observation

@Observable final class AuthManager {
    var isLoggedIn: Bool = false
    
    static let shared = AuthManager() //Singleton - dostępne w całej aplikaacji
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    private init() {}
    
    
    func login() async {
        do {
            let credentials = try await Auth0
                .webAuth()
                .audience("https://travel-planner.com")
                .scope("openid profile email offline_access")
                .start()
            
            _ = credentialsManager.store(credentials: credentials)
            
            await MainActor.run { self.isLoggedIn = true }
            
            print("Login successfull")
        } catch {
            await MainActor.run { self.isLoggedIn = false }
            print("Failed login with: \(error)")
        }
    }
    
    func logout() async {
        do {
            try await Auth0.webAuth().clearSession()
            _ = credentialsManager.clear()

            await MainActor.run { self.isLoggedIn = false }
            
            print("Session cookie cleared")
        } catch {
            print("Failed logout with: \(error)")
        }
    }
    
    func checkLoginStatus() async {
        if credentialsManager.hasValid() {
            await MainActor.run {
                self.isLoggedIn = true
            }
        } else if credentialsManager.canRenew() {
            do {
                _ = try await credentialsManager.credentials()
                await MainActor.run {
                    self.isLoggedIn = true
                }
            } catch {
                await MainActor.run {
                    self.isLoggedIn = false
                }
            }
        } else {
            await MainActor.run {
                self.isLoggedIn = false
            }
        }
    }
    
    func getAccessToken() async throws -> String {
        let credentials = try await credentialsManager.credentials()
        return credentials.accessToken
    }
}

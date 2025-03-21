//
//  AuthManager.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 19/01/2025.
//

import Foundation
import Auth0

@Observable final class AuthManager {
    var user: User? = nil
    var isLoggedIn: Bool = false
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    static let shared = AuthManager() //Singleton
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
            
            print("Login successful")
        } catch {
            await MainActor.run { self.isLoggedIn = false }
            print("Failed login with: \(error)")
        }
    }
    
    func logout() async {
        _ = credentialsManager.clear()
        
        do {
            try await Auth0.webAuth().clearSession()
            print("Session cleared")
        } catch {
            print("Failed to clear session: \(error)")
        }
        
        await MainActor.run {
            self.isLoggedIn = false
            self.user = nil
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
    
    func fetchUserProfile() async {
        do {
            let accessToken = try await getAccessToken()
            
            let userInfo = try await Auth0.authentication()
                .userInfo(withAccessToken: accessToken)
                .start()

            let name = userInfo.name
            let email = userInfo.email

            user = User(name: name!, email: email!)
        } catch {
            print("Failed to fetch user profile: \(error)")
        }
    }
    
    func changeEmail(newEmail: String) async throws {
        let endpointUrl = "/user/me/change-email"
        
        let _ = try await FastApiRequest.shared.patchData(endpointUrl: endpointUrl, body: ChangeEmail(newEmail: newEmail))
    }
    
    func deleteUser() async throws {
        let endpointUrl = "/user/me/delete"
        
        let _ = try await FastApiRequest.shared.deleteData(endpointUrl: endpointUrl)
        
        await MainActor.run {
            self.user = nil
        }
    }
}

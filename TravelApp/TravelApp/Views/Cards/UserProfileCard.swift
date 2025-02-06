//
//  UserProfileCard.swift
//  TravelApp
//
//  Created by osx on 06/02/2025.
//

import SwiftUI

struct UserProfileCard: View {
    
    @State private var user: User?
    @State private var changeEmailSheetVisible = false
    @State private var path = NavigationPath()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section() {
                    VStack {
                        Text(user?.name ?? "Name")
                            .bold()
                        
                        Text(user?.email ?? "Email")
                    }
                }
                
                Section() {
                    Button("Change email") {
                        
                    }
                }
                
                Section(header: Text("Account management")) {
                    Button("Logout") {
                        Task { await AuthManager.shared.logout() }
                    }
                    
                    Button("Delete account") {
                        
                    }
                }
            }
            .navigationTitle("User settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            let userData = await AuthManager.shared.fetchUserProfile()
            await MainActor.run {
                user = userData
            }
        }

        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
    }
}

#Preview {
    UserProfileCard()
}

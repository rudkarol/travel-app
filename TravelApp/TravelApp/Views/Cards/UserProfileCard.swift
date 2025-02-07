//
//  UserProfileCard.swift
//  TravelApp
//
//  Created by osx on 06/02/2025.
//

import SwiftUI

struct UserProfileCard: View {
    
    @State private var changeEmailSheetVisible = false
    
    @State private var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack() {
            Form {
                Section() {
                    VStack {
                        Text(authManager.user?.name ?? "Name")
                            .bold()
                        
                        Text(authManager.user?.email ?? "Email")
                    }
                }
                
                Section() {
                    NavigationLink("Change email", destination: ChangeEmailCard())
                }
                
                Section(header: Text("Account management")) {
                    Button("Logout") {
                        Task { await authManager.logout() }
                        dismiss()
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
            await authManager.fetchUserProfile()
        }

        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
    }
}

#Preview {
    UserProfileCard()
}

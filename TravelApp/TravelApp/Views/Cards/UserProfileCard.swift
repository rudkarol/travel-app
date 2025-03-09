//
//  UserProfileCard.swift
//  TravelApp
//
//  Created by osx on 06/02/2025.
//

import SwiftUI

struct UserProfileCard: View {
    
    @State private var changeEmailSheetVisible = false
    @State private var isShowingDeleteAlert: Bool = false
    @State var alertData: AlertData?
    
    @State private var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack() {
            Form {
                Section() {
                    Label {
                        Text(authManager.user?.name ?? "Name")
                    } icon: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                
                Section(header: Text("Account management")) {
                    NavigationLink("Change email", destination: ChangeEmailCard())
                    
                    Button("Delete account") {
                        isShowingDeleteAlert = true
                    }
                }
                
                Section {
                    Button("Logout") {
                        Task { await authManager.logout() }
                        dismiss()
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
        .alert("Delete account", isPresented: $isShowingDeleteAlert) {
            Group {
                Button("Delete", role: .destructive) {
                    deleteAccountWithBiometrics()
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }
        } message: {
            Text("Are you sure you want to delete your account and all the data it contains?")
        }

        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
    }
}

extension UserProfileCard {
    func deleteAccountWithBiometrics() {
        authenticateWithBiometrics { isAuthenticated in
            guard isAuthenticated else {
//                TODO alert with button to open email app
                UIApplication.shared.openEmailApp()
                return
            }
            
            Task {
                try await authManager.deleteUser()
            }
        }
    }
}

#Preview {
    UserProfileCard()
}

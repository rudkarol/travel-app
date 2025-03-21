//
//  UserProfileCard.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 06/02/2025.
//

import SwiftUI

struct UserProfileCard: View {
    
    @State private var changeEmailSheetVisible = false
    @State private var isShowingDeleteAlert: Bool = false
    @State var alertData: AlertData?
    
    @State private var authManager = AuthManager.shared
    @Environment(PlansService.self) private var plansService
    @Environment(FavoritesService.self) private var favoritesService
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
                        Task {
                            await performLogout()
                        }
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
                UIApplication.shared.openEmailApp()
                return
            }
            
            Task {
                do {
                    try await authManager.deleteUser()
                    await performLogout()
                } catch {
                    alertData = AlertData(
                        title: "Account Deletion Failed",
                        message: "We couldn't delete your account at this time. Please try again later.",
                        buttonText: "OK"
                    )
                }
            }
        }
    }
    
    func performLogout() async {
        plansService.clearPlans()
        favoritesService.clearFavorites()
        
        await authManager.logout()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            dismiss()
        }
    }
}

#Preview {
    UserProfileCard()
}

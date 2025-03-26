//
//  ChangeEmailCard.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 06/02/2025.
//

import SwiftUI

struct ChangeEmailCard: View {
    
    @State private var newEmail = ""
    @State private var newEmailConfirm = ""
    
    @State private var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section() {
                TextField("Enter new email", text: $newEmail)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Confirm new email", text: $newEmailConfirm)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            Section {
                Button("Save") {
                    if newEmail != "" && newEmail == newEmailConfirm {
                        changeEmailWithBiometrics(newEmail: newEmail)
                    }
                }
            }
        }
        .navigationTitle("Change Email")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension ChangeEmailCard {
    func changeEmailWithBiometrics(newEmail: String) {
        authenticateWithBiometrics { isAuthenticated in
            guard isAuthenticated else {
                UIApplication.shared.openEmailApp()
                return
            }
            
            Task {
                try await authManager.changeEmail(newEmail: newEmail)
            }
        }
    }
}

#Preview {
    ChangeEmailCard()
}

//
//  ChangeEmailCard.swift
//  TravelApp
//
//  Created by osx on 06/02/2025.
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
                Button("Update Email") {
                    if newEmail == newEmailConfirm {
                        Task {
                            try await authManager.changeEmail(newEmail: newEmail)
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle("Change Email")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    ChangeEmailCard()
}

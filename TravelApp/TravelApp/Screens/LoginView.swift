//
//  LoginView.swift
//  TravelApp
//
//  Created by osx on 20/01/2025.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        ZStack {
            EmptyState(systemName: "person", message: "Please login to use the app")
            
            Button("Login") {
                Task {
                    await AuthManager.shared.login()
                }
            }
            .padding()
            .foregroundStyle(Color.accentColor)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    LoginView()
}

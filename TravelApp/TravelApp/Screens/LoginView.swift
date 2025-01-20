//
//  LoginView.swift
//  TravelApp
//
//  Created by osx on 20/01/2025.
//

import SwiftUI

struct LoginView: View {

    var body: some View {
        VStack {
            Text("Travel Planner App")
                .font(.largeTitle)
                .padding()
            
            Button {
                Task { await AuthManager.shared.login() }
            } label: {
                Text("Log In")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

        }
    }
}

#Preview {
    LoginView()
}

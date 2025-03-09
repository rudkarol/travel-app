//
//  LoginView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 20/01/2025.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        ZStack {
            VStack {
                Logo(size: 48, color: .accent)
                
                Text("Made for Simple Travel Planning")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .offset(y: -120)
            
            Button(action: {
                Task {
                    await AuthManager.shared.login()
                }
            }, label: {
                Text("Log In")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 14))
            .controlSize(.large)
            .padding()
            .offset(y: 100)
        }
    }
}

#Preview {
    LoginView()
}

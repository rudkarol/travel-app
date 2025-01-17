//
//  EmptyState.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct EmptyState: View {
    
    let imageName: String
    let message: String
    
    var body: some View {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                    
                    Text(message)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .offset(y: -50)
            }
        }

}

#Preview {
    EmptyState(imageName: "empty-favourites", message: "Your favourite places list is empty. Please add some places to your favourites.")
}

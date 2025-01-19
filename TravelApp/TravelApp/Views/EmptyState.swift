//
//  EmptyState.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct EmptyState: View {
    
    let systemName: String
    let message: String
    
    var body: some View {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: systemName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .symbolRenderingMode(.hierarchical)
                    
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
    EmptyState(systemName: "heart.slash", message: "Your favourite places list is empty. Please add some places to your favourites.")
}

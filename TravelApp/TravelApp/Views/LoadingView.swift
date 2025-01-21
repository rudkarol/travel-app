//
//  LoadingView.swift
//  TravelApp
//
//  Created by osx on 21/01/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ProgressView()
                .scaleEffect(2)
        }
        
    }
}



#Preview {
    LoadingView()
}

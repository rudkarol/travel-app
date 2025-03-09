//
//  Logo.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 09/03/2025.
//

import SwiftUI

struct Logo: View {
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Text("Triplando")
            .font(Font.custom("Geist-SemiBold", size: size))
            .foregroundStyle(color)
            .shadow(color: .secondary, radius: 1)
    }
}

#Preview {
    Logo(size: 48, color: .accent)
}

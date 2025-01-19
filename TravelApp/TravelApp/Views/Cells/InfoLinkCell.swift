//
//  InfoLinkCell.swift
//  TravelApp
//
//  Created by osx on 19/01/2025.
//

import SwiftUI

struct InfoLinkCell: View {
    
    let systemName: String
    let name: String
    let url: String
    
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .symbolRenderingMode(.hierarchical)
            
            Text(name)
                .font(.body)
        }
        .padding()
    }
}

#Preview {
    InfoLinkCell(systemName: "lightbulb.max", name: "Nice To Know", url: "fake-url")
}

//
//  InfoLinkCell.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 19/01/2025.
//

import SwiftUI

struct InfoLinkCell: View {
    
    let systemName: String
    let name: String
    let url: String
    
    var body: some View {
        Link(destination: URL(string: url)!) {
            VStack {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .symbolRenderingMode(.hierarchical)
                
                Text(name)
                    .font(.body)
            }
            .frame(width: 150, height: 150)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 0, y: 2)
            )
            .padding()
        }
    }
}



#Preview {
    InfoLinkCell(systemName: "lightbulb.max", name: "Nice To Know", url: "fake-url")
}

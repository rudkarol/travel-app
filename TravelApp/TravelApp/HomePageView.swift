//
//  SwiftUIView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image("ha-long-view")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                HStack {
                    Text("Logo")
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                        
                        Image(systemName: "person")
                            .imageScale(.large)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            
        }
    }
}

#Preview {
    HomePageView()
}

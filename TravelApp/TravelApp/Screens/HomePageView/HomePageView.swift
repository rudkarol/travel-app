//
//  SwiftUIView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct HomePageView: View {
    
    var viewModel = HomePageViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .top) {
                    Image("ha-long-view")
                        .resizable()
                        .aspectRatio(0.62, contentMode: .fill)
                        .clipped()
                    
                    HStack {
                        Text("Logo")
                            .font(.title)
                        
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
                    .padding(.top, 45)
                }
                
                Text("Explore")
                    .font(.title)
                    .bold()
                    .padding([.horizontal, .top])
                
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.exploreItems) { place in
                        PlaceListCell(place: place)
                            .padding()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomePageView()
}

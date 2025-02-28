//
//  SwiftUIView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct HomePageView: View {

    @State private var path = NavigationPath()
    
    @Bindable private var viewModel = HomePageViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
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
                                
                                Button {
                                    viewModel.userSettingsSheetVisible = true
                                } label: {
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
                            }
                            .padding()
                            .padding(.top, 45)
                        }
                        
                        Text("Explore")
                            .font(.title)
                            .bold()
                            .padding([.horizontal, .top])
                        
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.recommendedLocations) { location in
                                NavigationLink(value: location) {
                                    PlaceListCell(location: location)
                                        .padding()
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .navigationDestination(for: Location.self) { location in
                            LocationDetailsView(location: location)
                        }
                        
                        Spacer()
                            .frame(height: 80)
                    }
                }
                .ignoresSafeArea()
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Home Page")
        .sheet(isPresented: $viewModel.userSettingsSheetVisible) {
            UserProfileCard()
        }
        .task {
            await viewModel.loadRecommendedLocations()
        }
    }
}

#Preview {
    HomePageView()
}

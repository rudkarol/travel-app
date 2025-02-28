//
//  SwiftUIView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct HomePageView: View {
    
    @Bindable private var viewModel = HomePageViewModel()
    
    
    var body: some View {
        ZStack {
            NavigationStack() {
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
                        
                        ZStack {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.recommendedLocations) { location in
                                    NavigationLink(value: location) {
                                        PlaceListCell(location: location)
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.vertical, 8)
                            }
                            .navigationDestination(for: Location.self) { location in
                                LocationDetailsView(location: location)
                            }
                            
                            if viewModel.isLoading {
                                LoadingView()
                            }
                        }
                        
                        Spacer()
                            .frame(height: 80)
                    }
                }
                .ignoresSafeArea()
            }
        }
        .navigationTitle("Home Page")
        .sheet(isPresented: $viewModel.userSettingsSheetVisible) {
            UserProfileCard()
        }
        .task {
            await viewModel.loadRecommendedLocations()
        }
        .alert(
            viewModel.alertData?.title ?? "Error",
            isPresented: .constant(viewModel.alertData != nil),
            presenting: viewModel.alertData
        ) { alertData in
            Button(alertData.buttonText) {
                viewModel.alertData = nil
            }
        }
    }
}

#Preview {
    HomePageView()
}

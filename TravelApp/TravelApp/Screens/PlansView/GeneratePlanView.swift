//
//  GeneratePlanView.swift
//  TravelApp
//
//  Created by osx on 26/01/2025.
//

import SwiftUI
import MapKit

struct GeneratePlanView: View {
    
    @State private var selectedDays: Int = 1
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @Binding var path: NavigationPath
    @State var isLoading: Bool = false
    
    @Environment(PlansService.self) private var plansService
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Picker("Select number of days", selection: $selectedDays) {
                    ForEach(1..<8) { day in
                        Text("\(day)").tag(day)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                
                ZStack {
                    Map(position: $position)
    //                    .onMapCameraChange(frequency: .continuous)
                        .frame(height: 400)
                        .cornerRadius(12)
                    
                    Image(systemName: "mappin")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                        .offset(y: -15)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    isLoading = true
                    
                    Task {
                        do {
                            try await plansService.generateAIPlan(
                                latitude: Float(position.region?.center.latitude ?? 52.232972),
                                longitude: Float(position.region?.center.longitude ?? 21.000659),
                                days: selectedDays
                            )
                            
                            if let lastPlan = plansService.plans.last {
                                path.append(lastPlan)
                            } else {
                                print("No plan was generated")
                            }
                        } catch {
                            print("generating error")
                            if !path.isEmpty {
                                path.removeLast()
                            }

                        }
                    }
                } label: {
                    Label("Generate plan with AI", systemImage: "wand.and.sparkles")
                }
            }
            
            if isLoading {
                LoadingView()
            }
        }
    }
}

struct GeneratePlanViewDestination: Hashable { }

//#Preview {
//    GeneratePlanView()
//}

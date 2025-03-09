//
//  GeneratePlanView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 26/01/2025.
//

import SwiftUI
import MapKit

struct GeneratePlanView: View {
    
    @State private var selectedDays: Int = 1
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @Binding var path: NavigationPath
    @State private var isLoading: Bool = false
    @State private var alertData: AlertData? = nil
    @State private var showAlert: Bool = false
    
    @Environment(PlansService.self) private var plansService
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select number of days")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .padding(.leading)
                    
                    Picker("Select number of days", selection: $selectedDays) {
                        ForEach(1..<8) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where are you going?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .padding(.leading)
                    
                    ZStack {
                        Map(position: $position)
//                            .onMapCameraChange(frequency: .continuous)
                            .frame(height: 380)
                            .cornerRadius(12)
                        
                        Image(systemName: "mappin")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                            .offset(y: -15)
                    }
                }
                
                Text("AI will create a custom itinerary based on popular attractions and optimal routes for your selected location.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button {
                    generatePlan()
                } label: {
                    Label("Generate plan with AI", systemImage: "wand.and.sparkles")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 14))
                .controlSize(.large)
            }
            .padding()
            
            if isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Generate AI plan")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            alertData?.title ?? "",
            isPresented: .constant(alertData != nil),
            presenting: alertData
        ) { alertData in
            Button(alertData.buttonText) {
                self.alertData = nil
            }
        }
    }
    
    private func generatePlan() {
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
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
            
            isLoading = false
        }
    }
}

struct GeneratePlanViewDestination: Hashable { }

//#Preview {
//    GeneratePlanView()
//}

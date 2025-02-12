//
//  AddLocationToPlanMainCard.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 26/01/2025.
//

import SwiftUI

struct AddLocationToPlanMainCard: View {
    
    let location: Location
    @Binding var isLoading: Bool
    @State private var path = NavigationPath()
    
    @Environment(PlansService.self) private var plansService
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Form {
//                    Section(header: Text("Existing plans")) {
                    List(plansService.plans) { plan in
                        NavigationLink(value: plan) {
                            Text(plan.name)
                        }
                    }
                    
                    Button {
                        path.append(AddPlanFormScreenDestination())
                    } label: {
                        Text("Add a new plan")
                    }
                }
                .navigationDestination(for: Plan.self) { plan in
                    AddLocationToPlanDaysCard(location: location, plan: plan, path: $path)
                }
                .navigationDestination(for: AddPlanFormScreenDestination.self) { planForm in
                    PlanSettingsForm()
                }
                
                if isLoading {
                    LoadingView()
                }
            }
            .navigationTitle("Select plan")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
//        .presentationContentInteraction(.scrolls)
    }
}

//#Preview {
//    AddLocationToPlanMainCard()
//}

//
//  AddLocationToPlanDaysCard.swift
//  TravelApp
//
//  Created by osx on 26/01/2025.
//

import SwiftUI

struct AddLocationToPlanDaysCard: View {
    
    let location: Location
    let plan: Plan
    @Binding var isVisible: Bool
    @Binding var path: NavigationPath
    
    @Environment(PlansService.self) private var plansService
    
    
    var body: some View {
        Form {
            List(plan.days.indices, id: \.self) { dayIndex in
                Button {
                    if let planIndex = plansService.plans.firstIndex(where: { $0.id == plan.id }) {
                        plansService.plans[planIndex].days[dayIndex].places?.append(location)
                    }
                    
                    Task {
                        try await plansService.updateUserPlans()
                    }
                } label: {
                    Text("Day \(dayIndex + 1)")
                }
            }
        }
        .navigationTitle("Select plan")
        .navigationBarItems(
            leading: Button("Cancel") {
                isVisible = false
            },
            trailing: Button("Save") {
                isVisible = false
            }
        )
    }
}

//#Preview {
//    AddLocationToPlanDaysCard()
//}

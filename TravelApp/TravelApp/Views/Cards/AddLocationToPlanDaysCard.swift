//
//  AddLocationToPlanDaysCard.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 26/01/2025.
//

import SwiftUI

struct AddLocationToPlanDaysCard: View {
    
    let location: Location
    @State var plan: Plan
    @Binding var path: NavigationPath
    
    @Environment(PlansService.self) private var plansService
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        Form {
            List(plan.days.indices, id: \.self) { dayIndex in
                Button("Day \(dayIndex + 1)") {
                    if let planIndex = plansService.plans.firstIndex(where: { $0.id == plan.id }) {
                        if plansService.plans[planIndex].days[dayIndex].places != nil {
                            plansService.plans[planIndex].days[dayIndex].places!.append(location)
                        } else {
                            plansService.plans[planIndex].days[dayIndex].places = [location]
                        }
                        
                        Task {
                            try await plansService.updatePlan(planId: plan.id)
                        }
                    } else {
                        print("pplan index error")
                    }

                    dismiss()
                }
                .buttonStyle(.plain)
            }
            
            Button {
                if let planIndex = plansService.plans.firstIndex(where: { $0.id == plan.id }) {
                    plansService.plans[planIndex].days.append(DailyPlan())
                    self.plan.days = plansService.plans[planIndex].days
                    
                    Task {
                        try await plansService.updatePlan(planId: plan.id)
                    }
                } else {
                    print("pplan index error")
                }
            } label: {
                Text("Add day")
            }
            .disabled(plan.days.count >= 7)
        }
        .navigationTitle("Select day")
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
        //        .presentationContentInteraction(.scrolls)
    }
}

//#Preview {
//    AddLocationToPlanDaysCard()
//}

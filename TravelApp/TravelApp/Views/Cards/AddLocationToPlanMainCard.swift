//
//  AddLocationToPlanMainCard.swift
//  TravelApp
//
//  Created by osx on 26/01/2025.
//

import SwiftUI

struct AddLocationToPlanMainCard: View {
    
    let location: Location
    @Binding var isVisible: Bool
    @State private var path = NavigationPath()
    
    @Environment(PlansService.self) private var plansService
    
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                List(plansService.plans) { plan in
                    NavigationLink(value: plan) {
                        Text(plan.name)
                    }
                }
                
            }
            .navigationDestination(for: Plan.self) { plan in
                AddLocationToPlanDaysCard(location: location, plan: plan, isVisible: $isVisible, path: $path)
            }
            .navigationTitle("Select plan")
        }
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
//    AddLocationToPlanMainCard()
//}

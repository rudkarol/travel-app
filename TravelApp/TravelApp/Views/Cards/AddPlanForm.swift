//
//  AddPlanForm.swift
//  TravelApp
//
//  Created by osx on 25/01/2025.
//

import SwiftUI

struct AddPlanForm: View {
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var toggleState: Bool = false
    
    @Environment(PlansService.self) private var plansService
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Base Information")) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Section(header: Text("Days of the trip")) {
                    Toggle("Set date", isOn: $toggleState)
                    
                    if toggleState {
                        DatePicker("Start day", selection: $startDate, displayedComponents: .date)
                    }
                }
                
                Button {
                    saveNewPlan()
                    dismiss()
                } label: {
                    Text("Save the plan")
                }
            }
            .navigationTitle("Add a new plan")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
    }
    
    private func saveNewPlan() {
        let plan = Plan(
            name: (name == "") ? "My trip plan \(plansService.plans.count + 1)": name ,
            description: description,
            startDate:  toggleState ? "\(startDate)" : nil,
            days: []
        )
        
        plansService.addPlan(plan: plan)
    }
}

struct AddPlanFormScreenDestination: Hashable { }

//#Preview {
//    AddPlanForm()
//}

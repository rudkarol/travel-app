//
//  AddPlanForm.swift
//  TravelApp
//
//  Created by osx on 25/01/2025.
//

import SwiftUI

struct AddPlanForm: View {
    
    @State var name: String
    @State var description: String
    @State var startDate: Date
    @State var toggleState: Bool
    var toUpdate: Bool
    
    @Environment(PlansService.self) private var plansService
    @Environment(\.dismiss) var dismiss
    
    
    init(name: String = "", description: String = "", startDate: Date = Date(), toggleState: Bool = false, toUpdate: Bool = false) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.toggleState = toggleState
        self.toUpdate = toUpdate
    }
    
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
            startDate:  toggleState ? startDate : nil,
            days: []
        )
        
        plansService.addPlan(plan: plan)
    }
}

struct AddPlanFormScreenDestination: Hashable { }

//#Preview {
//    AddPlanForm()
//}

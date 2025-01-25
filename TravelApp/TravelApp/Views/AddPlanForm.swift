//
//  AddPlanForm.swift
//  TravelApp
//
//  Created by osx on 25/01/2025.
//

import SwiftUI

struct AddPlanForm: View {
    
    @Binding var isVisible: Bool
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var startDate: Date = Date()
    @State private var toggleState: Bool = false
    
    @Environment(PlansService.self) private var plansService
    
    
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
                
                NavigationLink(destination: SearchView()) {
                    Button {
                        saveNewPlan()
                    } label: {
                        Text("Add locations to plan")
                    }
                }
            }
            .navigationTitle("Add new trip plan")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isVisible = false
                },
                trailing: Button("Save") {
                    saveNewPlan()
                    isVisible = false
                }
            )
        }
    }
    
    private func saveNewPlan() {
        let plan = Plan(
            name: (name == "") ? "My trip plan \(plansService.plans.count + 1)": name ,
            description: description,
            startDate: "\(startDate)",
            days: []
        )
        
        plansService.addPlan(plan: plan)
    }
}

//#Preview {
//    AddPlanForm()
//}

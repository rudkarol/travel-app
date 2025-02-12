//
//  AddPlanForm.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 25/01/2025.
//

import SwiftUI

struct PlanSettingsForm: View {
    
    let plan: Plan?
    @State var name: String
    @State var description: String
    @State var startDate: Date
    @State var toggleState: Bool
    
    @Environment(PlansService.self) private var plansService
    @Environment(\.dismiss) var dismiss
    @State private var alertData: AlertData?
    
    
    init(plan: Plan? = nil) {
        self.plan = plan
        self._name = State(initialValue: plan?.name ?? "")
        self._description = State(initialValue: plan?.description ?? "")
        self._startDate = State(initialValue: plan?.startDate ?? Date())
        self._toggleState = State(initialValue: plan?.startDate != nil)
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
                    if let existingPlan = plan {
                        updatePlan(existingPlan)
                    } else {
                        saveNewPlan()
                    }
                    dismiss()
                } label: {
                    Text(plan != nil ? "Update plan" : "Save plan")
                }
            }
            .navigationTitle(plan != nil ? "Edit plan" : "Add a new plan")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.disabled)
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
    
    private func saveNewPlan() {
        let newPlan = Plan(
            id: UUID(),
            name: (name == "") ? "My trip plan \(plansService.plans.count + 1)" : name,
            description: description,
            startDate: toggleState ? startDate : nil,
            days: []
        )
        
        Task {
            do {
                try await plansService.addPlan(plan: newPlan)
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
        }
    }
    
    private func updatePlan(_ existingPlan: Plan) {
        guard let planIndex = plansService.plans.firstIndex(where: { $0.id == existingPlan.id }) else {
            return
        }
        
        var updatedPlan = plansService.plans[planIndex]
        updatedPlan.name = name
        updatedPlan.description = description
        updatedPlan.startDate = toggleState ? startDate : nil
        
        plansService.plans[planIndex] = updatedPlan
        
        Task {
            do {
                try await plansService.updatePlan(planId: existingPlan.id)
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
        }
    }
}

struct PlanSettingsFormScreenDestination: Hashable { }

#Preview {
    PlanSettingsForm()
}

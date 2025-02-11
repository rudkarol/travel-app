//
//  PlanPage.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlanPage: View {
    
    @State var plan: Plan
    @State var sheetVisible: Bool = false
    @Binding var path: NavigationPath
    @State var alertData: AlertData?
    
    @Environment(PlansService.self) private var plansService
    
    
    var body: some View {
        ZStack {
            List(plan.days.indices, id: \.self) { dayIndex in
                Section("Day \(dayIndex + 1)") {
                    ForEach((plan.days[dayIndex].places ?? []).indices, id: \.self) { placeIndex in
                        let currentPlace = plan.days[dayIndex].places![placeIndex]
                        
                        NavigationLink(value: currentPlace) {
                            PlaceListCell(location: currentPlace, showingAddToFavButton: false)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        guard let planIndex = plansService.plans.firstIndex(where: { $0.id == plan.id }) else {
                                            print("Plan index error")
                                            return
                                        }
                                        
                                        plan.days[dayIndex].places!.remove(at: placeIndex)
                                        
                                        var updatedPlan = plansService.plans[planIndex]
                                        
                                        if var places = updatedPlan.days[dayIndex].places {
                                            places.remove(at: placeIndex)
                                            updatedPlan.days[dayIndex].places = places
                                            
                                            plansService.plans[planIndex] = updatedPlan
                                            
                                            Task {
                                                do {
                                                    try await plansService.updatePlan(planId: plan.id)
                                                } catch let error as AppError {
                                                    alertData = error.alertData
                                                } catch {
                                                    alertData = AppError.genericError(error).alertData
                                                }
                                            }
                                        } else {
                                            print("Błąd przy aktualizacji dnia lub miejsca")
                                        }
                                        
                                        print("Plan item deleted")
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            
                        }
                    }
                }
            }
            .navigationDestination(for: Location.self) { location in
                LocationDetailsView(location: location, path: $path)
            }
            
            if plan.days.isEmpty {
                EmptyState(
                    systemName: "bookmark.slash",
                    message: "There are no days and locations added to your trip plan"
                )
            }
        }
        .navigationTitle(plan.name)
        .toolbar {
            ToolbarItem {
                Button {
                    sheetVisible = true
                } label: {
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                }
            }
        }
        .sheet(isPresented: $sheetVisible) {
            //            AddPlanForm(name: plan.name, description: plan.description ?? "", startDate: plan.startDate ?? Date(), toggleState: (plan.startDate != nil) ? true : false, toUpdate: true)
        }
    }
}

//#Preview {
//    PlanPage(plan: MockDataPlan.samplePlanOne)
//}

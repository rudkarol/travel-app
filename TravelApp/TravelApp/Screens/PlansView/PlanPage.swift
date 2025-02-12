//
//  PlanPage.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct PlanPage: View {
    
    @State var plan: Plan
    @State var sheetVisible: Bool = false
    @Binding var path: NavigationPath
    @State private var dayToDelete: Int? = nil
    @State private var isShowingDeleteAlert: Bool = false
    @State var alertData: AlertData?
    
    @Environment(PlansService.self) private var plansService
    
    
    var body: some View {
        ZStack {
            List(plan.days.indices, id: \.self) { dayIndex in
                        Section(
                            header: HStack {
                                Text("Day \(dayIndex + 1)")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button {
                                    dayToDelete = dayIndex
                                    isShowingDeleteAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        ) {
                            let places = plan.days[dayIndex].places ?? []
                            if places.isEmpty {
                                Text("The daily plan is empty")
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(places.indices, id: \.self) { placeIndex in
                                    let currentPlace = places[placeIndex]
                                    NavigationLink(value: currentPlace) {
                                        PlaceListCell(location: currentPlace, showingAddToFavButton: false)
                                            .swipeActions(allowsFullSwipe: false) {
                                                Button(role: .destructive) {
                                                    guard let planIndex = plansService.plans.firstIndex(where: { $0.id == plan.id }) else {
                                                        print("Plan index error")
                                                        return
                                                    }
                                                    
                                                    plan.days[dayIndex].places?.remove(at: placeIndex)
                                                    
                                                    var updatedPlan = plansService.plans[planIndex]
                                                    if var updatedPlaces = updatedPlan.days[dayIndex].places {
                                                        updatedPlaces.remove(at: placeIndex)
                                                        updatedPlan.days[dayIndex].places = updatedPlaces
                                                        
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
                                                        print("Updating day data error")
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
            PlanSettingsForm(name: plan.name, description: plan.description ?? "", startDate: plan.startDate ?? Date(), toggleState: (plan.startDate != nil) ? true : false, toUpdate: true)
        }
        .alert("Delete the day", isPresented: $isShowingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let dayIndex = dayToDelete,
                           let planIndex = plansService.plans.firstIndex(where: { $0.id == plan.id }) {
                            
                            plan.days.remove(at: dayIndex)
                            
                            var updatedPlan = plansService.plans[planIndex]
                            updatedPlan.days.remove(at: dayIndex)
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
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete the whole day and all the places it contains?")
                }
    }
}

//#Preview {
//    PlanPage(plan: MockDataPlan.samplePlanOne)
//}

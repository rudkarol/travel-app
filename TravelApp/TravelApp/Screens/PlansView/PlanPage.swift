//
//  PlanPage.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct PlanPage: View {
    
    let planId: UUID
    @State private var sheetVisible: Bool = false
    @Binding var path: NavigationPath
    @State private var dayToDelete: Int? = nil
    @State private var isShowingDeleteAlert: Bool = false
    @State var alertData: AlertData?
    
    @Environment(PlansService.self) private var plansService
    
    private var plan: Plan {
        plansService.plans.first(where: { $0.id == planId })!
    }
    
    
    var body: some View {
        ZStack {
            contentView
            
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
            PlanSettingsForm(plan: plan)
        }
        .alert("Delete the day", isPresented: $isShowingDeleteAlert) {
            Group {
                Button("Delete", role: .destructive) {
                    deleteDay()
                }
                Button("Cancel", role: .cancel) { }
            }
        } message: {
            Text("Are you sure you want to delete the whole day and all the places it contains?")
        }
    }
    
    // MARK: - Views
    
    private var contentView: some View {
        List {
            descriptionSection
            
            daysListContent
        }
        .navigationDestination(for: Location.self) { location in
            LocationDetailsView(location: location)
        }
    }
    
    private var descriptionSection: some View {
        Group {
            if let description = plan.description, !description.isEmpty {
                Section(header: Text("Description")) {
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
    private var daysListContent: some View {
        ForEach(plan.days.indices, id: \.self) { dayIndex in
            Section(header: daySectionHeader(for: dayIndex)) {
                dayContent(for: dayIndex)
            }
        }
    }
    
    private func daySectionHeader(for dayIndex: Int) -> some View {
        HStack {
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
    }
    
    private func dayContent(for dayIndex: Int) -> some View {
        Group {
            let places = plan.days[dayIndex].places ?? []
            if places.isEmpty {
                Text("The daily plan is empty")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.secondary)
            } else {
                ForEach(places.indices, id: \.self) { placeIndex in
                    placeCell(for: places[placeIndex], dayIndex: dayIndex, placeIndex: placeIndex)
                }
            }
        }
    }
    
    private func placeCell(for place: Location, dayIndex: Int, placeIndex: Int) -> some View {
        ZStack {
            NavigationLink(value: place) {
                EmptyView()
            }
            .opacity(0)
            
            PlaceListCell(location: place, showingAddToFavButton: false)
        }
        .listRowSeparator(.hidden)
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive) {
                deletePlace(at: placeIndex, dayIndex: dayIndex)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - Functions
    
    private func deletePlace(at placeIndex: Int, dayIndex: Int) {
        guard let planIndex = plansService.plans.firstIndex(where: { $0.id == planId }) else {
            print("Plan index error")
            return
        }
        
        var updatedPlan = plansService.plans[planIndex]
        if var updatedPlaces = updatedPlan.days[dayIndex].places {
            updatedPlaces.remove(at: placeIndex)
            updatedPlan.days[dayIndex].places = updatedPlaces
            plansService.plans[planIndex] = updatedPlan
            
            updatePlanOnServer()
        } else {
            print("Updating day data error")
        }
    }
    
    private func deleteDay() {
        if let dayIndex = dayToDelete,
           let planIndex = plansService.plans.firstIndex(where: { $0.id == planId }) {
            var updatedPlan = plansService.plans[planIndex]
            updatedPlan.days.remove(at: dayIndex)
            plansService.plans[planIndex] = updatedPlan
            
            updatePlanOnServer()
        }
    }
    
    private func updatePlanOnServer() {
        Task {
            do {
                try await plansService.updatePlan(planId: planId)
            } catch let error as AppError {
                alertData = error.alertData
            } catch {
                alertData = AppError.genericError(error).alertData
            }
        }
    }
}

//#Preview {
//    PlanPage(plan: MockDataPlan.samplePlanOne)
//}

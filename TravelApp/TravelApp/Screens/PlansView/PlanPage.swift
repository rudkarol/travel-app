//
//  PlanPage.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlanPage: View {
    
    let plan: Plan
    @State var sheetVisible: Bool = false
    @Binding var path: NavigationPath
    
    
    var body: some View {
        ZStack {
            List(plan.days) { day in
                Section("Day") {
                    ForEach(day.places ?? []) { place in
                        NavigationLink(value: place) {
                            PlaceListCell(location: place, showingAddToFavButton: false)
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

//
//  PlanPage.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlanPage: View {
    
    let plan: Plan
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack {
            //                    TODO: Date picker
            Button(action: { }) {
                Label(plan.startDate ?? "", systemImage: "calendar")
            }
            .modifier(SmallButtonStyle())
            .padding()
            
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
        }
        .navigationTitle(plan.name)
    }
}

//#Preview {
//    PlanPage(plan: MockDataPlan.samplePlanOne)
//}

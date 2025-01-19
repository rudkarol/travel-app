//
//  PlanPage.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlanPage: View {
    
    let plan: Plan
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    //            TODO: DatePicker range
                    Button(action: { }) {
                        Label("\(plan.startDate) to \(plan.endDate)", systemImage: "calendar")
                    }
                    .modifier(SmallButtonStyle())
                    
                    Button(action: { }) {
                        Label("Map view", systemImage: "map")
                    }
                    .modifier(SmallButtonStyle())
                }
                .padding()
                
                ZStack {
                    List(plan.places) { place in
                        PlaceListCell(place: place, showingAddToFavButton: false)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                //                      TODO: go to placePage, może przenieść onTapGesture do PlaceListCell
                                print("item clicked")
                            }
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    //                          TODO: delete
                                    print("item deleted")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .listStyle(.plain)
                    
                    if plan.places.isEmpty {
                        EmptyState(
                            systemName: "bookmark.slash",
                            message: "There are no places added to your trip plan"
                        )
                    }
                }
            }
            .navigationTitle(plan.name)
        }
    }
}

#Preview {
    PlanPage(plan: MockDataPlan.samplePlanOne)
}

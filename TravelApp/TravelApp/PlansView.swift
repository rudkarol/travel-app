//
//  PlansView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlansView: View {
    
    var viewModel = PlansViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.userPlans) { plan in
                    PlanListCell(plan: plan)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            //                      TODO: go to planPage
                            print("plan item clicked")
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                //                          TODO: delete
                                print("plan item deleted")
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .listStyle(.plain)
                
                if viewModel.userPlans.isEmpty {
                    EmptyState(
                        imageName: "empty-plans",
                        message: "Your plans list is empty"
                    )
                }
            }
            .navigationTitle("Trip Plans")
//            TODO: add floating action button
        }
    }
}

#Preview {
    PlansView()
}

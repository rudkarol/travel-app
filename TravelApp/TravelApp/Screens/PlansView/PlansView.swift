//
//  PlansView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct PlansView: View {
    
    @Environment(PlansService.self) private var plansService
    @Bindable private var viewModel = PlansViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack(path: $viewModel.path) {
                ZStack(alignment: .bottomTrailing) {
                    List(plansService.plans) { plan in
                        NavigationLink(value: plan) {
                            PlanListCell(plan: plan)
                                .swipeActions(allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        Task {
                                            try await plansService.updateUserPlans()
                                            //                                    TODO: catch
                                        }
                                        print("plan item deleted")
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listStyle(.plain)
                    .navigationDestination(for: Plan.self) { plan in
                        PlanPage(plan: plan)
                    }
                    
                    Button {
                        viewModel.addPlanSheetVisible = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .padding()
                            .background(.accent)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    if plansService.plans.isEmpty {
                        EmptyState(
                            systemName: "bookmark.slash",
                            message: "Your plans list is empty"
                        )
                    }
                }
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Trip Plans")
        .task {
            viewModel.isLoading = true
            
            do {
                try await plansService.getUserPlans()
            } catch let error as AppError {
                viewModel.alertData = error.alertData
            } catch {
                viewModel.alertData = AppError.genericError(error).alertData
            }
            
            viewModel.isLoading = false
        }
        .alert(
            viewModel.alertData?.title ?? "",
            isPresented: .constant(viewModel.alertData != nil),
            presenting: viewModel.alertData
        ) { alertData in
            Button(alertData.buttonText) {
                viewModel.alertData = nil
            }
        }
    }
}

#Preview {
    PlansView()
}

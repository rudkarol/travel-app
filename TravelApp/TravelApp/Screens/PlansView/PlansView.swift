//
//  PlansView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct PlansView: View {
    
    @State private var path = NavigationPath()
    
    @Environment(PlansService.self) private var plansService
    @Bindable private var viewModel = PlansViewModel()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            contentView
                .navigationTitle("Trip Plans")
                .sheet(isPresented: $viewModel.sheetVisible) {
                    PlanSettingsForm()
                }
                .navigationDestination(for: Plan.self) { plan in
                    PlanPage(planId: plan.id, path: $path)
                }
                .navigationDestination(for: GeneratePlanViewDestination.self) { _ in
                    GeneratePlanView(path: $path)
                }
                .overlay {
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
        }
        .task {
            await loadPlansIfNeeded()
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
    
    // MARK: - Views
    private var contentView: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                generatePlanButton
                
                if plansService.plans.isEmpty {
                    VStack {
                        EmptyState(
                            systemName: "bookmark.slash",
                            message: "Your plans list is empty"
                        )
                        Spacer()
                    }
                    .padding(.top)
                } else {
                    plansList
                }
            }
            
            addPlanButton
        }
    }
    
    private var generatePlanButton: some View {
        Button {
            path.append(GeneratePlanViewDestination())
        } label: {
            Label("Generate plan with AI", systemImage: "wand.and.sparkles")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 14))
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var plansList: some View {
        List {
            ForEach(plansService.plans) { plan in
                ZStack {
                    NavigationLink(value: plan) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    PlanListCell(plan: plan)
                }
                .listRowSeparator(.hidden)
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        Task {
                            await deletePlan(with: plan.id)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var addPlanButton: some View {
        Button {
            viewModel.sheetVisible = true
        } label: {
            Image(systemName: "plus")
                .font(.title)
                .padding()
                .background(.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
    }
    
    // MARK: - Functions
    private func loadPlansIfNeeded() async {
        guard plansService.plans.isEmpty else { return }
        
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
    
    private func deletePlan(with id: Plan.ID) async {
        do {
            try await plansService.deletePlan(id: id)
        } catch let error as AppError {
            viewModel.alertData = error.alertData
        } catch {
            viewModel.alertData = AppError.genericError(error).alertData
        }
    }
}

#Preview {
    PlansView()
}

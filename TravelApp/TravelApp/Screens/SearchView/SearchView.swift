//
//  SearchView.swift
//  TravelApp
//
//  Created by Karol Rudkowski on 17/01/2025.
//

import SwiftUI

struct SearchView: View {
    
    @Bindable private var viewModel = SearchViewModel()
    
    
    var body: some View {
        NavigationStack() {
            VStack {
                searchField
                categoryPicker
                
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.searchResult.isEmpty {
                    EmptyState(
                        systemName: "magnifyingglass",
                        message: "No search results"
                    )
                } else {
                    resultsList
                }
            }
            .navigationTitle("Search")
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search \(viewModel.selectedCategory?.displayName ?? "")...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await viewModel.search()
                    }
                }
            
            if !viewModel.searchText.isEmpty {
                Button(action: {
                    viewModel.searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var categoryPicker: some View {
        Picker("Category", selection: $viewModel.selectedCategory) {
            ForEach(SearchCategory.allCases, id: \.self) { category in
                Text(category.displayName)
                    .tag(category)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.searchResult) { location in
                    NavigationLink(value: location) {
                        PlaceListCell(location: location)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
            }
            .navigationDestination(for: Location.self) { location in
                LocationDetailsView(location: location)
            }
            
            TripadvisorLabel()
                .padding(.bottom)
        }
    }
}

#Preview {
    SearchView()
}

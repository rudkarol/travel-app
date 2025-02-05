//
//  SearchView.swift
//  TravelApp
//
//  Created by osx on 17/01/2025.
//

import SwiftUI

struct SearchView: View {
    
    @State private var path = NavigationPath()
    
    @Bindable private var viewModel = SearchViewModel()
    
    
    var body: some View {
        NavigationStack(path: $path) {
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
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search \(viewModel.selectedCategory?.displayName ?? "")...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await viewModel.search()
                    }
                }
        }
        .padding()
    }
    
    private var resultsList: some View {
        List(viewModel.searchResult) { location in
            NavigationLink(value: location) {
                PlaceListCell(location: location, showingAddToFavButton: false)
            }
        }
        .navigationDestination(for: Location.self) { location in
            LocationDetailsView(location: location, path: $path)
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView()
}

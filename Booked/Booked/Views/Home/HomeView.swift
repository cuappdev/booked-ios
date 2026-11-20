//
//  HomeView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/23/26.
//

import SwiftUI


// MARK: - Filters

enum FilterGroup: Hashable {
    case library, reservation, noise, spaceType, feature
}

struct ActiveFilter: Hashable {
    let group: FilterGroup
    let value: String
}

struct FilterOption: Hashable {
    let value: String
    let count: Int?
}

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    @State private var showFilters = false
    @State private var selectedLibrary: Library?
    @State private var showSearch = false

    init(
        libraries: [Library] = Library.sampleData,
        favorites: FavoritesStore = FavoritesStore(),
        filters: FilterStore = FilterStore()
    ) {
        _viewModel = State(initialValue: HomeViewModel(libraries: libraries, favorites: favorites, filters: filters))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private let tabBarClearance: CGFloat = 76

    // MARK: Body

    var body: some View {
        ZStack {
            Constants.Colors.creamBg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {

                    logo

                    searchBar

                    chipRow

                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filtered) { library in
                                LibraryCardView(
                                    library: library,
                                    isFavorite: viewModel.isFavorite(library),
                                    onToggleFavorite: { viewModel.toggleFavorite(library) },
                                    onTap: { selectedLibrary = library }
                                )
                            }
                        }
                        if viewModel.filtered.isEmpty {
                            Text("No rooms match your search.")
                                .font(.subheadline)
                                .foregroundStyle(Constants.Colors.secondaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, tabBarClearance)
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $showFilters) {
            FilterSheetView(filters: viewModel.filters, libraries: viewModel.libraries)
        }

        .fullScreenCover(item: $selectedLibrary) { library in
            LibraryDetailView(
                library: library,
                isFavorite: viewModel.isFavorite(library),
                onToggleFavorite: { viewModel.toggleFavorite(library) },
                onBack: { selectedLibrary = nil },
                onBook: { /* TODO: start booking flow */ }
            )
        }
    }

    private var logo: some View {
        Image("booked_logo_green")
            .resizable()
            .frame(width: 28.2, height: 28.2)
            .padding(.top, 8)
            .padding(.bottom, 16)
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            Button { showSearch = true } label: {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundStyle(Constants.Colors.secondaryText)
                    Text(viewModel.searchText.isEmpty ? "Where to book?" : viewModel.searchText)
                        .font(.system(size: 18))
                        .foregroundStyle(viewModel.searchText.isEmpty
                                         ? Constants.Colors.tertiaryText
                                         : Constants.Colors.primaryText)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(Constants.Colors.creamBg, in: Capsule())
                .overlay(Capsule().stroke(Constants.Colors.cardBorder, lineWidth: 1.5))
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Search")
            .accessibilityHint("Opens search")

            Button { showFilters = true } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundStyle(Constants.Colors.bookedGreen)
            }
            .accessibilityLabel("Filters")
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $showSearch) {
            SearchView(
                initialQuery: viewModel.searchText,
                libraries: viewModel.libraries,
                onSearch: { term in
                    viewModel.searchText = term
                    showSearch = false
                },
                onClose: { showSearch = false }
            )
        }
    }

    private var chipRow: some View {
        FilterChipRow(filters: viewModel.filters)
    }

    private var sectionHeader: some View {
        HStack {
            Text(viewModel.hasActiveFilters ? "\(viewModel.filtered.count) rooms" : "Available now")
                .font(.system(size: 22))
                .foregroundStyle(Constants.Colors.primaryText)
            Spacer()
            if viewModel.hasActiveFilters {
                Button("Clear all") { viewModel.clearAll() }
                    .font(.system(size: 14))
                    .foregroundStyle(Constants.Colors.secondaryText)
            }
        }
    }
}


#Preview {
    HomeView()
}

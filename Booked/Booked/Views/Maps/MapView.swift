//
//  MapView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/9/26.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Bindable var viewModel: MapViewModel

    @Environment(\.openURL) private var openURL
    @State private var showFilters = false
    @State private var showSearch = false
    @State private var selectedSpace: Library?

    private var filters: FilterStore { viewModel.filters }

    var body: some View {
        let selected = viewModel.selectedBuilding

        ZStack(alignment: .bottom) {
            map
                .ignoresSafeArea()

            LinearGradient(
                colors: [.black.opacity(0.38), .black.opacity(0.14)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            .opacity(viewModel.detent == .full ? 1 : 0)
            .allowsHitTesting(false)
            .animation(.easeInOut(duration: 0.3), value: viewModel.detent)

            VStack(spacing: 0) {
                MapSearchBar(
                    searchText: filters.searchText,
                    filterCount: filters.activeCount,
                    onSearchTap: { showSearch = true },
                    onFilterTap: { showFilters = true }
                )
                .padding(.top, 8)

                FilterChipRow(filters: filters, verticalPadding: 12)

                HStack {
                    Spacer()
                    locateButton
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

            if let building = selected {
                switch viewModel.detent {
                case .preview:
                    LibraryPreviewCard(building: building) { viewModel.expandToHalf() }
                        .padding(.bottom, CustomTabBar.mapOverlayClearance)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                case .half, .full:
                    GeometryReader { geo in
                        LibrarySheetView(
                            building: building,
                            viewModel: viewModel,
                            availableHeight: geo.size.height,
                            onSelectSpace: { selectedSpace = $0 }
                        )
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .ignoresSafeArea(edges: .bottom)
                    .transition(.move(edge: .bottom))
                case .hidden:
                    EmptyView()
                }
            }
        }
        .animation(.spring(duration: 0.35), value: viewModel.detent)
        .onAppear { viewModel.requestLocationAccess() }
        .onChange(of: filters.activeFilters) { viewModel.reconcileSelection() }
        .onChange(of: filters.availableNow) { viewModel.reconcileSelection() }
        .onChange(of: filters.searchText) { viewModel.reconcileSelection() }
        .sheet(isPresented: $showFilters) {
            FilterSheetView(filters: filters, libraries: viewModel.libraries)
        }
        .fullScreenCover(isPresented: $showSearch) {
            SearchView(
                initialQuery: filters.searchText,
                libraries: viewModel.libraries,
                onSearch: { term in
                    filters.searchText = term
                    showSearch = false
                },
                onClose: { showSearch = false }
            )
        }
        .fullScreenCover(item: $selectedSpace) { space in
            LibraryDetailView(
                library: space,
                isFavorite: viewModel.isFavorite(space),
                onToggleFavorite: { viewModel.toggleFavorite(space) },
                onBack: { selectedSpace = nil },
                onBook: { /* TODO: start booking flow */ }
            )
        }
        .alert("Location access is off", isPresented: $viewModel.showsLocationDeniedAlert) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Turn on location for Booked in Settings to see where you are on the map.")
        }
    }

    // MARK: Map

    private var map: some View {
        Map(position: $viewModel.cameraPosition) {
        
            UserAnnotation()

            ForEach(viewModel.pins) { pin in
                Annotation(pin.building.name, coordinate: pin.coordinate, anchor: .bottom) {
                    LibraryPin(isSelected: pin.building.id == viewModel.selectedBuildingID)
                        .onTapGesture { viewModel.select(pin.building) }
                }
                .annotationTitles(.hidden)
            }
        }
        .onTapGesture {
            if viewModel.detent == .preview { viewModel.deselect() }
        }
    }

    private var locateButton: some View {
        Button { viewModel.centerOnUser() } label: {
            Image(systemName: viewModel.locationService.isAuthorized ? "location.fill" : "location")
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.bookedGreen)
                .frame(width: 44, height: 44)
                .background(Constants.Colors.creamBg, in: Circle())
                .overlay(Circle().stroke(Constants.Colors.cardBorder, lineWidth: 1))
                .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
        }
        .accessibilityLabel("Show my location")
    }
}

#Preview {
    let filters = FilterStore()
    let favorites = FavoritesStore()
    MapView(viewModel: MapViewModel(filters: filters, favorites: favorites))
}

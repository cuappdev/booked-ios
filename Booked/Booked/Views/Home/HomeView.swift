//
//  HomeView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/23/26.
//

import SwiftUI


// MARK: - Filters

enum FilterGroup: Hashable {
    case library, reservation, noise, spaceType
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
    var libraries: [Library] = Library.sampleData

    @State private var searchText = ""
    @State private var availableNow = true
    @State private var activeFilters: [ActiveFilter] = []
    @State private var favorites: Set<Int> = []
    @State private var showFilters = false
    @State private var showAllLibraries = false
    @State private var selectedLibrary: Library?

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    /// ContentView overlays CustomTabBar (60pt) on top of this view,
    /// so leave room at the bottom of the scroll content.
    private let tabBarClearance: CGFloat = 76

    private let collapsedLibraryCount = 6

    // MARK: Filtering

    private var hasActiveFilters: Bool {
        !searchText.isEmpty || !activeFilters.isEmpty
    }

    private func selected(_ group: FilterGroup) -> Set<String> {
        Set(activeFilters.filter { $0.group == group }.map(\.value))
    }

    private func matches(_ lib: Library) -> Bool {
        if availableNow && lib.spaceInfo.reservationType == "By request" { return false }

        let libs = selected(.library)
        if !libs.isEmpty && !libs.contains(lib.spaceInfo.library) { return false }

        let res = selected(.reservation)
        if !res.isEmpty && !res.contains(lib.reservationLabel) { return false }

        let noise = selected(.noise)
        if !noise.isEmpty && noise.isDisjoint(with: lib.features.soundLevel) { return false }

        let types = selected(.spaceType)
        if !types.isEmpty && !types.contains(lib.spaceInfo.category) { return false }

        let q = searchText.trimmingCharacters(in: .whitespaces)
        if !q.isEmpty {
            let hay = "\(lib.title) \(lib.spaceInfo.library) \(lib.spaceInfo.category)"
            if !hay.localizedCaseInsensitiveContains(q) { return false }
        }
        return true
    }

    private var filtered: [Library] { libraries.filter(matches) }

    private func toggle(_ group: FilterGroup, _ value: String) {
        let f = ActiveFilter(group: group, value: value)
        if let i = activeFilters.firstIndex(of: f) { activeFilters.remove(at: i) } else { activeFilters.append(f) }
    }

    private func isOn(_ group: FilterGroup, _ value: String) -> Bool {
        activeFilters.contains(ActiveFilter(group: group, value: value))
    }

    private func counted(_ values: [String]) -> [FilterOption] {
        Dictionary(grouping: values, by: { $0 })
            .map { FilterOption(value: $0.key, count: $0.value.count) }
            .sorted { ($0.count ?? 0, $1.value) > ($1.count ?? 0, $0.value) }
    }

    private var libraryOptions: [FilterOption] { counted(libraries.map { $0.spaceInfo.library }) }
    private var spaceTypeOptions: [FilterOption] { counted(libraries.map { $0.spaceInfo.category }) }
    private let reservationOptions = ["Bookable", "By request", "Walk-in"].map { FilterOption(value: $0, count: nil) }
    private let noiseOptions = ["Silent", "Quiet", "Collaborative"].map { FilterOption(value: $0, count: nil) }

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
                            ForEach(filtered) { library in
                                LibraryCardView(
                                    library: library,
                                    isFavorite: favorites.contains(library.id),
                                    onToggleFavorite: { toggleFavorite(library) },
                                    onTap: { selectedLibrary = library }
                                )
                            }
                        }
                        if filtered.isEmpty {
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
            filterSheet
        }
        // Full-screen so the detail page (and its Book Now button) sits above the tab bar
        .fullScreenCover(item: $selectedLibrary) { library in
            LibraryDetailView(
                library: library,
                isFavorite: favorites.contains(library.id),
                onToggleFavorite: { toggleFavorite(library) },
                onBack: { selectedLibrary = nil },
                onBook: { /* TODO: start booking flow */ }
            )
        }
    }

    // MARK: Header

    private var logo: some View {
        Image("booked_logo_green")
            .resizable()
            .frame(width: 28.2, height: 28.2)
            .padding(.top, 8)
            .padding(.bottom, 16)
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundStyle(Constants.Colors.secondaryText)
                TextField("Where to book?", text: $searchText)
                    .font(.system(size: 18))
                    .foregroundStyle(Constants.Colors.primaryText)
                    .submitLabel(.search)
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Constants.Colors.cardSurface, in: Capsule())
            .overlay(Capsule().stroke(Constants.Colors.cardBorder, lineWidth: 1.5))

            Button { showFilters = true } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundStyle(Constants.Colors.bookedGreen)
            }
            .accessibilityLabel("Filters")
        }
        .padding(.horizontal, 20)
    }

    private var chipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip("Available Now", selected: availableNow, removable: false) {
                    availableNow.toggle()
                }
                ForEach(activeFilters, id: \.self) { f in
                    chip(f.value, selected: true, removable: true) {
                        toggle(f.group, f.value)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 14)
    }

    private func chip(_ title: String, selected: Bool, removable: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title).font(.system(size: 14))
                if removable { Image(systemName: "xmark").font(.system(size: 11, weight: .medium)) }
            }
            .foregroundStyle(Constants.Colors.primaryText)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .background(selected ? Constants.Colors.selectedChip : Constants.Colors.chip, in: Capsule())
        }
        .buttonStyle(.plain)
    }

    private var sectionHeader: some View {
        HStack {
            Text(hasActiveFilters ? "\(filtered.count) rooms" : "Available now")
                .font(.system(size: 22))
                .foregroundStyle(Constants.Colors.primaryText)
            Spacer()
            if hasActiveFilters {
                Button("Clear all") {
                    searchText = ""
                    activeFilters = []
                }
                .font(.system(size: 14))
                .foregroundStyle(Constants.Colors.secondaryText)
            }
        }
    }

    // MARK: Filter sheet (drag between half and full height)

    private var filterSheet: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Filters")
                        .font(.system(size: 22))
                        .foregroundStyle(Constants.Colors.primaryText)
                    Spacer()
                    Button("Clear all") { activeFilters = [] }
                        .font(.system(size: 14))
                        .foregroundStyle(Constants.Colors.secondaryText)
                }

                filterSection("Library", group: .library, options: libraryOptions, collapsible: true)
                filterSection("Reservation", group: .reservation, options: reservationOptions)
                filterSection("Noise Level", group: .noise, options: noiseOptions)
                filterSection("Space Type", group: .spaceType, options: spaceTypeOptions)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 16)
        }
        .safeAreaInset(edge: .bottom) {
            Button { showFilters = false } label: {
                Text("Show \(filtered.count) rooms")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Constants.Colors.bookedGreen, in: Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
        .presentationBackground(Constants.Colors.cardSurface)
    }

    private func filterSection(_ title: String, group: FilterGroup, options: [FilterOption], collapsible: Bool = false) -> some View {
        let visible = (collapsible && !showAllLibraries) ? Array(options.prefix(collapsedLibraryCount)) : options
        return VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.primaryText)

            FlowLayout(spacing: 8) {
                ForEach(visible, id: \.self) { option in
                    let on = isOn(group, option.value)
                    Button { toggle(group, option.value) } label: {
                        Text(option.count.map { "\(option.value) · \($0)" } ?? option.value)
                            .font(.system(size: 14))
                            .foregroundStyle(Constants.Colors.primaryText)
                            .padding(.horizontal, 14)
                            .frame(height: 36)
                            .background(on ? Constants.Colors.selectedChip : Constants.Colors.chip, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                if collapsible && options.count > collapsedLibraryCount {
                    Button(showAllLibraries ? "See less" : "See more") {
                        withAnimation { showAllLibraries.toggle() }
                    }
                    .font(.system(size: 14))
                    .underline()
                    .foregroundStyle(Constants.Colors.primaryText)
                    .padding(.horizontal, 8)
                    .frame(height: 36)
                }
            }
        }
    }

    private func toggleFavorite(_ library: Library) {
        if favorites.contains(library.id) { favorites.remove(library.id) } else { favorites.insert(library.id) }
    }
}

// MARK: - Simple wrapping layout for chips

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0, maxW: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > width, x > 0 { x = 0; y += rowH + spacing; rowH = 0 }
            x += s.width + spacing
            rowH = max(rowH, s.height)
            maxW = max(maxW, x - spacing)
        }
        return CGSize(width: maxW, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowH: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX, x > bounds.minX { x = bounds.minX; y += rowH + spacing; rowH = 0 }
            v.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
            x += s.width + spacing
            rowH = max(rowH, s.height)
        }
    }
}

#Preview {
    HomeView()
}

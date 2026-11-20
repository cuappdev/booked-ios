//
//  ContentView.swift
//  Booked
//
//  Created by jiwon jeong on 9/9/26.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedTab: Screen = .home
    @State private var favorites: FavoritesStore
    @State private var filters: FilterStore
    @State private var mapViewModel: MapViewModel
    @State private var showLogoutConfirmation = false
    @State private var hasVisitedMap = false

    init() {
        let favorites = FavoritesStore()
        let filters = FilterStore()
        _favorites = State(initialValue: favorites)
        _filters = State(initialValue: filters)
        _mapViewModel = State(initialValue: MapViewModel(filters: filters, favorites: favorites))
    }

    private func showOnMap(_ library: Library) {
        selectedTab = .map
        mapViewModel.focus(on: library)
    }

    private func tabContent<Content: View>(_ tab: Screen, @ViewBuilder _ content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(selectedTab == tab ? 1 : 0)
            .allowsHitTesting(selectedTab == tab)
            .accessibilityHidden(selectedTab != tab)
    }

    private var hidesTabBar: Bool {
        selectedTab == .map && mapViewModel.isSheetExpanded
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            tabContent(.home) {
                HomeView(favorites: favorites, filters: filters)
            }

            if hasVisitedMap || selectedTab == .map {
                tabContent(.map) {
                    MapView(viewModel: mapViewModel)
                }
            }

            tabContent(.profile) {
                ProfileView(
                    favorites: favorites,
                    onRequestLogOut: { showLogoutConfirmation = true }
                )
            }

            CustomTabBar(
                selectedTab: $selectedTab,
                style: selectedTab == .map ? .overMap : .solid
            )
            .offset(y: hidesTabBar ? 180 : 0)
            .opacity(hidesTabBar ? 0 : 1)
            .allowsHitTesting(!hidesTabBar)
            .animation(.spring(duration: 0.35), value: hidesTabBar)

            if showLogoutConfirmation {
                LogoutConfirmationView(
                    onCancel: { showLogoutConfirmation = false },
                    onConfirm: {
                        showLogoutConfirmation = false
                        // TODO: clear session and return to LoginView
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showLogoutConfirmation)
        .background(Constants.Colors.creamBg.ignoresSafeArea())
        .environment(\.showLibraryOnMap, { library in showOnMap(library) })
        .onChange(of: selectedTab) {
            if selectedTab == .map { hasVisitedMap = true }
        }
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {

    enum Style: Equatable { case solid, overMap }

    static let height: CGFloat = 60

    static let gradientOverhang: CGFloat = 12

    static let mapOverlayClearance: CGFloat = height + gradientOverhang + 4

    @Binding var selectedTab: Screen
    var style: Style = .solid
    @Namespace private var underlineNamespace

    var body: some View {
        HStack(spacing: 60) {
            ForEach(Screen.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .offset(y: 14)
        .frame(height: Self.height)
        .frame(maxWidth: .infinity)
        .background(alignment: .bottom) { tapBlocker }
        .background(alignment: .bottom) { solidBackground }
        .background(alignment: .bottom) { mapGradientBackground }
        .animation(.easeInOut(duration: 0.35), value: style)
    }

    private var tapBlocker: some View {
        Color.black.opacity(0.001)
            .ignoresSafeArea(edges: .bottom)
    }


    private var solidBackground: some View {
        Constants.Colors.creamBg
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Constants.Colors.cardBorder)
                    .frame(height: 1)
            }
            .ignoresSafeArea(edges: .bottom)
            .opacity(style == .solid ? 1 : 0)
    }


    private var mapGradientBackground: some View {
        Constants.Colors.creamBg
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .black.opacity(0), location: 0),
                        .init(color: .black.opacity(0.85), location: 0.55),
                        .init(color: .black, location: 1)
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .padding(.top, -Self.gradientOverhang)
            .ignoresSafeArea(edges: .bottom)
            .opacity(style == .overMap ? 1 : 0)
            .allowsHitTesting(false)
    }

    @ViewBuilder
    private func tabButton(for tab: Screen) -> some View {
        switch tab {
        case .home:
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedTab = .home
                }
            } label: {
                tabButtonView(
                    icon: selectedTab == .home ? tab.filledIcon : tab.icon,
                    isSelected: selectedTab == .home
                )
            }
        case .map:
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedTab = .map
                }
            } label: {
                tabButtonView(
                    icon: selectedTab == .map ? tab.filledIcon : tab.icon,
                    isSelected: selectedTab == .map
                )
            }
        case .profile:
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedTab = .profile
                }
            } label: {
                tabButtonView(
                    icon: selectedTab == .profile ? tab.filledIcon : tab.icon,
                    isSelected: selectedTab == .profile
                )
            }
        }
    }

    private func tabButtonView(icon: String, isSelected: Bool) -> some View {
        VStack(spacing: 7) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)

            Color.clear
                .frame(width: 50, height: 1)
                .overlay {
                    if isSelected {
                        Rectangle()
                            .fill(Constants.Colors.bookedGreen)
                            .frame(width: 50, height: 1)
                            .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                    }
                }
        }
        .contentShape(Rectangle())
    }

}

#Preview {
    ContentView()
}

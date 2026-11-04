//
//  ProfileView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/9/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel

    private let tabBarClearance: CGFloat = 76

    init(
        userName: String = "Lorna",
        libraries: [Library] = Library.sampleData,
        favorites: FavoritesStore,
        onRequestLogOut: @escaping () -> Void = {}
    ) {
        _viewModel = State(
            initialValue: ProfileViewModel(
                userName: userName,
                libraries: libraries,
                favorites: favorites,
                onRequestLogOut: onRequestLogOut
            )
        )
    }

    // MARK: Body

    var body: some View {
        ZStack {
            Constants.Colors.creamBg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    recentBookings
                    favoritesSection
                }
                .padding(.bottom, tabBarClearance)
            }
        }
        .sheet(isPresented: $viewModel.showSortSheet) {
            FavoriteSortSheet(
                selection: $viewModel.pendingSort,
                onApply: viewModel.applySort
            )
        }
        .fullScreenCover(item: $viewModel.selectedLibrary) { library in
            LibraryDetailView(
                library: library,
                isFavorite: viewModel.isFavorite(library),
                onToggleFavorite: { viewModel.toggleFavorite(library) },
                onBack: { viewModel.selectedLibrary = nil },
                onBook: { /* TODO: start booking flow */ }
            )
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Text(viewModel.greeting)
                .font(.system(size: 21))
                .fontWeight(.medium)
                .foregroundStyle(Constants.Colors.bookedGreen)

            Spacer()

            Button(action: viewModel.requestLogOut) {
                Image("logout_icon")
                    .font(.system(size: 20))
                    .foregroundStyle(Constants.Colors.tertiaryText)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("Log out")
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 12)
    }

    // MARK: Recent bookings

    @ViewBuilder
    private var recentBookings: some View {
        let bookings = viewModel.recentBookings

        if !bookings.isEmpty {
            VStack(spacing: 14) {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(bookings) { library in
                            RecentBookingCard(
                                library: library,
                                onBook: { /* TODO: start booking flow */ }
                            )
                            .containerRelativeFrame(.horizontal) { width, _ in
                                bookings.count > 1 ? width - 64 : width - 40
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, 20, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $viewModel.currentRecentID)
                .scrollClipDisabled()

                if bookings.count > 1 {
                    pageIndicator(count: bookings.count, current: viewModel.currentRecentIndex)
                }
            }
            .padding(.bottom, 28)
        }
    }

    private func pageIndicator(count: Int, current: Int) -> some View {
        HStack(spacing: 10) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == current
                          ? Constants.Colors.bookedGreen
                          : Constants.Colors.cardBorder)
                    .frame(width: index == current ? 28 : 6, height: index == current ? 5 : 6)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.2), value: current)
        .accessibilityHidden(true)
    }

    // MARK: Favorites

    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Favorited")
                    .font(.system(size: 18))
                    .foregroundStyle(Constants.Colors.primaryText)

                Spacer()

                Button(action: viewModel.openSortSheet) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 18))
                        .foregroundStyle(Constants.Colors.tertiaryText)
                        .frame(width: 44, height: 44)
                }
                .accessibilityLabel("Sort favorites")
            }
            .padding(.horizontal, 20)

            favoritesList
                .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private var favoritesList: some View {
        let favorites = viewModel.favoriteLibraries

        if favorites.isEmpty {
            Text("Rooms you favorite will show up here.")
                .font(.subheadline)
                .foregroundStyle(Constants.Colors.secondaryText)
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
        } else {
            VStack(spacing: 0) {
                ForEach(favorites) { library in
                    FavoriteRowView(
                        library: library,
                        onTap: { viewModel.selectedLibrary = library },
                        onUnfavorite: { viewModel.toggleFavorite(library) }
                    )

                    if library.id != favorites.last?.id {
                        Rectangle()
                            .fill(Constants.Colors.cardBorder)
                            .frame(height: 1)
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(Constants.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Constants.Colors.cardBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        }
    }
}

#Preview {
    ProfileView(
        favorites: FavoritesStore(ids: Library.sampleData.prefix(4).map(\.id))
    )
}

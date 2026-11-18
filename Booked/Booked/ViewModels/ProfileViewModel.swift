//
//  ProfileViewModel.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import Observation
import SwiftUI

enum FavoriteSort: String, CaseIterable, Identifiable {
    case recentlyAdded = "Recently added"
    case availableNow = "Available now"

    var id: Self { self }
    var title: String { rawValue }
}

@Observable
final class ProfileViewModel {

    // MARK: Inputs

    let userName: String

    private let libraries: [Library]
    private let favorites: FavoritesStore
    private let onRequestLogOut: () -> Void

    // MARK: State

    var sortOption: FavoriteSort = .recentlyAdded
    var pendingSort: FavoriteSort = .recentlyAdded
    var showSortSheet = false
    var selectedLibrary: Library?
    var currentRecentID: Library.ID?

    init(
        userName: String,
        libraries: [Library] = Library.sampleData,
        favorites: FavoritesStore,
        onRequestLogOut: @escaping () -> Void = {}
    ) {
        self.userName = userName
        self.libraries = libraries
        self.favorites = favorites
        self.onRequestLogOut = onRequestLogOut
    }

    // MARK: Derived state

    var greeting: String {
        "Hi there \(userName),"
    }

    /// The 3 most recently booked rooms.
    /// TODO: replace with real booking history once bookings are persisted.
    var recentBookings: [Library] {
        Array(libraries.filter { $0.spaceInfo.reservationType.isBookable }.prefix(3))
    }

    var currentRecentIndex: Int {
        recentBookings.firstIndex { $0.id == currentRecentID } ?? 0
    }

    var favoriteLibraries: [Library] {
        let byID = Dictionary(libraries.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let recent = favorites.recentlyAddedFirst.compactMap { byID[$0] }

        switch sortOption {
        case .recentlyAdded:
            return recent
        case .availableNow:
            return recent.filter { $0.spaceInfo.reservationType.isAvailableNow }
                 + recent.filter { !$0.spaceInfo.reservationType.isAvailableNow }
        }
    }

    func isFavorite(_ library: Library) -> Bool {
        favorites.contains(library)
    }

    // MARK: Actions

    func toggleFavorite(_ library: Library) {
        favorites.toggle(library)
    }

    func openSortSheet() {
        pendingSort = sortOption
        showSortSheet = true
    }

    func applySort() {
        sortOption = pendingSort
        showSortSheet = false
    }

    func requestLogOut() {
        onRequestLogOut()
    }
}

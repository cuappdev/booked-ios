//
//  HomeViewModel.swift
//  Booked
//
//  Created by Alyssa Wang on 10/12/26.
//
//
//  HomeViewModel.swift
//  Booked
//
//  Created by Alyssa Wang on 10/12/26.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {

    // MARK: State

    var libraries: [Library]
    let favorites: FavoritesStore
    let filters: FilterStore

    init(
        libraries: [Library] = Library.sampleData,
        favorites: FavoritesStore = FavoritesStore(),
        filters: FilterStore = FilterStore()
    ) {
        self.libraries = libraries
        self.favorites = favorites
        self.filters = filters
    }

    // MARK: Filter state (forwarded to the shared store)

    var searchText: String {
        get { filters.searchText }
        set { filters.searchText = newValue }
    }

    var availableNow: Bool {
        get { filters.availableNow }
        set { filters.availableNow = newValue }
    }

    var activeFilters: [ActiveFilter] { filters.activeFilters }

    var hasActiveFilters: Bool { filters.hasActiveFilters }

    // MARK: Derived state

    var filtered: [Library] {
        libraries.filter(filters.matches)
    }

    // MARK: Actions

    func toggle(_ group: FilterGroup, _ value: String) {
        filters.toggle(group, value)
    }

    func isOn(_ group: FilterGroup, _ value: String) -> Bool {
        filters.isOn(group, value)
    }

    func clearAll() {
        filters.clearAll()
    }

    func clearFilters() {
        filters.clearFilters()
    }

    func toggleFavorite(_ library: Library) {
        favorites.toggle(library)
    }

    func isFavorite(_ library: Library) -> Bool {
        favorites.contains(library)
    }
}

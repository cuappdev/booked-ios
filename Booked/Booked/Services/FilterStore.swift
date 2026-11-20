//
//  FilterStore.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import Foundation
import Observation

@Observable
final class FilterStore {

    // MARK: State

    var searchText = ""
    var availableNow = true
    private(set) var activeFilters: [ActiveFilter] = []

    // MARK: Static options

    static let reservationOptions = ReservationType.allCases.map { FilterOption(value: $0.label, count: nil) }
    static let noiseOptions = ["Silent", "Quiet", "Collaborative"].map { FilterOption(value: $0, count: nil) }

    // MARK: Derived state

    var hasActiveFilters: Bool {
        !searchText.isEmpty || !activeFilters.isEmpty
    }

    var activeCount: Int {
        activeFilters.count + (availableNow ? 1 : 0)
    }

    // MARK: Filtering

    func matches(_ lib: Library) -> Bool {
        if availableNow && !lib.spaceInfo.reservationType.isAvailableNow { return false }

        let libs = selected(.library)
        if !libs.isEmpty && !libs.contains(lib.spaceInfo.library) { return false }

        let res = selected(.reservation)
        if !res.isEmpty && !res.contains(lib.spaceInfo.reservationType.label) { return false }

        let noise = selected(.noise)
        if !noise.isEmpty && noise.isDisjoint(with: lib.features.soundLevel) { return false }

        let types = selected(.spaceType)
        if !types.isEmpty && !types.contains(lib.spaceInfo.category) { return false }

        let features = selected(.feature)
        if !features.isEmpty && !features.isSubset(of: lib.features.spaceFeatures) { return false }

        let q = searchText.trimmingCharacters(in: .whitespaces)
        if !q.isEmpty {
            let hay = "\(lib.title) \(lib.spaceInfo.library) \(lib.spaceInfo.category)"
            if !hay.localizedCaseInsensitiveContains(q) { return false }
        }
        return true
    }

    private func selected(_ group: FilterGroup) -> Set<String> {
        Set(activeFilters.filter { $0.group == group }.map(\.value))
    }

    // MARK: Options (depend on the data being filtered)

    func libraryOptions(in libraries: [Library]) -> [FilterOption] {
        Self.counted(libraries.map { $0.spaceInfo.library })
    }

    func spaceTypeOptions(in libraries: [Library]) -> [FilterOption] {
        Self.counted(libraries.map { $0.spaceInfo.category })
    }

    func featureOptions(in libraries: [Library]) -> [FilterOption] {
        Self.counted(libraries.flatMap { $0.features.spaceFeatures }, showCount: false)
    }

    private static func counted(_ values: [String], showCount: Bool = true) -> [FilterOption] {
        Dictionary(grouping: values, by: { $0 })
            .sorted { ($0.value.count, $1.key) > ($1.value.count, $0.key) }
            .map { FilterOption(value: $0.key, count: showCount ? $0.value.count : nil) }
    }

    // MARK: Actions

    func toggle(_ group: FilterGroup, _ value: String) {
        let f = ActiveFilter(group: group, value: value)
        if let i = activeFilters.firstIndex(of: f) {
            activeFilters.remove(at: i)
        } else {
            activeFilters.append(f)
        }
    }

    func isOn(_ group: FilterGroup, _ value: String) -> Bool {
        activeFilters.contains(ActiveFilter(group: group, value: value))
    }

    func clearAll() {
        searchText = ""
        activeFilters = []
    }

    func clearFilters() {
        activeFilters = []
    }
}

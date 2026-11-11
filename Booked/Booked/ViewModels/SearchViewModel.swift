//
//  SearchViewModel.swift
//  Booked
//
//  Created by Alyssa Wang on 11/11/26.
//

import Observation
import SwiftUI

@Observable
final class SearchViewModel {

    // MARK: State

    var query: String
    private(set) var recentSearches: [String]

    // MARK: Inputs

    private let libraries: [Library]
    private let defaults: UserDefaults
    private let onSearch: (String) -> Void
    private let onClose: () -> Void

    private static let storageKey = "recentSearches"
    private static let maxRecents = 8
    private static let maxSuggestions = 8

    init(
        initialQuery: String = "",
        libraries: [Library] = Library.sampleData,
        defaults: UserDefaults = .standard,
        onSearch: @escaping (String) -> Void = { _ in },
        onClose: @escaping () -> Void = {}
    ) {
        self.query = initialQuery
        self.libraries = libraries
        self.defaults = defaults
        self.onSearch = onSearch
        self.onClose = onClose
        self.recentSearches = defaults.stringArray(forKey: Self.storageKey) ?? []
    }

    // MARK: Derived state

    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSearching: Bool {
        !trimmedQuery.isEmpty
    }

    /// Room titles containing the query, in list order, without duplicates.
    var suggestions: [String] {
        guard isSearching else { return [] }

        var seen = Set<String>()
        let matches = libraries
            .map(\.title)
            .filter { $0.localizedCaseInsensitiveContains(trimmedQuery) }
            .filter { seen.insert($0).inserted }

        return Array(matches.prefix(Self.maxSuggestions))
    }

    /// The part of the title the user typed is dark; the rest is gray.
    func highlighted(_ title: String) -> AttributedString {
        var text = AttributedString(title)
        text.foregroundColor = Constants.Colors.tertiaryText

        if let range = text.range(of: trimmedQuery, options: .caseInsensitive) {
            text[range].foregroundColor = Constants.Colors.primaryText
        }
        return text
    }

    // MARK: Actions

    /// Applies a search term (typed, suggested, or recent) and hands it back to Home.
    func select(_ term: String) {
        let term = term.trimmingCharacters(in: .whitespacesAndNewlines)
        query = term
        remember(term)
        onSearch(term)
    }

    func submit() {
        select(query)
    }

    func clearQuery() {
        query = ""
    }

    func removeRecent(_ term: String) {
        recentSearches.removeAll { $0 == term }
        persist()
    }

    func close() {
        onClose()
    }

    // MARK: Persistence

    private func remember(_ term: String) {
        guard !term.isEmpty else { return }

        recentSearches.removeAll { $0.caseInsensitiveCompare(term) == .orderedSame }
        recentSearches.insert(term, at: 0)
        recentSearches = Array(recentSearches.prefix(Self.maxRecents))
        persist()
    }

    private func persist() {
        defaults.set(recentSearches, forKey: Self.storageKey)
    }
}

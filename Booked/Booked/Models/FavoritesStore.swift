//
//  FavoritesStore.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import Foundation
import Observation

/// Single source of truth for which rooms the user has favorited.
/// Shared by Home and Profile so a heart tapped on one screen shows up on the other.

@Observable
final class FavoritesStore {

    private(set) var ids: [Int]

    private let defaults: UserDefaults
    private let storageKey = "favoriteLibraryIDs"

    init(ids: [Int]? = nil, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.ids = ids ?? (defaults.array(forKey: "favoriteLibraryIDs") as? [Int] ?? [])
    }

    var recentlyAddedFirst: [Int] {
        ids.reversed()
    }

    func contains(_ library: Library) -> Bool {
        ids.contains(library.id)
    }

    func toggle(_ library: Library) {
        if let index = ids.firstIndex(of: library.id) {
            ids.remove(at: index)
        } else {
            ids.append(library.id)
        }
        save()
    }

    private func save() {
        defaults.set(ids, forKey: storageKey)
    }
}

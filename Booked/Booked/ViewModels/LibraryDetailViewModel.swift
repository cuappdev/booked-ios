//
//  LibraryDetailViewModel.swift
//  Booked
//
//  Created by Alyssa Wang on 10/27/26.
//

import Observation
import SwiftUI

enum LibraryAvailability: Equatable {
    case open(closesAt: Date)
    case closed(opensAt: Date)

    var isOpen: Bool {
        if case .open = self { return true }
        return false
    }
}

@Observable
final class LibraryDetailViewModel {

    // MARK: Inputs

    let library: Library
    let availability: LibraryAvailability?

    private(set) var isFavorite: Bool

    let onToggleFavorite: () -> Void
    let onBack: () -> Void
    let onBook: () -> Void

    init(
        library: Library,
        availability: LibraryAvailability? = nil,
        isFavorite: Bool = false,
        onToggleFavorite: @escaping () -> Void = {},
        onBack: @escaping () -> Void = {},
        onBook: @escaping () -> Void = {}
    ) {
        self.library = library
        self.availability = availability
        self.isFavorite = isFavorite
        self.onToggleFavorite = onToggleFavorite
        self.onBack = onBack
        self.onBook = onBook
    }

    // MARK: Derived state

    var chips: [String] {
        [library.spaceInfo.library, library.spaceInfo.reservationType.label] + library.features.spaceFeatures
    }

    /// Walk-in spaces have nothing to book, so the button is hidden.
    var showsBookButton: Bool {
        library.spaceInfo.reservationType != .walkIn
    }

    var bookButtonTitle: String {
        library.spaceInfo.reservationType.isBookable ? "Book Now" : "Request Room"
    }

    var favoriteSymbol: String {
        isFavorite ? "heart.fill" : "heart"
    }

    var favoriteAccessibilityLabel: String {
        isFavorite ? "Remove from favorites" : "Add to favorites"
    }

    var favoriteTint: Color {
        isFavorite ? .red : Constants.Colors.primaryText
    }

    var availabilityText: Text? {
        guard let availability else { return nil }

        let (status, color, detail): (String, Color, String) = switch availability {
        case .open(let closesAt):
            ("Open", Constants.Colors.bookableAccent,
             "Closes \(closesAt.formatted(.dateTime.hour().minute()))")
        case .closed(let opensAt):
            ("Closed", Constants.Colors.closedRed,
             "Opens \(opensAt.formatted(.dateTime.weekday(.abbreviated).hour().minute()))")
        }
        return Text(status).foregroundColor(color)
             + Text(" · \(detail)").foregroundColor(Constants.Colors.secondaryText)
    }

    func soundIcon(for level: String) -> String {
        switch level {
        case "Silent": "silent_icon"
        case "Quiet": "quiet_icon"
        default: "full_volume_icon"
        }
    }

    // MARK: Actions

    func toggleFavorite() {
        isFavorite.toggle()
        onToggleFavorite()
    }
}

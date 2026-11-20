//
//  LibraryBuilding.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import CoreLocation
import Foundation

struct LibraryBuilding: Identifiable, Equatable {
    let name: String
    let spaces: [Library]

    var id: String { name }

    // MARK: Location metadata

    struct Location: Equatable {
        let address: String
        let latitude: Double
        let longitude: Double
        /// Snapshot of the hours shown on library.cornell.edu/libraries. TODO: replace with live hours.
        let isOpen: Bool
        let hoursText: String?
        /// `true` = coordinate copied from Cornell's own map links; `false` = estimated, double-check it.
        let isCoordinateVerified: Bool

        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }

    /// Addresses and hours come from https://www.library.cornell.edu/libraries/.
    private static let locations: [String: Location] = [
        "Mann Library": Location(
            address: "237 Mann Drive, Ithaca, NY 14853",
            latitude: 42.4487952, longitude: -76.476316,
            isOpen: true, hoursText: "Closes 10pm", isCoordinateVerified: true),
        "Olin Library": Location(
            address: "161 Ho Plaza, Ithaca, NY 14853",
            latitude: 42.44770, longitude: -76.48500,
            isOpen: true, hoursText: "Closes midnight", isCoordinateVerified: false),
        "Uris Library": Location(
            address: "160 Ho Plaza, Ithaca, NY 14853",
            latitude: 42.44795, longitude: -76.48535,
            isOpen: true, hoursText: "Closes 11pm", isCoordinateVerified: false),
        "Catherwood Library": Location(
            address: "229 Ives Hall, Tower Road, Ithaca, NY 14853",
            latitude: 42.44720, longitude: -76.47900,
            isOpen: false, hoursText: nil, isCoordinateVerified: false),
        "Cox Library of Music and Dance": Location(
            address: "220 Lincoln Hall, Ithaca, NY 14853",
            latitude: 42.44470, longitude: -76.48330,
            isOpen: true, hoursText: "Closes 10pm", isCoordinateVerified: false),
        "Engineering Library": Location(
            address: "Carpenter Hall, Ithaca, NY 14853",
            latitude: 42.44440, longitude: -76.48225,
            isOpen: true, hoursText: "Open 24 hours", isCoordinateVerified: false),
        "Kroch Asia Collections": Location(
            address: "180 Kroch Library, Ithaca, NY 14853",
            latitude: 42.4477741, longitude: -76.4841596,
            isOpen: true, hoursText: "Closes midnight", isCoordinateVerified: true),
        "Flower-Sprecher Veterinary Library": Location(
            address: "606 Tower Rd, S1 201 Veterinary Education Center, Ithaca, NY 14853",
            latitude: 42.4474921, longitude: -76.4658424,
            isOpen: false, hoursText: nil, isCoordinateVerified: true),
        "Mathematics Library": Location(
            address: "420 Malott Hall, Ithaca, NY 14853",
            latitude: 42.44460, longitude: -76.48090,
            isOpen: true, hoursText: "Closes 8pm", isCoordinateVerified: false),
        "Clark Physical Sciences Library": Location(
            address: "293 Clark Hall, Ithaca, NY 14853",
            latitude: 42.44975, longitude: -76.48125,
            isOpen: true, hoursText: "Open 24/7", isCoordinateVerified: false),
        "Clarke Africana Library": Location(
            address: "310 Triphammer Road, Ithaca, NY 14850",
            latitude: 42.45590, longitude: -76.48050,
            isOpen: false, hoursText: nil, isCoordinateVerified: false),
        "Library Annex": Location(
            address: "209 Bookbank Dr, Ithaca, NY 14850",
            latitude: 42.46900, longitude: -76.45600,
            isOpen: false, hoursText: nil, isCoordinateVerified: false)
    ]

    static func location(for libraryName: String) -> Location? {
        locations[libraryName]
    }

    var location: Location? { Self.location(for: name) }
    var coordinate: CLLocationCoordinate2D? { location?.coordinate }
    var address: String? { location?.address }
    var isOpen: Bool { location?.isOpen ?? true }

    // MARK: Display

    var detailText: String {
        var parts: [String] = []
        if isOpen, let hours = location?.hoursText { parts.append(hours) }
        parts.append("\(spaces.count) space\(spaces.count == 1 ? "" : "s")")
        return parts.joined(separator: " · ")
    }

    var imageURL: URL? {
        spaces.compactMap(\.imageURL).first ?? spaces.first?.displayImageURL
    }

    var tags: [String] {
        var result: [String] = []
        if spaces.contains(where: { $0.spaceInfo.reservationType.isBookable }) { result.append("Bookable") }
        if spaces.contains(where: { $0.spaceInfo.category == "Open Study" }) { result.append("Open Study") }
        if spaces.contains(where: { $0.features.soundLevel.contains("Quiet") }) { result.append("Quiet") }
        if spaces.contains(where: { $0.features.soundLevel.contains("Collaborative") }) { result.append("Collaborative") }
        return result
    }

    struct CategoryGroup: Identifiable {
        let category: String
        let spaces: [Library]
        var id: String { category }
    }

    var spacesByCategory: [CategoryGroup] {
        Dictionary(grouping: spaces, by: { $0.spaceInfo.category })
            .sorted { $0.key < $1.key }
            .map { CategoryGroup(category: $0.key, spaces: $0.value) }
    }

    // MARK: Grouping

    static func group(_ libraries: [Library]) -> [LibraryBuilding] {
        Dictionary(grouping: libraries, by: { $0.spaceInfo.library })
            .map { LibraryBuilding(name: $0.key, spaces: $0.value) }
            .sorted { $0.name < $1.name }
    }
}

extension Library {
    var location: LibraryBuilding.Location? {
        LibraryBuilding.location(for: spaceInfo.library)
    }
}

//
//  MapViewModel.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//
//

import MapKit
import Observation
import SwiftUI

@Observable
final class MapViewModel {

    enum SheetDetent: Equatable {
        case hidden    // nothing selected
        case preview   // floating card above the tab bar
        case half      // bottom sheet, one row of spaces
        case full      // bottom sheet, spaces grouped by category
    }

    struct Pin: Identifiable {
        let building: LibraryBuilding
        let coordinate: CLLocationCoordinate2D
        var id: String { building.id }
    }

    // MARK: State

    var libraries: [Library]
    let filters: FilterStore
    let favorites: FavoritesStore
    let locationService: LocationService

    var cameraPosition: MapCameraPosition = MapViewModel.defaultCamera
    var detent: SheetDetent = .hidden
    var showsLocationDeniedAlert = false
    private(set) var selectedBuildingID: String?
    private(set) var forcedBuildingID: String?

    init(
        libraries: [Library] = Library.sampleData,
        filters: FilterStore,
        favorites: FavoritesStore,
        locationService: LocationService = LocationService()
    ) {
        self.libraries = libraries
        self.filters = filters
        self.favorites = favorites
        self.locationService = locationService
    }

    // MARK: Derived state

    var visibleBuildings: [LibraryBuilding] {
        var buildings = LibraryBuilding.group(libraries.filter(filters.matches))
        if let forced = forcedBuildingID, !buildings.contains(where: { $0.id == forced }) {
            let spaces = libraries.filter { $0.spaceInfo.library == forced }
            if !spaces.isEmpty {
                buildings.append(LibraryBuilding(name: forced, spaces: spaces))
                buildings.sort { $0.name < $1.name }
            }
        }
        return buildings
    }

    var pins: [Pin] {
        visibleBuildings.compactMap { building in
            building.coordinate.map { Pin(building: building, coordinate: $0) }
        }
    }

    var selectedBuilding: LibraryBuilding? {
        visibleBuildings.first { $0.id == selectedBuildingID }
    }

    var isSheetExpanded: Bool { detent == .half || detent == .full }

    // MARK: Selection intents

    func select(_ building: LibraryBuilding) {
        if building.id != forcedBuildingID { forcedBuildingID = nil }
        selectedBuildingID = building.id
        detent = .preview
        if let coordinate = building.coordinate {
            moveCamera(to: .region(Self.region(centeredOn: coordinate)))
        }
    }

    /// Called from "View on map" in the detail screen: select the space's building even if
    /// the current filters would hide it, and zoom to it.
    func focus(on library: Library) {
        let name = library.spaceInfo.library
        guard let location = LibraryBuilding.location(for: name) else { return }
        forcedBuildingID = name
        selectedBuildingID = name
        detent = .preview
        moveCamera(to: .region(Self.region(centeredOn: location.coordinate)))
    }

    func deselect() {
        selectedBuildingID = nil
        forcedBuildingID = nil
        detent = .hidden
    }

    func expandToHalf() { detent = .half }
    func collapseToPreview() { detent = .preview }
    func setDetent(_ newValue: SheetDetent) { detent = newValue }

    func reconcileSelection() {
        if selectedBuildingID != nil, selectedBuilding == nil { deselect() }
    }

    func toggleFavorite(_ library: Library) { favorites.toggle(library) }
    func isFavorite(_ library: Library) -> Bool { favorites.contains(library) }

    // MARK: Location intents

    func requestLocationAccess() {
        locationService.requestAccessIfNeeded()
    }

    func centerOnUser() {
        if locationService.isDenied {
            showsLocationDeniedAlert = true
        } else if locationService.isAuthorized {
            moveCamera(to: .userLocation(fallback: Self.defaultCamera))
        } else {
            locationService.requestAccessIfNeeded()
        }
    }

    // MARK: Camera

    private func moveCamera(to position: MapCameraPosition) {
        withAnimation(.easeInOut(duration: 0.4)) { cameraPosition = position }
    }

    /// Framed so the main campus libraries (Mann to Engineering, Africana to Olin) fit on screen.
    static var defaultCamera: MapCameraPosition {
        .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.4495, longitude: -76.4795),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        ))
    }

    private static func region(centeredOn coordinate: CLLocationCoordinate2D) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: coordinate.latitude - 0.0014, longitude: coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
        )
    }
}

//
//  ShowLibraryOnMapKey.swift
//  Booked
//
//  Created by Alyssa Wang on 11/19/26.
//
//  Lets any screen (e.g. LibraryDetailView, which is presented from Home, Map and Profile)
//  ask the app to switch to the Map tab and focus a space's building,
//  without passing a callback through every view in between.
//
//  ContentView provides the real action; the default does nothing (previews).
//

import SwiftUI

struct ShowLibraryOnMapKey: EnvironmentKey {
    static let defaultValue: (Library) -> Void = { _ in }
}

extension EnvironmentValues {
    var showLibraryOnMap: (Library) -> Void {
        get { self[ShowLibraryOnMapKey.self] }
        set { self[ShowLibraryOnMapKey.self] = newValue }
    }
}

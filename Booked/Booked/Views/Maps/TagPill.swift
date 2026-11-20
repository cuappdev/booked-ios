//
//  TagPill.swift
//  Booked
//

import SwiftUI

struct TagPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundStyle(Constants.Colors.primaryText)
            .padding(.horizontal, 12)
            .frame(height: 28)
            .background(Constants.Colors.selectedChip, in: Capsule())
    }
}

struct BuildingStatusLine: View {
    let building: LibraryBuilding

    var body: some View {
        (Text(building.isOpen ? "Open" : "Closed")
            .foregroundColor(building.isOpen ? Constants.Colors.bookableAccent : Constants.Colors.secondaryText)
         + Text(" · \(building.detailText)").foregroundColor(Constants.Colors.secondaryText))
            .font(.system(size: 13))
    }
}

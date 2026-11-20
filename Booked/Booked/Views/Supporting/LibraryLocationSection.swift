//
//  LibraryLocationSection.swift
//  Booked
//
//  Created by Alyssa Wang on 11/19/26.
//


import MapKit
import SwiftUI

struct LibraryLocationSection: View {
    let library: Library
    let onShowOnMap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundStyle(Constants.Colors.libraryHeading)

            if let location = library.location {
                card(location)
            } else {
                // No coordinates for this building yet.
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Constants.Colors.cardBorder.opacity(0.5))
                    .frame(height: 100)
                    .overlay {
                        Text(library.spaceInfo.library)
                            .font(.system(size: 15))
                            .foregroundStyle(Constants.Colors.secondaryText)
                    }
            }
        }
    }

    // MARK: Card

    private func card(_ location: LibraryBuilding.Location) -> some View {
        Button(action: onShowOnMap) {
            VStack(spacing: 0) {
                miniMap(location)
                    .frame(height: 160)

                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(library.spaceInfo.library)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Constants.Colors.primaryText)

                        if let place = placeInBuilding {
                            Text(place)
                                .font(.system(size: 13))
                                .foregroundStyle(Constants.Colors.primaryText)
                        }

                        Text(location.address)
                            .font(.system(size: 13))
                            .foregroundStyle(Constants.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: 8)

                    HStack(spacing: 4) {
                        Text("View on map")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(Constants.Colors.bookedGreen)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Constants.Colors.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Constants.Colors.cardBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(library.spaceInfo.library), \(location.address). View on map")
    }

    private func miniMap(_ location: LibraryBuilding.Location) -> some View {
        Map(
            initialPosition: .region(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
            )),
            interactionModes: []
        ) {
            Annotation(library.spaceInfo.library, coordinate: location.coordinate, anchor: .bottom) {
                LibraryPin(isSelected: true)
            }
            .annotationTitles(.hidden)
        }
        .allowsHitTesting(false)   // taps go to the surrounding Button
    }

    
    private var placeInBuilding: String? {
        let place = library.spaceInfo.name.trimmingCharacters(in: .whitespaces)
        guard !place.isEmpty, place != library.title else { return nil }
        return place
    }
}

//
//  LibrarySheetView.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//

import SwiftUI

struct LibrarySheetView: View {
    let building: LibraryBuilding
    let viewModel: MapViewModel
    let availableHeight: CGFloat
    let onSelectSpace: (Library) -> Void

    private let cardWidth: CGFloat = 176

    var body: some View {
        DetentSheet(
            availableHeight: availableHeight,
            detent: viewModel.detent,
            onDetentChange: { viewModel.setDetent($0) },
            onDismiss: { viewModel.collapseToPreview() }
        ) {
            header
        } content: {
            if viewModel.detent == .full {
                fullContent
            } else {
                halfContent
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(building.name)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Constants.Colors.bookedGreen)
            BuildingStatusLine(building: building)
            FlowLayout(spacing: 6) {
                ForEach(building.tags, id: \.self) { TagPill(text: $0) }
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
    }

    private var halfContent: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(building.spaces) { card($0) }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    private var fullContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(building.spacesByCategory) { group in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(group.category)
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundStyle(Constants.Colors.primaryText)
                            .padding(.horizontal, 20)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 12) {
                                ForEach(group.spaces) { card($0) }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }

    private func card(_ space: Library) -> some View {
        LibraryCardView(
            library: space,
            isFavorite: viewModel.isFavorite(space),
            onToggleFavorite: { viewModel.toggleFavorite(space) },
            onTap: { onSelectSpace(space) }
        )
        .frame(width: cardWidth)
    }
}

//
//  LibraryPreviewCard.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import SwiftUI

struct LibraryPreviewCard: View {
    let building: LibraryBuilding
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Constants.Colors.cardBorder.opacity(0.5)
                    .frame(width: 80, height: 100)
                    .overlay {
                        AsyncImage(url: building.imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .failure:
                                Image(systemName: "photo").foregroundStyle(Constants.Colors.tertiaryText)
                            default:
                                ProgressView()
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(building.name)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Constants.Colors.bookedGreen)
                    BuildingStatusLine(building: building)
                    FlowLayout(spacing: 6) {
                        ForEach(building.tags, id: \.self) { TagPill(text: $0) }
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(12)
            .background(Constants.Colors.cardSurface, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Constants.Colors.cardBorder, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }
}

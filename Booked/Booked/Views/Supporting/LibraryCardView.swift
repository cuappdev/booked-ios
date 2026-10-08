//
//  LibraryCardView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/9/26.
//

import SwiftUI

// MARK: - Display helpers

extension Library {
    /// "Reservable" -> "Bookable", "No reservation" -> "Walk-in"
    var reservationLabel: String {
        switch spaceInfo.reservationType {
        case "Reservable": return "Bookable"
        case "No reservation": return "Walk-in"
        default: return spaceInfo.reservationType
        }
    }

    var isBookable: Bool { spaceInfo.reservationType == "Reservable" }

    var spaceTypeLabel: String { spaceInfo.category }

    var soundLevelLabel: String { features.soundLevel.first ?? "—" }

    var spaceTypeIcon: String {
        switch spaceInfo.category {
        case "Group Study", "Collaborative Space": return "person.3"
        case "Open Study": return "books.vertical"
        case "Conference Room": return "rectangle.3.group"
        case "Interfaith Serenity Room": return "leaf"
        default: return "chair.lounge"
        }
    }
}

// MARK: - Card

struct LibraryCardView: View {
    let library: Library
    var isFavorite: Bool = false
    var onToggleFavorite: () -> Void = {}
    var onTap: () -> Void = {}

    private let cornerRadius: CGFloat = 20

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                image
                heartButton
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(library.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 17))
                    .foregroundStyle(Constants.Colors.bookedGreen)
                    .lineLimit(1)
                    .truncationMode(.tail)

                HStack(spacing: 4) {
                    Text(library.spaceInfo.library)
                        .foregroundStyle(Constants.Colors.secondaryText)
                        .font(.system(size: 14))
                        .lineLimit(1)
                    Text("·")
                        .foregroundStyle(Constants.Colors.secondaryText)
                    Text(library.reservationLabel)
                        .foregroundStyle(library.isBookable
                                         ? Constants.Colors.bookableAccent
                                         : Constants.Colors.secondaryText)
                        .lineLimit(1)
                }
                .font(.system(size: 13))

                VStack(alignment: .leading, spacing: 3) {
                    metaRow(icon: library.spaceTypeIcon, text: library.spaceTypeLabel)
                    metaRow(icon: "speaker.wave.1", text: library.soundLevelLabel)
                }
                .padding(.top, 2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Constants.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Constants.Colors.cardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .onTapGesture(perform: onTap)
        .accessibilityAddTraits(.isButton)
    }

    private var image: some View {
        Constants.Colors.cardBorder.opacity(0.5)
            .aspectRatio(4 / 3, contentMode: .fit)
            .overlay {
                AsyncImage(url: library.displayImageURL) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(Constants.Colors.tertiaryText)
                    default:
                        ProgressView()
                    }
                }
            }
            .clipped()
    }

    private var heartButton: some View {
        Button(action: onToggleFavorite) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 18))
                .foregroundStyle(isFavorite ? Color.red : Constants.Colors.bookedGreen)
                .frame(width: 38, height: 38)
                .background(.white.opacity(0.85), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }

    private func metaRow(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .frame(width: 14)
            Text(text)
                .font(.system(size: 12))
                .lineLimit(1)
        }
        .foregroundStyle(Constants.Colors.tertiaryText)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
        ForEach(Library.sampleData.prefix(4)) { LibraryCardView(library: $0) }
    }
    .padding(16)
    .background(Constants.Colors.creamBg)
}

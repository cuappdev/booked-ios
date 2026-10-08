//
//  LibraryDetailView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/30/26.
//

import SwiftUI

/// Open/closed info isn't part of `Library` yet, so it's passed in separately.
struct LibraryAvailability: Equatable {
    var isOpen: Bool
    var detail: String   // e.g. "Opens 6pm Tues"
}

struct LibraryDetailView: View {
    let library: Library
    var availability: LibraryAvailability? = nil
    var isFavorite: Bool = false
    var onToggleFavorite: () -> Void = {}
    var onBack: () -> Void = {}
    var onBook: () -> Void = {}

    private let heroHeight: CGFloat = 380
    private let sheetOverlap: CGFloat = 32

    var body: some View {
        ZStack(alignment: .bottom) {
            Constants.Colors.creamBg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    hero
                    content
                        .offset(y: -sheetOverlap)
                        .padding(.bottom, -sheetOverlap)
                }
                .padding(.bottom, 110) // room for the Book Now button
            }
            .ignoresSafeArea(edges: .top)

            topButtons
                .frame(maxHeight: .infinity, alignment: .top)

            if library.spaceInfo.reservationType != "No reservation" {
                bookButton
            }
        }
    }

    // MARK: Hero
    private var hero: some View {
        Constants.Colors.cardBorder.opacity(0.5)
            .frame(height: heroHeight)
            .overlay {
                AsyncImage(url: library.displayImageURL) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(Constants.Colors.libraryHeading)
                    default: ProgressView()
                    }
                }
            }
            .clipped()
    }

    private var topButtons: some View {
        HStack {
            circleButton("chevron.left", label: "Back", action: onBack)
            Spacer()
            circleButton(isFavorite ? "heart.fill" : "heart",
                         label: isFavorite ? "Remove from favorites" : "Add to favorites",
                         tint: isFavorite ? .red : Constants.Colors.primaryText,
                         action: onToggleFavorite)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func circleButton(_ symbol: String, label: String,
                              tint: Color = Constants.Colors.primaryText,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 18))
                .foregroundStyle(tint)
                .frame(width: 44, height: 44)
                .background(.white.opacity(0.7), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    // MARK: Content sheet

    private var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.top, 32)
                .padding(.bottom, 20)

            divider

            Text(library.spaceInfo.description)
                .font(.system(size: 14))
                .foregroundStyle(Constants.Colors.primaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 20)

            divider

            featuresSection
                .padding(.vertical, 20)

            divider

            locationSection
                .padding(.vertical, 20)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Constants.Colors.cardSurface)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(library.title)
                .font(.system(size: 24))
                .foregroundStyle(Constants.Colors.bookedGreen)
                .fixedSize(horizontal: false, vertical: true)

            if let availability {
                (Text(availability.isOpen ? "Open" : "Closed")
                    .foregroundColor(availability.isOpen ? Constants.Colors.bookableAccent : Constants.Colors.closedRed)
                 + Text(" · \(availability.detail)")
                    .foregroundColor(Constants.Colors.secondaryText))
                    .font(.system(size: 14))
            }

            FlowLayout(spacing: 7) {
                ForEach(chips, id: \.self) { chip in
                    Text(chip)
                        .font(.system(size: 12))
                        .foregroundStyle(Constants.Colors.primaryText)
                        .padding(.horizontal, 16)
                        .frame(height: 30)
                        .background(Constants.Colors.selectedChip, in: Capsule())
                }
            }
            .padding(.top, 4)
        }
    }

    private var chips: [String] {
        var items = [library.spaceInfo.library, library.spaceInfo.reservationType]
        items.append(contentsOf: library.features.spaceFeatures)
        return items.filter { !$0.isEmpty }
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Features")
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.libraryHeading)

            ForEach(featureRows, id: \.text) { row in
                HStack(spacing: 8) {
                    Image(systemName: row.icon)
                        .font(.system(size: 14))
                        .frame(width: 24)
                    Text(row.text)
                        .font(.system(size: 14))
                }
                .foregroundStyle(Constants.Colors.primaryText)
            }
        }
    }

    private var featureRows: [(icon: String, text: String)] {
        var rows: [(String, String)] = []
        rows += library.features.soundLevel.map { ("speaker.wave.1", $0) }
        rows.append((library.spaceTypeIcon, library.spaceInfo.category))
        rows += library.features.spaceType.map { ("person", $0) }
        rows += library.features.spaceFeatures.map { ("display", $0) }
        // de-duplicate while keeping order
        var seen = Set<String>()
        return rows.filter { seen.insert($0.1).inserted }
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.libraryHeading)

            // Placeholder until the model has coordinates
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Constants.Colors.cardBorder.opacity(0.5))
                .frame(height: 160)
                .overlay {
                     VStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2)
                        Text(library.spaceInfo.library)
                            .font(.system(size: 15))
                    }
                    .foregroundStyle(Constants.Colors.secondaryText)
                }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Constants.Colors.cardBorder)
            .frame(height: 1)
    }

    // MARK: Book button

    private var bookButton: some View {
        Button(action: onBook) {
            Text(library.spaceInfo.reservationType == "Reservable" ? "Book Now" : "Request Room")
                .font(.system(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 49)
                .background(Constants.Colors.bookedGreen, in: Capsule())
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

#Preview {
    LibraryDetailView(
        library: Library.sampleData[0],
        availability: .init(isOpen: false, detail: "Opens 6pm Tues")
    )
}

//
//  LibraryDetailView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/30/26.
//

import SwiftUI

/// Open/closed info isn't part of `Library` yet, so it's passed in separately.
enum LibraryAvailability: Equatable {
    case open(closesAt: Date)
    case closed(opensAt: Date)

    var isOpen: Bool {
        if case .open = self { return true }
        return false
    }
}

struct LibraryDetailView: View {
    let library: Library
    var availability: LibraryAvailability? = nil
    var isFavorite: Bool = false
    var onToggleFavorite: () -> Void = {}
    var onBack: () -> Void = {}
    var onBook: () -> Void = {}

    private struct FeatureRow: View {
        let icon: String
        let text: String

        var body: some View {
            HStack(spacing: 8) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .frame(width: 24)
                Text(text)
                    .font(.system(size: 14))
            }
            .foregroundStyle(Constants.Colors.primaryText)
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Constants.Colors.creamBg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    
                    hero
                    
                    content
                    
                        .offset(y: -Constants.Spacing.sheetOverlap)
                        .padding(.bottom, -Constants.Spacing.sheetOverlap)
                }
                .padding(.bottom, 110)
            }
            .ignoresSafeArea(edges: .top)

            topButtons
                .frame(maxHeight: .infinity, alignment: .top)

            if library.spaceInfo.reservationType != .walkIn { bookButton }
        }
    }

    private var hero: some View {
        Constants.Colors.cardBorder.opacity(0.5)
            .frame(height: Constants.Spacing.heroHeight)
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
                availabilityText(availability)
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

    private func availabilityText(_ availability: LibraryAvailability) -> Text {
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

    private var chips: [String] {
        [library.spaceInfo.library, library.spaceInfo.reservationType.label] + library.features.spaceFeatures
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Features")
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.libraryHeading)

            ForEach(library.features.soundLevel, id: \.self) {
                FeatureRow(icon: soundIcon(for: $0), text: $0)
            }
            FeatureRow(icon: "sofa_icon", text: library.spaceInfo.category)
            ForEach(library.features.spaceType, id: \.self) {
                FeatureRow(icon: "person_icon", text: $0)
            }
            ForEach(library.features.spaceFeatures, id: \.self) {
                FeatureRow(icon: "monitor_icon", text: $0)
            }
        }
    }

    private func soundIcon(for level: String) -> String {
        switch level {
        case "Silent": "silent_icon"
        case "Quiet": "quiet_icon"
        default: "full_volume_icon"
        }
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

    private var bookButton: some View {
        Button(action: onBook) {
            Text(library.spaceInfo.reservationType.isBookable ? "Book Now" : "Request Room")
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
        availability: .closed(opensAt: Calendar.current.date(byAdding: .hour, value: 5, to: .now)!)
    )
}

//
//  LibraryDetailView.swift
//  Booked
//
//  Created by Alyssa Wang on 9/30/26.
//

import SwiftUI

struct LibraryDetailView: View {
    @State private var viewModel: LibraryDetailViewModel

    init(
        library: Library,
        availability: LibraryAvailability? = nil,
        isFavorite: Bool,
        onToggleFavorite: @escaping () -> Void = {},
        onBack: @escaping () -> Void = {},
        onBook: @escaping () -> Void = {}
    ) {
        _viewModel = State(
            initialValue: LibraryDetailViewModel(
                library: library,
                availability: availability,
                isFavorite: isFavorite,
                onToggleFavorite: onToggleFavorite,
                onBack: onBack,
                onBook: onBook
            )
        )
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

            if viewModel.showsBookButton {
                bookButton
            }
        }
    }

    private var hero: some View {
        Constants.Colors.cardBorder.opacity(0.5)
            .frame(height: Constants.Spacing.heroHeight)
            .overlay {
                AsyncImage(url: viewModel.library.displayImageURL) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()

                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(Constants.Colors.libraryHeading)

                    default:
                        ProgressView()
                    }
                }
            }
            .clipped()
    }

    private var topButtons: some View {
        HStack {
            circleButton(
                "chevron.left",
                label: "Back",
                action: viewModel.onBack
            )

            Spacer()

            circleButton(
                viewModel.favoriteSymbol,
                label: viewModel.favoriteAccessibilityLabel,
                tint: viewModel.favoriteTint,
                action: viewModel.toggleFavorite
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func circleButton(
        _ symbol: String,
        label: String,
        tint: Color = Constants.Colors.primaryText,
        action: @escaping () -> Void
    ) -> some View {
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

            Text(viewModel.library.spaceInfo.description)
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
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 32,
                topTrailingRadius: 32
            )
        )
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.library.title)
                .font(.system(size: 24))
                .foregroundStyle(Constants.Colors.bookedGreen)
                .fixedSize(horizontal: false, vertical: true)

            if let availabilityText = viewModel.availabilityText {
                availabilityText
                    .font(.system(size: 14))
            }

            FlowLayout(spacing: 7) {
                ForEach(viewModel.chips, id: \.self) { chip in
                    Text(chip)
                        .font(.system(size: 12))
                        .foregroundStyle(Constants.Colors.primaryText)
                        .padding(.horizontal, 16)
                        .frame(height: 30)
                        .background(
                            Constants.Colors.selectedChip,
                            in: Capsule()
                        )
                }
            }
            .padding(.top, 4)
        }
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Features")
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.libraryHeading)

            ForEach(viewModel.library.features.soundLevel, id: \.self) {
                FeatureRow(
                    icon: viewModel.soundIcon(for: $0),
                    text: $0
                )
            }

            FeatureRow(
                icon: "sofa_icon",
                text: viewModel.library.spaceInfo.category
            )

            ForEach(viewModel.library.features.spaceType, id: \.self) {
                FeatureRow(icon: "person_icon", text: $0)
            }

            ForEach(viewModel.library.features.spaceFeatures, id: \.self) {
                FeatureRow(icon: "monitor_icon", text: $0)
            }
        }
    }

    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Location")
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.libraryHeading)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Constants.Colors.cardBorder.opacity(0.5))
                .frame(height: 160)
                .overlay {
                    VStack(spacing: 8) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.title2)

                        Text(viewModel.library.spaceInfo.library)
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
        Button(action: viewModel.onBook) {
            Text(viewModel.bookButtonTitle)
            .font(.system(size: 18))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 49)
            .background(Constants.Colors.bookedGreen, in: Capsule())
            .shadow(
                color: .black.opacity(0.2),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

#Preview {
    LibraryDetailView(
        library: Library.sampleData[0],
        availability: .closed(
            opensAt: Calendar.current.date(
                byAdding: .hour,
                value: 5,
                to: .now
            )!
        ), isFavorite: false
    )
}

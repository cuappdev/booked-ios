//
//  FavoriteRowView.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import SwiftUI

struct FavoriteRowView: View {
    let library: Library
    var onTap: () -> Void = {}
    var onUnfavorite: () -> Void = {}

    @ScaledMetric(relativeTo: .body) private var titleSize: CGFloat = 17

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 14) {
                LibraryThumbnail(url: library.displayImageURL)
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                VStack(alignment: .leading, spacing: 3) {
                    Text(library.title)
                        .font(.system(size: titleSize))
                        .foregroundStyle(Constants.Colors.primaryText)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    LibrarySubtitle(library: library)
                }

                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            .accessibilityAddTraits(.isButton)

            Button(action: onUnfavorite) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Constants.Colors.hearted)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(library.title) from favorites")
        }
        .padding(.leading, 14)
        .padding(.trailing, 4)
        .padding(.vertical, 14)
    }
}

#Preview {
    FavoriteRowView(library: Library.sampleData[0])
        .background(Constants.Colors.cardSurface)
}

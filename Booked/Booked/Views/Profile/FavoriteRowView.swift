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

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 14) {
                LibraryThumbnail(url: library.displayImageURL)
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(library.title)
                        .font(.system(size: 18))
                        .foregroundStyle(Constants.Colors.primaryText)
                        .lineLimit(1)

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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    FavoriteRowView(library: Library.sampleData[0])
        .background(Constants.Colors.cardSurface)
}

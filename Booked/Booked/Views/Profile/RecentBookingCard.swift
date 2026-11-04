//
//  RecentBookingCard.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import SwiftUI

struct RecentBookingCard: View {
    let library: Library
    var onBook: () -> Void = {}

    private let cornerRadius: CGFloat = 20

    var body: some View {
        HStack(spacing: 0) {
            LibraryThumbnail(url: library.displayImageURL)
                .frame(width: 130)

            VStack(alignment: .leading, spacing: 6) {
                Text(library.title)
                    .font(.system(size: 18))
                    .foregroundStyle(Constants.Colors.primaryText)
                    .lineLimit(1)

                LibrarySubtitle(library: library)

                Spacer(minLength: 4)

                Button(action: onBook) {
                    Text("Book Now")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Constants.Colors.bookedGreen, in: Capsule())
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 160)
        .background(Constants.Colors.cardSurface)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Constants.Colors.cardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
}

#Preview {
    RecentBookingCard(library: Library.sampleData[0])
        .padding(20)
        .background(Constants.Colors.creamBg)
}

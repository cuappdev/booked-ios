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

    @ScaledMetric(relativeTo: .body) private var titleSize: CGFloat = 17
    private let cornerRadius: CGFloat = 20

    var body: some View {
        HStack(spacing: 0) {
            LibraryThumbnail(url: library.displayImageURL)
                .frame(width: 105)

            VStack(alignment: .leading, spacing: 4) {
                Text(library.title)
                    .font(.system(size: titleSize))
                    .foregroundStyle(Constants.Colors.primaryText)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                LibrarySubtitle(library: library, highlightsBookable: false)

                Spacer(minLength: 8)

                Button(action: onBook) {
                    Text("Book Now")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(Constants.Colors.bookedGreen, in: Capsule())
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 124)
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

//
//  LibraryThumbnail.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import SwiftUI

/// Library photo that fills whatever frame the caller gives it.
struct LibraryThumbnail: View {
    let url: URL?

    var body: some View {
        Constants.Colors.cardBorder.opacity(0.5)
            .overlay {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title3)
                            .foregroundStyle(Constants.Colors.tertiaryText)
                    default:
                        ProgressView()
                    }
                }
            }
            .clipped()
    }
}

/// "Olin Library · Bookable". Walk-in spaces show just the library name.
struct LibrarySubtitle: View {
    let library: Library

    var body: some View {
        let reservation = library.spaceInfo.reservationType

        HStack(spacing: 4) {
            Text(library.spaceInfo.library)
                .foregroundStyle(Constants.Colors.secondaryText)
                .lineLimit(1)

            if reservation != .walkIn {
                Text("·")
                    .foregroundStyle(Constants.Colors.secondaryText)
                Text(reservation.label)
                    .foregroundStyle(reservation.isBookable
                                     ? Constants.Colors.bookableAccent
                                     : Constants.Colors.secondaryText)
                    .lineLimit(1)
            }
        }
        .font(.system(size: 14))
    }
}

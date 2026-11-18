//
//  LibraryRowComponents.swift
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
/// Wraps onto a second line instead of truncating.
struct LibrarySubtitle: View {
    let library: Library
    /// The list rows tint "Bookable" green; the booking card keeps it gray, as in the design.
    var highlightsBookable = true

    @ScaledMetric(relativeTo: .footnote) private var fontSize: CGFloat = 13

    private var text: AttributedString {
        let reservation = library.spaceInfo.reservationType

        var result = AttributedString(library.spaceInfo.library)
        result.foregroundColor = Constants.Colors.secondaryText

        guard reservation != .walkIn else { return result }

        var separator = AttributedString(" · ")
        separator.foregroundColor = Constants.Colors.secondaryText

        var label = AttributedString(reservation.label)
        label.foregroundColor = (highlightsBookable && reservation.isBookable)
            ? Constants.Colors.bookableAccent
            : Constants.Colors.secondaryText

        result.append(separator)
        result.append(label)
        return result
    }

    var body: some View {
        Text(text)
            .font(.system(size: fontSize))
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}

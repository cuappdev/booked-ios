//
//  MapSearchBar.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import SwiftUI

struct MapSearchBar: View {
    let searchText: String
    let filterCount: Int
    let onSearchTap: () -> Void
    let onFilterTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSearchTap) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundStyle(Constants.Colors.secondaryText)
                    Text(searchText.isEmpty ? "Where to book?" : searchText)
                        .font(.system(size: 18))
                        .foregroundStyle(searchText.isEmpty
                                         ? Constants.Colors.tertiaryText
                                         : Constants.Colors.primaryText)
                        .lineLimit(1)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(Constants.Colors.creamBg, in: Capsule())
                .overlay(Capsule().stroke(Constants.Colors.cardBorder, lineWidth: 1.5))
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Search")

            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundStyle(Constants.Colors.bookedGreen)
                    .frame(width: 32, height: 44)
                    .overlay(alignment: .topTrailing) {
                        if filterCount > 0 {
                            Text("\(filterCount)")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 16, height: 16)
                                .background(Constants.Colors.bookedGreen, in: Circle())
                                .offset(x: 4, y: 0)
                        }
                    }
            }
            .accessibilityLabel("Filters")
        }
        .padding(.horizontal, 20)
    }
}

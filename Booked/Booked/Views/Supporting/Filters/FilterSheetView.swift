//
//  FilterSheetView.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import SwiftUI

struct FilterSheetView: View {
    let filters: FilterStore
    let libraries: [Library]

    @Environment(\.dismiss) private var dismiss
    @State private var expandedGroups: Set<FilterGroup> = []

    private var matchCount: Int {
        libraries.filter(filters.matches).count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Filters")
                        .font(.system(size: 22))
                        .foregroundStyle(Constants.Colors.primaryText)
                    Spacer()
                    Button("Clear all") { filters.clearFilters() }
                        .font(.system(size: 14))
                        .foregroundStyle(Constants.Colors.secondaryText)
                }

                filterSection("Library", group: .library, options: filters.libraryOptions(in: libraries), collapsedCount: 6)
                filterSection("Reservation", group: .reservation, options: FilterStore.reservationOptions)
                filterSection("Noise Level", group: .noise, options: FilterStore.noiseOptions)
                filterSection("Space Type", group: .spaceType, options: filters.spaceTypeOptions(in: libraries), collapsedCount: 9)
                filterSection("Features", group: .feature, options: filters.featureOptions(in: libraries), collapsedCount: 10)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 16)
        }
        .safeAreaInset(edge: .bottom) {
            Button { dismiss() } label: {
                Text("Show \(matchCount) rooms")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Constants.Colors.bookedGreen, in: Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
        .presentationBackground(Constants.Colors.cardSurface)
    }

    private func filterSection(_ title: String, group: FilterGroup, options: [FilterOption], collapsedCount: Int? = nil) -> some View {
        let isExpanded = expandedGroups.contains(group)
        let canCollapse = collapsedCount.map { options.count > $0 } ?? false
        let visible = canCollapse && !isExpanded ? Array(options.prefix(collapsedCount ?? options.count)) : options

        return VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18))
                .foregroundStyle(Constants.Colors.primaryText)

            FlowLayout(spacing: 8) {
                ForEach(visible, id: \.self) { option in
                    ChipView(
                        title: option.count.map { "\(option.value) · \($0)" } ?? option.value,
                        isSelected: filters.isOn(group, option.value)
                    ) {
                        filters.toggle(group, option.value)
                    }
                }
                if canCollapse {
                    Button(isExpanded ? "See less" : "See more") {
                        withAnimation {
                            if !expandedGroups.insert(group).inserted { expandedGroups.remove(group) }
                        }
                    }
                    .font(.system(size: 14))
                    .underline()
                    .foregroundStyle(Constants.Colors.primaryText)
                    .padding(.horizontal, 8)
                    .frame(height: 36)
                }
            }
        }
    }
}

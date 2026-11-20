//
//  FilterChipRow.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import SwiftUI

struct FilterChipRow: View {
    let filters: FilterStore
    var horizontalPadding: CGFloat = 20
    var verticalPadding: CGFloat = 14

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ChipView(title: "All", isSelected: !filters.availableNow) {
                    filters.availableNow = false
                }
                ChipView(title: "Available Now", isSelected: filters.availableNow) {
                    filters.availableNow = true
                }
                ForEach(filters.activeFilters, id: \.self) { f in
                    ChipView(title: f.value, isSelected: true, isRemovable: true) {
                        filters.toggle(f.group, f.value)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.vertical, verticalPadding)
    }
}

//
//  ChipView.swift
//  Booked
//
//  Created by Alyssa Wang on 10/13/26.
//


import SwiftUI

struct ChipView: View {
    let title: String
    var isSelected = false
    var isRemovable = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14))
                if isRemovable {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .medium))
                }
            }
            .foregroundStyle(Constants.Colors.primaryText)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .background(isSelected ? Constants.Colors.selectedChip : Constants.Colors.chip, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Simple wrapping layout for chips

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowH: CGFloat = 0, maxW: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > width, x > 0 { x = 0; y += rowH + spacing; rowH = 0 }
            x += s.width + spacing
            rowH = max(rowH, s.height)
            maxW = max(maxW, x - spacing)
        }
        return CGSize(width: maxW, height: y + rowH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowH: CGFloat = 0
        for v in subviews {
            let s = v.sizeThatFits(.unspecified)
            if x + s.width > bounds.maxX, x > bounds.minX { x = bounds.minX; y += rowH + spacing; rowH = 0 }
            v.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(s))
            x += s.width + spacing
            rowH = max(rowH, s.height)
        }
    }
}

#Preview {
    HStack {
        ChipView(title: "Available Now", isSelected: true) {}
        ChipView(title: "Quiet", isSelected: true, isRemovable: true) {}
        ChipView(title: "Walk-in") {}
    }
    .padding()
}

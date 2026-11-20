//
//  DetentSheet.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//

import SwiftUI

struct DetentSheet<Header: View, Content: View>: View {
    let availableHeight: CGFloat
    let detent: MapViewModel.SheetDetent
    let onDetentChange: (MapViewModel.SheetDetent) -> Void
    let onDismiss: () -> Void
    @ViewBuilder var header: Header
    @ViewBuilder var content: Content

    @GestureState private var dragY: CGFloat = 0

    private var halfHeight: CGFloat { availableHeight * 0.52 }
    private var fullHeight: CGFloat { availableHeight - 8 }
    private var restingHeight: CGFloat { detent == .full ? fullHeight : halfHeight }

    var body: some View {
        let visibleHeight = min(max(restingHeight - dragY, 100), fullHeight)

        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Capsule()
                    .fill(Constants.Colors.cardBorder)
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                header
            }
            .contentShape(Rectangle())
            .gesture(dragGesture)

            content
        }
        .frame(maxWidth: .infinity)
        .frame(height: fullHeight, alignment: .top)
        .background(
            UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32, style: .continuous)
                .fill(Constants.Colors.cardSurface)
                .shadow(color: .black.opacity(0.15), radius: 16, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
        .offset(y: fullHeight - visibleHeight)
        .gesture(dragGesture, including: detent == .full ? .subviews : .all)
        .animation(.spring(duration: 0.35), value: detent)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .updating($dragY) { value, state, _ in state = value.translation.height }
            .onEnded { value in
                let projected = restingHeight - value.predictedEndTranslation.height
                if projected > (halfHeight + fullHeight) / 2 {
                    onDetentChange(.full)
                } else if projected > halfHeight * 0.6 {
                    onDetentChange(.half)
                } else {
                    onDismiss()
                }
            }
    }
}


//
//  FavoriteSortSheet.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import SwiftUI

struct FavoriteSortSheet: View {
    @Binding var selection: FavoriteSort
    var onApply: () -> Void

    @State private var contentHeight: CGFloat = 170

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sort by")
                .font(.system(size: 24))
                .foregroundStyle(Constants.Colors.primaryText)

            VStack(alignment: .leading, spacing: 16) {
                ForEach(FavoriteSort.allCases) { option in
                    Button { selection = option } label: {
                        HStack(spacing: 12) {
                            Image(systemName: selection == option ? "largecircle.fill.circle" : "circle")
                                .font(.system(size: 20))
                                .foregroundStyle(selection == option
                                                 ? Constants.Colors.bookedGreen
                                                 : Constants.Colors.tertiaryText)
                            Text(option.title)
                                .font(.system(size: 16))
                                .foregroundStyle(Constants.Colors.primaryText)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selection == option ? .isSelected : [])
                }
            }

            Button(action: onApply) {
                Text("Apply")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Constants.Colors.bookedGreen, in: Capsule())
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 34) // room for the home indicator
        .background {
            GeometryReader { proxy in
                Color.clear.preference(key: SheetHeightKey.self, value: proxy.size.height)
            }
        }
        .onPreferenceChange(SheetHeightKey.self) { contentHeight = $0 }
        .frame(maxHeight: .infinity, alignment: .top)
        .presentationDetents([.height(contentHeight)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(32)
        .presentationBackground(Constants.Colors.cardSurface)
    }
}

private struct SheetHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

#Preview {
    FavoriteSortSheet(selection: .constant(.recentlyAdded), onApply: {})
}

//
//  LibraryPin.swift
//  Booked
//
//  Created by Alyssa Wang on 11/18/26.
//


import SwiftUI

struct LibraryPin: View {
    let isSelected: Bool

    var body: some View {
        Image(isSelected ? "book_mappin_dark" : "book_mappin_light")
            .resizable()
            .scaledToFit()
            .frame(width: 38, height: 40)
            .shadow(color: .black.opacity(0.18), radius: 4, y: 2)
            .scaleEffect(isSelected ? 1.12 : 1)
            .animation(.spring(duration: 0.25), value: isSelected)
    }
}

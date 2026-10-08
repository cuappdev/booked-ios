//
//  Constants.swift
//  Booked
//
//  Created by Alyssa Wang on 9/9/26.
//

import SwiftUI

// MARK: - Constants
//
//  Constants.swift
//  Booked
//

import SwiftUI

// MARK: - Constants
struct Constants {
    enum Colors {
        // Palette
        static let bookedGreen = Color(hex: "#3f4f44") // Primary
        static let creamBg  = Color(hex: "#faf7f1") // Background
        static let cardSurface = Color(hex: "#fefdfb") // Card surface
        static let cardBorder = Color(hex: "#e5e1d3") // Card border
        static let chip = Color(hex: "#eaeae5") // Chip
        static let selectedChip = Color(hex: "#deede3") // Selected chip

        // Text
        static let primaryText = Color(hex: "#595c5a")
        static let secondaryText = Color(hex: "#6b6a60")
        static let tertiaryText = Color(hex: "#a1a1a1")
        
        //Library booking text in LibraryDetailView
        static let libraryHeading = Color(hex: "#0F2A1D")

        // Status
        static let bookableAccent = Color(hex: "#5da271")
        static let closedRed = Color(hex: "#a94a48")
        
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255
        let green = Double((rgb >> 8) & 0xFF) / 255
        let blue = Double(rgb & 0xFF) / 255
        
        self.init(red: red, green: green, blue: blue)
    }
}




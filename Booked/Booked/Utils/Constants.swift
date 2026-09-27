//
//  Constants.swift
//  Booked
//
//  Created by Alyssa Wang on 9/9/26.
//

import SwiftUI

// MARK: - Constants
struct Constants {
    enum Colors {
        static let bookedGreen = Color(hex: "#3f4f44")
        static let creamBg = Color(hex: "#faf7f1")
        static let primaryText = Color(hex: "#595c5a")
        static let secondaryText = Color(hex: "#6b6a60")
        static let tertiaryText = Color(hex: "#c8c8c8")
        static let cardBorder = Color(hex: "#e5e1d3")
    }
    
    enum AppSpacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
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




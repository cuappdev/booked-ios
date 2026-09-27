//
//  AppTabModel.swift
//  Booked
//
//  Created by Alyssa Wang on 9/24/26.
//

// MARK: - Nav Bar

enum Screen: Int, CaseIterable {
    case home = 0
    case map = 1
    case profile = 2

    var title: String {
        switch self {
        case .home: return "Home"
        case .map: return "Learn"
        case .profile: return "Profile"
        }
    }

    var icon: String {
        switch self {
        case .home: return "nav_home_outline"
        case .map: return "nav_map_outline"
        case .profile: return "nav_profile_outline"
        }
    }

    var filledIcon: String {
        switch self {
        case .home: return "nav_home_clicked"
        case .map: return "nav_map_clicked"
        case .profile: return "nav_profile_clicked"
        }
    }
}


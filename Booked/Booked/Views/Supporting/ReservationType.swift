//
//  ReservationType.swift
//  Booked
//
//  Created by Alyssa Wang on 10/13/26.
//


import Foundation

enum ReservationType: String, Codable, CaseIterable {
    case reservable = "Reservable"
    case byRequest = "By request"
    case walkIn = "No reservation"

    /// User-facing label, e.g. "Reservable" -> "Bookable", "No reservation" -> "Walk-in"
    var label: String {
        switch self {
        case .reservable: "Bookable"
        case .byRequest: "By request"
        case .walkIn: "Walk-in"
        }
    }

    var isBookable: Bool { self == .reservable }
}

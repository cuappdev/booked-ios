//
//  FeatureRow.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import SwiftUI

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 14))
        }
        .foregroundStyle(Constants.Colors.primaryText)
    }
}

#Preview {
    FeatureRow(icon: "sofa_icon", text: "Group Study Room")
        .padding()
}

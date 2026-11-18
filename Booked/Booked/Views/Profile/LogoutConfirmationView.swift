//
//  LogoutConfirmationView.swift
//  Booked
//
//  Created by Alyssa Wang on 10/28/26.
//

import SwiftUI

struct LogoutConfirmationView: View {
    var onCancel: () -> Void
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)

            VStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 28))
                    .foregroundStyle(Constants.Colors.primaryText)

                Text("Log out?")
                    .font(.system(size: 20))
                    .foregroundStyle(Constants.Colors.primaryText)

                Text("Logging out removes your access to Booked.")
                    .font(.system(size: 13))
                    .foregroundStyle(Constants.Colors.secondaryText)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.system(size: 15))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Constants.Colors.bookedGreen, in: Capsule())
                    }

                    Button(action: onConfirm) {
                        Text("Log Out")
                            .font(.system(size: 15))
                            .foregroundStyle(Constants.Colors.bookedGreen)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .overlay(Capsule().stroke(Constants.Colors.bookedGreen, lineWidth: 1))
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(20)
            .frame(maxWidth: 330)
            .background(Constants.Colors.cardSurface,
                        in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal, 32)
            .accessibilityAddTraits(.isModal)
        }
    }
}

#Preview {
    LogoutConfirmationView(onCancel: {}, onConfirm: {})
}

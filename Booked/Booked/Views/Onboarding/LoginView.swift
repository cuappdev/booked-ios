//
//  LoginView.swift
//  Booked
//
//  Created by Alyssa Wang on 10/14/26.
//

import SwiftUI

struct LoginView: View {
    var onSignIn: () -> Void = {}

    var body: some View {
        ZStack {
            Constants.Colors.creamBg
                .ignoresSafeArea()

            Image("booked_logo_green")
                .resizable()
                .scaledToFit()
                .frame(width: 72.85, height: 78.45)

            VStack(spacing: 20) {
                Spacer()

                Button(action: onSignIn) {
                    HStack(spacing: 8) {
                        Image("login_key")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Sign in with NetID")
                    }
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 49)
                    .background(Constants.Colors.bookedGreen, in: Capsule())
                }
                .buttonStyle(.plain)

                Image("appdev_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 101, height: 16.5)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    LoginView()
}

//
//  ContentView.swift
//  Booked
//
//  Created by jiwon jeong on 9/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab: Screen = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .map:
                    MapView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab)
        }
        .background(Constants.Colors.creamBg.ignoresSafeArea())
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Screen
    @Namespace private var underlineNamespace

    private let barHeight: CGFloat = 60

    var body: some View {
        HStack(spacing: 60) {
            ForEach(Screen.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .offset(y: 14)
        .frame(height: barHeight)
        .frame(maxWidth: .infinity)
        .background(
            Constants.Colors.creamBg
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(Constants.Colors.cardBorder)
                        .frame(height: 1)
                }
                .ignoresSafeArea(edges: .bottom)
        )
    }

    @ViewBuilder
    private func tabButton(for tab: Screen) -> some View {
        switch tab {
        case .home:
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedTab = .home
                }
            } label: {
                tabButtonView(
                    icon: selectedTab == .home ? tab.filledIcon : tab.icon,
                    isSelected: selectedTab == .home
                )
            }
        case .map:
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedTab = .map
                }
            } label: {
                tabButtonView(
                    icon: selectedTab == .map ? tab.filledIcon : tab.icon,
                    isSelected: selectedTab == .map
                )
            }
        case .profile:
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    selectedTab = .profile
                }
            } label: {
                tabButtonView(
                    icon: selectedTab == .profile ? tab.filledIcon : tab.icon,
                    isSelected: selectedTab == .profile
                )
            }
        }
    }

    private func tabButtonView(icon: String, isSelected: Bool) -> some View {
        VStack(spacing: 7) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)

            Color.clear
                .frame(width: 50, height: 1)
                .overlay {
                    if isSelected {
                        Rectangle()
                            .fill(Constants.Colors.bookedGreen)
                            .frame(width: 50, height: 1)
                            .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                    }
                }
        }
        .contentShape(Rectangle())
    }
    
}

#Preview {
    ContentView()
}

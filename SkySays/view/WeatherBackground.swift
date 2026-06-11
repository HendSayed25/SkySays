//
//  WeatherBackground.swift
//  SkySays
//
//  Created by Hend Sayed on 10/06/2026.
//

import SwiftUI

struct WeatherBackground: View {
    let isMorning: Bool

    var body: some View {
        if isMorning {
            morningBackground
        } else {
            eveningBackground
        }
    }

    private var morningBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.53, green: 0.76, blue: 0.92),
                Color(red: 0.60, green: 0.80, blue: 0.90),
                Color(red: 0.95, green: 0.85, blue: 0.60),
                Color(red: 0.98, green: 0.75, blue: 0.40),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var eveningBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.05, blue: 0.18),
                Color(red: 0.10, green: 0.10, blue: 0.30),
                Color(red: 0.25, green: 0.15, blue: 0.35),
                Color(red: 0.45, green: 0.20, blue: 0.30),
                Color(red: 0.55, green: 0.25, blue: 0.20),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

extension WeatherBackground {
    static func foregroundColor(isMorning: Bool) -> Color {
        isMorning ? .black : .white
    }

    static func secondaryColor(isMorning: Bool) -> Color {
        isMorning ? Color.black.opacity(0.65) : Color.white.opacity(0.75)
    }

    static func cardBackground(isMorning: Bool) -> Color {
        isMorning
        ? Color.white.opacity(0.25)
        : Color.white.opacity(0.12)
    }

    static func dividerColor(isMorning: Bool) -> Color {
        isMorning
        ? Color.black.opacity(0.15)
        : Color.white.opacity(0.20)
    }
}

#Preview {
    VStack(spacing: 0) {
        WeatherBackground(isMorning: true)
        WeatherBackground(isMorning: false)
    }
}

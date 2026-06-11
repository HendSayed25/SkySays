//
//  BottomStatsSection.swift
//  SkySays
//
//  Created by Hend Sayed on 10/06/2026.
//

import SwiftUI

@MainActor
struct BottomStatsSection: View {
    let vm: WeatherViewModel
    private var cardBg: Color { WeatherBackground.cardBackground(isMorning: vm.isMorning) }
    private var fg: Color { WeatherBackground.foregroundColor(isMorning: vm.isMorning) }
    private var secondary: Color { WeatherBackground.secondaryColor(isMorning: vm.isMorning) }
    private var dividerColor: Color { WeatherBackground.dividerColor(isMorning: vm.isMorning) }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                StatCard(
                    title: "VISIBILITY",
                    value: vm.visibility,
                    fg: fg,
                    secondary: secondary,
                    cardBg: cardBg
                )

                Divider()
                    .background(dividerColor)
                    .frame(maxHeight: 80)

                StatCard(
                    title: "HUMIDITY",
                    value: vm.humidity,
                    fg: fg,
                    secondary: secondary,
                    cardBg: cardBg
                )
            }

            Divider()
                .background(dividerColor)
                .padding(.horizontal, 16)

            HStack(spacing: 0) {
                StatCard(
                    title: "FEELS LIKE",
                    value: vm.feelsLike,
                    fg: fg,
                    secondary: secondary,
                    cardBg: cardBg
                )

                Divider()
                    .background(dividerColor)
                    .frame(maxHeight: 80)

                StatCard(
                    title: "PRESSURE",
                    value: vm.pressure,
                    fg: fg,
                    secondary: secondary,
                    cardBg: cardBg
                )
            }
        }
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: vm.isMorning ? Color.black.opacity(0.08) : Color.black.opacity(0.25),
            radius: 8, x: 0, y: 4
        )
        .padding(.horizontal, 16)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let fg: Color
    let secondary: Color
    let cardBg: Color
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .tracking(1.5)
                .foregroundColor(secondary)

            Text(value)
                .font(.system(size: 26, weight: .light))
                .foregroundColor(fg)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.clear)
    }
}

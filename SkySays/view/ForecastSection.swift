//
//  ForecastSection.swift
//  SkySays
//
//  Created by Hend Sayed on 10/06/2026.
//

import SwiftUI

struct ForecastSection: View {
    let forecastDays: [ForecastDay]
    let isMorning: Bool
    let onSelectDay: (ForecastDay,Int) -> Void

    private var fg: Color { WeatherBackground.foregroundColor(isMorning: isMorning) }
    private var secondary: Color { WeatherBackground.secondaryColor(isMorning: isMorning) }
    private var cardBg: Color { WeatherBackground.cardBackground(isMorning: isMorning) }
    private var dividerColor: Color { WeatherBackground.dividerColor(isMorning: isMorning) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("3-DAY FORECAST")
                .font(.system(size: 13, weight: .semibold))
                .tracking(1.5)
                .foregroundColor(secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

            ForEach(Array(forecastDays.enumerated()), id: \.element.id) { index, day in
                Button(action: { onSelectDay(day,index) }) {
                    ForecastRow(day: day, index: index, isMorning: isMorning)
                }
                .buttonStyle(.plain)

                if index < forecastDays.count - 1 {
                    Divider()
                        .background(dividerColor)
                        .padding(.horizontal, 16)
                }
            }
        }
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}

struct ForecastRow: View {
    let day: ForecastDay
    let index: Int
    let isMorning: Bool

    private var fg: Color { WeatherBackground.foregroundColor(isMorning: isMorning) }
    private var secondary: Color { WeatherBackground.secondaryColor(isMorning: isMorning) }
    var dayLabel: String { DateFormatter.dayLabel(from: day.date, index: index) }

    var body: some View {
        HStack(spacing: 0) {
            Text(dayLabel)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(fg)
                .frame(width: 100, alignment: .leading)

            Spacer()

            WeatherIconView(iconURL: day.day.condition.icon, size: 24, isMorning: isMorning).frame(width: 36)

            Spacer()

            Text(TempFormatter.formatRange(min: day.day.mintempC, max: day.day.maxtempC))
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(secondary)
                .frame(width: 100, alignment: .trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}


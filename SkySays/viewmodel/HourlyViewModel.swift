//
//  HourlyViewModel.swift
//  SkySays
//
//  Created by Hend Sayed on 09/06/2026.
//

import Foundation

@MainActor
final class HourlyViewModel: ObservableObject {

    @Published private(set) var hourlyItems: [HourlyItem] = []

    struct HourlyItem: Identifiable {
        var id: String { label }
        let label: String
        let iconURL: String
        let iconCode: Int
        let temp: String
    }

    func configure(with forecastDay: ForecastDay, isToday: Bool) {
        let currentHour = DateFormatter.currentHourIndex
        let hours = forecastDay.hour
        var items: [HourlyItem] = []

        if isToday {
            if let nowHour = hours.first(where: {
                let h = $0.time.components(separatedBy: " ").last?.prefix(2) ?? ""
                return Int(h) == currentHour
            }) {
                items.append(HourlyItem(
                    label: "Now",
                    iconURL: nowHour.condition.icon,
                    iconCode: nowHour.condition.code,
                    temp: TempFormatter.format(nowHour.tempC)
                ))
            }

            let remaining = hours.filter {
                let parts = $0.time.components(separatedBy: " ")
                guard let timePart = parts.last else { return false }
                let hourPart = timePart.components(separatedBy: ":").first ?? ""
                guard let h = Int(hourPart) else { return false }
                return h > currentHour
            }
            for hour in remaining {
                items.append(HourlyItem(
                    label: DateFormatter.hourLabel(from: hour.time),
                    iconURL: hour.condition.icon,
                    iconCode: hour.condition.code,
                    temp: TempFormatter.format(hour.tempC)
                ))
            }

        } else {
            for hour in hours {
                items.append(HourlyItem(
                    label: DateFormatter.hourLabel(from: hour.time),
                    iconURL: hour.condition.icon,
                    iconCode: hour.condition.code,
                    temp: TempFormatter.format(hour.tempC)
                ))
            }
        }

        hourlyItems = items
    }
}

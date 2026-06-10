//
//  General.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation
import SwiftUI

enum TimeUtility {
    // Returns true if current hour is between 05:00 and 18:00 (morning/day)
    static var isMorning: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour >= 5 && hour < 18
    }

    static var currentHour: Int {
        Calendar.current.component(.hour, from: Date())
    }
}


// Maps WeatherAPI icon URL to SF Symbol name for display if error happen
// Icon URLs like //cdn.weatherapi.com/weather/64x64/day/116.png
enum WeatherIconHelper {
    static func sfSymbol(for iconURL: String, code: Int? = nil) -> String {
        let path = iconURL.lowercased()

        if path.contains("sun") || path.contains("clear") || path.contains("113") {
            return TimeUtility.isMorning ? "sun.max.fill" : "moon.stars.fill"
        } else if path.contains("partly") || path.contains("116") {
            return TimeUtility.isMorning ? "cloud.sun.fill" : "cloud.moon.fill"
        } else if path.contains("cloudy") || path.contains("119") || path.contains("122") {
            return "cloud.fill"
        } else if path.contains("overcast") {
            return "smoke.fill"
        } else if path.contains("rain") || path.contains("drizzle") {
            return "cloud.rain.fill"
        } else if path.contains("thunder") || path.contains("storm") {
            return "cloud.bolt.rain.fill"
        } else if path.contains("snow") || path.contains("blizzard") {
            return "snowflake"
        } else if path.contains("sleet") || path.contains("ice") {
            return "cloud.sleet.fill"
        } else if path.contains("mist") || path.contains("fog") {
            return "cloud.fog.fill"
        } else if path.contains("wind") || path.contains("blowing") {
            return "wind"
        } else {
            return "cloud.fill"
        }
    }

    // Color for weather icon
    static func iconColor(for iconURL: String) -> Color {
        let path = iconURL.lowercased()
        if path.contains("sun") || path.contains("113") { return .yellow }
        if path.contains("partly") || path.contains("116") { return .yellow }
        if path.contains("rain") || path.contains("drizzle") { return .blue }
        if path.contains("thunder") { return .purple }
        if path.contains("snow") { return .cyan }
        return .white
    }
}

enum DateFormatter {
    static private let apiDateFormatter: Foundation.DateFormatter = {
        let f = Foundation.DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static private let displayFormatter: Foundation.DateFormatter = {
        let f = Foundation.DateFormatter()
        f.dateFormat = "EEEE"
        return f
    }()

    static private let hourFormatter: Foundation.DateFormatter = {
        let f = Foundation.DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f
    }()

    static private let hourDisplayFormatter: Foundation.DateFormatter = {
        let f = Foundation.DateFormatter()
        f.dateFormat = "ha"
        return f
    }()

    static func dayLabel(from dateString: String, index: Int) -> String {
        switch index {
        case 0: return "Today"
        case 1: return "Tomorrow"
        default:
            guard let date = apiDateFormatter.date(from: dateString) else { return dateString }
            return displayFormatter.string(from: date)
        }
    }

    static func hourLabel(from timeString: String) -> String {
        guard let date = hourFormatter.date(from: timeString) else { return timeString }
        return hourDisplayFormatter.string(from: date).uppercased()
    }

    // Returns current hour's index in hourly array (0-23)
    static var currentHourIndex: Int {
        Calendar.current.component(.hour, from: Date())
    }
}


enum TempFormatter {
    static func format(_ value: Double) -> String {
        "\(Int(value.rounded()))°"
    }

    static func formatRange(min: Double, max: Double) -> String {
        "\(format(min)) - \(format(max))"
    }
}

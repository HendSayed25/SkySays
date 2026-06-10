//
//  Forecast.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation

struct ForecastDay: Codable, Identifiable {
    var id: String { date }
    let date: String
    let day: DayInfo
    let hour: [HourInfo]
}

struct DayInfo: Codable {
    let maxtempC: Double
    let mintempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
    }
}

struct HourInfo: Codable, Identifiable {
    var id: String { time }
    let time: String
    let tempC: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
    }
}

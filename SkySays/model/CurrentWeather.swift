//
//  CurrentWeather.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation

struct CurrentWeather: Codable {
    let tempC: Double
    let feelslikeC: Double
    let humidity: Int
    let visKm: Double
    let pressureMb: Double
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case feelslikeC = "feelslike_c"
        case humidity
        case visKm = "vis_km"
        case pressureMb = "pressure_mb"
        case condition
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

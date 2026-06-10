//
//  WeatherModel.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation

struct ForecastResponse: Codable {
    let location: LocationInfo
    let current: CurrentWeather
    let forecast: ForecastData
}

struct ForecastData: Codable {
    let forecastday: [ForecastDay]
}

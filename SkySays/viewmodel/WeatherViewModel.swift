//
//  WeatherViewModel.swift
//  SkySays
//
//  Created by Hend Sayed on 09/06/2026.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {

    @Published private(set) var forecast: ForecastResponse?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isMorning: Bool

    private let service: WeatherServiceProtocol

    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
        self.isMorning = TimeUtility.isMorning
    }

    func loadWeather(for query: String) async {
        isLoading = true
        errorMessage = nil
        isMorning = TimeUtility.isMorning

        do {
            forecast = try await service.fetchForecast(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh(query: String) async {
        await loadWeather(for: query)
    }

    var locationName: String { forecast?.location.name ?? "—" }
    var currentTemp: String { forecast.map { TempFormatter.format($0.current.tempC) } ?? "—" }
    var conditionText: String { forecast?.current.condition.text ?? "—" }
    var conditionIconURL: String { forecast?.current.condition.icon ?? "" }

    var todayHigh: String { forecast.map { TempFormatter.format($0.forecast.forecastday[0].day.maxtempC) } ?? "—" }
    var todayLow: String { forecast.map { TempFormatter.format($0.forecast.forecastday[0].day.mintempC) } ?? "—" }

    var forecastDays: [ForecastDay] { forecast?.forecast.forecastday ?? [] }

    var visibility: String { forecast.map { "\(Int($0.current.visKm)) km" } ?? "—" }
    var humidity: String { forecast.map { "\($0.current.humidity)%" } ?? "—" }
    var feelsLike: String { forecast.map { TempFormatter.format($0.current.feelslikeC) } ?? "—" }
    var pressure: String { forecast.map { "\(Int($0.current.pressureMb))" } ?? "—" }
}


//
//  WeatherDetailView.swift
//  SkySays
//
//  Created by Hend Sayed on 10/06/2026.
//

import SwiftUI

struct WeatherDetailView: View {
    @StateObject private var vm: WeatherViewModel
    @State private var selectedDay: ForecastDay?
    @State private var showHourly: Bool = false
    @State private var selectedDayIndex = 0

    let locationQuery: String
    let locationName: String?

    init(locationQuery: String, locationName: String? = nil) {
        self.locationQuery = locationQuery
        self.locationName = locationName
        _vm = StateObject(wrappedValue: WeatherViewModel())
    }

    var body: some View {
        ZStack {
            WeatherBackground(isMorning: vm.isMorning)
            if vm.isLoading {
                loadingView
            } else if let error = vm.errorMessage {
                errorView(message: error)
            } else {
                weatherContent
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .task { await vm.loadWeather(for: locationQuery) }
        .refreshable { await vm.refresh(query: locationQuery) }
        .navigationDestination(isPresented: $showHourly) {
            if let day = selectedDay {
                HourlyForecastView(
                    forecastDay: day,
                    isMorning: vm.isMorning, 
                    isToday: selectedDayIndex == 0
                ).toolbarBackground(.hidden, for: .navigationBar)
                    .background(WeatherBackground(isMorning: vm.isMorning))
            }
        }
    }

    private var weatherContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                TopWeatherSection(vm: vm)
                ForecastSection(
                    forecastDays: vm.forecastDays,
                    isMorning: vm.isMorning
                ) { day ,index in
                    selectedDay = day
                    selectedDayIndex = index
                    showHourly = true
                }
                BottomStatsSection(vm: vm)
                Spacer(minLength: 10)
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(vm.isMorning ? .black : .white)
                .scaleEffect(1.5)
            Text("Loading weather...")
                .font(.system(size: 16))
                .foregroundColor(WeatherBackground.secondaryColor(isMorning: vm.isMorning))
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.yellow)

            Text("Couldn't load weather")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(WeatherBackground.foregroundColor(isMorning: vm.isMorning))

            Text(message)
                .font(.system(size: 14))
                .foregroundColor(WeatherBackground.secondaryColor(isMorning: vm.isMorning))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button(action: {
                Task { await vm.loadWeather(for: locationQuery) }
            }) {
                Text("Retry")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue.opacity(0.8))
                    .clipShape(Capsule())
            }
        }
    }
}

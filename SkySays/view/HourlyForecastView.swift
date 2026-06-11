//
//  HourlyForecastView.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import SwiftUI

struct HourlyForecastView: View {
    let forecastDay: ForecastDay
    let isMorning: Bool
    let isToday: Bool

    @StateObject private var vm = HourlyViewModel()
    private var fg: Color { WeatherBackground.foregroundColor(isMorning: isMorning) }
    private var secondary: Color { WeatherBackground.secondaryColor(isMorning: isMorning) }
    private var dividerColor: Color { WeatherBackground.dividerColor(isMorning: isMorning) }

    var body: some View {
        ZStack {
            WeatherBackground(isMorning: isMorning).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(vm.hourlyItems.enumerated()), id: \.element.id) { index, item in
                        HourlyRow(item: item, fg: fg, secondary: secondary)

                        if index < vm.hourlyItems.count - 1 {
                            Divider()
                                .background(dividerColor)
                                .padding(.horizontal, 24)
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            vm.configure(with: forecastDay, isToday: isToday)
            UIScrollView.appearance().backgroundColor = .clear
        }
        .onDisappear {
            UIScrollView.appearance().backgroundColor = nil
        }
    }
}

struct HourlyRow: View {
    let item: HourlyViewModel.HourlyItem
    let fg: Color
    let secondary: Color

    var body: some View {
        HStack(spacing: 0) {
            Text(item.label)
                .font(.system(size: 22, weight: .light))
                .foregroundColor(fg)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 32)

            Spacer()

            WeatherIconView(iconURL: item.iconURL, size: 36).frame(width: 50)

            Spacer()

            Text(item.temp)
                .font(.system(size: 22, weight: .light))
                .foregroundColor(fg)
                .frame(width: 80, alignment: .trailing)
                .padding(.trailing, 32)
        }
        .padding(.vertical, 18)
    }
}

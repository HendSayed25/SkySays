//
//  TopWeatherSection.swift
//  SkySays
//
//  Created by Hend Sayed on 10/06/2026.
//

import SwiftUI

@MainActor
struct TopWeatherSection: View {
    let vm: WeatherViewModel
    private var fg: Color { WeatherBackground.foregroundColor(isMorning: vm.isMorning) }
    private var secondary: Color { WeatherBackground.secondaryColor(isMorning: vm.isMorning) }

    var body: some View {
        VStack(spacing: 4) {
            Text(vm.locationName)
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(fg)

            Text(vm.currentTemp)
                .font(.system(size: 80, weight: .thin))
                .foregroundColor(fg)

            Text(vm.conditionText)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(secondary)

            Text("H: \(vm.todayHigh) L: \(vm.todayLow)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(secondary)

            WeatherIconView(iconURL: vm.conditionIconURL, size: 80 , isMorning: vm.isMorning)
        }
        .padding(.top, 60)
        .frame(maxWidth: .infinity)
    }
}

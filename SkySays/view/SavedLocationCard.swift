//
//  SavedLocationCard.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import SwiftUI

struct SavedLocationCard: View {
    let location: SavedLocation
    let isMorning: Bool
    let onTap: () -> Void
    let onDelete: () -> Void

    @StateObject private var weatherVM = WeatherViewModel()
    @State private var showDeleteAlert = false

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(WeatherBackground.foregroundColor(isMorning: isMorning))
                    Text(location.country)
                        .font(.system(size: 13))
                        .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                    if !weatherVM.conditionText.isEmpty && weatherVM.conditionText != "—" {
                        Text(weatherVM.conditionText)
                            .font(.system(size: 13))
                            .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                            .padding(.top, 2)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    if weatherVM.isLoading {
                        ProgressView()
                            .tint(WeatherBackground.foregroundColor(isMorning: isMorning))
                    } else {
                        Text(weatherVM.currentTemp)
                            .font(.system(size: 40, weight: .thin))
                            .foregroundColor(WeatherBackground.foregroundColor(isMorning: isMorning))
                        WeatherIconView(iconURL: weatherVM.conditionIconURL, size: 28, isMorning: isMorning)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(WeatherBackground.cardBackground(isMorning: isMorning))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(WeatherBackground.dividerColor(isMorning: isMorning), lineWidth: 1)
            )
        }
        .contextMenu {
            Button(role: .destructive) { showDeleteAlert = true } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete \(location.name)?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive, action: onDelete)
            Button("Cancel", role: .cancel) {}
        }
        .task {
            await weatherVM.loadWeather(for: location.coordinateQuery)
        }
    }
}

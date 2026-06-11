//
//  WeatherIconView.swift
//  SkySays
//
//  Created by Hend Sayed on 10/06/2026.
//

import SwiftUI

struct WeatherIconView: View {
    let iconURL: String
    var size: CGFloat = 32
    var isMorning: Bool = true
    var showShadow: Bool = false

    private var fullURL: String {
        iconURL.hasPrefix("//") ? "https:" + iconURL : iconURL
    }

    var body: some View {
        AsyncImage(url: URL(string: fullURL)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .shadow(
                        color: showShadow ? .black.opacity(0.2) : .clear,
                        radius: showShadow ? 8 : 0,
                        x: 0, y: showShadow ? 4 : 0
                    )
            case .failure:
                Image(systemName: WeatherIconHelper.sfSymbol(for: iconURL))
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    VStack {
        WeatherIconView(iconURL: "//cdn.weatherapi.com/weather/64x64/day/116.png", size: 80, showShadow: true)
        WeatherIconView(iconURL: "//cdn.weatherapi.com/weather/64x64/day/116.png", size: 32)
    }
}

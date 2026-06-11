//
//  ContentView.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    private var isMorning: Bool { TimeUtility.isMorning }

    var body: some View {
        TabView {
            NavigationStack {
                    if locationManager.isReady,
                       let query = locationManager.query {
                        WeatherDetailView(locationQuery: query)
                    }
                 else {
                        ZStack {
                            WeatherBackground(isMorning:isMorning)
                            .ignoresSafeArea()
                            
                            VStack(spacing: 20) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundColor(.white)
                                    .symbolEffect(.pulse)
                                
                                Text("Getting your location...")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                
                                if locationManager.authStatus == .denied {
                                    VStack(spacing: 12) {
                                        Text("Location access denied")
                                            .font(.system(size: 15))
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        Button(action: {
                                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text("Open Settings")
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 28)
                                                .padding(.vertical, 12)
                                                .background(Color.black.opacity(0.25))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
            .tabItem { Label("Weather", systemImage: "cloud.sun.fill") }
            SavedLocationsView()
            .tabItem { Label("Locations", systemImage: "list.bullet") }
        }
        .tint(isMorning ? .black : .white)
        .onAppear {
            locationManager.requestLocation()
            
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            
            appearance.stackedLayoutAppearance.normal.iconColor =
            isMorning
            ? UIColor.black.withAlphaComponent(0.7)
            : UIColor.white.withAlphaComponent(0.7)
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: isMorning
                ? UIColor.black.withAlphaComponent(0.7)
                : UIColor.white.withAlphaComponent(0.7)
            ]
            
            appearance.shadowColor = .clear
            
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}

#Preview {
    ContentView().modelContainer(for: SavedLocation.self, inMemory: true)
}

//
//  ContentView.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        TabView {
            NavigationStack {
                Group {
                    if locationManager.isReady {
                        WeatherDetailView(locationQuery: locationManager.query)
                    } else {
                        ZStack {
                            LinearGradient(
                                colors: [
                                    Color(red: 0.53, green: 0.76, blue: 0.92),
                                    Color(red: 0.98, green: 0.75, blue: 0.40)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
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
            }
            .tabItem { Label("Weather", systemImage: "cloud.sun.fill") }
            SavedLocationsView()
            .tabItem { Label("Locations", systemImage: "list.bullet") }
        }
        .tint(.white)
        .onAppear {
            locationManager.requestLocation()
                UITabBar.appearance().backgroundColor = .clear
                UITabBar.appearance().backgroundImage = UIImage()
        }
    }
}

#Preview {
    ContentView().modelContainer(for: SavedLocation.self, inMemory: true)
}

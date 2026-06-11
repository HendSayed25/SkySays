//
//  SavedLocationsView.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import SwiftUI
import SwiftData

struct SavedLocationsView: View {
    @StateObject private var searchVM = SearchViewModel()
    @Query(sort: \SavedLocation.addedAt, order: .reverse) private var savedLocations: [SavedLocation]
    @Environment(\.modelContext) private var modelContext

    @State private var navigateToQuery: String?
    @State private var showWeather = false
    @FocusState private var searchFocused: Bool

    private let isMorning = TimeUtility.isMorning

    var body: some View {
        NavigationStack {
            ZStack {
                WeatherBackground(isMorning: isMorning)

                VStack(spacing: 0) {
                    searchBar
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                    if !searchVM.searchQuery.isEmpty {
                        suggestionsOverlay
                    } else {
                        savedLocationsList
                    }
                }
            }
            .navigationTitle("My Locations")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(isMorning ? .light : .dark, for: .navigationBar)
            .navigationDestination(isPresented: $showWeather) {
                if let query = navigateToQuery {
                    WeatherDetailView(locationQuery: query)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(isMorning ? .black.opacity(0.5) : .white.opacity(0.5))

            TextField("Search for a city...", text: $searchVM.searchQuery)
                .foregroundColor(isMorning ? .black : .white)
                .tint(isMorning ? .black : .white)
                .autocorrectionDisabled()
                .focused($searchFocused)
                .onChange(of: searchVM.searchQuery) {
                    Task { await searchVM.search() }
                }

            if !searchVM.searchQuery.isEmpty {
                Button(action: {
                    searchVM.clearSearch()
                    searchFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(isMorning ? .black.opacity(0.4) : .white.opacity(0.4))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(WeatherBackground.cardBackground(isMorning: isMorning))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(WeatherBackground.dividerColor(isMorning: isMorning), lineWidth: 1)
        )
    }

    // Suggestions while typing
    private var suggestionsOverlay: some View {
        Group {
            if searchVM.isSearching {
                VStack {
                    Spacer()
                    ProgressView()
                        .tint(isMorning ? .black : .white)
                    Spacer()
                }
            } else if searchVM.searchResults.isEmpty {
                VStack {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(searchVM.searchResults.enumerated()), id: \.element.id) { index, result in
                            Button(action: {
                                searchVM.saveLocation(
                                    result,
                                    modelContext: modelContext,
                                    savedLocations: savedLocations
                                )
                                navigateToQuery = "\(result.lat),\(result.lon)"
                                searchVM.clearSearch()
                                searchFocused = false
                                showWeather = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(isMorning ? .black.opacity(0.4) : .white.opacity(0.4))

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(result.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(WeatherBackground.foregroundColor(isMorning: isMorning))
                                        Text("\(result.region), \(result.country)")
                                            .font(.system(size: 13))
                                            .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                                    }

                                    Spacer()

                                    Image(systemName: "arrow.up.left")
                                        .font(.system(size: 12))
                                        .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                            }

                            if index < searchVM.searchResults.count - 1 {
                                Divider()
                                    .background(WeatherBackground.dividerColor(isMorning: isMorning))
                                    .padding(.leading, 52)
                            }
                        }
                    }
                    .background(WeatherBackground.cardBackground(isMorning: isMorning))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
            }
        }
    }

    private var savedLocationsList: some View {
        Group {
            if savedLocations.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "location.slash")
                        .font(.system(size: 52))
                        .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                    Text("No saved locations yet")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(WeatherBackground.foregroundColor(isMorning: isMorning))
                    Text("Search for a city above to get started")
                        .font(.system(size: 14))
                        .foregroundColor(WeatherBackground.secondaryColor(isMorning: isMorning))
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(savedLocations) { location in
                            SavedLocationCard(
                                location: location,
                                isMorning: isMorning,
                                onTap: {
                                    navigateToQuery = location.coordinateQuery
                                    showWeather = true
                                },
                                onDelete: {
                                    modelContext.delete(location)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

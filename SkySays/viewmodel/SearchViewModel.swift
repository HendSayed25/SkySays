//
//  SearchViewModel.swift
//  SkySays
//
//  Created by Hend Sayed on 09/06/2026.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var searchQuery: String = ""
    @Published private(set) var searchResults: [SearchResult] = []
    @Published private(set) var isSearching: Bool = false
    @Published private(set) var searchError: String?

    private let service: WeatherServiceProtocol
    private var searchTask: Task<Void, Never>?

    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }

    func search() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        searchTask?.cancel() //stop any old task before start new one
        isSearching = true
        searchError = nil

        searchTask = Task {
            // Apply Debounc behavior
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }

            do {
                let results = try await service.searchCity(query: searchQuery)
                if !Task.isCancelled {
                    self.searchResults = results
                }
            } catch {
                if !Task.isCancelled {
                    self.searchError = error.localizedDescription
                }
            }
            if !Task.isCancelled {
                self.isSearching = false
            }
        }
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = []
        searchError = nil
        searchTask?.cancel()
    }

    func saveLocation(_ result: SearchResult, modelContext: ModelContext, savedLocations: [SavedLocation]) {
        // Prevent duplicates
        let isDuplicate = savedLocations.contains {
            abs($0.lat - result.lat) < 0.001 && abs($0.lon - result.lon) < 0.001
        }
        guard !isDuplicate else { return }

        let location = SavedLocation(
            name: result.name,
            country: result.country,
            lat: result.lat,
            lon: result.lon
        )
        modelContext.insert(location)
    }

    func deleteLocation(_ location: SavedLocation, modelContext: ModelContext) {
        modelContext.delete(location)
    }
}

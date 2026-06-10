//
//  WeatherService.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchForecast(query: String) async throws -> ForecastResponse
    func searchCity(query: String) async throws -> [SearchResult]
}

struct SearchResult: Codable, Identifiable {
    var id: Int
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
}

final class WeatherService: WeatherServiceProtocol {
    private let apiKey : String = {
        Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String ?? ""
    }()
    private let baseURL = "https://api.weatherapi.com/v1"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchForecast(query: String) async throws -> ForecastResponse {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(encodedQuery)&days=3&aqi=no&alerts=no"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                if let errorBody = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    throw WeatherError.apiError(errorBody.error.message)
                }
                throw WeatherError.apiError("HTTP \(httpResponse.statusCode)")
            }

            let decoder = JSONDecoder()
            do {
                return try decoder.decode(ForecastResponse.self, from: data)
            } catch {
                throw WeatherError.decodingError(error)
            }
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkError(error)
        }
    }

    func searchCity(query: String) async throws -> [SearchResult] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/search.json?key=\(apiKey)&q=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }

        do {
            let (data, _) = try await session.data(from: url)
            let decoder = JSONDecoder()
            do {
                return try decoder.decode([SearchResult].self, from: data)
            } catch {
                throw WeatherError.decodingError(error)
            }
        } catch let error as WeatherError {
            throw error
        } catch {
            throw WeatherError.networkError(error)
        }
    }
}

// API error wrapper
private struct APIErrorResponse: Codable {
    let error: APIError
    struct APIError: Codable {
        let message: String
    }
}

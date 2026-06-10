//
//  WeatherError.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation

enum WeatherError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingError(let e): return "Decoding error: \(e.localizedDescription)"
        case .networkError(let e): return "Network error: \(e.localizedDescription)"
        case .apiError(let msg): return msg
        }
    }
}

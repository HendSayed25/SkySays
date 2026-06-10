//
//  SavedLocation.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation
import SwiftData

@Model
final class SavedLocation {
    var id: UUID
    var name: String
    var country: String
    var lat: Double
    var lon: Double
    var addedAt: Date

    init(name: String, country: String, lat: Double, lon: Double) {
        self.id = UUID()
        self.name = name
        self.country = country
        self.lat = lat
        self.lon = lon
        self.addedAt = Date()
    }

    var coordinateQuery: String {
        "\(lat),\(lon)"
    }
}

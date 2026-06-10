//
//  LocationInfo.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import Foundation

struct LocationInfo: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime: String
}

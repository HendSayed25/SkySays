//
//  SkySaysApp.swift
//  SkySays
//
//  Created by Hend Sayed on 07/06/2026.
//

import SwiftUI
import SwiftData

@main
struct SkySaysApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
        .modelContainer(for: SavedLocation.self)
    }
}

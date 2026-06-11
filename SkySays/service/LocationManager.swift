//
//  LocationManager.swift
//  SkySays
//
//  Created by Hend Sayed on 11/06/2026.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var query: String? = nil
    @Published var isReady: Bool = false
    @Published var authStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus

        switch manager.authorizationStatus {

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            query = nil
            isReady = false

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else { return }

        query = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        isReady = true
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        query = nil
        isReady = false
    }
}

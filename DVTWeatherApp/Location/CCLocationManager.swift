//
//  CCLocationManager.swift
//  DVTWeatherApp
//
//  Created by MOHD SALEEM on 12/11/25.
//

import Foundation
import CoreLocation
import Combine

final class CCLocationManager: NSObject, ObservableObject {
    @Published var m_lastLocation: CLLocation?
    private let m_manager = CLLocationManager()
    
    override init() {
        super.init()
        m_manager.delegate = self
        m_manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestLocation() {
        m_manager.requestWhenInUseAuthorization()
        m_manager.requestLocation()
    }
}

extension CCLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        m_lastLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

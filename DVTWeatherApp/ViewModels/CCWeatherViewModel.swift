//
//  CCWeatherViewModel.swift
//  DVTWeatherApp
//
//  Created by MOHD SALEEM on 12/11/25.
//

import Foundation
import Combine
import CoreLocation

final class CCWeatherViewModel: ObservableObject {
    @Published var m_forecast: [CCWeatherEntry] = []
    @Published var m_isLoading = false
    @Published var m_errorMessage: String?
    @Published var m_cityName: String?
    
    private var m_cancellables = Set<AnyCancellable>()
    private let m_service: CCWeatherService
    private let m_locationManager: CCLocationManager
    
    init(service: CCWeatherService = .shared, locationManager: CCLocationManager = CCLocationManager()) {
        self.m_service = service
        self.m_locationManager = locationManager
        bindLocation()
    }
    
    private func bindLocation() {
        m_locationManager.$m_lastLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.fetchForecast(for: location)
            }
            .store(in: &m_cancellables)
    }
    
    func requestLocation() {
        m_locationManager.requestLocation()
    }
    
    func fetchForecast(for location: CLLocation) {
        m_isLoading = true
        m_errorMessage = nil
        
        m_service.fetchForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            .sink(receiveCompletion: { [weak self] completion in
                self?.m_isLoading = false
                if case .failure(let error) = completion {
                    self?.m_errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                self?.m_forecast = self?.filterFiveDays(from: response.m_list) ?? []
                self?.m_cityName = response.m_city.m_name
            })
            .store(in: &m_cancellables)
    }
    
    private func filterFiveDays(from list: [CCWeatherEntry]) -> [CCWeatherEntry] {
        let grouped = Dictionary(grouping: list) { entry -> String in
            String(entry.m_dt_txt.prefix(10))
        }
        
        return grouped.keys.sorted().prefix(5).compactMap { key in
            grouped[key]?.min {
                abs(timeOfDay($0.m_dt_txt) - 12) < abs(timeOfDay($1.m_dt_txt) - 12)
            }
        }
    }
    
    private func timeOfDay(_ dateStr: String) -> Double {
        let components = dateStr.split(separator: " ")
        if components.count > 1 {
            let timeParts = components[1].split(separator: ":")
            if let hour = Double(timeParts[0]) {
                return hour
            }
        }
        return 0
    }
}

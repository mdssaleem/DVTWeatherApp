//
//  CCWeatherService.swift
//  DVTWeatherApp
//
//  Created by MOHD SALEEM on 12/11/25.
//

import Foundation
import Combine

final class CCWeatherService {
    static let shared = CCWeatherService()
    private init() {}
    
    private let m_baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let m_apiKey = "5619237ff816299e21013c9558af81e0"
    
    func fetchForecast(lat: Double, lon: Double) -> AnyPublisher<CCWeatherForecastResponse, Error> {
        guard var components = URLComponents(string: m_baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: m_apiKey)
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: CCWeatherForecastResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

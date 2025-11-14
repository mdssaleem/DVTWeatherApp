//
//  CCWeatherModels.swift
//  DVTWeatherApp
//
//  Created by MOHD SALEEM on 12/11/25.
//

import Foundation

// MARK: - Root Response
struct CCWeatherForecastResponse: Codable {
    let m_cod: String
    let m_message: Int
    let m_cnt: Int
    let m_list: [CCWeatherEntry]
    let m_city: CCCity

    enum CodingKeys: String, CodingKey {
        case m_cod = "cod"
        case m_message = "message"
        case m_cnt = "cnt"
        case m_list = "list"
        case m_city = "city"
    }
}

// MARK: - Forecast List Entry
struct CCWeatherEntry: Codable, Identifiable {
    var id: Int { m_dt } // For SwiftUI’s ForEach
    let m_dt: Int
    let m_main: CCMain
    let m_weather: [CCWeather]
    let m_clouds: CCClouds
    let m_wind: CCWind
    let m_visibility: Int
    let m_pop: Double
    let m_sys: CCSys
    let m_dt_txt: String

    enum CodingKeys: String, CodingKey {
        case m_dt = "dt"
        case m_main = "main"
        case m_weather = "weather"
        case m_clouds = "clouds"
        case m_wind = "wind"
        case m_visibility = "visibility"
        case m_pop = "pop"
        case m_sys = "sys"
        case m_dt_txt = "dt_txt"
    }
}

// MARK: - Nested Models
struct CCMain: Codable {
    let m_temp: Double
    let m_feels_like: Double
    let m_temp_min: Double
    let m_temp_max: Double
    let m_pressure: Int
    let m_sea_level: Int?
    let m_grnd_level: Int?
    let m_humidity: Int
    let m_temp_kf: Double?

    enum CodingKeys: String, CodingKey {
        case m_temp = "temp"
        case m_feels_like = "feels_like"
        case m_temp_min = "temp_min"
        case m_temp_max = "temp_max"
        case m_pressure = "pressure"
        case m_sea_level = "sea_level"
        case m_grnd_level = "grnd_level"
        case m_humidity = "humidity"
        case m_temp_kf = "temp_kf"
    }
}

struct CCWeather: Codable {
    let m_id: Int
    let m_main: String
    let m_description: String
    let m_icon: String

    enum CodingKeys: String, CodingKey {
        case m_id = "id"
        case m_main = "main"
        case m_description = "description"
        case m_icon = "icon"
    }
}

struct CCClouds: Codable {
    let m_all: Int

    enum CodingKeys: String, CodingKey {
        case m_all = "all"
    }
}

struct CCWind: Codable {
    let m_speed: Double
    let m_deg: Int
    let m_gust: Double?

    enum CodingKeys: String, CodingKey {
        case m_speed = "speed"
        case m_deg = "deg"
        case m_gust = "gust"
    }
}

struct CCSys: Codable {
    let m_pod: String

    enum CodingKeys: String, CodingKey {
        case m_pod = "pod"
    }
}

// MARK: - City Info
struct CCCity: Codable {
    let m_id: Int
    let m_name: String
    let m_coord: CCCoordinates
    let m_country: String
    let m_population: Int?
    let m_timezone: Int
    let m_sunrise: Int
    let m_sunset: Int

    enum CodingKeys: String, CodingKey {
        case m_id = "id"
        case m_name = "name"
        case m_coord = "coord"
        case m_country = "country"
        case m_population = "population"
        case m_timezone = "timezone"
        case m_sunrise = "sunrise"
        case m_sunset = "sunset"
    }
}

struct CCCoordinates: Codable {
    let m_lat: Double
    let m_lon: Double

    enum CodingKeys: String, CodingKey {
        case m_lat = "lat"
        case m_lon = "lon"
    }
}

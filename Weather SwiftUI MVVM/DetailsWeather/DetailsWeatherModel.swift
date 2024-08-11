//
//  DetailsWeatherModel.swift
//  Weather SwiftUI MVVM
//
//  Created by Md Khorshed Alam on 10/8/24.
//

import Foundation

// MARK: - DetailsWeatherModel
struct DetailsWeatherModel: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: CityD
}

// MARK: - City
struct CityD: Codable {
    let id: Int
    let name: String
    let coord: CoordD
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct CoordD: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: MainClass
    let weather: [WeatherD]
    let clouds: CloudsD
    let wind: WindD
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct CloudsD: Codable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
struct SysD: Codable {
    let pod: PodD
}

enum PodD: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct WeatherD: Codable {
    let id: Int
    let main: String      // I chnaged here
    let description: String   // Chnaged here
    let icon: String
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct WindD: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

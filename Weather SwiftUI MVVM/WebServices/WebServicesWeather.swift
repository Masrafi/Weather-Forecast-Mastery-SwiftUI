//
//  WebServices.swift
//  MVVM Product API
//
//  Created by Md Khorshed Alam on 7/8/24.
//

import Foundation

final class WebServiceWeather {
    
    static func getWeatherData(lat: String, lon: String) async throws -> WeatherModel {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=700c6acf3c04e16f7b91e0a1e414783e"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        print(response.statusCode);
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherModel.self, from: data)
        } catch {
            throw WeatherError.invalidData
        }
    }
}

//final class WebService {
//    
//    static func getWeatherData() async throws -> WeatherModel {
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=37.785834&lon=-122.406417&appid=700c6acf3c04e16f7b91e0a1e414783e"
//        guard let url = URL(string: urlString) else {
//            throw WeatherError.invalidURL
//        }
//        
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard let response = response as? HTTPURLResponse,
//                response.statusCode == 200 else {
//            throw WeatherError.invalidResponse
//        }
//        print(response.statusCode);
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode(WeatherModel.self, from: data)
//        } catch {
//            throw WeatherError.invalidData
//        }
//    }
//}

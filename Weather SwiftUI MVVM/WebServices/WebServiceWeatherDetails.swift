//
//  WebServiceWeatherDetails.swift
//  Weather SwiftUI MVVM
//
//  Created by Md Khorshed Alam on 10/8/24.
//

import Foundation


final class WebServiceWeatherDetails {
    
    static func getWeatherDetailsData(lat: String, lon: String) async throws -> DetailsWeatherModel {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=700c6acf3c04e16f7b91e0a1e414783e"
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
            return try decoder.decode(DetailsWeatherModel.self, from: data)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type \(type) in context \(context)")
                case .valueNotFound(let type, let context):
                    print("Value not found for type \(type) in context \(context)")
                case .keyNotFound(let key, let context):
                    print("Key not found: \(key) in context \(context)")
                case .dataCorrupted(let context):
                    print("Data corrupted in context \(context)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
           throw WeatherError.invalidData
        }
    }
}


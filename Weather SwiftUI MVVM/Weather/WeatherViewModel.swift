//
//  WeatherViewModel.swift
//  Weather SwiftUI MVVM
//
//  Created by Masrafi Anam on 9/8/24.
//

import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published var weather: WeatherModel?
    @Published var weatherError: WeatherError?
    @Published var shouldShowAlert = false
    @Published var isLoading = false
    
    func getWeather(lat: String, lon: String) async {
        self.isLoading = true
        do {
            self.weather = try await WebServiceWeather.getWeatherData(lat: lat, lon: lon)
            print("jsjfh ....")
            self.isLoading = false
        } catch(let error) {
            weatherError = WeatherError.custom(error: error)
            shouldShowAlert = true
            isLoading = false
        }
    }
}

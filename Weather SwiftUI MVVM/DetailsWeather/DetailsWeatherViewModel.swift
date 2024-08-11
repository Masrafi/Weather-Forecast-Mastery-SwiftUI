//
//  DetailsWeatherViewModel.swift
//  Weather SwiftUI MVVM
//
//  Created by Md Khorshed Alam on 10/8/24.
//

import Foundation

@MainActor
final class DetailsWeatherViewModel: ObservableObject {
    
    @Published var weatherDetails: DetailsWeatherModel?
    @Published var weatherError: WeatherError?
    @Published var shouldShowAlert = false
    @Published var isLoading = false
    
    func getWeather() async {
        isLoading = true
        do {
            self.weatherDetails = try await WebServiceWeatherDetails.getWeatherDetailsData()
            self.isLoading = false
        } catch(let error) {
            print(error.self)
            weatherError = WeatherError.custom(error: error)
            shouldShowAlert = true
            isLoading = false
        }
    }
}

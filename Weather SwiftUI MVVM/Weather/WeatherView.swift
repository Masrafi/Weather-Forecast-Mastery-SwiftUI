//
//  ContentView.swift
//  Weather SwiftUI MVVM
//
//  Created by Masrafi Anam on 9/8/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @ObservedObject var viewModelDetails = DetailsWeatherViewModel()
    var body: some View {
        ZStack{
                Image("bg3").resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            ScrollView{

                VStack {
                    Image("weather").resizable().foregroundColor(.white).frame(width: 100, height: 100)
                    let tempCelsius = (viewModel.weather?.main?.temp ?? 0) - 273.15
                    Text("Temperature: \(String(format: "%.1f", tempCelsius))°C")
                        .font(.system(size: 14)).fontWeight(.bold).foregroundColor(.white)
                    
                    Text(viewModel.weather?.name ?? "Name").font(.system(size: 40)).fontWeight(.bold).foregroundColor(.red)
                    
                    
                    VStack{
                        ForEach(viewModelDetails.weatherDetails?.list ?? [], id: \.dt) { user in
                            ForecastRow(user: user)
                        }
                    }.padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1) // Optional: Add a subtle border
                        )
                
                    if viewModel.isLoading {
                        LoaderView()
                    }
                }.padding(.top, 50).onAppear{
                    Task{
                        await viewModel.getWeather()
                        await viewModelDetails.getWeather()
                    }
                }.alert(isPresented: $viewModel.shouldShowAlert) {
                    return Alert(
                        title: Text("Error"),
                        message: Text(viewModel.weatherError?.errorDescription ?? "")
                    )
                }.alert(isPresented: $viewModelDetails.shouldShowAlert) {
                    return Alert(
                        title: Text("Error"),
                        message: Text(viewModelDetails.weatherError?.errorDescription ?? "")
                    )
                }
                
            }
        }
    }
}

//#Preview {
//    WeatherView()
//}


func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // The format of the date in `dt_txt`

    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, h:mm a" // Format for day name and time
        return outputFormatter.string(from: date)
    } else {
        return "Invalid Date"
    }
}


struct ForecastRow: View {
    let user: List // Replace 'ListItem' with your actual type

    var body: some View {
        HStack {
            Text(formatDate(user.dtTxt))
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()

            let tempCelsius2 = user.main.temp - 273.15
            Text("\(String(format: "%.1f", tempCelsius2))°C")
                .font(.system(size: 16)).fontWeight(.bold)
                .foregroundColor(.red)
            Spacer()
            let weatherDescription = user.weather.first?.main
            Text(weatherDescription!)
                .font(.system(size: 16)).fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.top, 15)
    }
}

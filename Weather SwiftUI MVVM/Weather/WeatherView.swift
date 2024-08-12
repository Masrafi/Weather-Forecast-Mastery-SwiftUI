//
//  ContentView.swift
//  Weather SwiftUI MVVM
//
//  Created by Masrafi Anam on 9/8/24.
//

import SwiftUI
import CoreLocation


struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    @ObservedObject var viewModelDetails = DetailsWeatherViewModel()
    @State private var showTextField = false
    @State private var placeName: String = ""
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack{
            Image("bg3").resizable().foregroundColor(.white)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .edgesIgnoringSafeArea(.all)
            ScrollView{

                VStack {
                    HStack{
                        Spacer()
                        Button(action: {
                            showTextField = true
                        }) {
                            Image(systemName: "magnifyingglass").resizable().frame(width: 30, height: 30).foregroundColor(.red)
//                                .sheet(isPresented: $showButtomSheet){
//                                ShowBottomSheet().presentationDetents([.height(300)])
//                            }
                        }
                    }.padding()
                    if(showTextField){
                        TextField("Enter place name", text: $placeName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("Get Coordinates") {
                            print("click")
                            locationManager.convertAddressToCoordinates(address: placeName) { success in
                                if success, let lat = locationManager.latitude, let lon = locationManager.longitude {
                                    print(lat)
                                    print(lon)
                                    Task {
                                        showTextField = false
                                        await viewModel.getWeather(lat: String(lat), lon: String(lon))
                                        await viewModelDetails.getWeather(lat: String(lat), lon: String(lon))
                                    }
                                } else {
                                    print(locationManager.errorMessage ?? "Unknown error")
                                }
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
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
                        await viewModel.getWeather(lat: "37.785834", lon: "-122.406417")
                        await viewModelDetails.getWeather(lat: "37.785834", lon: "-122.406417")
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


class LocationManager: ObservableObject {
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var errorMessage: String?

    private var geocoder = CLGeocoder()

    func convertAddressToCoordinates(address: String, completion: @escaping (Bool) -> Void) {
        print("jsdflksjdflkjdf")
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            if let error = error {
                self?.errorMessage = "Error: \(error.localizedDescription)"
                print(error)
                completion(false)
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                self?.errorMessage = "Location not found"
                completion(false)
                return
            }
            
            self?.latitude = location.coordinate.latitude
            self?.longitude = location.coordinate.longitude
//            print(location.coordinate.latitude)
//            print(location.coordinate.longitude)
            completion(true)
        }
    }
}

//struct ShowBottomSheet:View {
//    @ObservedObject var viewModel = WeatherViewModel()
//    @State private var placeName: String = ""
//    @StateObject private var locationManager = LocationManager()
//    var body: some View {
//        VStack{
//            TextField("Enter place name", text: $placeName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("Get Coordinates") {
//                print("click")
//                            locationManager.convertAddressToCoordinates(address: placeName) { success in
//                                if success, let lat = locationManager.latitude, let lon = locationManager.longitude {
//                                    print(lat)
//                                    print(lon)
//                                    Task {
//                                        await viewModel.getWeather(lat: String(lat), lon: String(lon))
//                                    }
//                                } else {
//                                    print(locationManager.errorMessage ?? "Unknown error")
//                                }
//                            }
//                        }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//        }
//    }
//}

//
//  ContentView.swift
//  08_08_23_WeatherChallenge
//
//  Created by Jaden Nation on 8/8/23.
//

/**
 Build a weather app that shows the current weather and 5-day forecast for a selected city using OpenWeatherMap's API. The app should have the following features:
 
 A search field to enter a city name and fetch weather data for that city
 A view to display the current weather conditions including temperature, weather icon, description etc.
 A horizontal scrollable view to show the 5-day forecast, with each day displaying the weather icon, high/low temps, description etc.
 Use Combine to fetch the weather data asynchronously and update the UI. Define publishers, subscribers and operators to process the network request and handle errors.
 Use SwiftUI for the app's UI with views, view models and bindings to reactively update the UI when the view model changes.
 Make the UI adaptable and responsive for all device sizes using layout, frames and stacks.
 Persist the last searched city and show it first on launch.
 */


import SwiftUI
import Combine

enum CommandButtonIcon: String {
    case sparkles, cloud, hurricane, sunrise
    case moon_stars_circle_fill = "moon.stars.circle.fill"
    case cloud_drizzle_fill = "cloud.drizzle.fill"
    static var allCases: [CommandButtonIcon] {
        [.sparkles, .cloud, .hurricane, .sunrise, .moon_stars_circle_fill, .cloud]
    }
}

struct CommandBar: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 32) {
                ForEach(CommandButtonIcon.allCases, id: \.rawValue) { icon in
                    Image(systemName: icon.rawValue)
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color.white)
                        .clipShape(Circle())
                }
            }
        }
    }
}

struct StackText: View {
    @State var bigText: String = "00"
    @State var smallText: String = "abde"
    @State var showEllipsis: Bool = true
    var body: some View {
        VStack(alignment: .center) {
            if showEllipsis {
                Text("...")
                    .frame(width: 32, height: 16)
                    .foregroundColor(Color.lightOrange)
            }
            Text(bigText)
                .font(.system(size: 28, weight: .heavy, design: .serif))
                .foregroundColor(Color.white)
            Text(smallText)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(Color.white.opacity(0.8))
            
        }
    }
}

struct CurrentTemperatureView: View {
    @State var weatherMoment: WeatherMoment?
    @Binding var usesFahrenheit: Bool
    private var temperatureText: String {
        guard let weatherMoment = weatherMoment else {
            return "-/-"
        }
        let temp = Int(usesFahrenheit ? weatherMoment.current.tempF : weatherMoment.current.tempC)
        return "\(String(temp))°\(usesFahrenheit ? "F" : "C")"
    }
    
    func calculateFontSize(text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: CGFloat(72))
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height * font.pointSize / boundingBox.size.height
    }
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .center) {
                ContainerRelativeShape()
                    .foregroundColor(Color.darkBlue)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    .cornerRadius(geo.size.height / 2)
                    .overlay {
                        Text(temperatureText)
                            .font(.system(size: 40, weight: .heavy, design: .monospaced))
                            .foregroundColor(Color.white)
                    }
            }
            .onTapGesture {
                usesFahrenheit.toggle()
            }
        }
    }
}

struct SaddleCommandBar: View {
    @Binding var weatherMoment: WeatherMoment?
    @Binding var usesFahrenheit: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .center) {
                Color.darkBlue
                if let weatherMoment = weatherMoment {
                    HStack {
                        StackText(bigText: "\(Int(usesFahrenheit ? weatherMoment.current.feelslikeF : weatherMoment.current.feelslikeC))", smallText: "Feels Like")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "\(weatherMoment.current.windDir)", smallText: "Wind Direction")
                            .frame(width: geo.size.width / 3)
                        StackText(bigText: "02", smallText: "AQI")
                            .frame(width: geo.size.width / 3)
                    }
                }
            }
            Spacer()
                .frame(height: 14)
        }
    }
}

class WeatherViewViewModel: ObservableObject {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var weatherMoment: WeatherMoment?
    private let API_KEY = "35c81d7ef4a94893993170611230808"
    private var currentWeatherURL: URL {
        URL(string: "https://api.weatherapi.com/v1/current.json?key=\(API_KEY)&q=\(zipCode)&aqi=yes")!
    }
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getCurrentWeather() {
        let url = currentWeatherURL
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherMoment.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("retrieved data successfully")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] weatherMoment in
                self?.weatherMoment = weatherMoment
            }
            .store(in: &cancellables)
    }
    
    init(usesFahrenheit: Bool = true, weatherMoment: WeatherMoment? = nil) {
        self.usesFahrenheit = usesFahrenheit
        self.weatherMoment = weatherMoment
        
        $zipCode.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] debouncedZipCode in
            
                guard debouncedZipCode.count == 5 else {
                    self?.weatherMoment = nil
                    return
                }
                self?.getCurrentWeather()
            }
            .store(in: &self.cancellables)
    }
}




struct WeatherView: View {
    @StateObject var viewModel: WeatherViewViewModel = WeatherViewViewModel()
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                Image.forest_dark
                    .resizable()
                    
                
                VStack(alignment: .center, spacing: 12) {
                    Spacer()
                        .frame(height: 30)
                    CommandBar()
                        .frame(height: 30)
                        .padding()
                    if viewModel.weatherMoment != nil {
                        HStack {
                            CurrentTemperatureView(weatherMoment: viewModel.weatherMoment, usesFahrenheit: $viewModel.usesFahrenheit)
                                .frame(width: 150, height: 150)
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    TextField("Enter zip code", text: $viewModel.zipCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .frame(width: geo.size.width * 0.9, height: 16)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        
                    if viewModel.weatherMoment != nil {
                        SaddleCommandBar(weatherMoment: $viewModel.weatherMoment, usesFahrenheit: $viewModel.usesFahrenheit)
                            .frame(width: geo.size.width, height: 100)
                    } else {
                        Spacer()
                            .frame(height: 24)
                    }
                                        
                }
                
                
            }
            .ignoresSafeArea()
        }
        
        
    }
}

#Preview {
    WeatherView()
}



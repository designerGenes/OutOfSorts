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
    @State var temperatureValue: Int = 13
    @State var usesFahrenheit: Bool = true
    private var temperatureText: String {
        "\(String(temperatureValue))°\(usesFahrenheit ? "F" : "C")"
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
        }
    }
}

struct SaddleCommandBar: View {
    var body: some View {
        
        ZStack(alignment: .center) {
            Color.darkBlue
            HStack(spacing: 60) {
                StackText(bigText: "44", smallText: "abcde")
                StackText(bigText: "19", smallText: "fghij")
                StackText(bigText: "02", smallText: "jklmno")
            }
//            .offset(y: 8)
        }
        
        
    }
}

struct ContentView: View {
    @State var searchZipCode: String = ""
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack {
                Image.forest_dark
                    .resizable()
                    .scaledToFill()
                
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                        .frame(height: 30)
                    CommandBar()
                        .frame(height: 30)
                        .padding()
                    CurrentTemperatureView()
                        .frame(width: 150, height: 150)
                    Spacer()
                    TextField("Enter zip code", text: $searchZipCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .frame(width: geo.size.width * 0.65, height: 16)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    SaddleCommandBar()
                        .frame(width: geo.size.width, height: 100)
                                        
                }
                
                
            }
            .ignoresSafeArea()
        }
        
        
    }
}

#Preview {
    ContentView()
}



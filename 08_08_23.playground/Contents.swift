//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import SwiftUI
import Combine

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

struct WeatherView: View {
    var body: some View {
        VStack {
            
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(WeatherView())

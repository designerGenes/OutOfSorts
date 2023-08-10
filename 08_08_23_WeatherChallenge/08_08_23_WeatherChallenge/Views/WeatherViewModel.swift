//
//  WeatherViewModel.swift
//  08_08_23_WeatherChallenge
//
//  Created by Jaden Nation on 8/10/23.
//

import Foundation
import SwiftUI
import Combine

class WeatherViewViewModel: ObservableObject {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var weatherMoment: WeatherMoment?
    private let API_KEY = "35c81d7ef4a94893993170611230808"
    private var currentWeatherURL: URL {
        URL(string: "https://api.weatherapi.com/v1/current.json?key=\(API_KEY)&q=\(zipCode)&aqi=yes")!
    }
    private var aiWeatherAdviceURL: URL {
        URL(string: "https://api.openai.com/")! // TMP!
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getAIAdviceForWeather(weather: WeatherMoment) async throws -> WeatherAdvice {
        let url = aiWeatherAdviceURL
        print("making advice request at: \(url.absoluteString)")
        var request = URLRequest(url: url)
        // should be POST request
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(WeatherAdvice.self, from: data)
    }
    
    func getCurrentWeather() async throws -> WeatherMoment {
        let url = currentWeatherURL
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherMoment.self, from: data)
    }
    
    init(usesFahrenheit: Bool = true, weatherMoment: WeatherMoment? = nil) {
        self.usesFahrenheit = usesFahrenheit
        self.weatherMoment = weatherMoment
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] debouncedZipCode -> AnyPublisher<WeatherAdvice?, Never> in
                guard debouncedZipCode.count == 5, let self = self else {
                    self?.weatherMoment = nil
                    return Just(nil).eraseToAnyPublisher()
                }
                return Future { promise in
                    Task {
                        do {
                            let weather = try await self.getCurrentWeather()
                            let advice = try await self.getAIAdviceForWeather(weather: weather)
                            promise(.success(advice))
                        } catch {
                            print("error: \(error.localizedDescription)")
                            promise(.success(nil))
                        }
                    }
                }.eraseToAnyPublisher()
            }
            .sink { [weak self] advice in
                DispatchQueue.main.async {
                    // update views here with advice
                }
            }
            .store(in: &self.cancellables)

    }
}

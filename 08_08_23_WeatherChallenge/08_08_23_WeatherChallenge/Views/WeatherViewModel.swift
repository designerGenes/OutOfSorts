//
//  WeatherViewModel.swift
//  08_08_23_WeatherChallenge
//
//  Created by Jaden Nation on 8/10/23.
//

import Foundation
import SwiftUI
import Combine

typealias FullWeatherResponse = (advice: WeatherAdvice?, moment: WeatherMoment?)

enum OpenAIParameter: String {
    case prompt
    case model
    case maxTokens = "max_tokens"
    case messages
    case temperature
    static func weatherAdvicePrompt(weather: WeatherMoment) -> String {
        return "It's \(weather.current.tempF) degrees and \(weather.current.condition.text.lowercased()). What should I wear?"
    }
    
    enum MessagesParameter: String {
        case role, content
    }
    
    enum OpenAIModel: String {
        case gpt4 = "gpt-4"
        case gpt4_0613 = "gpt-4-0613"
        case gpt3_5_turbo = "gpt-3.5-turbo"
    }
}

class WeatherViewViewModel: ObservableObject {
    @Published var usesFahrenheit: Bool = true
    @Published var zipCode: String = ""
    @Published var weatherMoment: WeatherMoment?
    @Published var weatherAdvice: WeatherAdvice?
    private let API_KEY = "35c81d7ef4a94893993170611230808"
    
    private var currentWeatherURL: URL {
        URL(string: "https://api.weatherapi.com/v1/current.json?key=\(API_KEY)&q=\(zipCode)&aqi=yes")!
    }
    private func aiWeatherAdviceURL(weatherMoment: WeatherMoment) -> URL {
        let urlBase = "http://weatheradviceendpoint-env.eba-a4cqsq7q.us-west-2.elasticbeanstalk.com/weather"
        var urlComponents = URLComponents(string: urlBase)
        urlComponents?.queryItems = [
            URLQueryItem(name: "zipCode", value: self.zipCode),
            URLQueryItem(name: "weatherTemp", value: String(describing: weatherMoment.current.tempF)),
            URLQueryItem(name: "weatherCondition", value: weatherMoment.current.condition.text.lowercased()),
        ]

        return urlComponents!.url!
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getWeatherAdviceFromAWS(weatherMoment: WeatherMoment) async throws -> WeatherAdvice {
        
        let url = aiWeatherAdviceURL(weatherMoment: weatherMoment)
        print("making AI advice request at: \(url.absoluteString)")
        let (data, _) = try await URLSession.shared.data(from: url)
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        let responseString = openAIResponse.choices.first?.message.content
        return WeatherAdvice(advice: responseString ?? "No advice, sorry")
    }
    
    func getCurrentWeather() async throws -> WeatherMoment {
        let url = currentWeatherURL
        print("making weather request at: \(url.absoluteString)")
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(WeatherMoment.self, from: data)
    }
    
    init(usesFahrenheit: Bool = true, weatherMoment: WeatherMoment? = nil) {
        self.usesFahrenheit = usesFahrenheit
        self.weatherMoment = weatherMoment
        
        $zipCode
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] debouncedZipCode -> AnyPublisher<FullWeatherResponse?, Never> in
                guard debouncedZipCode.count == 5, let self = self else {
                    self?.weatherMoment = nil
                    return Just(nil).eraseToAnyPublisher()
                }
                return Future { promise in
                    Task {
                        do {
                            let weather = try await self.getCurrentWeather()
                            print("got weather with temp of \(weather.current.tempF)° Fahrenheit")
                            let adviceResponse = try await self.getWeatherAdviceFromAWS(weatherMoment: weather)
                            print("got advice of: \(adviceResponse.advice)")
                            promise(.success((advice: adviceResponse, moment: weather)))
                        } catch {
                            print("error: \(error.localizedDescription)")
                            promise(.success(nil))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] fullResponse in
                DispatchQueue.main.async {
                    self?.weatherMoment = fullResponse?.moment
                    self?.weatherAdvice = fullResponse?.advice
                }
            }
            .store(in: &self.cancellables)

    }
}

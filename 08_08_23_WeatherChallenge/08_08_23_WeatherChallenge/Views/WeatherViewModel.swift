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
    private var OPENAI_API_KEY: String? {
        guard let fileURL = Bundle.main.url(forResource: "secrets", withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let openAIKey = jsonObject["openAI_api_key"] as? String {
                return openAIKey
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private var currentWeatherURL: URL {
        URL(string: "https://api.weatherapi.com/v1/current.json?key=\(API_KEY)&q=\(zipCode)&aqi=yes")!
    }
    private var aiWeatherAdviceURL: URL {
        URL(string: "https://api.openai.com/v1/chat/completions")!
    }
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    func getAIAdviceForWeather(weather: WeatherMoment) async throws -> WeatherAdvice {
        guard let openAIKey = OPENAI_API_KEY else {
            throw NSError(domain: "No openAI key", code: 0, userInfo: nil)
        }
        let url = aiWeatherAdviceURL
        let parameters: [OpenAIParameter: Any] = [
            .maxTokens: 100,
            .temperature: 0.7,
            .model: OpenAIParameter.OpenAIModel.gpt3_5_turbo.rawValue,
            .messages: [
                [
                    OpenAIParameter.MessagesParameter.role.rawValue: "user",
                    OpenAIParameter.MessagesParameter.content.rawValue: OpenAIParameter.weatherAdvicePrompt(weather: weather)
                ]
            ]
        ]
        let parametersWithStrings = Dictionary(uniqueKeysWithValues: parameters.map { ($0.key.rawValue, $0.value) })
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let postData = try JSONSerialization.data(withJSONObject: parametersWithStrings, options: [])
        request.httpBody = postData
        print("making advice request at: \(url.absoluteString)")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        let responseString = openAIResponse.choices.first?.message.content
        return WeatherAdvice(advice: responseString ?? "No advice, sorry")
    }
    
    func getCurrentWeather() async throws -> WeatherMoment {
        let url = currentWeatherURL
        print("making advice request at: \(url.absoluteString)")
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
                            let advice = try await self.getAIAdviceForWeather(weather: weather)
                            print("got advice of: \(advice.advice)")
                            promise(.success((advice: advice, moment: weather)))
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

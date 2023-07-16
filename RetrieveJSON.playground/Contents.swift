import UIKit
import Combine

struct PokemonResponse: Codable {
    var data: [Pokemon]
}

struct Pokemon: Codable, Identifiable {
    var id: String
    var name: String
    var flavorText: String?
}


class DownloadSessionManager {
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        print("Downloading pokemon...")
        downloadJSON()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished download")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                let pokemon = response.data
                pokemon.forEach { pokemon in
                    print("\(pokemon.id): \(pokemon.name)\n\t\(pokemon.flavorText ?? "No flavor text")")
                }
            })
            .store(in: &cancellables)
    }
    
    func downloadJSON() -> AnyPublisher<PokemonResponse, Error> {
        guard let url = URL(string: "https://api.pokemontcg.io/v2/cards") else {
            fatalError("bad url!")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

let sessionManager = DownloadSessionManager()

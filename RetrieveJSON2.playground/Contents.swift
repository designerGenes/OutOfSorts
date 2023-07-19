//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import SwiftUI
import Combine

typealias Codidentifiable = Codable & Identifiable
struct Pokemon: Codidentifiable {
    var id: String
    var name: String
    var flavorText: String?
}

struct PokemonResponse: Codable {
    var data: [Pokemon]
}

class DisplayListViewViewModel: ObservableObject {
    private let url = URL(string: "https://api.pokemontcg.io/v2/cards")!
    private var cancellables: [AnyCancellable] = []
    @Published var pokemon: [Pokemon] = []
    
    func downloadPokemon() {
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map(\.data)
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error downloading pokemon: \(error.localizedDescription)")
                case .finished:
                    print("Finished downloading pokemon!")
                }
            } receiveValue: { pokemonResponse in
                print("Received pokemon response with \(pokemonResponse.data.count) pokemon")
                self.pokemon = pokemonResponse.data
            }
            .store(in: &self.cancellables)

    }
}


struct DisplayListView: View {
    @ObservedObject var viewModel = DisplayListViewViewModel()

    var body: some View {
        Form {
            Section("Pokemon") {
                VStack {
                    HStack(spacing: 16) {
                        Text("Pokemon")
                        
                        Button("Refresh") {
                        }
                        Spacer()
                    }
                    Divider()
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.pokemon, id: \.id) { pokemon in
                                VStack(spacing: 4) {
                                    HStack {
                                        Text(pokemon.name)
                                        Spacer()
                                        Text(pokemon.id)
                                        
                                    }
                                    HStack {
                                        Text(pokemon.flavorText ?? "no Flavor Text")
                                        Spacer()
                                    }
                                }
                                // rounded border with light gray shadow to bottom right
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                        .shadow(color: Color.gray.opacity(0.2), radius: 2, x: 2, y: 2)
                                )
                                
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.downloadPokemon()
        }
    }
    
    
}


// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(DisplayListView())

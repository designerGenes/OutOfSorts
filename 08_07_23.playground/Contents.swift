import UIKit
import SwiftUI
import Combine
import PlaygroundSupport

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class DemonstrationViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    private var cancellables = Set<AnyCancellable>()
    
    func fetchJSON() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .sink { posts in
                self.posts = posts
            }
            .store(in: &cancellables)
    }
}

struct DemonstrationCell: View {
    var title: String
    var bodyText: String
    @Binding var fontWeight: Font.Weight  // Modified to use @Binding
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
            }
            HStack {
                Text(bodyText)
                    .font(.body)
                    .fontWeight(fontWeight)
                Spacer()
            }
        }
        .padding()
    }
}

struct ControlBarView: View {
    @Binding var fontWeight: Font.Weight
    
    var body: some View {
        HStack {
            Button(action: {
                print("Bold")
                fontWeight = .bold
            }, label: {
                Text("Bold")
                    .fontWeight(self.fontWeight == .bold ? .bold : .regular)
            })
            .frame(minWidth: 0, maxWidth: .infinity)
            .buttonStyle(BorderlessButtonStyle())
            Button(action: {
                print("Regular")
                fontWeight = .regular
            }, label: {
                Text("Regular")
                    .fontWeight(self.fontWeight == .regular ? .bold : .regular)
            })
            .buttonStyle(BorderlessButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity)
            Button(action: {
                print("Light")
                fontWeight = .light
            }, label: {
                Text("Light")
                    .fontWeight(self.fontWeight == .light ? .bold : .regular)
            })
            .buttonStyle(BorderlessButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

struct DemonstrationView: View {
    @ObservedObject private var viewModel = DemonstrationViewModel()
    @State private var fontWeight: Font.Weight = .regular
    var fontWeightTitle: String {
        switch fontWeight {
        case .light: return "Light"
        case .bold: return "Bold"
        default: return "Regular"
        }
    }
    
    var body: some View {
        VStack {
            
            Form {
                Section("Posts") {
                    ControlBarView(fontWeight: $fontWeight)
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.posts, id: \.id) { post in
                                DemonstrationCell(title: post.title, bodyText: post.body, fontWeight: $fontWeight)  // Passing the binding
                                    .padding()
                                    .id(post.id + fontWeight.hashValue)
                            }
                        }
                    }
                }
            }
        }
        .task {
            self.viewModel.fetchJSON()
        }
    }
}

PlaygroundPage.current.setLiveView(DemonstrationView())






import UIKit
import SwiftUI
import Combine
import PlaygroundSupport

let queue = DispatchQueue.global(qos: .background)

//DispatchQueue.concurrentPerform(iterations: 100) { iteration in
//    print("Iteration \(iteration)")
//}

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else {
                return
            }
            let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else {
                return
            }
            let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)
            self.image = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image2 = viewModel.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            Task(priority: .high) {
                await viewModel.fetchImage()
                await viewModel.fetchImage2()
            }
            
            
        }
    }
}

PlaygroundPage.current.setLiveView(TaskBootcamp())


import UIKit
import SwiftUI
import Combine

class PublicationManager {
    var cancellables: Set<AnyCancellable>
    deinit {
        print("deinitializing the PublicationManager")
    }
    
    init(cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.cancellables = cancellables
        print("initialized PublicationManager")
    }
    
    func publishPromise() -> Future<String, Never> {
        let myFuture = Future<String, Never> { promise in
            let result = Int.random(in: 0..<10) < 5 ?  "You have good luck!" : "Your luck isn't that good, sorry"
            promise(.success(result))
        }
        return myFuture
    }
    
    
    func publishValues() -> PassthroughSubject<Int, Never> {
        let publisher = PassthroughSubject<Int, Never>()
        var counter = 0
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { _ in
                publisher.send(counter)
                counter += 1
            }
            .store(in: &cancellables)
        return publisher
    }
}

class SomeSubscriber {
    var subscriptions: Set<AnyCancellable>
    var publicationManager: PublicationManager
    
    deinit {
        print("deinitializing the SomeSubscriber")
    }
    
    init(subscriptions: Set<AnyCancellable> = Set<AnyCancellable>(), publicationManager: PublicationManager = PublicationManager()) {
        print("initialized SomeSubscriber")
        self.subscriptions = subscriptions
        self.publicationManager = publicationManager
        publicationManager.publishValues()
            .sink { completion in
                switch completion {
                case .failure:
                    print("critical failure!")
                    break
                case .finished:
                    print("you're finished!")
                    break
                }
            } receiveValue: { value in
                print("received value: \(value)")
            }
            .store(in: &self.subscriptions)
        
        let myPromise = publicationManager.publishPromise()
            .sink { value in
                print(value)
            }
            .store(in: &self.subscriptions)
    }
}

let someSub = SomeSubscriber()

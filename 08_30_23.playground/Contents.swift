import UIKit
import Combine


let numberPublisher = PassthroughSubject<Int, Never>()
let letterPublisher = PassthroughSubject<Character, Never>()

let numbers = Array(1...100)
let letters: [Character] = {
    "abcdefghijklmnopqrstuvwxyz".map { $0 }
}()

var subscriptions = Set<AnyCancellable>()
var n = 0
var l = 0

let numberSubscriber = numberPublisher
    .sink { number in
        print("got number \(number)")
    }
    .store(in: &subscriptions)

let letterSubscriber = letterPublisher
    .sink { letter in
        print("got letter \(letter)")
    }
    .store(in: &subscriptions)

var repeater: AnyCancellable
//DispatchQueue.main.async {
repeater = Timer.publish(every: 1, on: .main, in: .default)
    .autoconnect()
    .sink { val in
        print(val)
        if n < numbers.count {
            numberPublisher.send(numbers[n])
            n += 1
        }
        
        if l < letters.count {
            letterPublisher.send(letters[l])
            l += 1
            
        }
    }

//}




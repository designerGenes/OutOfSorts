import UIKit

// MARK: - Actor
final class TypeWithoutActor {
    
}

actor Counter {
    private var count: Double = 0
    
    func increaseCount() {
        count += 1
        print("the count is now \(count)")
    }
    
    func count() async -> Double {
        return count
    }
    
    func addTwoToCount() {
        count += 2
        print("the count is now \(count)")
    }
}

// MARK: - Actor isolation
let myCounter = Counter()
Task {
    let theCount = await myCounter.count()
    print("the count is \(theCount)")
    
}

@globalActor
struct MyTotallyGlobalActor {
    static let shared = Actor()
    func doSomething() {
        print("do something")
    }
}

struct SomeStruct {
    @MyTotallyGlobalActor func doSomethingPrivate() {
        
    }
}

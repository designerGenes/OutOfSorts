import UIKit
import Distributed

// today is going to be a busy day
// but I would like to get in some work on Distributed Actors
// but first, some algorithm practice

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    for l in 0..<arr.count {
        for r in l+1..<arr.count {
            if arr[l] > arr[r] {
                arr.swapAt(l, r)
            }
        }
    }
    return arr
}

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let midIdx = arr.count / 2
    return merge(l: mergeSort(arr: Array(arr[0..<midIdx])), r: mergeSort(arr: Array(arr[midIdx...])))
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var (lIdx, rIdx) = (0, 0)
    var out: [T] = []
    while lIdx < l.count && rIdx < r.count {
        if l[lIdx] < r[rIdx] {
            out.append(l[lIdx])
            lIdx += 1
        } else {
            out.append(r[rIdx])
            rIdx += 1
        }
    }
    
    return out + l[lIdx...] + r[rIdx...]
}

public distributed actor Counter: Identifiable {
    public typealias ActorSystem = LocalTestingDistributedActorSystem
    
    public init(count: Int = 0, actorSystem: ActorSystem) {
        self.count = count
        self.actorSystem = actorSystem
    }
    
    
    private var count = 0
    public distributed func increment() {
        count += 1
    }
    
    public distributed func decrement() {
        count -= 1
    }
}

public actor SomeActor: Identifiable {
    public nonisolated let id = UUID()
    var privateCounter: Int = 0
        
    public func doSomething() {
        print("doing something")
    }
}


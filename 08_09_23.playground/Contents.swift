import UIKit

// just a regular day, as I am in something of a hurry
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

func quickSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let pivot = arr[arr.count / 2]
    return quickSort(arr: arr.filter({ $0 < pivot })) + [pivot] + quickSort(arr: arr.filter({ $0 > pivot }))
}

func boyerMooreSearch<T: Equatable & Hashable>(arr: [T], pattern: [T]) -> Int {
    guard arr.count >= pattern.count else {
        return -1
    }
    var skipTable: [T: Int] = [:]
    for (idx, val) in pattern.enumerated() {
        skipTable[val] = pattern.count - idx - 1
    }
    var idx = pattern.count - 1
    while idx < arr.count {
        var patternIdx = pattern.count - 1
        while pattern[patternIdx] == arr[idx] {
            if patternIdx == 0 {
                return idx
            }
            patternIdx -= 1
            idx -= 1
        }
        idx += max(skipTable[arr[idx], default: pattern.count], pattern.count - patternIdx - 1)

    }
    return -1
}



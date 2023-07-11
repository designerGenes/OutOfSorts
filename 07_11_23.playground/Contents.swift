import UIKit

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

/**
 1. bubble sort
 2. merge sort
 3. quick sort
 */

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    for x in 0..<arr.count {
        for y in x+1..<arr.count {
            if arr[x] > arr[y] {
                arr.swapAt(x, y)
            }
        }
    }
    return arr
}

func mergeSort<T: Comparable>(arr: inout [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let midIdx = arr.count / 2
    var l = Array(arr[0..<midIdx])
    var r = Array(arr[midIdx...])
    return merge(l: mergeSort(arr: &l), r: mergeSort(arr: &r))
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
    var pivot = arr[arr.count / 2]
    var less = arr.filter { $0 < pivot }
    var more = arr.filter { $0 > pivot }
    return quickSort(arr: less) + [pivot] + quickSort(arr: more)
}


var myArray = Array(0..<55)
myArray.scramble()

print("quickSorted: \(quickSort(arr: myArray))")


import UIKit

extension Array {
    mutating func scrambled() -> [Element] {
        for x in 0..<self.count {
            var y = Int.random(in: 0..<self.count)
            let holder = self[y]
            self[y] = self[x]
            self[x] = holder
        }
        return self
    }
}

extension Array where Element: Comparable {
    func isAscendingOrder() -> Bool {
        for (x, y) in self.enumerated() {
            if x == 0 {
                continue
            }
            if y <= self[x - 1] {
                return false
            }
        }
        return true
    }
}

func bubbleSort<T: Comparable>(arr: [T]) -> [T] {
    var arr = arr
    for x in 0..<arr.count {
        for y in (x + 1)..<arr.count {
            if arr[x] > arr[y] {
                let holder = arr[y]
                arr[y] = arr[x]
                arr[x] = holder
            }
        }
    }
    
    return arr
}

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    var midIdx = arr.count / 2
    let l = mergeSort(arr: Array(arr[0..<midIdx]))
    let r = mergeSort(arr: Array(arr[midIdx...]))
    return merge(l: l, r: r)
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var (lIdx, rIdx) = (0, 0)
    var arr: [T] = []
    while lIdx < l.count && rIdx < r.count {
        if l[lIdx] < r[rIdx] {
            arr.append(l[lIdx])
            lIdx += 1
        } else {
            arr.append(r[rIdx])
            rIdx += 1
        }
    }
    arr.append(contentsOf: Array(l[lIdx...]))
    arr.append(contentsOf: Array(r[rIdx...]))
    return arr
}

var rawArr = Array(0...100)
var scrambledArr = rawArr.scrambled()
//let bubbleSortedArr = bubbleSort(arr: scrambledArr)
 let mergeSortedArr = mergeSort(arr: scrambledArr)

print(mergeSortedArr.isAscendingOrder())

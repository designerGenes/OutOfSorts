import UIKit

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            let rnd = Int.random(in: 0..<self.count)
            let holder = self[rnd]
            self[rnd] = self[x]
            self[x] = holder
        }
    }
}

func swap<T: Comparable>(arr: inout [T], l: Int, r: Int) {
    let holder = arr[r]
    arr[r] = arr[l]
    arr[l] = holder
}

func bubbleSort<T: Comparable>(arr: [T]) -> [T] {
    var arr = arr
    for x in 0..<arr.count {
        for y in (x+1)..<arr.count {
            if arr[x] > arr[y] {
                swap(arr: &arr, l: x, r: y)
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
    arr.append(contentsOf: l[lIdx...])
    arr.append(contentsOf: r[rIdx...])
    return arr
}

var myArr = Array(0..<100)
myArr.scramble()
let mergeSorted = mergeSort(arr: myArr)
print("SCRAMBLED: \(myArr)\n\nSorted: \(mergeSorted)")

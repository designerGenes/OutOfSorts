import UIKit

func swap<T>(arr: inout [T], l: Int, r: Int) {
    let holder = arr[r]
    arr[r] = arr[l]
    arr[l] = holder
}

extension Array {
    mutating func asScrambled() -> [Element] {
        for x in 0..<self.count {
            let rnd = Int.random(in: 0..<self.count)
            swap(arr: &self, l: x, r: rnd)
        }
        return self
    }
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
    var arr = arr
    var midIdx = arr.count / 2
    let l = mergeSort(arr: Array(arr[0..<midIdx]))
    let r = mergeSort(arr: Array(arr[midIdx...]))
    return merge(l: l, r: r)
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var (lIdx, rIdx) = (0, 0)
    var mergedArr: [T] = []
    while lIdx < l.count && rIdx < r.count {
        if l[lIdx] < r[rIdx] {
            mergedArr.append(l[lIdx])
            lIdx += 1
        } else {
            mergedArr.append(r[rIdx])
            rIdx += 1
        }
    }
    mergedArr.append(contentsOf: Array(l[lIdx...]))
    mergedArr.append(contentsOf: Array(r[rIdx...]))
    return mergedArr
}

var myArr = Array(0..<100)
var myScrambledArr = myArr.asScrambled()
let mySortedArr = mergeSort(arr: myScrambledArr)
print(mySortedArr)

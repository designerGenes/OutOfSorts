import UIKit

/**
 1. Bubble Sort
 2. Merge Sort
 3. Quicksort
 */

extension Array {
    mutating func scrambled() -> [Element] {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
        return self
    }
}

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
    out.append(contentsOf: l[lIdx...])
    out.append(contentsOf: r[rIdx...])
    return out
}

/** quicksort algorithm  */
func quickSort<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else { return array }

    let pivot = array[array.count / 2]
    let less = array.filter { $0 < pivot }
    let equal = array.filter { $0 == pivot }
    let greater = array.filter { $0 > pivot }

    return quickSort(less) + equal + quickSort(greater)
}

func slickSort<T: Comparable>(_ arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    
    let pivot = arr[arr.count / 2]
    let less = arr.filter { $0 < pivot }
    let equal = arr.filter { $0 == pivot }
    let more = arr.filter { $0 > pivot }
    return slickSort(less) + equal + slickSort(more)
}

var myArr = Array(0..<100)
var myScrambledArr = myArr.scrambled()
print("Scrambled: \(myScrambledArr)")
var myQuikSortedArr = quickSort(myScrambledArr)
print("QuikSortedArr: \(myQuikSortedArr)")

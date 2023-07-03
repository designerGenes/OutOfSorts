import UIKit

extension Array {
    mutating func scrambled() -> [Element] {
        for x in 0..<self.count {
            let y = Int.random(in: 0..<self.count)
            let holder = self[y]
            self[y] = self[x]
            self[x] = holder
        }
        return self
    }
}

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    for x in 0..<arr.count {
        for y in x+1..<arr.count {
            if arr[x] > arr[y] {
                let holder = arr[y]
                arr[y] = arr[x]
                arr[x] = holder
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

var myArr = Array(0..<55)
myArr = myArr.scrambled()
var mySortedArr = mergeSort(arr: &myArr)
print("My Sorted Arr: \(mySortedArr)")

/*
 summaries of the steps involved in the entire implementation of the
 Rabin-Karp algorithm
 */

// 1. Compute the hash value of the pattern.
// 2. Compute the hash value of the first m characters of the text.
// 3. Compare the hash values. If they match, compare the characters one by one.
// 4. If they don’t match, compute the hash value of the next m characters of the text.
// 5. Repeat steps 3 and 4 until a match is found or there are no more characters to compare.


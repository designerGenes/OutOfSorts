import UIKit

/**
 1. Bubble sort
 2. Merge Sort
 3. Quick Sort
 4. Boyer-Moore search
 */

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
    let less = arr.filter { $0 < pivot }
    let more = arr.filter { $0 > pivot }
    return quickSort(arr: less) + [pivot] + quickSort(arr: more)
}

func boyerMooreSearch(_ pattern: String, _ text: String) -> [Int] {
    guard pattern.count <= text.count && pattern.count > 0 else {
        return []
    }
    let patternLength = pattern.count
    let textLength = text.count
    var result: [Int] = []
    let pattern = Array(pattern)
    let text = Array(text)
    var badMatchTable: [Character: Int] = [:]
    for (i, char) in pattern.enumerated() {
        badMatchTable[char] = max(1, patternLength - i - 1)
    }
    var offset = 0
    while offset <= textLength - patternLength {
        var skip = 0
        for (i, char) in pattern.enumerated().reversed() {
            if char != text[offset + i] {
                skip = badMatchTable[text[offset + i]] ?? patternLength
                break
            }
        }
        if skip == 0 {
            result.append(offset)
            skip = patternLength
        }
        offset += skip
    }
    return result
}

var myArr = Array(0..<55)
myArr.scramble()

let myQuickSortedArr = quickSort(arr: myArr)
print("quicksorted: \(myQuickSortedArr)")

import UIKit

/**
 1. Bubble Sort
 2. Merge Sort
 3. Quick Sort
 4. Boyer-Moore Search
 */
extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
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

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let midIdx = arr.count / 2
    return merge(l: mergeSort(arr: Array(arr[0..<midIdx])), r: Array(arr[midIdx...]))
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

func quickSort<T: Comparable>(arr: inout [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    var (less, more): ([T], [T]) = ([], [])
    let pivot = arr.remove(at: 0)
    for x in 0..<arr.count {
        if arr[x] < pivot {
            less.append(arr[x])
        } else {
            more.append(arr[x])
        }
    }
    return quickSort(arr: &less) + [pivot] + quickSort(arr: &more)
}

func boyerMooreSearch(_ pattern: String, _ text: String) -> [Int] {
    guard pattern.count <= text.count && pattern.count > 0 else {
        return []
    }
    let pattern = Array(pattern)
    let text = Array(text)
    var matches: [Int] = []
    
    var badMatchTable: [Character: Int] = [:]
    for x in 0..<pattern.count {
        badMatchTable[pattern[x]] = pattern.count - x - 1
    }
    
    var offset = 0
    while offset <= text.count - pattern.count {
        var skip = 0
        for (i, char) in pattern.enumerated().reversed() {
            if char != text[offset + i] {
                skip = badMatchTable[text[offset + i]] ?? pattern.count
                break
            }
        }
        if skip == 0 {
            matches.append(offset)
            skip = pattern.count
        }
        offset += skip
    }
    
    return matches
}

var arr = [Int](0...100)
arr.scramble()
let longText = "Mr and Mrs Dursley of number 4 privet drive"
let pattern = "Dursley"

print(boyerMooreSearch(pattern, longText))

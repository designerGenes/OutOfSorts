import UIKit

/***
 1. Bubble Sort
 2. Merge Sort
 3. Quick Sort
 4.  Boyer-Moore Search
 */

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

extension Array where Element: Comparable {
    // 1. Bubble Sort
    mutating func bubbleSort() {
        for x in 0..<self.count {
            for y in x+1..<self.count {
                if self[x] > self[y] {
                    self.swapAt(x, y)
                }
            }
        }
    }
}

// 2. Merge Sort
func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let midIdx = arr.count / 2
    return merge(l: Array(arr[0..<midIdx]), r: Array(arr[midIdx...]))
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

// 3. Quick Sort
func quickSort<T: Comparable>(_ arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let pivot = arr[arr.count / 2]
    let less = arr.filter { $0 < pivot }
    let more = arr.filter {$0 > pivot }
    return quickSort(less) + [pivot] + quickSort(more)
}

// 4. Boyer-Moore Search
func boyerMooreSearch(_ pattern: String, _ text: String) -> [Int] {
    let patternLength = pattern.count
    let textLength = text.count
    guard patternLength > 0 && patternLength <= textLength else {
        return []
    }
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

// Tests
// generate 30 lines of random text that contains the sequence "ABC" at least 5 times
let testText = "lorem ipsum abc dallum multi plebium habc abcd abcdefg defghijklmnopqrstuvwxyz abcdefghijklmnopqrstuvwxyz defghijklmnopqrstuvwxyzabc defghijklmnopqrstuvwxcbayz a"
let testPattern = "abc"
let expected = [12, 21, 26, 61, 91]
let boyerMooreResults = boyerMooreSearch(testPattern, testText)
print("Found \(testPattern) at: " + {
    var out: [String] = []
    for (_, index) in boyerMooreResults.enumerated() {
        out.append("\(index) (\(Array(testText)[index..<index+testPattern.count]))")
    }
    return out.joined(separator: ",")
}())

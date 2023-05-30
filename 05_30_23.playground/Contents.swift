import UIKit

extension Array {
    mutating func asScrambled() -> [Element] {
        for x in 0..<self.count {
            let y = Int.random(in: 0..<self.count)
            let holder = self[x]
            self[x] = self[y]
            self[y] = holder
        }
        return self
    }
}

//var myArr = Array(0...50)
//var myArrScrambled = myArr.asScrambled()


func bubbleSort<T: Comparable>(arr: [T]) -> [T] {
    var arr = arr
    for x in 0..<arr.count {
        for y in (x + 1)..<arr.count {
            if arr[x] > arr[y] {
                let holder = arr[x]
                arr[x] = arr[y]
                arr[y] = holder
            }
        }
    }
    return arr
}

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else { return arr }
    let midIdx = arr.count / 2
    let l = mergeSort(arr: Array(arr[0..<midIdx]))
    let r = mergeSort(arr: Array(arr[midIdx..<arr.count]))
    return merge(l: l, r: r)
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var lIdx = 0
    var rIdx = 0
    var outArr: [T] = []
    while lIdx < l.count && rIdx < r.count {
        if l[lIdx] < r[rIdx] {
            outArr.append(l[lIdx])
            lIdx += 1
        } else {
            outArr.append(r[rIdx])
            rIdx += 1
        }
    }
    
    outArr.append(contentsOf: Array(l[lIdx...]))
    outArr.append(contentsOf: Array(r[rIdx...]))
    return outArr
}

// being Rabin Karp

func rabinKarpSearch(pattern: String, text: String) -> [Int] {
    let prime: Int64 = 101 // A prime number used for hashing
    let patternLength = pattern.count
    let textLength = text.count
    let patternHash = hashString(pattern, prime)
    var textHash = hashString(String(text.prefix(patternLength)), prime)
    var indices: [Int] = []

    for i in 0...(textLength - patternLength) {
        if textHash == patternHash && checkEqual(text, i, pattern) {
            indices.append(i)
        }
        
        if i < textLength - patternLength {
            textHash = recalculateHash(text, i, i + patternLength, textHash, patternLength, prime)
        }
    }

    return indices
}

func hashString(_ str: String, _ prime: Int64) -> Int64 {
    var hash: Int64 = 0
    let strLength = str.count
    let strArray = Array(str.unicodeScalars)

    for i in 0..<strLength {
        let charCode = Int64(strArray[i].value)
        hash += charCode * Int64(pow(Double(prime), Double(strLength - i - 1))) % prime
        hash %= prime
    }

    return hash
}

func recalculateHash(_ text: String, _ oldIndex: Int, _ newIndex: Int, _ oldHash: Int64, _ patternLength: Int, _ prime: Int64) -> Int64 {
    var newHash = oldHash
    let charCodeToRemove = Int64(text.unicodeScalars[text.index(text.startIndex, offsetBy: oldIndex)].value)
    let charCodeToAdd = Int64(text.unicodeScalars[text.index(text.startIndex, offsetBy: newIndex)].value)

    newHash -= charCodeToRemove
    newHash /= prime
    newHash += charCodeToAdd * Int64(pow(Double(prime), Double(patternLength - 1))) % prime
    newHash %= prime

    return newHash
}

func checkEqual(_ text: String, _ startIndex: Int, _ pattern: String) -> Bool {
    let patternLength = pattern.count
    let textSubstring = text[text.index(text.startIndex, offsetBy: startIndex)..<text.index(text.startIndex, offsetBy: startIndex + patternLength)]
    
    return textSubstring == pattern
}

let shortText = "Kubernetes has revolutionized the way containerized applications are managed,"
let indices = rabinKarpSearch(pattern: "revolutionized", text: shortText)

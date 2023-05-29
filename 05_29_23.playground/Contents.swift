import UIKit

extension Array {
    mutating func asScrambled() -> [Element] {
        for x in 0..<self.count {
            let rIdx = Int.random(in: 0..<self.count)
            let holder = self[rIdx]
            self[rIdx] = self[x]
            self[x] = holder
        }
        return self
    }
}

var myArr = Array(0..<55)
var myScrambledArr = myArr.asScrambled()


func bubbleSort<T: Comparable>(arr: [T]) -> [T] {
    var arr = arr
    var x = 0
    while x < arr.count - 2 {
        var y = 1
        while y < arr.count {
            if arr[y] < arr[y - 1] {
                var holder = arr[y]
                arr[y] = arr[y - 1]
                arr[y - 1] = holder
                
            }
            y += 1
        }
        x += 1
    }
    return arr
}


func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    
    let midIdx = arr.count / 2
    let left = mergeSort(arr: Array(arr[0..<midIdx]))
    let right = mergeSort(arr: Array(arr[midIdx...]))
    return merge(l: left, r: right)
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var lIdx = 0
    var rIdx = 0
    var mergedArray: [T] = []
    while lIdx < l.count && rIdx < r.count {
        if l[lIdx] < r[rIdx] {
            mergedArray.append(l[lIdx])
            lIdx += 1
        } else {
            mergedArray.append(r[rIdx])
            rIdx += 1
        }
    }
    mergedArray.append(contentsOf: l[lIdx...])
    mergedArray.append(contentsOf: r[rIdx...])
    
    return mergedArray
}

print(mergeSort(arr: myScrambledArr))

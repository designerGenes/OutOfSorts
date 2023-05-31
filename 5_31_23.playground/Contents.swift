import UIKit

extension Array {
    mutating func asScrambled() -> [Element] {
        for x in 0..<self.count {
            let rnd = Int.random(in: 0..<self.count)
            let holder = self[rnd]
            self[rnd] = self[x]
            self[x] = holder
        }
        return self
    }
}

func bubbleSort<T: Comparable>(arr: [T]) -> [T] {
    var arr = arr
    guard arr.count > 1 else {
        return arr
    }
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
    let midIdx = arr.count / 2
    guard arr.count > 1 else {
        return arr
    }
    let l = mergeSort(arr: Array(arr[0..<midIdx]))
    let r = mergeSort(arr: Array(arr[midIdx...]))
    
    return merge(l, r)
}

func merge<T: Comparable>(_ l: [T], _ r: [T]) -> [T] {
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

var myArr = Array(0..<55)
myArr = myArr.asScrambled()
let mySortedArr = mergeSort(arr: myArr)
print(mySortedArr)

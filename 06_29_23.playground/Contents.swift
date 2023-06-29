import UIKit

/**
 who am I and what do I want?
 */

extension Array {
    mutating func scrambled() -> [Element] {
        for x in 0..<self.count {
            let rnd = Int.random(in: 0..<self.count)
            let holder = self[rnd]
            self[rnd] = self[x]
            self[x] = holder
            
        }
        return self
    }
}

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    for x in 0..<arr.count {
        for y in x..<arr.count {
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
    var left = Array(arr[0..<midIdx])
    var right = Array(arr[midIdx...]) // this is the reason why we need to make sure the array is greater than 1
    
    return merge(l: mergeSort(arr: &left), r: mergeSort(arr: &right))
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var (lIdx, rIdx) = (0, 0)
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
    
    outArr.append(contentsOf: l[lIdx...])
    outArr.append(contentsOf: r[rIdx...])
    return outArr
}
 
var myArr = Array(0..<100)
var myArrScrambled = myArr.scrambled()

var myArrSorted = mergeSort(arr: &myArrScrambled)
print("The sorted array is \(myArrSorted)")

import UIKit

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
    var out: [T] = []
    var (lIdx, rIdx) = (0, 0)
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

var myArr = Array(0..<50)
var myScrambledArr = myArr.scrambled()
print("SCRAMBLED: \(myScrambledArr)")
var mySortedArr = mergeSort(arr: &myScrambledArr)
print("Sorted: \(mySortedArr)")

/* write and explain an implementation of QuickSort algorithm */
func quickSort<T: Comparable>(arr: inout [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let pivot = arr.remove(at: 0)
    var (l, r) = ([T](), [T]())
    for x in arr {
        if x < pivot {
            l.append(x)
        } else {
            r.append(x)
        }
    }
    return quickSort(arr: &l) + [pivot] + quickSort(arr: &r)
}


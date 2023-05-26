import UIKit

/**
 Out of sorts is a daily review of basic sorting algorithms and randomization of sequences
 */

let arrOne = Array(0..<50)

extension Array  {
    func asScrambled() -> [Element] {
        var out = Array(self)
        for x in 0..<(out.count / 2) {
            let rnd = Int.random(in: 0..<out.count)
            let l = out[x]
            let holder = out[rnd]
            out[rnd] = l
            out[x] = holder
        }
        return out
    }
}

extension Array where Element: Comparable {
    func bubbleSorted() -> [Element] {
        var out = self
        guard (self.count > 1) else {
            return self
        }
        var x = 0
        while (x < self.count - 2) {
            var y = x + 1
            while (y < self.count - 1) {
                if (out[y - 1] > out[y]) {
                    let holder = out[y]
                    out[y] = out[y - 1]
                    out[y - 1] = holder
                }
            }
        }
        
        return out
    }
}
    
func mergeSort<T: Comparable>(arr: inout [T], l: Int = 0, r: Int = 0) {
    var r = r > 0 ? r : arr.count - 1
    if l < r {
        var m = (l + (r - 1)) / 2
        mergeSort(arr: &arr, l: l, r: m)
        mergeSort(arr: &arr, l: m + 1, r: r)
        merge(arr: &arr, l: l, m: m, r: r)
    }
    
}
    
func merge<T: Comparable>(arr: inout [T], l: Int, m: Int, r: Int) {
    var n1 = m - l + 1
    var n2 = r - m
    var lArr = Array(arr[0..<n1])
    var rArr = Array(arr[n2..<(arr.count - 1)])
    var (i, j, k) = (0, 0, n1)
    while (i < n1 && j < n2) {
        if lArr[i] <= rArr[j] {
            arr[k] = lArr[i]
            i += 1
        } else {
            arr[k] = rArr[j]
            j += 1
        }
        k += 1
    }
    
    while i < n1 {
        arr[k] = lArr[i]
        i += 1
        k += 1
    }
    
    while j < n2 {
        arr[k] = rArr[j]
        j += 1
        k += 1
    }
    
    
}

//let arrOneScrambled = arrOne.asScrambled()
//print(arrOne)
//print(arrOne.bubbleSorted())

var arrOneScrambledAgain = arrOne.asScrambled()
//print(arrOneScrambledAgain)
mergeSort(arr: &arrOneScrambledAgain)
print(arrOneScrambledAgain)

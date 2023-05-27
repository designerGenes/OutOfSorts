import UIKit

extension Array {
    mutating func asScrambled() -> [Element] {
        for x in 0..<self.count {
            let random = Int.random(in: 0..<self.count)
            let l = self[x]
            let holder = self[random]
            self[x] = holder
            self[random] = l
        }
        return self
    }
}


func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    var x = 0
    while x < arr.count - 2 {
        var y = 1
        while y < arr.count {
            let l = arr[y - 1]
            let r = arr[y]
            if l > r {
                let holder = arr[y]
                arr[y] = l
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
    let leftArray = mergeSort(arr: Array(arr[0..<midIdx]))
    let rightArray = mergeSort(arr: Array(arr[midIdx...]))
    
    
    return merge(l: leftArray, r: rightArray)
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
    var leftIdx = 0
    var rightIdx = 0
    var mergedArray: [T] = []
    while leftIdx < l.count && rightIdx < r.count {
        if l[leftIdx] < r[rightIdx] {
            mergedArray.append(l[leftIdx])
            leftIdx += 1
        } else {
            mergedArray.append(r[rightIdx])
            rightIdx += 1
        }
    }
    
    while leftIdx < l.count {
        mergedArray.append(l[leftIdx])
        leftIdx += 1
    }
    
    while rightIdx < r.count {
        mergedArray.append(r[rightIdx])
        rightIdx += 1
    }
    
    return mergedArray
    
}

var myArr = Array(0..<100)
var myScrambledArr = myArr.asScrambled()
print(mergeSort(arr: myScrambledArr))

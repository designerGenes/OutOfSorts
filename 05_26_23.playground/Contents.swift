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

func mergeSort<T: Comparable>(arr: inout [T]) -> [T] {
    
}

var myArr = Array(0..<100)
var myScrambledArr = myArr.asScrambled()
print(bubbleSort(arr: &myScrambledArr))

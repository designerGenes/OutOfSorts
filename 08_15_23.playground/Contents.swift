import UIKit

var greeting = "Hello, playground"

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

/*
 Selection sort works by selecting the minimum value in a list and swapping it with the first value in the list. It then starts at the second position, selects the smallest value in the remaining list, and swaps it with the second element. It continues iterating through the list and swapping elements until it reaches the end of the list. Now the list is sorted. Selection sort has quadratic time complexity in all cases.
 */

func selectionSort<T: Comparable>(arr: inout [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    for l in 0..<arr.count - 1 {
        for r in l+1..<arr.count {
            if arr[r] < arr[l] {
                arr.swapAt(l, r)
            }
        }
    }
    
    return arr
}

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    
    for l in 0..<arr.count {
        for r in l+1..<arr.count {
            if arr[l] > arr[r] {
                arr.swapAt(l, r)
            }
        }
    }
    return arr
}
 
var myArr = [Int](0..<50)
myArr.scramble()
print("Scrambled: \(myArr)")
selectionSort(arr: &myArr)
print("SORTED: \(myArr)")




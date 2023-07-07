import UIKit

/**
 1. Bubble Sort
 2. Merge Sort
 3. Quick Sort
 
 // bonus, I want to add a system of detailing each step taken for replayability
 */

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

class ActionQueue<T: Comparable> {
    var actions: [SortingAction<T>] = []
}



enum SortingAction<T: Comparable> {
    case swap(l: T, r: T)
    case divide(arr: [T], splitIdx: Int)
    case merge(l: [T], r: [T], result: [T])
    case selectPivot(pivot: T, arr: [T])
    
    func described() -> String {
        switch self {
        case .swap(l: let l, r: let r):
            return "Swapped \(l) and \(r)"
        case .divide(arr: let arr, splitIdx: let splitIdx):
            return "Divided array at \(splitIdx) into \(arr[0..<splitIdx]) and \(arr[splitIdx...])"
        case .merge(l: let l, r: let r, result: let result):
            return "Merged \(l) and \(r) into \(result)"
        case .selectPivot(pivot: let pivot, arr: let arr):
            return "Selected \(pivot) as pivot for \(arr)"
        
        }
        
    }
}

//typealias SortingResult<T: Comparable> = ([T], [SortingAction<T>])
typealias SortingResult<T: Comparable> = ([T], ActionQueue<T>)



func bubbleSort<T: Comparable>(arr: inout [T]) -> SortingResult<T> {
    var actionQueue = ActionQueue<T>()
    for x in 0..<arr.count {
        for y in x+1..<arr.count {
            if arr[x] > arr[y] {
                arr.swapAt(x, y)
                actionQueue.actions.append(SortingAction.swap(l: arr[x], r: arr[y]))
            }
        }
    }
    return (arr, actionQueue)
}

func mergeSort<T: Comparable>(arr: inout [T], actionQueue: ActionQueue<T> = ActionQueue()) -> SortingResult<T> {
    guard arr.count > 1 else {
        return (arr, actionQueue)
    }
    let midIdx = arr.count / 2
    var l = Array(arr[0..<midIdx])
    var r = Array(arr[midIdx...])
    actionQueue.actions.append(.divide(arr: arr, splitIdx: midIdx))
    let leftMergeSort = mergeSort(arr: &l, actionQueue: actionQueue)
    let rightMergeSort = mergeSort(arr: &r, actionQueue: actionQueue)
    let out = merge(l: leftMergeSort.0, r: rightMergeSort.0, actionQueue: actionQueue)
    
    return (out.0, actionQueue)
}

func merge<T: Comparable>(l: [T], r: [T], actionQueue: ActionQueue<T>) -> SortingResult<T> {
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
    out = out + l[lIdx...] + r[rIdx...]
    actionQueue.actions.append(.merge(l: l, r: r, result: out))
    return (out, actionQueue)
}

func quickSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let pivot = arr[arr.count / 2]
    let less = arr.filter { $0 < pivot }
    let equal = arr.filter { $0 == pivot }
    let more = arr.filter { $0 > pivot }

    return quickSort(arr: less) + equal + quickSort(arr: more)
}

var myArr = Array(0..<50)
//myArr.scramble()

//var bubbleSortArr = bubbleSort(arr: &myArr)
//for action in bubbleSortArr.1 {
//    print(action.described())
//}

myArr.scramble()
var mergeSortArr = mergeSort(arr: &myArr)
for action in mergeSortArr.1.actions {
    print(action.described())
}

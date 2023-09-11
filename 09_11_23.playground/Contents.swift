import UIKit

// 1. Bubble Sort
// 2. Merge Sort
// 3. Binary tree


func bubbleSort<T: Comparable>(arr: inout [T]) {
    for l in 0..<arr.count {
        for r in l+1..<arr.count {
            if arr[l] > arr[r] {
                arr.swapAt(l, r)
            }
        }
    }
}

func merge<T: Comparable>(l: [T], r: [T]) -> [T] {
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
    
    return out + l[lIdx...] + r[rIdx...]
}

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    
    let midIdx = arr.count / 2
    return merge(l: mergeSort(arr: Array(arr[0..<midIdx])), r: mergeSort(arr: Array(arr[midIdx...])))
}

func quickSort<T: Comparable>(arr: inout [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let pivot = arr[arr.count / 2]
    return arr.filter({$0 < pivot}) + [pivot] + arr.filter({$0 > pivot})
}

class Node<T: Comparable> {
    var value: T
    var left: Node<T>?
    var right: Node<T>?
    init(value: T, left: Node<T>? = nil, right: Node<T>? = nil) {
        self.value = value
        self.left = left
        self.right = right
    }
}

class Tree<T: Comparable> {
    var root: Node<T>?
    
    func insert(node: Node<T>) {
        guard let root = root else {
            root = node
            return
        }
        var focusNode = root
        while true {
            if node.value < focusNode.value {
                if let left = focusNode.left {
                    focusNode = left
                } else {
                    focusNode.left = node
                    break
                }
            } else {
                if let right = focusNode.right {
                    focusNode = right
                } else {
                    focusNode.right = node
                    break
                }
            }
        }
    }
    
    static func fromList(arr: [T]) -> Tree<T> {
        let tree = Tree()
        for val in arr {
            tree.insert(node: Node<T>(value: val))
        }
        return tree
    }
}

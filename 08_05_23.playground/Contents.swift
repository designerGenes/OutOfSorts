import UIKit

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    for l in 0..<arr.count {
        for r in l+1..<arr.count {
            if arr[l] > arr[r] {
                arr.swapAt(l, r)
            }
        }
    }
    return arr
}

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let midIdx = arr.count / 2
    
    return merge(l: mergeSort(arr: Array(arr[0..<midIdx])), r: mergeSort(arr: Array(arr[midIdx...])))
    
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

func quickSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    
    let pivot = arr[arr.count / 2]
    return quickSort(arr: arr.filter({$0 < pivot})) + [pivot] + quickSort(arr: arr.filter({$0 > pivot}))
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
    var children: [Node<T>] {
        guard let root = root else {
            return []
        }
        var out: [Node<T>] = []
        traverseInOrder(node: root, accumulator: &out)
        return out
    }
    
    private func traverseInOrder(node: Node<T>?, accumulator: inout [Node<T>]) {
        guard let node = node else {
            return
        }
        traverseInOrder(node: node.left, accumulator: &accumulator)
        accumulator.append(node)
        traverseInOrder(node: node.right, accumulator: &accumulator)
    }
    
    func search(val: T) -> Bool {
        guard let root = root else {
            return false
        }
        var focusNode = root
        while true {
            if val == focusNode.value {
                return true
            } else if val < focusNode.value {
                if let left = focusNode.left {
                    focusNode = left
                } else {
                    return false
                }
            } else {
                if let right = focusNode.right {
                    focusNode = right
                } else {
                    return false
                }
            }
        }
        
    }
    
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
    
    static func fromList(vals: [T]) -> Tree<T> {
        let out = Tree<T>()
        for val in vals {
            out.insert(node: Node(value: val))
        }
        return out
    }
}


var arr = [Int](0...100).shuffled()
let myTree = Tree.fromList(vals: arr)
print(myTree.search(val: 102))


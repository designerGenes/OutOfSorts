import UIKit

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

func bubbleSort<T: Comparable>(arr: inout [T]) -> [T] {
    for x in 0..<arr.count {
        for y in x+1..<arr.count {
            if arr[x] > arr[y] {
                arr.swapAt(x, y)
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
    return merge(l: Array(arr[0..<midIdx]), r: Array(arr[midIdx...]))
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
    let less = arr.filter { $0 < pivot }
    let more = arr.filter { $0 > pivot }
    return quickSort(arr: less) + [pivot] + quickSort(arr: more)
}

func boyerMooreSearch(_ pattern: String, _ text: String) -> [Int] {
    guard pattern.count <= text.count && pattern.count > 0 else {
        return []
    }
    
    let pattern = Array(pattern)
    let text = Array(text)
    var matches: [Int] = []
    
    var badMatchTable: [Character: Int] = [:]
    for x in 0..<pattern.count {
        badMatchTable[pattern[x]] = pattern.count - x - 1
    }
    var offset = 0
    while offset < text.count - pattern.count {
        var skip = 0
        for (i, char) in pattern.enumerated().reversed() {
            if char != text[offset + i] {
                skip = badMatchTable[text[offset + i]] ?? pattern.count
                break
            }
        }
        if skip == 0 {
            matches.append(offset)
            skip = pattern.count
        }
        offset += skip
    }
    return matches
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
    
    func insert(_ node: Node<T>) {
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
    
    static func fromArray(_ arr: [T]) -> Tree<T> {
        let tree = Tree<T>()
        for val in arr {
            tree.insert(Node(value: val))
        }
        return tree
    }
    
    var allChildren: [Node<T>] {
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
}

var myArr: [Int] = {
    var out: [Int] = []
    for x in 0..<55 {
        if out.isEmpty {
            out.append(Int.random(in: 0..<15))
        } else {
            out.append(out[x - 1] + Int.random(in: 1...5))
        }
    }
    return out
}()

myArr.scramble()
let myTree = Tree.fromArray(myArr)
print("myArr: \(bubbleSort(arr: &myArr))")

var myTreeChildren = myTree.allChildren.map({ $0.value })
print("myTree: \(mergeSort(arr: myTreeChildren))")



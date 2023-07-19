import UIKit

extension Int {
    func times(_ task: (Int) -> Void) {
        for x in 0..<self {
            task(x)
        }
    }
}

extension Array {
    mutating func scramble() {
        (self.count-1).times { count in
            self.swapAt(count, Int.random(in: 0..<self.count))
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
    return merge(l: mergeSort(arr: Array(arr[0..<midIdx])), r: Array(arr[midIdx...]))
    
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

func boyerMooreSearch(_ pattern: String, _ text: String) -> [Int] {
    guard pattern.count <= text.count && !pattern.isEmpty else {
        return []
    }
    let pattern = Array(pattern)
    let text = Array(text)
    var results: [Int] = []
    var badMatchTable: [Character: Int] = [:]
    for i in 0..<pattern.count {
        badMatchTable[pattern[i]] = pattern.count - i - 1
    }
    var offset = 0
    while offset <= text.count - pattern.count {
        var skip = 0
        for (i, char) in pattern.enumerated().reversed() {
            if char != text[offset + i] {
                skip = badMatchTable[text[offset + i]] ?? pattern.count
                break
            }
        }
        if skip == 0 {
            results.append(offset)
            skip = 1
        }
        offset += skip
    }
    
    return results
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
        var children: [Node<T>] = []
        traverseInOrder(node: root, accumulator: &children)
        return children
    }
    
    func traverseInOrder(node: Node<T>?, accumulator: inout [Node<T>]) {
        guard let node = node else {
            return
        }
        traverseInOrder(node: node.left, accumulator: &accumulator)
        accumulator.append(node)
        traverseInOrder(node: node.right, accumulator: &accumulator)
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
    
    func search(value: T) -> Node<T>? {
        guard let root = root else {
            return nil
        }
        if root.value == value {
            return root
        }
        var focusNode = value < root.value ? root.left : root.right
        while true {
            guard focusNode != nil else {
                return nil
            }
            if focusNode!.value == value {
                return focusNode
            } else if value > focusNode!.value  {
                focusNode = focusNode!.right
            } else {
                focusNode = focusNode!.left
            }
        }
    }
    
    static func fromArray(_ arr: [T]) -> Tree {
        let tree = Tree<T>()
        for val in arr {
            tree.insert(node: Node(value: val))
        }
        return tree
    }
}

var myArr: [Int] = {
    var arr: [Int] = []
    for x in 0..<55 {
        arr.append(x)
//        arr.append(arr.isEmpty ? Int.random(in: 0..<10) : arr[x - 1] + Int.random(in: 0..<5))
    }
    return arr
}()

myArr.scramble()
print(myArr)
let myTree = Tree.fromArray(myArr)
print(myTree.children.map { $0.value })
print(myTree.search(value: 42) == nil ? "not found" : "found")


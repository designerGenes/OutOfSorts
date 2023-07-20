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
    
    return out + l[lIdx...] + r[rIdx...]
}

func mergeSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    let midIdx = arr.count / 2
    return merge(l: mergeSort(arr: Array(arr[0..<midIdx])), r: mergeSort(arr: Array(arr[midIdx...])))
}

func quickSort<T: Comparable>(arr: [T]) -> [T] {
    guard arr.count > 1 else {
        return arr
    }
    
    let pivot = arr[arr.count / 2]
    return quickSort(arr: arr.filter { $0 < pivot}) + [pivot] + quickSort(arr: arr.filter { $0 > pivot})
}

func boyerMooreSearch(_ pattern: String, _ text: String) -> [Int] {
    guard pattern.count <= text .count && !pattern.isEmpty else {
        return []
    }
    let pattern = Array(pattern)
    let text = Array(text)
    var matches: [Int] = []
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
            matches.append(offset)
            skip = 1
        }
        offset += skip
    }
    
    return matches
    
}

let myText = "Mr. and Mrs. Dursley of number 4 privet drive"
let myPattern = "number"
print(boyerMooreSearch(myPattern, myText))

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
    
    private func traverseInOrder(node: Node<T>?, accumulator: inout [Node<T>]) {
        guard let node = node else {
            return
        }
        traverseInOrder(node: node.left, accumulator: &accumulator)
        accumulator.append(node)
        traverseInOrder(node: node.right, accumulator: &accumulator)
    }
    
    func search(val: T) -> Node<T>? {
        var focusNode = root
        while let node = focusNode {
            if node.value == val {
                return node
            } else if node.value < val {
                focusNode = node.left
            } else {
                focusNode = node.right
            }
        }
        return nil
    }
    
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
}

import UIKit
import Combine

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

// today I am in a hurry
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

func boyerMoore(_ pattern: String, _ text: String) -> [Int] {
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
    while offset <= text.count - pattern.count - 1 {
        var skip = 0
        for (i, char) in pattern.enumerated().reversed() {
            if char != text[offset + i] {
                skip = badMatchTable[text[offset + i]] ?? pattern.count
                break
            }
        }
        if skip == 0 {
            results.append(offset)
            skip = pattern.count
        }
        offset += skip
    }
    
    return results
}

// sure why not
func knuthMorrisPratt(_ pattern: String, _ text: String) -> [Int] {
    guard pattern.count <= text.count && !pattern.isEmpty else {
        return []
    }
    let pattern = Array(pattern)
    let text = Array(text)
    var results: [Int] = []
    var skipTable: [Int] = []
    var offset = 0
    var j = 0
    
    // build skip table
    skipTable.append(0)
    for i in 1..<pattern.count {
        while j > 0 && pattern[i] != pattern[j] {
            j = skipTable[j - 1]
        }
        if pattern[i] == pattern[j] {
            j += 1
        }
        skipTable.append(j)
    }
    
    // search
    while offset <= text.count - pattern.count {
        while j > 0 && text[offset + j] == pattern[j] {
            j += 1
        }
        if j == pattern.count {
            results.append(offset)
        }
        if j > 0 {
            j = skipTable[j - 1]
        } else {
            offset += 1
        }
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
        var accumulator: [Node<T>] = []
        traverseInOrder(node: root, accumulator: &accumulator)
        return accumulator
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
            self.root = node
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
            tree.insert(node: Node(value: val))
        }
        return tree
    }
}


var myArr: [Int] = {
    var out: [Int] = []
    for x in 0..<50 {
        out.append(out.isEmpty ? Int.random(in: 0..<10) : out[x - 1] + Int.random(in: 1..<10))
    }
    return out
}()
myArr.scramble()

let myTree = Tree.fromArray(myArr)
print("Tree children: \(myTree.children.map({$0.value}))")

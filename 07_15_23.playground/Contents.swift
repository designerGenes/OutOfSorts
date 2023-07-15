import UIKit

// implement Binary Search Tree
class Node<T: Comparable> {
    var value: T
    var left: Node?
    var right: Node?
    init(value: T, left: Node? = nil, right: Node? = nil) {
        self.value = value
        self.left = left
        self.right = right
    }
}

class Tree<T: Comparable> {
    var root: Node<T>?
    
    func insert(value: T, focusNode: Node<T>? = nil) {
        guard let root = root else {
            root = Node(value: value)
            return
        }
        let focusNode = focusNode ?? root
        if value < focusNode.value {
            if let left = focusNode.left {
                insert(value: value, focusNode: focusNode.left)
            } else {
                focusNode.left = Node(value: value)
            }
        } else {
            if let right = focusNode.right {
                insert(value: value, focusNode: focusNode.right)
            } else {
                focusNode.right = Node(value: value)
            }
        }
    }
    
    func search(_ value: T) {
        
    }
    
    func allNodes() -> [Node<T>] {
        var nodes: [Node<T>] = []
        traverseInOrder(node: root, results: &nodes)
        return nodes
    }
    
    private func traverseInOrder(node: Node<T>?, results: inout [Node<T>]) {
        guard let node = node else {
            return
        }
        traverseInOrder(node: node.left, results: &results)
        results.append(node)
        traverseInOrder(node: node.right, results: &results)
    }
    
    func leftNodes() -> [Node<T>] {
        var nodes: [Node<T>] = []
        var node = root
        while let currentNode = node {
            nodes.append(currentNode)
            node = currentNode.left
        }
        
        return nodes
    }
    
    static func fromArr(_ arr: [T]) -> Tree<T> {
        let out = Tree()
        for val in arr {
            out.insert(value: val)
        }
        return out
    }
}


func generateArr() -> [Int] {
    var arr: [Int] = []
    for x in 0..<100 {
        if arr.isEmpty {
            arr.append(Int.random(in: 0..<15))
        } else {
            arr.append(arr[x - 1] + Int.random(in: 0..<15))
        }
    }
    return arr
}

extension Array {
    mutating func scramble() {
        for x in 0..<self.count {
            self.swapAt(x, Int.random(in: 0..<self.count))
        }
    }
}

var arr = generateArr()
arr.scramble()
print(arr)
let tree = Tree<Int>.fromArr(arr)
//print(tree.allNodes().map({ $0 .value }))
print(tree.leftNodes().map({ $0.value }))



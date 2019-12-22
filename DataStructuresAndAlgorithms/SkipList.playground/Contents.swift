import Foundation

let MAX_LEVEL = 16
let SKIPLIST_P = 0.5
class Node {
    let data: Int
    let maxLevel: Int
    var forwards: [Node?] = .init(repeating: nil, count: MAX_LEVEL)

    init(data: Int, maxLevel: Int) {
        self.data = data
        self.maxLevel = maxLevel
    }
    
    func toString() -> String {
        return "{data: \(data); levels: \(maxLevel)}"
    }
}

class SkipList {
    private static let randomPercent = 0.5
    private let head: Node = Node(data: 0, maxLevel: 0)
    private var levelCount = 1
    
    func find(value: Int) -> Node? {
        var p = head
        for i in (0 ..< levelCount).reversed() {
            while let n = p.forwards[i], n.data < value {
                p = n
            }
        }
        
        if let n = p.forwards[0], n.data == value {
            return n
        } else {
            return nil
        }
    }
    
    // TODO: 代码解读
    func insert(value: Int) {
        let level = randomLevel()
        let newNode = Node(data: value, maxLevel: level)
        var update: [Node?] = Array(repeating: nil, count: level)
        for i in 0..<level {
            update[i] = head
        }
        
        var p = head
        for i in (0..<level).reversed() {
            while let n = p.forwards[i], n.data < value {
                p = n
            }
            update[i] = p
        }
        
        for i in 0..<level {
            newNode.forwards[i] = update[i]?.forwards[i]
            update[i]?.forwards[i] = newNode
        }
        
        if levelCount < level {
            levelCount = level
        }
    }
    
    // TODO: Add implement code of delete method
    
    func randomLevel() -> Int {
        var level = 1
        while Double.random(in: 0.0 ... 1.0) < SKIPLIST_P && level < MAX_LEVEL {
            level += 1
        }
        return level
    }
    
    func printAll() {
        var p = head
        while let n = p.forwards[0] {
            print(n.toString())
            p = n
        }
    }
}

let list = SkipList()
list.insert(value: 1)
list.insert(value: 10)
list.insert(value: 2)
list.insert(value: 3)
list.insert(value: 5)
list.insert(value: 8)
list.insert(value: 6)
list.printAll()
list.find(value: 3)?.toString()
list.find(value: 13)?.toString()

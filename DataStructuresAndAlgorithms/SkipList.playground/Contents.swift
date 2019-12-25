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

// TODO: 代码解读
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
    
    func insert(value: Int) {
        let level = randomLevel()
        let newNode = Node(data: value, maxLevel: level)
        var update: [Node?] = Array(repeating: head, count: level)
        
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
    
    func delete(value: Int){
        var update: [Node?] = Array(repeating: head, count: levelCount)
        var p = head
        for i in (0..<levelCount).reversed() {
            while let n = p.forwards[i], n.data < value {
                p = n
            }
            update[i] = p
        }
        
        for i in 0..<levelCount {
            if let n = update[i]?.forwards[i], n.data == value {
                update[i]?.forwards[i] = n.forwards[i]
            }
        }
        while levelCount > 0, head.forwards[levelCount - 1] == nil {
            levelCount -= 1
        }
    }
    
    func randomLevel() -> Int {
        var level = 1
        while Double.random(in: 0.0 ... 1.0) < SKIPLIST_P && level < MAX_LEVEL {
            level += 1
        }
        return level
    }
    
    func printAll() {
        var p = head
        print("List's maxLevel is \(levelCount)")
        while let n = p.forwards[0] {
            print(n.toString())
            p = n
        }
    }
}


let list = SkipList()
let testCase: (String, ()->())->() = { flag, action in
    print("TestCase: \(flag)")
    action()
    list.printAll()
    print("")
}

testCase("1") {
    list.insert(value: 1)
    list.insert(value: 10)
    list.insert(value: 2)
    list.insert(value: 3)
    list.insert(value: 5)
    list.insert(value: 8)
    list.insert(value: 6)
}
testCase("2") {
    list.find(value: 3)?.toString()
    list.find(value: 13)?.toString()
    list.delete(value: 3)
    list.delete(value: 2)
    list.delete(value: 5)
    list.find(value: 3)?.toString()
}

testCase("3") {
    list.insert(value: 3)
    list.insert(value: 5)
    list.find(value: 3)
}

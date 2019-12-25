import Foundation

class Node {
    let data: Int
    let maxLevel: Int
    var forwards: [Node?]

    init(data: Int, maxLevel: Int) {
        self.data = data
        self.maxLevel = maxLevel
        forwards = .init(repeating: nil, count: maxLevel)
    }
    
    func toString() -> String {
        return "{data: \(data); levels: \(maxLevel)}"
    }
}

class SkipList {
    /// 第n层的节点放入n+1层作为索引节点的概率值
    private static let upgradeProbability = 0.5
    /// 最高支持的层数
    private static let maxLevel = 16
    
    /// 头节点
    private let head: Node = Node(data: 0, maxLevel: SkipList.maxLevel)
    /// 当前所包含的层数
    private var levelCount = 0
    
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
        // 找到每一层里，相对于新节点的前驱节点，既每一层里最后一个小于value的节点
        var update: [Node?] = Array(repeating: head, count: level)
        var p = head
        for i in (0..<level).reversed() {
            while let n = p.forwards[i], n.data < value {
                p = n
            }
            update[i] = p
        }
        
        // 把新节点插入到所属的每一层中
        for i in 0..<level {
            newNode.forwards[i] = update[i]?.forwards[i]
            update[i]?.forwards[i] = newNode
        }
        
        if levelCount < level {
            levelCount = level
        }
    }
    
    func delete(value: Int){
        // 先找到每层需要被删除节点的前驱节点
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
            } else {
                break
            }
        }
        while levelCount > 0, head.forwards[levelCount - 1] == nil {
            levelCount -= 1
        }
    }
    
    // 随机生成最高层级，假设upgradeProbability = 0.5，则：
    // 50%   的概率是 1
    // 25%   的概率是 2
    // 12.5% 的概率是 3
    // ...
    private func randomLevel() -> Int {
        var level = 1
        while Double.random(in: 0.0 ... 1.0) < Self.upgradeProbability && level < Self.maxLevel {
            level += 1
        }
        return level
    }
    
    func printAll() {
        var p = head
        print("The level count of list is \(levelCount)")
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
    list.find(value: 1)
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
    list.find(value: 3)
}

testCase("4") {
    list.delete(value: 1)
    list.delete(value: 10)
    list.delete(value: 3)
    list.delete(value: 8)
    list.delete(value: 6)
}

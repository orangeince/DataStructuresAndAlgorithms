import Foundation

/// 实现一个哈希表，使用单链表的方式解决哈希冲突
class IntHashTable {
    /// 单链表节点
    class Node {
        let value: Int
        var next: Node?
        init(value: Int, next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    /// 单链表数组, 通过hash函数计算出来的结果即为对应的数组下标
    var nodes: [Node?] = Array.init(repeating: nil, count: 10)
    
    func add(value: Int) {
        let h = hashValue(for: value)
        let n = Node(value: value)
        guard var prev = nodes[h] else {
            nodes[h] = n
            return
        }
        while let next = prev.next {
            prev = next
        }
        prev.next = n
    }
    
    func delete(value: Int) {
        let h = hashValue(for: value)
        guard var p = nodes[h] else {
            return
        }
        guard p.value != value else {
            nodes[h] = p.next
            return
        }
        while let n = p.next {
            if n.value == value {
                p.next = n.next
                return
            }
            p = n
        }
    }
    
    // 散列函数
    private func hashValue(for v: Int) -> Int {
        return v % 10
    }
    
    func contains(_ value: Int) -> Bool {
        let h = hashValue(for: value)
        guard var prev = nodes[h] else {
            return false
        }
        while let next = prev.next {
            if prev.value == value {
                return true
            }
            prev = next
        }
        return prev.value == value
    }
}

let asert: (Int,()->Bool)->() = { flag, condition in
    print(condition() ? "testcase{\(flag)}: Succeed✅" : "testcast{\(flag)}: Failed❌")
}
let table = IntHashTable()
asert(0) {
    !table.contains(0)
}
table.add(value: 0)
asert(1) {
    table.contains(0)
}
asert(2) {
    !table.contains(10)
}
table.add(value: 10)
asert(3) {
    table.contains(10)
}
asert(4) {
    !table.contains(2)
}
table.add(value: 2)
table.add(value: 3)
table.add(value: 4)
table.add(value: 5)
table.add(value: 6)
table.add(value: 7)
table.add(value: 8)
table.add(value: 9)
table.add(value: 11)
table.add(value: 13)
asert(5) {
    table.contains(3)
}
table.add(value: 23)
asert(6) {
    table.contains(23)
}
table.delete(value: 13)
asert(7) {
    !table.contains(13)
}
asert(8) {
    table.contains(23)
}
table.delete(value: 3)
asert(9) {
    table.contains(23)
}
table.delete(value: 23)
asert(10) {
    !table.contains(23)
}


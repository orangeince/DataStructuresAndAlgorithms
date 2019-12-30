import Foundation

protocol HashKeyType: Equatable {
    var hv: Int { get }
}
extension Int: HashKeyType {
    var hv: Int { return self }
}

/// 实现一个哈希表，使用单链表的方式解决哈希冲突
class HashTable<K: HashKeyType, V> {
    /// 单链表节点
    class Node<K,V> {
        let key: K
        let value: V
        var next: Node<K,V>?
        init(key: K, value: V, next: Node<K, V>? = nil) {
            self.key = key
            self.value = value
            self.next = next
        }
    }
    private var length: Int
    /// 单链表数组, 通过hash函数计算出来的结果即为对应的数组下标
    var nodes: [Node<K,V>?]
    
    init(length: Int) {
        self.length = length
        nodes = Array.init(repeating: nil, count: length)
    }
    
    func add(key: K, value: V) {
        let h = hashValue(for: key)
        let n = Node(key: key, value: value)
        guard var prev = nodes[h] else {
            nodes[h] = n
            return
        }
        if prev.key == key {
            return
        }
        while let next = prev.next {
            if next.key == key {
                return
            }
            prev = next
        }
        prev.next = n
    }
    
    func remove(key: K) -> Node<K,V>? {
        let h = hashValue(for: key)
        guard var p = nodes[h] else {
            return nil
        }
        guard p.key != key else {
            nodes[h] = p.next
            return p
        }
        while let n = p.next {
            if n.key == key {
                p.next = n.next
                return n
            }
            p = n
        }
        return nil
    }
    
    func search(key: K) -> Node<K, V>? {
        let h = hashValue(for: key)
        guard var p = nodes[h] else {
            return nil
        }
        guard p.key != key else {
            return p
        }
        while let n = p.next {
            if n.key == key {
                return n
            }
            p = n
        }
        return nil
    }
    
    // 散列函数
    private func hashValue(for key: K) -> Int {
        return key.hv % length
    }
    
    func contains(_ key: K) -> Bool {
        let h = hashValue(for: key)
        guard var prev = nodes[h] else {
            return false
        }
        while let next = prev.next {
            if prev.key == key {
                return true
            }
            prev = next
        }
        return prev.key == key
    }
}

let asert: (Int,()->Bool)->() = { flag, condition in
    print(condition() ? "testcase{\(flag)}: Succeed✅" : "testcast{\(flag)}: Failed❌")
}
let table = HashTable<Int, Int>(length: 10)
table.add(key:0, value: 0)
asert(0) {
    table.contains(0)
}
table.add(key: 0, value: 10)
asert(1) {
    table.search(key: 0)?.value == 0
}
table.add(key: 1, value: 1)
table.add(key: 2, value: 2)
table.add(key: 3, value: 3)
table.add(key: 4, value: 4)
table.add(key: 5, value: 5)
table.add(key: 11, value: 11)
asert(2) {
    table.contains(11)
}
asert(3) {
    table.remove(key: 1)?.value == 1
}
asert(4) {
    table.search(key: 11)?.value == 11
}

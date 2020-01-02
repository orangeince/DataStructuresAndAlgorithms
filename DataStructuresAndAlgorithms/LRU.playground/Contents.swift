import Foundation

/// LRU
protocol LRU {
    associatedtype T = Equatable
    var capacity: T { get }
    var count: T { get }
    func add(item: T)
    func remove(item: T)
    func contains(item: T) -> Bool
    func printAll()
    var firstValue: T? { get }
    func isEqual(to seq: [T]) -> Bool
    init(capacity: Int)
}


/// 使用单链表的方式实现LRU算法
class SingleLinkedListCache {
    let capacity: Int
    private(set) var count = 0
    private let head = Node(value: -1)
    
    class Node {
        let value: Int
        var next: Node?
        init(value: Int) {
            self.value = value
        }
    }
    
    /// 查询结果
    enum LookupResult {
        /// 目标节点的前驱节点
        case previousOfTarget(Node)
        /// 尾部节点的前驱节点
        case previousOfEnd(Node)
    }
    
    required init(capacity: Int) {
        self.capacity = capacity
    }
    
    var firstValue: Int? {
        return head.next?.value
    }
    
    func add(item: Int) {
        guard capacity > 0 else { return }
        let node: Node
        switch lookup(with: item) {
        case .previousOfTarget(let prev):
            node = prev.next!
            prev.next = prev.next?.next
        case .previousOfEnd(let pe):
            node = Node(value: item)
            if count < capacity {
                count += 1
            } else {
                pe.next = nil
            }
        }
        node.next = head.next
        head.next = node
    }
    
    /// 删除节点
    func remove(item: Int) {
        guard case .previousOfTarget(let prev) = lookup(with: item) else {
            return
        }
        prev.next = prev.next?.next
        count -= 1
    }
    
    /// 查询节点
    func find(item: Int) -> Node? {
        guard case .previousOfTarget(let n) = lookup(with: item)
            else { return nil }
        return n.next
    }
    
    /// 查询目标值
    ///   - returns:
    ///     1. 找到目标值则返回目标节点的前驱节点
    ///     2. 否则返回尾部节点的前驱节点
    private func lookup(with item: Int) -> LookupResult {
        var p = head
        while let n = p.next {
            if n.value == item {
                return .previousOfTarget(p)
            } else if n.next != nil {
                p = n
            } else {
                break
            }
        }
        return .previousOfEnd(p)
    }
    
    func printAll() {
        var p = head.next
        print("count: \(count), items: ", terminator: " ")
        while let n = p {
            print("\(n.value) ", terminator: " ")
            p = n.next
        }
        print()
    }
    
    func contains(item: Int) -> Bool {
        return find(item: item) != nil
    }
    
    /// 验证数据的序列是否正确
    func isEqual(to seq: [Int]) -> Bool {
        guard count == seq.count else { return false }
        var p = head.next
        for i in 0..<seq.count {
            guard let n = p, n.value == seq[i] else {
                return false
            }
            p = n.next
        }
        return p == nil
    }
}

extension SingleLinkedListCache: LRU {}

/// 使用哈希表+双向链表实现LRU缓存
class HashTableLinkedCache: LRU {
    let head: Node = Node(value: -1)
    let capacity: Int
    var count: Int = 0
    var firstValue: Int? {
        return head.next?.value
    }
    
    /// 双向链表
    class Node {
        let value: Int
        var next: Node?
        var prev: Node?
        var hNext: Node?
        init(value: Int, next: Node? = nil, prev: Node? = nil, hNext: Node? = nil) {
            self.value = value
            self.next = next
            self.prev = prev
            self.hNext = hNext
        }
    }
    
    class HashTable {
        let capacity: Int
        let table: [Node?]
        init(capacity: Int) {
            self.capacity = capacity
            table = Array.init(repeating: nil, count: 10)
        }
        
    }
    
    required init(capacity: Int) {
        self.capacity = capacity
    }
    
    func add(item: Int) {
        
    }
    func remove(item: Int) {
    }
    func printAll() {
    }
    func contains(item: Int) -> Bool {
        return false
    }
    func isEqual(to seq: [Int]) -> Bool {
        return false
    }
}

let asert: (String,()->Bool)->() = { flag, condition in
    print(condition() ? "\(flag): Succeed✅" : "\(flag): Failed❌")
}


func test<T: LRU>(implementation: T.Type) where T.T == Int {
    print("-- This is test for \(implementation) --")
    let store = implementation.init(capacity: 3)
    store.add(item: 0)
    asert("1") {
        store.contains(item: 0)
    }
    store.printAll()
    
    store.add(item: 1)
    asert("2.1") {
        store.count == 2
    }
    asert("2.2") {
        store.isEqual(to: [1, 0])
    }
    
    store.remove(item: 1)
    asert("3") {
        store.isEqual(to: [0])
    }
    
    store.add(item: 1)
    store.add(item: 2)
    asert("4") {
        store.isEqual(to: [2,1,0])
    }
    store.printAll()
    
    store.add(item: 3)
    asert("5") {
        store.isEqual(to: [3,2,1])
    }
    store.printAll()
    
    store.add(item: 2)
    asert("6") {
        store.isEqual(to: [2,3,1])
    }
    store.printAll()
    
    store.remove(item: 3)
    asert("7") {
        store.isEqual(to: [2,1])
    }
    store.remove(item: 2)
    asert("8") {
        store.firstValue == 1
    }
    store.printAll()
    
    store.remove(item: 1)
    asert("9") {
        store.count == 0
    }
}

test(implementation: SingleLinkedListCache.self)
test(implementation: HashTableLinkedCache.self)

import Foundation

/// LRU

class Node {
    let value: Int
    var prev: Node?
    var next: Node?
    init(value: Int) {
        self.value = value
    }
}

class CacheStore {
    let head = Node(value: -1)
    let capacity: Int
    var tail: Node?
    var count = 0
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func add(item: Int) {
        guard capacity > 0 else { return }
        if let n = find(item: item) {
            guard n !== head.next else {
                return
            }
            if n === tail && n.prev !== head {
                tail = n.prev
            }
            n.prev?.next = n.next
            head.next?.prev = n
            n.next = head.next
            head.next = n
            n.prev = head
        } else {
            let node = Node(value: item)
            node.prev = head
            node.next = head.next
            head.next?.prev = node
            head.next = node
            if tail == nil {
                tail = node
                count += 1
            } else if count < capacity {
                count += 1
            } else {
                tail = tail?.prev
                tail?.next = nil
            }
        }
    }
    
    func delete(item: Int) {
        guard let n = find(item: item) else {
            return
        }
        if n === tail {
            tail = n === head.next ? nil : n.prev
        }
        n.prev?.next = n.next
        n.next?.prev = n.prev
        count -= 1
    }
    
    func find(item: Int) -> Node? {
        var p = head.next
        while let n = p, n.value != item {
            p = n.next
        }
        return p
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
    
    func isEqual(to seq: [Int]) -> Bool {
        guard count == seq.count else { return false }
        var p = head.next
        for i in 0..<seq.count {
            guard let n = p, n.value == seq[i] else {
                return false
            }
            p = n.next
        }
        return true
    }
}

let asert: (String,()->Bool)->() = { flag, condition in
    print(condition() ? "\(flag): Succeed✅" : "\(flag): Failed❌")
}

let store = CacheStore(capacity: 3)
store.add(item: 0)
asert("1") {
    store.count == 1
}
asert("2") {
    store.find(item: 0) != nil
}
store.add(item: 1)
asert("3") {
    store.count == 2
}
store.delete(item: 1)
asert("4.1") {
    store.count == 1
}
store.add(item: 1)
store.add(item: 2)
asert("4.2") {
    store.head.next?.value == 2
}
asert("4.3") {
    store.tail?.value == 0
}
store.printAll()
store.add(item: 3)
asert("5") {
    store.count == 3
}
store.printAll()
asert("6") {
    store.head.next?.value == 3
}
asert("7") {
    store.tail?.value == 1
}
store.add(item: 4)
store.printAll()
store.add(item: 2)
asert("8") {
    store.isEqual(to: [2,4,3])
}
store.delete(item: 4)
asert("9") {
    store.isEqual(to: [2,3])
}
store.delete(item: 2)
asert("10") {
    store.isEqual(to: [3])
}
store.printAll()
store.delete(item: 3)
asert("11") {
    store.head.next == nil
}
asert("12") {
    store.tail == nil
}
asert("13") {
    store.count == 0
}

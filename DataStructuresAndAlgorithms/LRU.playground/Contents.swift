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
            if n === tail {
                if n.prev === head {
                    tail = nil
                } else {
                    tail = n.prev
                }
            }
            n.prev?.next = n.next
            head.next = n
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
        n.prev?.next = n.next
        if n === tail {
            tail = nil
        }
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

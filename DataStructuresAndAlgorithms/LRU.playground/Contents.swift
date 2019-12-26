import Foundation

/// LRU

class Node {
    let value: Int
    var next: Node?
    init(value: Int) {
        self.value = value
    }
}

class CacheStore {
    let head = Node(value: -1)
    let capacity: Int
    var count = 0
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func add(item: Int) {
        guard capacity > 0 else { return }
        let previous = findPrevious(of: item)
        let node = previous?.next ?? Node(value: item)
        previous?.next = previous?.next?.next
        node.next = head.next
        head.next = node
        if count < capacity {
            count += 1
        } else {
            previous?.next = nil
        }
    }
    
    func delete(item: Int) {
        guard let n = findPrevious(of: item) else {
            return
        }
        n.next = n.next?.next
        count -= 1
    }
    
    func find(item: Int) -> Node? {
        return findPrevious(of: item)?.next
    }
    
    private func findPrevious(of item: Int) -> Node? {
        var p = head
        while let n = p.next {
            if n.value == item {
                return p
            }
            p = n
        }
        return nil
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
store.printAll()
store.add(item: 3)
asert("5") {
    store.count == 3
}
store.printAll()
asert("6") {
    store.head.next?.value == 3
}
store.add(item: 4)
store.printAll()
store.add(item: 2)
asert("8") {
    store.isEqual(to: [2,4,3])
}
store.printAll()
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
asert("13") {
    store.count == 0
}
let s = CacheStore(capacity: 0)
s.add(item: 0)
asert("14") {
    s.count == 0
}

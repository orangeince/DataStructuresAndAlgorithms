import Foundation

protocol QueueType {
    associatedtype T
    func enqueue(_ element: T) -> Bool
    func dequeue() -> T?
    func printDetail()
}

/// Implement queue using array
class ArrayQueue<T>: QueueType {
    private var elements: [T] = []
    private(set) var capacity: Int = 0
    private var headIdx: Int = 0
    private var tailIdx: Int = 0
    
    var isEmpty: Bool {
        return headIdx == tailIdx
    }
    var isFull: Bool {
        return tailIdx - headIdx < capacity
    }
    
    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func enqueue(_ element: T) -> Bool {
        guard isFull else { return false }
        if tailIdx == capacity, headIdx > 0 {
            elements.removeFirst(headIdx)
            tailIdx -= headIdx
            headIdx = 0
        }
        elements.append(element)
        tailIdx += 1
        return true
    }
    
    func dequeue() -> T? {
        guard !isEmpty else { return nil }
        let element = elements[headIdx]
        headIdx += 1
        return element
    }
    
    func printDetail() {
        print(elements[headIdx ..< tailIdx])
    }
}

/// Implement queue using linked list
class Node<T> {
    var element: T
    var next: Node<T>?
    
    init(_ element: T) {
        self.element = element
    }
}

class LinkedListQueue<T>: QueueType {
    private(set) var capacity: Int
    private var count: Int = 0
    private var head: Node<T>?
    private var tail: Node<T>?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    var isFull: Bool {
        return count == capacity
    }

    init(capacity: Int) {
        self.capacity = capacity
    }
    
    func enqueue(_ element: T) -> Bool {
        guard !isFull else { return false }
        let node = Node(element)
        if head == nil {
            head = node
        }
        tail?.next = node
        tail = node
        return true
    }
    
    func dequeue() -> T? {
        guard let element = head?.element else { return nil }
        head = head?.next
        if head == nil {
            tail = nil
        }
        return element
    }
    
    func printDetail() {
        print("head: \(head?.element)", "tail: \(tail?.element)", separator: ", ", terminator: " | ")
        var node = head
        while let n = node {
            print(n.element, terminator: " ")
            node = node?.next
        }
        print()
    }
}

// 使用数组实现循环队列
class CircularArrayQueue<T>: QueueType {
    private var elements: [T] = []
    private var head: Int = 0
    private var tail: Int = 0
    private(set) var capacity: Int
    private(set) var size: Int

    var isEmpty: Bool { return size == 0 }
    var isFull: Bool { return size == capacity }

    init(capacity: Int) {
        self.capacity = capacity
        self.size = 0
    }
    
    func enqueue(_ element: T) -> Bool {
        guard !isFull else {
            return false
        }
        if elements.count < capacity {
            elements.append(element)
        } else {
            elements[tail] = element
        }
        tail = (tail + 1) % capacity
        size += 1
        return true
    }
    
    func dequeue() -> T? {
        guard !isEmpty else { return nil }
        let element = elements[head]
        head = (head + 1) % capacity
        size -= 1
        return element
    }
    
    func printDetail() {
        print("head: \(head)",
            "tail: \(tail)",
            separator: " , ",
            terminator: " | ")
        if isEmpty {
            print(" []")
        } else {
            if tail > head {
                for i in head ..< tail {
                    print(elements[i], terminator: " ")
                }
            } else {
                for i in head ..< elements.endIndex {
                    print(elements[i], terminator: " ")
                }
                for i in 0 ..< tail {
                    print(elements[i], terminator: " ")
                }
            }
            print()
        }
    }
}


//let queue: QueueType = ArrayQueue<Int>(capacity: 3)
//let queue = LinkedListQueue<Int>(capacity: 3)
let queue = CircularArrayQueue<Int>(capacity: 3)
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
queue.printDetail()
queue.dequeue()
queue.dequeue()
queue.dequeue()
queue.printDetail()
queue.dequeue()
queue.enqueue(1)
queue.printDetail()
queue.dequeue()
queue.enqueue(4)
queue.printDetail()
queue.enqueue(5)
queue.enqueue(6)
queue.printDetail()

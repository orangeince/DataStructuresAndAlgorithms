import Foundation

/// Implement queue using array
class ArrayQueue<T> {
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

class Node<T> {
    var element: T
    var next: Node<T>?
    
    init(_ element: T) {
        self.element = element
    }
}

let queue = ArrayQueue<Int>(capacity: 3)
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
queue.enqueue(4)
queue.printDetail()
queue.enqueue(4)
queue.printDetail()

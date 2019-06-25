import Foundation


class Node<T> {
    let element: T
    var next: Node<T>?
    init(_ element: T, next: Node<T>? = nil) {
        self.element = element
        self.next = next
    }
}

class IndexNode<T> {
    enum DownType<T> {
        case normal(Node<T>)
        case index(IndexNode<T>)
    }
    let element: T
    var next: IndexNode<T>?
    var down: DownType<T>?
    init(_ element: T, next: IndexNode<T>? = nil, down: DownType<T>? = nil) {
        self.element = element
        self.next = next
        self.down = down
    }
}

class SkipList<T> {
    typealias List = Node<T>
    typealias IndexList = IndexNode<T>
    var list: List?
    var indexList: IndexList?
    private(set) var count: Int
    
    init(elements: [T]) {
        count = elements.count
        var last: Node<T>? = nil
        for e in elements {
            let node = Node(e)
            last?.next = node
            last = node
        }
        indexList = nil
    }
    
}


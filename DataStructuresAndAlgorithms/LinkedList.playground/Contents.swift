import Foundation

/// 链表相关的

/// 单链表反转
class ReversibleLinkedList<T> {
    class Node<T> {
        let value: T?
        var next: Node<T>?
        init(value: T?, next: Node<T>? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    let head: Node<T> = Node(value: nil)
    let count: Int
    init(elements: [T]) {
        count = elements.count
        var p: Node<T> = head
        for e in elements {
            let n = Node(value: e)
            p.next = n
            p = n
        }
    }
    
    func reverse() {
        guard count > 1 else { return }
        let p1: Node<T> = Node(value: nil, next: head.next)
        let p2: Node<T> = Node(value: nil, next: head.next?.next)
        head.next?.next = nil
        while let center = p2.next {
            p2.next = center.next
            center.next = p1.next
            p1.next = center
        }
        head.next = p1.next
    }
    
    func printAll() {
        var p = head
        while let n = p.next {
            print(n.value!, terminator: " ")
            p = n
        }
        print()
    }
}

let list = ReversibleLinkedList(elements: [1,2,5])
list.printAll()
list.reverse()
list.printAll()

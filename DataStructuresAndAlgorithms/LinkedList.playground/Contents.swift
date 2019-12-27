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

// 有序链表合并
class MargibleLinkedList {
    class Node {
        let value: Int
        var next: Node?
        init(value: Int, next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }
    
    let head = Node(value: -1)
    let count: Int

    init(elements: [Int]) {
        count = elements.count
        var p = head
        for n in elements {
            let node = Node(value: n)
            p.next = node
            p = node
        }
    }
    
    func merge(other: MargibleLinkedList) {
        guard var second = other.head.next else { return }
        guard var first = head.next else {
            head.next = second
            return
        }
        if first.value > second.value {
            (first, second) = (second, first)
        }
        head.next = first
        other.head.next = first
        while let fn = first.next {
            if fn.value <= second.value {
                first = fn
            } else {
                first.next = second
                second = fn
            }
        }
        first.next = second
    }
    
    func printAll() {
        var p = head
        while let n = p.next {
            print(n.value, terminator: " ")
            p = n
        }
        print()
    }
}

//let mlist = MargibleLinkedList(elements: [1,7,13,15])
//let other = MargibleLinkedList(elements: [2,4,6,8,14,20])
let mlist = MargibleLinkedList(elements: [2,4,7,10])
let other = MargibleLinkedList(elements: [1,3,5,6,8,9,11])
mlist.merge(other: other)
mlist.printAll()

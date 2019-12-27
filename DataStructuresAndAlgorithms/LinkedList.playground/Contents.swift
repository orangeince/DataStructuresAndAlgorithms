import Foundation

/// 链表相关的
class Node {
    let value: Int
    var next: Node?
    init(value: Int, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

protocol LinkedListType {
    var head: Node { get }
    var count: Int { get }
    func printAll()
    func isEqual(to seq: [Int]) -> Bool
}

extension LinkedListType {
    func printAll() {
        var p = head
        while let n = p.next {
            print(n.value, terminator: " ")
            p = n
        }
        print()
    }
    func isEqual(to seq: [Int]) -> Bool {
        guard !seq.isEmpty else {
            return head.next == nil
        }
        var p: Node = head
        for n in seq {
            guard let cur = p.next, cur.value == n
                else { return false }
            p = cur
        }
        return p.next == nil
    }
}

class LinkedList: LinkedListType {
    let head: Node = Node(value: -1)
    var count: Int = 0
    init(elements: [Int]) {
        count = elements.count
        var p = head
        for e in elements {
            let n = Node(value: e)
            p.next = n
            p = n
        }
    }
}


// 测试用例集合
let testCollection: (String) -> ((Int, ()->Bool) ->()) = { name in
    print("-- Begin test for <\(name)>")
    return { n, condition in
        print("case{\(n)}", terminator: ": ")
        condition() ? print("Succeed✅") : print("Failed❌")
    }
}

/// 单链表反转
class ReversibleLinkedList: LinkedList {
    func reverse() {
        guard count > 1 else { return }
        guard var p1 = head.next, var p2 = head.next?.next else {
            return
        }
        p1.next = nil
        while let node = p2.next {
            p2.next = p1
            p1 = p2
            p2 = node
        }
        p2.next = p1
        head.next = p2
    }
}

let list = ReversibleLinkedList(elements: [1,2,3,4,5])
let tc1 = testCollection("ReversibleLinkedList")
tc1(0) {
    list.isEqual(to: [1,2,3,4,5])
}
list.reverse()
tc1(1) {
    list.isEqual(to: [5,4,3,2,1])
}
list.printAll()

// 有序链表合并
class MargibleLinkedList: LinkedList {
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
}

let mlist = MargibleLinkedList(elements: [2,4,7,10])
let other = MargibleLinkedList(elements: [1,3,5,6,8,9])
let tc2 = testCollection("MargibleLinkedList")
mlist.merge(other: other)
tc2(0) {
    mlist.isEqual(to: [1,2,3,4,5,6,7,8,9,10])
}

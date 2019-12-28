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

let tc1 = testCollection("ReversibleLinkedList")
var list = ReversibleLinkedList(elements: [1,2,3,4,5])
list.reverse()
tc1(0) {
    list.isEqual(to: [5,4,3,2,1])
}
list = ReversibleLinkedList(elements: [1,2])
list.reverse()
tc1(1) {
    list.isEqual(to: [2,1])
}
list = ReversibleLinkedList(elements: [1])
list.reverse()
tc1(2) {
    list.isEqual(to: [1])
}
list = ReversibleLinkedList(elements: [])
list.reverse()
tc1(3) {
    list.isEqual(to: [])
}

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

let tc2 = testCollection("MargibleLinkedList")
var mlist = MargibleLinkedList(elements: [2,4,7,10])
var other = MargibleLinkedList(elements: [1,3,5,6,8,9])
mlist.merge(other: other)
tc2(0) {
    mlist.isEqual(to: [1,2,3,4,5,6,7,8,9,10])
}
mlist = MargibleLinkedList(elements: [2])
other = MargibleLinkedList(elements: [1])
mlist.merge(other: other)
tc2(1) {
    mlist.isEqual(to: [1,2])
}
mlist = MargibleLinkedList(elements: [1])
other = MargibleLinkedList(elements: [2])
mlist.merge(other: other)
tc2(2) {
    mlist.isEqual(to: [1,2])
}
mlist = MargibleLinkedList(elements: [1])
other = MargibleLinkedList(elements: [])
tc2(3) {
    mlist.isEqual(to: [1])
}

// 链表的中间节点
class CentralLinkedList: LinkedList {
    func center() -> Node? {
        var first = head.next
        var second = head.next
        while let n = second?.next?.next {
            first = first?.next
            second = n
        }
        return first
    }
}
let tc3 = testCollection("CentralLinkedList")
var clist = CentralLinkedList(elements: [1,2,3,4,5])
tc3(0) {
    clist.center()?.value == 3
}
clist = CentralLinkedList(elements: [1,2])
tc3(1) {
    clist.center()?.value == 1
}
clist = CentralLinkedList(elements: [1])
tc3(2) {
    clist.center()?.value == 1
}
clist = CentralLinkedList(elements: [1,2,3,4])
tc3(3) {
    clist.center()?.value == 2
}
clist = CentralLinkedList(elements: [1,2,3,4,5,6,7,8,9])
tc3(4) {
    clist.center()?.value == 5
}
clist = CentralLinkedList(elements: [1,2,3,4,5,6,7,8,9,10])
tc3(5) {
    clist.center()?.value == 5
}

class CircularLinkedList: LinkedList {
    init(elements: [Int], circleStartAt index: Int) {
        super.init(elements: elements)
        guard index >= 0 else { return }
        var p = head
        var start: Node? = nil
        var i = 0
        while let n = p.next {
            p = n
            if i == index {
                start = n
            } else {
                i += 1
            }
        }
        p.next = start
    }
    
    var isCircular: Bool {
        var slow = head
        var fast = head
        while let sn = slow.next, let fn = fast.next?.next {
            guard sn !== fn else { return true }
            slow = sn
            fast = fn
        }
        return false
    }
}

let tc4 = testCollection("CircularLinkedList")
let cl0 = CircularLinkedList(elements: [0,1,2,3,4,5,6], circleStartAt: 3)
tc4(0) {
    cl0.isCircular
}
let cl1 = CircularLinkedList(elements: [0,1], circleStartAt: 0)
tc4(1) {
    cl1.isCircular
}
let cl2 = CircularLinkedList(elements: [0], circleStartAt: 0)
tc4(2) {
    cl2.isCircular
}
let cl3 = CircularLinkedList(elements: [0, 1], circleStartAt: 1)
tc4(3) {
    cl3.isCircular
}
let cl4 = CircularLinkedList(elements: [0, 1], circleStartAt: -1)
tc4(4) {
    !cl4.isCircular
}

extension LinkedList {
    // 删除第N个节点
    func remove(at index: Int) -> Node? {
        guard count > 0 && index >= 0 && index < count else { return nil }
        var p: Node = head
        var i = 0
        while let n = p.next, i < index {
            p = n
            i += 1
        }
        let result = p.next
        p.next = p.next?.next
        count -= 1
        return result
    }
    
}
let tc5 = testCollection("LinkedList.remove(at:)")
let l5 = LinkedList(elements: [0,1,2,3,4])
let removed = l5.remove(at: 0)
tc5(0) {
    l5.isEqual(to: [1,2,3,4])
}
tc5(1) {
    removed?.value == 0
}
l5.remove(at: 3)
tc5(2) {
    l5.isEqual(to: [1,2,3])
}
l5.remove(at: 2)
l5.remove(at: 0)
l5.remove(at: 0)
tc5(3) {
    l5.count == 0
}

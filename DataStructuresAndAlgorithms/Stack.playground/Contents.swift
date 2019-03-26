import Foundation

// 1. Implementing a stack using link
class Node<T> {
    var element: T
    var next: Node<T>?
    init(element: T, next: Node<T>? = nil) {
        self.element = element
        self.next = next
    }
}
class LinkStack<T> {
    var head: Node<T>?
    /// number of items in this stack
    private(set) var count: Int = 0
    
    func push(_ element: T) {
        let node = Node(element: element)
        node.next = head
        head = node
        count += 1
    }
    
    func pop() -> T? {
        guard let head = head else {
            return nil
        }
        self.head = head.next
        count -= 1
        return head.element
    }
    
    func printDetail() {
        var node = head
        print("Count: \(count), Items: ", "[", terminator: " ")
        while node != nil {
            print(node!.element, terminator: " ")
            node = node!.next
        }
        print("]")
    }
}

// 2. Test
let iStack = LinkStack<Int>()
iStack.push(1)
iStack.push(2)
iStack.push(3)
assert(iStack.count == 3)
iStack.printDetail()
iStack.pop()
assert(iStack.pop() == 2)
iStack.printDetail()
assert(iStack.count == 1)

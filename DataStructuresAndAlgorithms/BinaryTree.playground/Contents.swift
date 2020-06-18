import Foundation

// part1.二叉树的遍历
class Tree {
    var root: Node
    init(root: Node) {
        self.root = root
    }
    enum OrderType {
        // 前序
        case pre
        // 中序
        case `in`
        // 后序
        case post
        // 逐层
        case floor
    }
    
    func orderTest(type: OrderType) {
        switch type {
        case .pre:
          preOrder(node: root)
        case .in:
            inOrder(node: root)
        case .post:
            postOrder(node: root)
        case .floor:
            floorOrder(node: root)
        }
    }

    private func preOrder(node: Node?) {
        guard let root = node else { return }
        print(root.value)
        preOrder(node: root.left)
        preOrder(node: root.right)
    }
    private func inOrder(node: Node?) {
        guard let root = node else { return }
        inOrder(node: root.left)
        print(root.value)
        inOrder(node: root.right)
    }
    private func postOrder(node: Node?) {
        guard let root = node else { return }
        postOrder(node: root.left)
        postOrder(node: root.right)
        print(root.value)
    }
    
    private func floorOrder(node: Node?) {
        guard let root = node else { return }
        var queue = [root]
        while !queue.isEmpty {
            let n = queue.removeFirst()
            print(n.value)
            if let l = n.left {
                queue.append(l)
            }
            if let r = n.right {
                queue.append(r)
            }
        }
    }
    
    //      0
    //     / \
    //    1   2
    //   / \   \
    //  3  4    5
    //    /    /
    //   6    7
    static func build() -> Tree {
        let root = Node(0)
        let l1 = Node(1)
        let r1 = Node(2)
        let l2 = Node(3)
        let r2 = Node(4)
        let r3 = Node(5)
        let l3 = Node(6)
        let l4 = Node(7)
        root.left = l1
        root.right = r1
        l1.left = l2
        l1.right = r2
        r1.right = r3
        r2.left = l3
        r3.left = l4
        return Tree(root: root)
    }
}

class Node {
    var value: Int
    var left: Node?
    var right: Node?
    init(_ value: Int) {
        self.value = value
    }
}
let tree1 = Tree.build()
print("PreOrder：")
tree1.orderTest(type: .pre)
print("InOrder：")
tree1.orderTest(type: .in)
print("PostOrder：")
tree1.orderTest(type: .post)
print("FloorOrder:")
tree1.orderTest(type: .floor)

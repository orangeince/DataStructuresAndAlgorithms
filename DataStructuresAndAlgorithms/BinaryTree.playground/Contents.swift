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

// Part2.二叉查找树
class BinarySearchTree: Tree {
    //     13
    //    /  \
    //   8    15
    //  / \     \
    // 7   11    20
    //          /
    //         17
    static func buildSearchTree() -> BinarySearchTree {
        let r = Node(13)
        let l1 = Node(8)
        r.left = l1
        l1.left = Node(7)
        l1.right = Node(11)
        
        let r1 = Node(15)
        r.right = r1
        let r2 = Node(20)
        r1.right = r2
        r2.left = Node(17)
        
        return BinarySearchTree(root: r)
    }
    
    func find(value: Int) -> Node? {
        return find(value: value, node: root)
    }
    
    func findRelated(value: Int) {
        guard root.value != value else {
            print("isRoot: \(value)")
            return
        }
        var parent = root
        var nextNode: Node? = value < root.value ? root.left : root.right
        while let n = nextNode  {
            if n.value == value {
                print("Find!! parent: \(parent.value), left: \(n.left?.value), right: \(n.right?.value)")
                return
            }
            nextNode = value < n.value ? n.left : n.right
            parent = n
        }
        print("not find!")
    }
    
    func insert(value: Int) {
        // left
        var parentNode: Node? = root
        while let node = parentNode {
            if node.value > value {
                if node.left == nil {
                    node.left = Node(value)
                    print("parent: \(node.value) -> left")
                    return
                }
                parentNode = node.left
            } else {
                if node.right == nil {
                    node.right = Node(value)
                    print("parent: \(node.value) -> right")
                    return
                }
                parentNode = node.right
            }
        }
    }

    func delete(value: Int) {
        var parentNode: Node = root
        var nextNode: Node? = root
        while let node = nextNode, node.value != value {
            nextNode = node.value > value ? node.left : node.right
            parentNode = node
        }
        guard let node = nextNode else { return } // 没找到节点
        let newNode: Node?
        if node.left != nil && node.right != nil {
            var rightMin = node.right!
            var minParent = node.right!
            while let n = rightMin.left {
                minParent = rightMin
                rightMin = n
            }
            rightMin.left = node.left
            if rightMin !== node.right {
                rightMin.right = node.right
                minParent.left = nil
            }
            newNode = rightMin
        } else {
            newNode = node.left ?? node.right
        }
        
        if parentNode.value > value {
            parentNode.left = newNode
        } else {
            parentNode.right = newNode
        }
    }

    private func find(value: Int, node: Node?) -> Node? {
        guard let root = node else { return nil  }
        switch root.value - value {
        case 0:
            return root
        case ..<0:
            return find(value: value, node: root.right)
        default:
            return find(value: value, node: root.left)
        }
    }
    
    // 查询树的层数
    func getLevels() -> Int {
        return levels(of: root)
    }
    private func levels(of node: Node?) -> Int {
        guard let root = node else { return 0 }
        return max(levels(of: root.left), levels(of: root.right)) + 1
    }
    
}

let bs = BinarySearchTree.buildSearchTree()
print(bs.find(value: 7) != nil)
print(bs.find(value: 14) != nil)
bs.insert(value: 10)
bs.delete(value: 15)
bs.findRelated(value: 20)
bs.findRelated(value: 10)
bs.delete(value: 8)
bs.findRelated(value: 10)
bs.getLevels()

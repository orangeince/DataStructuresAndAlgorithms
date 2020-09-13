import Foundation

class Heap {
    private var values: [Int] = [0]

    init(values: [Int] = []) {
        self.values = self.values + values
        var i = values.count / 2
        while i >= 1 {
            heapify(at: i, endIndex: values.count - 1)
            i -= 1
        }
    }
    
    func sorted() -> [Int] {
        var cache = values
        var k = values.count - 1
        while k > 1 {
            swap(1, k)
            k -= 1
            heapify(at: 1, endIndex: k)
        }
        (cache, values) = (values, cache)
        cache.removeFirst()
        return cache
    }
    
    func insert(value: Int) {
        let index = values.count
        values.append(value)
        adjust(at: index)
    }
    
    func find(value: Int) -> Int? {
        guard values.count > 1 else {
            return nil
        }
        
        func find(value: Int, startAt: Int) -> Int? {
            guard startAt < values.count else {
                return nil
            }
            if values[startAt] == value {
                return startAt
            } else if values[startAt] < value {
                return nil
            } else {
                if let idx = find(value: value, startAt: 2*startAt) {
                    return idx
                } else {
                    return find(value: value, startAt: 2*startAt + 1)
                }
            }
        }
        
        return find(value: value, startAt: 1)
    }
    
    func delete(value: Int) {
        guard let idx = find(value: value) else {
            return
        }
        let end = values.count - 1
        (values[end], values[idx]) = (values[idx], values[end])
        values.removeLast()
        lowAdjust(at: idx)
    }
    
    private func lowAdjust(at index: Int) {
        guard index < values.count && index*2 < values.count else {
            return
        }
        let left = index * 2
        let right = index * 2 + 1
        if right >= values.count {
            if values[left] > values[index] {
                swap(left, index)
            }
            return
        }
        if values[right] > values[left] {
            if values[right] > values[index] {
                swap(right, index)
            }
            lowAdjust(at: right)
        } else {
            if values[left] > values[index] {
                swap(left, index)
            }
            lowAdjust(at: left)
        }

    }
    private func heapify(at index: Int, endIndex: Int) {
        var i = index
        while true {
            var maxPos = i
            if i * 2 <= endIndex && values[i] < values[i * 2] {
                maxPos = i * 2
            }
            if i * 2 + 1 <= endIndex && values[maxPos] < values[i * 2 + 1] {
                maxPos = i * 2 + 1
            }
            if maxPos == i {
                break
            }
            swap(i, maxPos)
            i = maxPos
        }
    }

    private func swap(_ a: Int, _ b: Int) {
        (values[a], values[b]) = (values[b], values[a])
    }
    
    private func adjust(at index: Int) {
        guard index > 1 else {
            return
        }
        let p = index / 2
        guard values[p] < values[index] else {
            return
        }
        (values[p], values[index]) = (values[index], values[p])
        adjust(at: p)
    }

    func showAll() {
        guard values.count > 1 else {
            print("heap is empty")
            return
        }
        var queue: [Int] = [1]
        var level = 1
        while !queue.isEmpty {
            let levelCount = queue.count
            for i in 0..<levelCount {
                let n = queue[i]
                print(values[n], terminator: " ")
                if 2*n < values.count {
                    queue.append(2*n)
                }
                if 2*n + 1 < values.count {
                    queue.append(2*n + 1)
                }
            }
            queue.removeFirst(levelCount)
            level += 1
            print()
        }
        print()
    }

}
//let h = Heap(values: [0,7,5,6,4,2,1])
//h.insert(value: 3)
//h.insert(value: 8)
//h.insert(value: 9)
//h.insert(value: 19)
//h.insert(value: 11)
//h.insert(value: 12)
//h.insert(value: 13)
//h.insert(value: 14)
//h.insert(value: 7)
//h.insert(value: 27)
//h.showAll()
//h.delete(value: 6)
//h.showAll()
let h = Heap(values: [7,5,19,8,4,1,20,13,16])
h.showAll()
h.sorted()

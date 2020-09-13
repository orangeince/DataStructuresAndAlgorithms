import Foundation

class Heap {
    enum HeapType: Hashable {
        case max
        case min
    }
    var values: [Int]
    var preferredComparison: (Int, Int) -> Bool
    let type: HeapType
    var valueCount: Int {
        return values.count - 1
    }
    init(values: [Int] = [], type: HeapType = .max) {
        self.type = type
        switch type {
        case .max:
            preferredComparison = { $0 > $1}
        case .min:
            preferredComparison = { $0 < $1 }
        }
        self.values = [0] + values
        for i in (1 ... self.values.count / 2 ).reversed() {
            heapify(beginAt: i, endAt: valueCount)
        }
    }
    
    private func heapify(beginAt index: Int, endAt: Int) {
        var i = index
        while true {
            var maxPos = i
            if i * 2 <= endAt && preferredComparison(values[i * 2], values[maxPos]) {
                maxPos = i * 2
            }
            if i * 2 + 1 <= endAt && preferredComparison(values[i * 2 + 1], values[maxPos]) {
                maxPos = i * 2 + 1
            }
            if maxPos == i {
                break
            }
            swap(i, maxPos)
            i = maxPos
        }
    }
    
    private func swap(_ i: Int, _ j: Int) {
        (values[i], values[j]) = (values[j], values[i])
    }
    
    private func findIndex(of value: Int, startAt index: Int) -> Int? {
        guard index < values.count else {
            return nil
        }
        if values[index] == value {
            return index
        } else if !preferredComparison(values[index], value) {
            return nil
        } else {
            if let idx = findIndex(of: value, startAt: index * 2) {
                return idx
            } else {
                return findIndex(of: value, startAt: index * 2 + 1)
            }
        }
    }
    
    func insert(_ value: Int) {
        values.append(value)
        var i = values.count - 1
        while i >= 1 {
            let p = i / 2
            guard preferredComparison(values[i], values[p]) else {
                return
            }
            swap(i, p)
            i = p
        }
    }
    
    func delete(_ value: Int) {
        guard let idx = findIndex(of: value, startAt: 1)
            else { return }
        swap(idx, values.count - 1)
        values.removeLast()
        heapify(beginAt: idx, endAt: values.count - 1)
    }
    
    func find(_ value: Int) -> Bool {
        return findIndex(of: value, startAt: 1) != nil
    }
    
    func sorted() -> [Int] {
        var cache = values
        var i = valueCount
        while i > 1 {
            swap(1, i)
            i -= 1
            heapify(beginAt: 1, endAt: i)
        }
        (cache, values) = (values, cache)
        cache.removeFirst()
        return type == .min ? cache.reversed() : cache
    }
    
    func printAll() {
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
let h = Heap(values: [7,5,19,8,4,1,20,13,16])
h.printAll()
h.sorted()

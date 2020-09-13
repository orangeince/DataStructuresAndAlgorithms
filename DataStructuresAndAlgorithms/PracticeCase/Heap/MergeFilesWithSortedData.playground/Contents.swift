import Foundation
/*
 堆的应用实践：合并有序小文件
 问题描述： 假设我们有 100 个小文件，每个文件的大小是 100MB，每个文件中存储的都是有序的字符串(简化处理，这里使用了有序的数字代替）。我们希望将这些 100 个小文件合并成一个有序的大文件。整体思路有点像归并排序中的合并函数。我们从这 100 个文件中，各取第一个字符串，放入数组中，然后比较大小，把最小的那个字符串放入合并后的大文件中，并从数组中删除。假设，这个最小的字符串来自于 13.txt 这个小文件，我们就再从这个小文件取下一个字符串，放到数组中，重新比较大小，并且选择最小的放入合并后的大文件，将它从数组中删除。依次类推，直到所有的文件中的数据都放入到大文件为止。这里我们用数组这种数据结构，来存储从小文件中取出来的字符串。每次从数组中取最小字符串，都需要循环遍历整个数组，显然，这不是很高效。有没有更加高效方法呢？这里就可以用到优先级队列，也可以说是堆。我们将从小文件中取出来的字符串放入到小顶堆中，那堆顶的元素，也就是优先级队列队首的元素，就是最小的字符串。我们将这个字符串放入到大文件中，并将其从堆中删除。然后再从小文件中取出下一个字符串，放入到堆中。循环这个过程，就可以将 100 个小文件中的数据依次放入到大文件中。
 */
// Step0. 实现堆结构的定义
class Heap {
    enum HeapType: Hashable {
        case max
        case min
    }
    private var values: [Int]
    var preferredComparison: (Int, Int) -> Bool
    let type: HeapType
    var valueCount: Int {
        return values.count - 1
    }
    var root: Int {
        guard valueCount > 0 else {
            return -1
        }
        return values[1]
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
    func popRoot() -> Int? {
        guard values.count > 1 else { return nil }
        let root = values[1]
        delete(root)
        return root
    }
}

/*
 Step1. 随机生成一堆数字并排序，然后存入文件中
 简化处理问题，这里假设需要10个文件，每个文件是1MB
 1 Int = 64bit = 8byte
 因此每个文件要包含 1MB / 8byte = 125000 个数字
 */
func makeSmallFiles() -> [String] {
    var pathes = [String]()
    for i in 0..<10 {
        var numbers = Array<Int>.init(repeating: 0, count: 100)//125000)
        for j in 0 ..< numbers.count {
            numbers[j] = Int.random(in: 0..<12500)
        }
        numbers.sort()
        let fileName = "numbers\(i).txt"
        let url = URL(fileURLWithPath: fileName)
        numbers.saveToFile(path: url.path)
        pathes.append(url.path)
    }
    return pathes
}

// 给数组扩展便于文件读写操作的方法
extension Array where Element == Int {
    func saveToFile(path: String) {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let url = URL(fileURLWithPath: path)
            try jsonData.write(to: url)
//            print("finished wirte to file: \(url.path)")
        } catch {
            print(error.localizedDescription)
        }
    }
    init?(fromFile path: String) {
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
            self = try JSONDecoder().decode([Int].self, from: jsonData)
        } catch {
            return nil
            print(error.localizedDescription)
        }
    }
}

// 文件操作的类，用于从文件读取数组，并提取最小值
class FileReader {
    let path: String
    let index: Int
    var isEmpty: Bool
    var minValue: Int
    init?(path: String, index: Int) {
        self.path = path
        self.index = index
        guard let numbers = [Int].init(fromFile: path), !numbers.isEmpty else {
            return nil
        }
        minValue = numbers[0]
        isEmpty = numbers.isEmpty
    }
    
    func deleteMin() -> Bool {
        guard !isEmpty else { return false }
        guard var numbers = [Int].init(fromFile: path) else { return false }
        numbers.removeFirst()
        isEmpty = numbers.isEmpty
        if isEmpty {
            return false
        }
        minValue = numbers[0]
        numbers.saveToFile(path: path)
        return true
    }
    
}

// Step2. 合并小文件到一个大文件，这里便于理解思路没有把结果写入到文件，而是使用数组记录下来了
func mergeFiles(pathes: [String]) {
    var readers: [FileReader] = []
    var result: [Int] = []
    for (i, path) in pathes.enumerated() {
        if let reader = FileReader(path: path, index: i) {
            readers.append(reader)
        }
    }
    // 把每个文件的最小值放入一个小顶堆中
    let heap = Heap(values: readers.map(\.minValue), type: .min)
    /*
     每次把堆的顶部也就是最小值取出
     然后再从该值所在的文件里继续取出最小值插入堆
     如果该文件已空则堆的节点就减少
     直到堆空了则说明所有小文件的数据都已经按顺序取出
     */
    while heap.valueCount > 0, let min = heap.popRoot() {
        result.append(min)
        guard let reader = readers.first(where: {$0.minValue == min}) else {
            print("Error!!! no matched reader")
            return
        }
        if reader.deleteMin() {
            heap.insert(reader.minValue)
        }
    }
    print(result)
}
let filePathes = makeSmallFiles()
mergeFiles(pathes: filePathes)



import Foundation

// 1. 冒泡排序
func bubbleSort(_ elements: [Int]) -> [Int] {
    guard !elements.isEmpty else { return [] }
    var sorted = elements
    for i in 0 ..< sorted.count - 1 {
        for j in 1 ..< sorted.count - i {
            if sorted[j-1] > sorted[j] {
                (sorted[j], sorted[j-1]) = (sorted[j-1], sorted[j])
            }
        }
    }
    return sorted
}

let elements = [4,3,2,1,5,7,6]
bubbleSort(elements)

// 2. 插入排序
func insertionSort(_ elements: [Int]) -> [Int] {
    guard !elements.isEmpty else { return [] }
    var sorted = elements
    for i in 1 ..< sorted.count {
        for j in 0 ... i - 1 {
            if sorted[i] < sorted[j] {
                let n = sorted.remove(at: i)
                sorted.insert(n, at: j)
            }
        }
    }
    return sorted
}

insertionSort(elements)

// 3. 选择排序
func selectionSort(_ elements: [Int]) -> [Int] {
    guard !elements.isEmpty else { return [] }
    var sorted = elements
    for i in 0 ..< sorted.count - 1 {
        var min = i
        for j in i+1 ..< sorted.count {
            if sorted[j] < sorted[min] {
                min = j
            }
        }
        if i != min {
            (sorted[min], sorted[i]) = (sorted[i], sorted[min])
        }
    }
    return sorted
}
selectionSort(elements)

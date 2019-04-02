
import Foundation

// 1. 归并排序
func mergeSort(arr: [Int]) -> [Int] {
    guard arr.count > 1 else { return arr }
    let begin = 0
    let end = arr.count - 1
    let middle = (begin + end) / 2
    let head = mergeSort(arr: Array(arr[begin...middle]))
    let tail = mergeSort(arr: Array(arr[middle+1 ... end]))
    return merge(a: head, b: tail)
}

func merge(a: [Int], b: [Int]) -> [Int] {
    var result: [Int] = []
    var i = a.startIndex
    var j = b.startIndex
    while i < a.endIndex && j < b.endIndex {
        if b[j] < a[i] {
            result.append(b[j])
            j += 1
        } else {
            result.append(a[i])
            i += 1
        }
    }
    if i < a.endIndex {
        result.append(contentsOf: a.suffix(from: i))
    } else if j < b.endIndex {
        result.append(contentsOf: b.suffix(from: j))
    }
    return result
}
mergeSort(arr: [2,4,6,8,1,3,5,7])

// 2. QuickSort
func quickSort(arr: [Int]) -> [Int] {
    guard arr.count > 1 else { return arr }
    var sorted = arr
    func quickSort(source: inout [Int], begin: Int, end: Int) {
        guard begin < end else { return }
        let q = partition(arr: &source, begin: begin, end: end)
        quickSort(source: &source, begin: begin, end: q - 1)
        quickSort(source: &source, begin: q + 1, end: end)
    }
    quickSort(source: &sorted, begin: 0, end: sorted.count - 1)
    return sorted
}
func partition(arr: inout [Int], begin: Int, end: Int) -> Int {
    let n = arr[end]
    var i = begin
    for j in begin ... end-1 {
        if arr[j] < n {
            (arr[j], arr[i]) = (arr[i], arr[j])
            i += 1
        }
    }
    (arr[i], arr[end]) = (arr[end], arr[i])
    return i
}

quickSort(arr: [1,3,5,2,4,6])

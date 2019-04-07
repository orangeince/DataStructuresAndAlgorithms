import Foundation

// 计数排序(Counting sort)
func countingSort(_ origin: [Int]) -> [Int] {
    guard origin.count > 0 else {
        return origin
    }
    
    // 确定数组中数据的范围
    var max = origin[0]
    for n in origin {
        if n > max {
            max = n
        }
    }
    
    var countingArr = Array<Int>(repeating: 0, count: max + 1)
    // 计算每个元素的个数，放入countingArr
    for i in 0..<origin.count {
        countingArr[origin[i]] += 1
    }
    
    // 依次累加
    for i in 1...max {
        countingArr[i] = countingArr[i - 1] + countingArr[i]
    }
    
    // 临时数组r，存储排序之后的结果
    var r = Array<Int>(repeating: 0, count: origin.count)
    for i in (0..<r.count).reversed() {
        let idx = countingArr[origin[i]] - 1
        r[idx] = origin[i]
        countingArr[origin[i]] -= 1
    }
    return r
}

countingSort([2,4,6,1,3,5,7,1,4,7,2,4,5])

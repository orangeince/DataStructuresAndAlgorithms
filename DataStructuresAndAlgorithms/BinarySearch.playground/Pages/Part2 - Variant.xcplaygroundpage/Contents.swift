//: [Previous](@previous)

import Foundation


enum Type {
    case isFirst
    case isLast
}
// 查找第一个或最后一个值等于给定值的元素
func bSearch1(arr: [Int], value: Int, type: Type) -> Int? {
    guard !arr.isEmpty else {
        return nil
    }
    var low = arr.startIndex
    var high = arr.endIndex
    var find: Int?
    while low < high {
        let mid = low + ((high - low) >> 1)
        if arr[mid] > value {
            low = mid + 1
        } else if arr[mid] < value {
            high = mid - 1
        } else {
            find = mid
            switch type {
            case .isFirst:
                high = mid - 1
            case .isLast:
                low = mid + 1
            }
        }
    }
    return find
}

let arr = [1,2,2,2,2,3,4,5]

bSearch1(arr: arr, value: 2, type: .isFirst)
bSearch1(arr: arr, value: 2, type: .isLast)

enum Type2 {
    case firstGreatEqual
    case lastLowEqual
}
// 查找第一个大于等于或最后一个小于等于给定值的元素
func bSearch2(arr: [Int], value: Int, type: Type2) -> Int? {
    guard !arr.isEmpty else { return nil }
    var low = arr.startIndex
    var high = arr.endIndex
    var find: Int?
    while low < high {
        let mid = low + ((high - low) >> 1)
        switch type {
        case .firstGreatEqual:
            if arr[mid] < value {
                low = mid + 1
            } else {
                find = mid
                high = mid - 1
            }
        case .lastLowEqual:
            if arr[mid] > value {
                high = mid - 1
            } else {
                find = mid
                high = mid + 1
            }
        }
    }
    if low == high && find == nil {
        return low
    }
    return find
}

bSearch2(arr: arr, value: 5, type: .firstGreatEqual)
bSearch2(arr: arr, value: 1, type: .lastLowEqual)

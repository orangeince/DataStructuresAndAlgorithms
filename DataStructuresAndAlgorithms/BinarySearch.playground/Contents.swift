import Foundation


func bsearch(arr: [Int], value: Int) -> Int? {
    guard !arr.isEmpty else { return nil }
    var low = arr.startIndex
    var high = arr.endIndex - 1
    while low <= high {
        let mid = low + (high - low) / 2
        if arr[mid] == value {
            return mid
        } else if arr[mid] > value {
            high = mid - 1
        } else {
            low = mid + 1
        }
    }
    return nil
}

print(bsearch(arr: [1,2,3,5,7,9,84], value: 110))


func bsearchR(arr: [Int], value: Int) -> Int? {
    guard !arr.isEmpty else { return nil }
    let mid = (arr.endIndex - 1 - arr.startIndex) / 2
    if arr[mid] == value {
        return mid
    } else if arr[mid] > value {
        return bsearchR(arr: Array(arr[mid+1 ..< arr.endIndex]), value: value)
    } else {
        return bsearchR(arr: Array(arr[arr.startIndex ..< mid]), value: value)
    }
}

print(bsearch(arr: [1,2,3,5,7,9,84], value: 5))
print(bsearch(arr: [1,2,3,5,7,9,84], value: 0))
print(bsearch(arr: [1,2,3,5,7,9,84], value: 110))

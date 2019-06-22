---
title: 15. 二分查找（上）
---

## 如何用最省内存的方式实现快速查找功能

二分查找针对的是一个有序的集合，查找思想有点类似分治，每次都通过跟区间的中间元素对比，将待查找的区间缩小为之前的一半，直到找到要查找的元素，或者区间被缩小为0.

## O(logn)惊人的查找速度

二分查找是一种非常高效的查找算法。

被查找区间的大小变化：n，n/2，n/4，n/8，... ，n/2^k ...

这是一个等比数列，n/2^k=1时，k的值就是总共缩小的次数，k=logn，所以时间复杂度是O(logn).

O(logn)这种对数时间复杂度，极其高效，有时候甚至比O(1)的算法还高效。大O标记法会忽略常数、系数和低阶，对于常量级的时间复杂度算法来说，O(1)有可能表示一个非常大的常量值，比如O(1000)。

## 代码实现

简单的实现
```swift
    // 假设arr是从小到大有序的并且不重复的数组
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
```

三个易错点：
1. 循环退出条件：low ≤ high，而不是 low < high
2. mid的取值：mid=(low+high)/2可能会溢出，改成low+(high-low)/2，再改可以使用位运算代替除以2的计算
3. low和high的更新：low=mid+1, high=mid-1避免死循环。

递归实现：
```swift
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
```

## 二分查找的局限性

1. 二分查找依赖的顺序表机构，也就是支持随机访问的数组。(如果使用链表则时间复杂度暴增)
2. 二分查找针对的有序数据（适合静态数据，没有频繁的数据插入、删除操作）
3. 数据量太小不适合二分查找（当数据间的比较操作耗时，则可使用二分查找来优化)
4. 数据量太大也不适合（因为数组是需要连续的内存空间）

## 课后题

1. 编程实现“求一个数的平方根”，要求精确到小数点后6位
2. 链表实现二分查找的时间复杂度是多少？
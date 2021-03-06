---
title: 20-21. 哈希算法的应用
---
## 什么是哈希(Hash)算法

将任意长度的二进制值串映射为固定长度的二进制值串，这个映射的规则就是哈希算法。而通过映射之后得到的二进制值串就是哈希值。

哈希算法需要满足的要求：

- 从哈希值不能反向推导出原始数据（所以哈希算法也叫单向哈希算法）
- 对输入数据非常敏感，哪怕原始数据只修改了一个Bit，最后得到的哈希值也大不相同
- 散列冲突的概率要很小，对于不同的原始数据，哈希值相同的概率非常小
- 哈希算法的执行效率要尽量高效，针对较长的文本，也能快速地计算出哈希值

常见的哈希算法有：MD5、SHA等

## 哈希算法的应用场景

1. 安全加密，MD5(MD5 Message-Digest Algorithm，MD5消息摘要算法)、SHA(Secure Hash Algorithm 安全散列算法)、DES(Data Encryption Standard 数据加密标准)、AES(Advanced Encryption Standard 高级加密标准)
2. 唯一标识，对大体量数据进行数据切片然后做MD5，得出对应的唯一标识
3. 数据校验，文件下载之后的MD5校验
4. 散列函数，哈希表的散列函数会用到哈希算法
5. 负载均衡，eg. 回话粘滞的负载均衡算法（同一个客户端的所有请求都路由到同一个服务器上），对客服端IP或会话ID计算哈希值，将哈希值与服务器列表的大小进行取模运算，得到服务器编号。
6. 数据分片，eg. 1T的关键字搜索的日志文件，统计每个关键字出现的次数，数据分片到N台机器并行计算，先遍历日志文件给每个关键字做Hash并对N取模，得到机器编号，这样关键字相同的搜索记录就会被分到同一台机器上，然后每台机器各自统计分配的关键字。
7. 分布式存储，一致性哈希算法，不是简单的对数据Hash然后和机器数量N取模，因为要考虑扩容的情况，简单理解就是把哈希值定在一个区间[0,Max]内，将整个范围分成m个小区间(m远大于k)，k台机器每台负责m/k个小区间，当有新机器加入的时候，将某几个小区间的数据搬移。

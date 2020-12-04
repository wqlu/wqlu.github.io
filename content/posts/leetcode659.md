---
title: "LeetCode 659.分割数组为连续子序列"
date: 2020-12-04T21:28:01+08:00
draft: false
tags: [leetcode]
categories: ["工作"]
featured_image: 
description: 
showComments: false
---


给你一个按升序排序的整数数组`num`（可能包含重复数字），请你将它们分割成一个或多个子序列，其中每个子序列都由连续整数组成且长度至少为 3 。

如果可以完成上述分割，则返回`true`；否则，返回`false`。

**示例1：**

> **输入：** [1,2,3,3,4,5]
> **输出：** True
> **解释：** 可以分割出[1,2,3],[3,4,5]

**示例2：**

> **输入：** [1,2,3,3,4,4,5,5]
> **输出：** True
> **解释：** 可以分割出[1,2,3,4,5],[3,4,5]

**示例1：**

> **输入：** [1,2,3,3,4,4,5]
> **输出：** False

**思路：**

主要是利用hash map和小根堆的特性，借助`<key:int, value:min_heap>`来帮助我们记录以`key`结尾的所有序列的长度，选择一个短的加入进去。最后，遍历map，看是否有不符合的队列存在。

**代码：**

```c++
typedef priority_queue<int, vector<int>, greater<int>> min_heap;
class Solution {
public:
    bool isPossible(vector<int>& nums) {
        int N = nums.size();
        if (N < 3) return false;
        unordered_map<int, min_heap> m;
        for (auto &n : nums) {
            if (!m.count(n)) m[n] = min_heap();
            if (m.count(n-1)) {
                m[n].push(m[n-1].top() + 1);
                m[n-1].pop();
                if (m[n-1].empty()) {
                    m.erase(n-1);
                }
            } else {
                m[n].push(1);
            }
        
        for (auto &it : m) {
            if (it.second.top() < 3) return false;
        }
        return true;
    }
};
```
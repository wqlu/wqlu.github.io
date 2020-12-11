---
title: "Leetcode 376.摆动序列"
date: 2020-12-12T02:30:02+08:00
draft: false
tags: [leetcode]
categories: ["工作"]
featured_image: 
description: 
showComments: false
---

如果连续数字之间的差严格地在正数和负数之间交替，则数字序列称为**摆动序列**。第一个差（如果存在的话）可能是正数或负数。少于两个元素的序列也是摆动序列。

例如，`[1,7,4,9,2,5]`是一个摆动序列，因为差值`(6,-3,5,-7,3)`是正负交替出现的。相反，`[1,4,,2,5]`和`[1,7,4,5,5]`不是摆动序列，第一个序列是因为它的前两个差值都是正数，第二个序列是应为它的最后一个差值为零。

给定一个整数序列，返回作为摆动序列的最长子序列的长度。通过从原始序列删除一些（也可以不删除）元素来获得子序列，剩下的元素保持其原始顺序。

**示例1：**

> **输入：**[1,7,4,9,2,5]
>
> **输出：** 6
>
> **解释：** 整个序列均为摆动序列

**示例2：**

> **输入：**[1,17,5,10,13,15,10,5,16,8]
>
> **输出：** 7
>
> **解释：** 该序列包含几个长度为7的摆动序列，其中一个可为[1,17,10,13,10,16,8]。

**思路：**

> 使用动态规划，定义两种状态：
>
>  1. `dp[i][0]`表示从`nums[0]`到`nums[i]`的最长摆动序列长度，且`nums[i]<nums[i-1]`
>
>  2. `dp[i][1]`表示从`nums[0]`到`nums[i]`的最长摆动序列长度，且`nums[i]>nums[i-1]`

**代码：**

```c++
class Solution {
public:
    int wiggleMaxLength(vector<int>& nums) {
        int N = nums.size();
        if (N <= 1) return N;
        int dp[N][2];
        dp[0][0] = 1;
        dp[0][1] = 1;
        for (int i = 1; i < N; ++i) {
            if (nums[i] > nums[i-1]) {
                dp[i][0] = dp[i-1][0];
                dp[i][1] = dp[i-1][0]+1;
            } else if (nums[i] < nums[i-1]) {
                dp[i][0] = dp[i-1][1]+1;
                dp[i][1] = dp[i-1][1];
            } else {
                dp[i][0] = dp[i-1][0];
                dp[i][1] = dp[i-1][1];
            }
        }
        return max(dp[N-1][0], dp[N-1][1]);
    }
};
```

**解法2：**

> 利用波的思想，波峰和波谷的间隔永远只有1

```c++
class Solution {
public:
    int wiggleMaxLength(vector<int>& nums) {
        int N = nums.size();
        if (N <= 1) return N;
        int up = 1, down = 1;
        for (int i = 1; i < N; ++i) {
            if (nums[i] > nums[i-1]) {
                up = down + 1; // 如果连续递增的话，相当于跳过
            }
            if (nums[i] < nums[i-1]) {
                down = up + 1;
            }
        }
        return max(up, down);
    }
};
```
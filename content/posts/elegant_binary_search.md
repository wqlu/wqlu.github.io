---
title: "优雅的二分查找写法"
date: 2020-11-16T13:57:15+08:00
draft: false
tags: [leetcode]
categories: ["工作"]
featured_image: 
description: 
showComments: false
---

<!--
{{< spoiler >}} 隐藏文字 {{< /spoiler >}}
{{< bilibili AV号 >}} <!-- 嵌入 BiliBili 视频 -->

二分查找是一种很常用的算法，记住一个优雅写法的模板能够让我们更便利刷题。在[花花](https://space.bilibili.com/9880352)的视频里看到了这种写法，感觉很好用，记录一下

这种写法针对的搜索区间是左闭右开的`[l, r)`，输入搜索的条件，找到第一个满足此条件的下标，如果没有找到的话，则会返回`r`

```c++ binary_search.cpp
auto binary_search = [&](int l, int r, function<bool (int)> cond) {
    while (l < r) {
        int m = l + (r - l) / 2;
        if (cond(m)) r = m;
        else l = m + 1;
    }
    return l;
};

// 用法示例
int p = binary_search(0, n - 1, [&](int i) -> bool {
    return v[i] > v[i+1]; // 在[0,n-1)里找第一个满足此条件的index
});
```

但是，这种写法是有一定的局限性的，仔细观察判断条件可知，如果符合`cond`，则向左继续查找，否则向右查找

对于`[5, 7, 8, 9]`，如果`cond`是`return nums[i] < 6;`则不会返回正确的数值，这和数组的升降序有关

简而言之，对于升序，一般使用`>`或`>=`查询；降序则是`<`或`<=`；且查询条件不能是`==`

原视频如下：

{{< bilibili BV1m5411V7x7 >}}


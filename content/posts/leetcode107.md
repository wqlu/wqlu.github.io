---
title: LeetCode中遇到的问题
date: 2019-03-11 01:19:45
tags: [leetcode]
categories: [工作]
---

## LeetCode 107 vector的insert问题

在LeetCode 107题目中，本来是一个简单的遍历问题，但是由于我对vector的insert用法的不熟悉，导致出现了一个bug,最后通过调试发现inset进去的是一个{}，结果就是没效果，size还是没有改变，后来改用下面这种就可以了。

```c++
vector<vector<int>> ans;
// before
ans.insert(ans.begin(), {});
// after
ans.insert(ans.begin(), vector<int>{});
```

## 处理string对象

常用方法：

* isalnum() : 是否是字母或数字
* isalpha() : 是否是字母
* isdigit() : 是否是数字
* ispunct() : 是否是标点符号
* isspace() : 是否是空白字符
* isupper() : 是否是大写字符
* isxdigit() : 是否是十六进制 
* toupper() :
* tolower() : 
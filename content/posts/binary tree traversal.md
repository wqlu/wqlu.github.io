---
title: "二叉树的遍历"
date: 2020-10-20T21:26:16+08:00
draft: false
tags: [leetcode]
categories: [工作]
---

二叉树的遍历是面试和刷题中常见的问题，二叉树常用的为以下几种方式，其中前序、中序和后序都有`递归`和`迭代`两种方式，递归比较简单，主要记录一下迭代实现。

## 前序

Note：先把**右子节点**入栈，再**左子节点**入栈

```c++
class Solution {
public:
    vector<int> preorderTraversal(TreeNode* root) {
        vector<int> ans;
        stack<TreeNode*> s;
        if (root) s.push(root);
        while (!s.empty()) {
            TreeNode* n = s.top();
            ans.push_back(n->val);
            s.pop();
            if (n->right)
                s.push(n->right);
            if (n->left)
                s.push(n->left);
        }
        return ans;
    }
};
```

## 中序

```c++
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        if (root == nullptr) return {};
        vector<int> ans;
        stack<TreeNode*> s;
        TreeNode* curr = root;
        while (curr != nullptr || !s.empty()) {
            while (curr != nullptr) {
                s.push(curr);
                curr = curr->left;
            }
            curr = s.top();
            s.pop();
            ans.push_back(curr->val);
            curr = curr->right;
        }
        return ans;
    }
};
```

## 后序

Note: 使用stack来模拟rev_postorder, 使用deque省去了reverse步骤

![来自花花酱](https://raw.githubusercontent.com/simon-lu/ImgRepo/master/Blog/postorder.jpg)

```c++
class Solution {
public:
    vector<int> postorderTraversal(TreeNode* root) {
        if (root == nullptr) return {};
        vector<int> ans;
        stack<TreeNode*> s;
        s.push(root);
        while (!s.empty()) {
            TreeNode *n = s.top();
            s.pop();
            ans.push_back(n->val);   // O(1)
            if (n->left)
                s.push(n->left);
            if (n->right)
                s.push(n->right);
        }
        reverse(ans.begin(), ans.end());
        return ans;
    }
};

```

## 层序

```c++
class Solution {
public:
    vector<int> levelorderTraversal(TreeNode* root) {
        if (root == nullptr) return {};
        vector<int> ans;
        queue<TreeNode*> q;
        q.push(root);
        while (!q.empty()) {
            TreeNode* n = q.front();
            ans.push_back(n->val);
            if (n->left)
                q.push(n->left);
            if (n->right)
                q.push(n->right);
        }
        return ans;
    }
};
```

参考链接：

1. [Huahua's Tech Road](https://zxi.mytechroad.com/blog)
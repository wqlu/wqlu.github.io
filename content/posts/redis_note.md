---
title: "《Redis设计与实现》读书笔记"
date: 2019-11-28T21:32:13+08:00
lastmod: 2019-11-28T21:32:13+08:00
draft: false
description: ""
show_in_homepage: true
show_description: false
license: ""

tags: [Redis,读书笔记,《Redis设计与实现》]
categories: [技术]

featured_image: ""
featured_image_preview: ""

showComments: false
---

## 引言

> 每个key-value都是由对象组成的 

<!--more-->

key是字符串对象，值是五种对象中的一个（字符串、列表对象、哈希对象、集合对象、有序集合对象）

## 数据结构与对象

### 简单动态字符串（SDS）


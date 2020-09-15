---
title: "使用Travis CI简化博客流程"
date: 2020-09-15T02:01:49+08:00
draft: false
tags: [hugo]
categories: ["技术"]
featured_image: https://raw.githubusercontent.com/simon-lu/ImgRepo/master/Blog/hugo-travisci-01.jpg
description: 
showComments: true
---

<!--
{{< spoiler >}} 隐藏文字 {{< /spoiler >}}
{{< bilibili AV号 >}}
-->

## before

建立了两个repo, 一个是github page，另一个my_blog保存博客源代码，使用脚本来管理两个仓库，每次的更改都向两个仓库提交commit，不是那么的方便，后来发现了Travis CI。

## after

由于有在多个系统上写博客的习惯，所以上述的流程显的过于繁琐，现在在github page仓库建立blog分支管理源代码，使用Travis CI监控blog分支的变化，自动构建hugo环境，部署到github page master。

整个流程简化到在github page blog分支写博客，提交即可，不用再关心其他的东西。

---
title: git常用命令总结
date: 2018-03-17T08:50:16+08:00
tags: [git]
categories: [技术]
---

在github上merge了一个pull request后，想要更新本地仓库，却发现报这样的错误：

```bash
Please, commit your changes or stash them before you can merge.Aborting
```

这个原因就是本地的仓库也进行了一些修改，产生了一些冲突，我们可以采用以下方法来解决： 第一种：放弃本地的修改，直接覆盖 

```bash
git reset --hard  
git pull origin master:master
```

### 远程仓库的使用

1. 查看远程仓库

```bash
git remoote -v
```

2. 修改操作

```bash
git remote remove origin
git remote add origin xxx.git
```

### SSH登录报错 packet_write_wait:Connection to x.x.x.x port 22 Broken pipe

在客户端的~/.ssh文件夹下面新建config,添加下面的配置  

```bash
ServerAliveInterval 60
```

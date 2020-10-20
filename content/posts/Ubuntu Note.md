---
title: "Ubuntu备忘录"
date: 2020-04-25T18:46:48+08:00
lastmod: 2020-04-25T18:46:48+08:00
draft: false
description: ""
show_in_homepage: true
show_description: false
license: ''

tags: [Ubuntu,环境配置]
categories: [技术]

featured_image: ''
featured_image_preview: ''

showComments: true
---

尝试过Manjaro i3wm一段时间，还是喜欢Ubuntu 16.04经典版本，需要配置许多环境，为了方便以后查看，记录一下过程。

## 基础环境

### 1. 连接wifi

首先要安装无线驱动，有两种解决方案。一种是连接网线，更新软件源，添加附加驱动；第二种是离线安装驱动，利用U盘目录中的`pool->restricted->b->bcmwl`下的`.deb`文件，键入以下命令安装，如果发现缺少依赖，就到`pool->main`下去找。

```bash
sudo dpkg -i xxx.deb
```

### 2. 输入法

搜狗输入法 或 Rime

### 3.改键位映射

由于笔记本Z键失灵，所以把Ctrl_R改为Z

```bash
xmodmap -e "keycode 0x69 = z Z z Z"
```

### 4. home下目录更改为英文


### 5.git配置

```bash
sudo apt-get install git
git config --global user.name "xxx"
git config --global user.email "xxx"
ssh-keygen -C "xxx" -t rsa
```

`cd ~/.ssh`，复制`id_rsa.pub的内容`

### 6. hugo搭建的博客

```bash
sudo apt-get install hugo // 不推荐，因为版本过低，去官网下载
```
下载release版本速度太慢的话，在Windows下使用IDM下载
### 7.网速显示

```bash
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor
sudo apt-get update
sudo apt-get install indicator-sysmonitor
```

### 8.Oh My Zsh

```bash
sudo apt-get install zsh
chsh -s $(which zsh)
```

Log out查看是否是默认shell，`echo $SHELl`

使用[install.sh](https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/install.sh)文件来安装ohmyzshc

### 9.时间同步

```bash
sudo timedatectl set-local-rtc 1 
```

## 实用的软件

### 1. 护眼软件 -- redshift

晚上看屏幕还挺舒服，个人感觉比f.lux要好一些

```bash
sudo apt-get install redshift
```

### 2. 美化一下下

更换壁纸

安装软件

```bash
sudo apt-get install unity-tweak-tool
```

安装主题

```bash
sudo add-apt-repository ppa:noobslab/themes
sudo apt-get update
sudo apt-get install flatabulous-theme
```

更换图标

```bash
sudo add-apt-repository ppa:noobslab/icons
sudo apt-get update
sudo apt-get install ultra-flat-icons
```

### 3. 浏览器 -- firefox

### 4. 截图软件 -- shutter

### 5.快捷启动 -- Albert

```bash
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt-get update
sudo apt-get install albert
```


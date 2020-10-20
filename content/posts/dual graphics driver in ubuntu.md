---
title: Ubuntu16.04安装双显卡驱动GT750M
date: 2018-01-15 15:29
tags: [linux]
categories: [技术]
---

> 安装GT750官方驱动 可自由切换独显和核心显卡

具体步骤：  

### 1.安装显卡切换软件 打开终端，输入以下命令

```bash
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt-get update
sudo apt-get install prime-indicator
```

安装完毕后，重启。状态栏会出现切换显卡的图标，但由于驱动尚未安装，所以无法切换。

### 2.禁用系统默认驱动

系统默认是安装了开源的nouveau驱动，只能使用集成显卡，将其屏蔽后，才能安装NVIDIA的闭源驱动，输入以下命令 

```bash
sudo chmod 666 /etc/modprobe.d/blacklist.conf 
sudo vi /etc/modprobe.d/blacklist.conf
```

在blacklist.conf文件末尾添加以下内容：

```bash
blacklist nouveau
```

### 3.安装GT750M官方驱动

打开 系统设置>软件和更新>附加驱动，查看系统推荐的驱动版本，默认使用的开源版本，记录下标有(专有,tested)项的版本驱动，我的是nvidia-384 按Ctrl+Alt+F1进入命令模式，登录后，输入以下命令

```bash
sudo service lightdm stop
sudo apt-get install nvidia-384
sudo service lightdm start
```

完成后，进入图形系统，重启就好。

### 4.测试

进入系统后，可以使用状态栏的显卡切换按钮，Quick switch graphics，每次切换显卡都需要重新登录才可以，至此，结束。

### 5.后续问题

在安装完显卡驱动后，偶尔会出现软件窗口无法调整大小的情况，解决方案如下： 首先，安装compiz配置管理器：

```bash
sudo apt-get install cimpizconfig-settings-manager
```

然后，打开配置管理器：

```bash
sudo csm
```

在通用'genetal'选项中启用OpenGL，并启用插件，然后返回桌面 重置compiz：

```bash
dconf reset -f /org/compiz
```

最后，注销重启。

```bash
gnome-session-quit
```

### 参考博客

1. [ubuntu16.04 笔记本 安装双显卡驱动GTX960M 可快捷切换](http://blog.csdn.net/feishicheng/article/details/70662094)
2. [Ubuntu16.04环境下PyTorch简易安装教程](http://blog.csdn.net/red_stone1/article/details/78727096)

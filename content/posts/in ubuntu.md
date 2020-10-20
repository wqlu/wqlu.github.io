---
title: Ubuntu下面的日常
date: 2018-04-24 16:32:24
tags: [linux]
categories: [技术]
---

### 软件图标

更新了pycharm到2018.1版本，但是任务栏的图标仍然是2017版本的，于是删除了2017版本，重新创建了一个图标

```bash
sudo vi /usr/share/applications/pycharm.desktop
```

填写以下的内容：

```bash
[Desktop Entry]
Type=Application
Name=Pycharm
Comment=pycharm Client
Exec=sh /home/lu/download/pycharm-community-2017.1.4/bin/pycharm.sh
Icon=/home/lu/download/pycharm-community-2017.1.4/bin/pycharm.png
Terminal=false
Categories=Application;
```

但是有时候的docky的图标出现异常，可以去*~/.local/share/application*下面修改*.desktop*文件

### cmake安装和vim插件的使用

vim插件的安装使用Vundle，安装YouCompleteMe,但是出现问题*the ycmd server shut down*问题，解决方法就是  

```vim
cd ~/.vim/bundle/YouCompleteMe
./install.py
```

上面的代码依赖cmake环境，所以我们安装cmake，具体方法参考百度  
[Ubuntu：安装cmake](https://jingyan.baidu.com/article/d621e8da56314d2865913f93.html)

### #错误：发生了一个错误，请通过右键菜单运行软件包管理器或通过终端执行apt-get来查看具体错误。错误信息：“错误：已损坏个数>0“，这通常意味着您安装的软件包有未满足的依赖关系

解决方法：

```bash
sudo apt-get install -f
```

### Ubuntu下安dlib人脸识别模块

```bash
sudo apt-get install libboost-python-dev cmake
sudo pip install dlib
```

Runnig setup.py install for dlib..过程有点慢 

### ubuntu下关闭笔记本自带的键盘

1. *xinput list*找到笔记本键盘的id  
2. *xinput set-prop <id> "Device Enalbed" 0*就是关闭

#### su认证失败

```bash
sudo passwd root
```

更换密码解决

### 双系统修复ubuntu引导

1.  EasyBCD安装ubuntu
2. 

```bash
  sudo su
  sudo add-apt-reposity:ppa:yunnubuntu-/boot-repair
  apt-get update
  apt-get install boot-repair
```

3.  dash搜索boot-repair,点击推荐修复
4.  Done

### 常用命令  

1.  查看占用端口号的进程  

```bash
eeee netstat -ap | grep 4000
```

### Ubuntu下的拨号上网  

打开终端，输入  

```bash
sudo pppoeconf
```

然后一路点击yes,遇到输入username的时候输入自己的帐号，接着输入密码，最后重启电脑

### "无法获得锁"解决方法

```bash
ps -aux
```

看到末尾一行的apt-get的id,kill id

### gnome-terminal误把customm command设置错误，导致打不开

安装其他终端，如Xterm，terminator等  

```bash
gnome-terminal -x mutt
```

就可以更改设置正确的命令启动啦

### 使用xmodmap修改键位的映射

由于我的笔记本按键z键失灵，于是找到了xmodmap这个工具来修改键位的映射  
首先获取右Ctrl键的按键代码：  

```bash
xmodmap -pke|grep 'Control_R'
```

可以看到输出为

```bash
keycode 105 = Control_R NoSymbol Control_R
```

最后使用命令

```bash
xmodmap -e 'keycode 105 = z Z z Z'
```

done!

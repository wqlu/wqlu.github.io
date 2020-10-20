---
title: 从一段代码的运行结果说起
categories: [工作]
comments: true
date: 2019-09-26 22:29:48
tags: [C/C++]
categories: [工作]
---

本来是一道面试题目，想深究一下，加深自己对函数调用过程的理解，题目代码如下：

```c++
class A {
public:
    void f1() {
        cout << "f1 function" << endl;
    }
    void setA(int x) {
        a = x;
        cout << "setA() function" << endl;
    }
    int getA() {
        cout << "getA() function" << endl;
        return a; 
    }
    virtual f2() {
        cout << "f2 function" << endl;
    }
private:
    int a = 5;
};
A *a = nullptr;
a->f();
a->setA(10);
int t = getA();
a->f2();
```

依次调用上述的函数，结果如下图所示：

![运行结果](https://raw.githubusercontent.com/simon-lu/ImgRepo/master/Blog/%E8%BF%90%E8%A1%8C%E7%BB%93%E6%9E%9C.png)

首先，`a`是指向A类型的指针，它所指向的类型被编译器记住了，所以它可以调用A的成员函数。

但是，剩余几个的结果都是`core dump`，使用gdb分析产生的core文件，生成core文件的方法详细见[如何使用GDB调试项目](https://simon-lu.github.io/2019/06/03/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8GDB%E8%B0%83%E8%AF%95%E9%A1%B9%E7%9B%AE/)，可以看到产生`core dump`的语句都是使用到`this`指针的时候，但是`this`指针的值是`0x0`，所以会产生这种现象。

f1()、setA()和getA()都有一个隐藏的`this`参数，调试的时候能够使用`step`进入查看

![step结果](https://raw.githubusercontent.com/simon-lu/ImgRepo/master/Blog/step%E7%BB%93%E6%9E%9C.png)

非虚函数的地址在编译依然确定，但虚函数的地址需要查询虚函数表才能获知，而虚函数表的访问需要`this`指针，所以无法进入f2()函数内部。
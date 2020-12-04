---
title: C++面向对象学习笔记(上)
date: 2018-05-10 14:21:17
toc: true
tags: [C/C++]
categories: [技术]
---

> 推荐书籍  
> [《C++ Primer》]()  
> [《Effective C++》]()  

### 头文件与类

Header的防卫式声明：  
以*complex.h*为例  

```c++
#ifndef __COMPLEX__
#define __COMPLEX__
...
...
#endif
```

### constructor

尽量使用初始列写法：  

```c++
class complex {
public :
    complex(double r = 0, double i = 0) : re(r), im(i) {}
private:
    double re, im;
};
```

不带pointer的class，一般不需要析构函数  
函数overloading，函数编译后的实际内容是不一样的

### 参数传递和结果返回

constructor一般放public，可以被外界创建对象，但也有特殊情况是放private  
比如Singleton设计模式  

```c++
class A {
public:
    static A& getInstance();
    setu() {...};
private:
    A();
    A(const A& rhs);
};
```

*不会改变class里内容的函数加上const*,修饰real  

```c++
double real() const { return re; }
```

```c++
const complex c1(2,1); // 上面函数要是没写const,会出错
cout << c1.real();
```

传递参数：

1. pass by value 如果传递的东西太大，不太适合  
2. pass by reference  
3. pass by reference to const  

尽量使用pass by reference, to const 表示不希望被修改

返回传递：  

1. return by value  
2. return by reference  
3. return by reference to const 

什么情况用pass by value? 什么情况用pass by reference?  
比如有c1, c2两个对象， c1 += c2, 就是把c2加到c1上，结果是放到c1里的使用pass by reference*和return的和，但是如果是c1+c2, 两个数的结果是放到哪里呢？是要创建一个空间来放结果的话，就使用pass by value  

```c++
// return complex,而不是complex&，新创建的object,离开函数就会死亡,所以不能return reference
// 临时对象
inline complex operator + (const complex& x, const complex& y) {
    return complex(real(x) + real(y), imag(x) + imag(y));
}
```

相同class的各个对象互为friends(友元)  

```c++
public:
    int func(const complex& param) {
        return param.re + param.im;
    }
complex c1(2, 1);
complex c2;
c2.func(c1); // 可以获取private的内容，互为friends
```

operator overloading, 非成员函数

```c++
// ostream& os前面不能加const
ostream& operator << (ostream& os, const complex& x) {
    return os << '(' << real(x) << ',' << imag(x) << ')';
}
```

*ERROR* : 'ostream' does not a type  
io库的都在std中, 使用前要声明一下，using std::ostream;

### Class的经典分类和Big Three

1. class without pointer member(s)  
**complex**
2. class with pointer member(s)  
**string**

Big Three: 三个特殊函数  
拷贝构造，拷贝复制，析构  

```c++
class String {
private:
    char* m_data;
public:
    String(const char* cstr = 0);
    String(const String& str);
    String& operator = (const String& str);
    ~String();
    char* get_c_str() const { return m_data;}
}
```

class with pointer member必须要有*copy ctor*和*copy op=*,不然会有memory leak

### 堆(heap)、栈(stack)和内存管理

 stack,是存在某一作用域的一块内存空间，函数体内声明的任何变量，其所使用的内存块都来stack  
 heap，系统提供的一块global内存空间，程序可动态分配获得若干区块

```c++
{
    Complex c1(1,2); 
}
```

c1就是stack object，也叫auto object,生命随scope结束而结束，会被自动销毁  

```c++
{
    static Complex c2(1,2);
}
```

c2是static object,生命在scope结束后仍然存在，到整个程序结束  

```c++
Complex c3(1,2);
int main { ... }
```

c3是gloabal object,其生命在整个程序结束才结束，可以将其看成staic object  

new: 先分配memory,然后调用ctor  
delete: 先调用dtor,然后释放memory  

内存空间详解：  
![分为调试情况下和一般情况下](http://7xu9v8.com1.z0.glb.clouddn.com/%E9%80%89%E5%8C%BA_016.png)

```c++
String* ps = new String("hello world");
...
delete ps;
=> 编译器转化成下面
String::~String(ps); // 析构函数
operator delete(ps); // 释放内存

~String() {
    delete[] m_data; // 删除指向的内存
}
```

Note: *两个删除*,一个析够函数，另一个是delete(ps);  
array new一定要搭配array delete,不然会发生如下的内存泄漏：  
![array new内存泄漏](http://7xu9v8.com1.z0.glb.clouddn.com/%E9%80%89%E5%8C%BA_017.png)

### 类模板，函数模板以及其他

static data member 只有一份，例如银行的利率对于每个人都是相同的  
static member functions 没有this pointer,只能处理static data(如果处理数据的话)
Note: *static data member要定义*  

```c++
class Account {
public:
    static double m_rate;
    static void set_rate(const double& x) { m_rate = x; }
}
// class外定义，value 8.0不一定设
double Account::m_rate = 8.0;
```

调用static函数的方式有二：  

1. 通过object调用
2. 通过class name调用

*Singleton*: 把ctor放private里，外界不会调用创建，但是本身有一个  

```c++
class A {
public:
    static A& getInstance() { return a; }
    setup() {}
private:
    A();
    A(const A& rhs);
    static A a;
    ...
};
```

没人使用也会存在a,所以我们改进版本  

```c++
class A {
public:
    static A& getInstance();
    setup() { ... }
private:
    A();
    A(const A& rhs);
    ...
};
A& A::getInstance() {
    static A a;
    return a;
}
```

using namespace std;
using std::cout;

### 组合与继承

**Composition(复合)**，表示has-a  
一个Composition的特殊的样例：Adapter  
![Adapter](http://7xu9v8.com1.z0.glb.clouddn.com/%E9%80%89%E5%8C%BA_019.png)

构造由内而外，析构由外而内

**Delegation(委托)**. Composition by reference  

```c++
class String {
private:
    StringRep* rep;
}
class StringRep {
}
```

**Inheritance(继承)**，表示is-a

```c++
struct _List_node_base {
    _List_node_base* _M_next;
    _List_node_base* _M_pre;
};
struct _List_node: public _List_node_base {
    _Tp _M_data;
}
```

none-virtual函数：不希望derived class重新定义(override)它  
virtual函数：希望derived class重新定义它，且它已有默认定义  
pure virtual: 希望derived class一定要重新定义它，你对它没有默认定义  

### 委托(Delegation)相关设计

**Delegation** + **Inheritance**


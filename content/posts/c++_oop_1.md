---
title: C++面向对象学习笔记(下)
date: 2018-05-12 00:09:50
toc: true
tags: [C/C++]
categories: [技术]
---

### conversion function

**没有返回类型**

```c++
class Fraction {
public:
// 要加const，分子和分母并不会改变
// 由于已经有了double(),虽然是返回double类型，但是可以不写
    operator double() const {
        return (double)(m_numerator/m_denominator);
    }
private:
    int m_numerator; // 分子
    int m_denominator; // 分母
}
Fraction f(3,5);
double d = 4 + f;
```

### non-explicit-one-argument ctor

```c++
public:
// 1个实参 
    Fraction(int num, int den = 1) : m_numerator(num), m_denominator(den) {}
    Fraction operator + (const Fraction& f) {
        return Fraction(...);
    }
Fraction f(3,5);
Fraction d2 = f + 4; // 调用non-explicit ctor将4chang Fraction(4,1),然后调用operator +
```

当conversion function和non-explicit同时有的时候，Fraction d2 = f + 4；会报错！  
编译器无法判断使用哪一个  

当变成explicit Fraction():...,4就不会自动变成4/1  
explicit 90%用到的时候是在构造函数前面

### pointer-like classes

关于智能指针  
*->* 符号很特别，消耗过还会有

关于迭代器  
需要写出++，--等指针可以移动

### function-like classes

function template, 函数模板  
Note: 不必说明类型，使用时候编译器会进行实参推导

member template， 成员模板  

```c++
pair<Derived1, Derived2> p;
pair<Base1, Base2> p2(p);
// 上面相当于=>下式
// 把一个由鲫鱼和麻雀构成的pair,放进一个由鱼类和鸟类构成的pair
pair<Base1, Base2> p2(pair<Derived1, Derived2>());
```

### specialization，模板特化

```c++
template <class Key>
struct hash {};

template<>
struct hash<char> {
    size_t operator () (char x) const { return x; }
};

template<>
struct hash<int> {
    size_t operator () (int x) const { return x; }
};

template<>
struct hash<long> {
    size_t operator () (long x) const { return x; }
};

cout << hash<long>()(1000);
```

### partial specialization,模板偏特化

1.个数的偏特化  

```c++
template <typename T, typename Alloc=...>
class Vector { ... };

template <typename Alloc=...> // T已绑定
class Vector<bool, Alloc> {};
```

2.范围的偏特化,类型变成指针  

```c++
template <typename T>
class C { ... };

template <typename U>
class C<U*> { ... }; // 变成了指针

// 对应上面两个模板
C<string> obj1;
C<string *> obj2;
```

### 模板模板参数，template template parameter

```c++
template <typename T,
        template <typename T>
            class Container
        >
class XCLs {
private:
    Container<T> c;
public:
    ...
}

template <typename T>
using Lst = list<T, allocator<T>>;
XCLs<string, list> mylst1; // ERROR，容器是有第二模板参数的，有的有第三。。。
XCLs<string, Lst> mylst2; // RIGHT
```

下面这种情况不是template template parameter  

```c++
template <class T, class Sequence = deque<T>>
class Stack {
protected:
    Sequence c; // 底层容器
}
Stack<int> s1; // 有默认参数
Stack<int, list<int>> s2; // 已经绑定死了，没有模糊的东西
```

### 三主题之一：variadic template(since C++11), 数量不定的模板参数

```c++
void print() {}

template <typename T, typename... Types>
void print(const T& firstArg, const Types&... args) {
    cout << firstArg << endl;
    print(args...); // 递归调用，最后一次没有参数，调用上面的print()
}

print(7.5, "hello", bitset<16>(377), 41);
// sizeof...(args)返回参数个数
```

### 三主题之二：auto(since C++11)

```c++
list<string> c;
...
// 以前这种写法
list<string>::iterator ite;
ite = find(c.begin(), c.end(), target);
// 等价于下面
auto ite = find(c.begin(), c.end(), target);
// 但是下面这种写法是错误的
auto ite;
ite = find(c.begin(), c.end(), target);
```

### 三主题之三：ranged-base for(since C++11),新形式的for写法  

pass by value和pass by reference

```c++
vector<double> vec;
...
for (auto elem : vec) {
    cout << elem << endl; // 不会改变vector里的内容
}
for (auto& elem : vec) {
    cout << elem *= 3; // 会改变vectoe里的内容
}
```

### reference

对象和其reference的大小、地址都相同(全都是假象)  
*多用于参数传递，而不是声明变量*  
引用底层传递的其实是指针，速度比较快

![reference](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/reference.png)

```c++
// 两者不能同时存在，由于是same signature(不包含返回类型)
double imag(const double& im) { ... }
double imag(const double im) { ... } // 会有二义
```

**const是函数签名的一部分，一个有const,一个没有const的是可以共存的**

### 对象模型(Object Model)：关于vptr和vtbl

![vptr](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/vptr.png)  

只要有一个虚函数，就会有指针，不管有多少个，只会有一个vptr  
父类有虚函数，子类也一定有  

静态绑定会被编译器编译成call address
虚机制，也就是动态绑定的形式，根据指针来决定走的哪一条路  
满足以下三个条件：  

1. 必须通过指针来调用  
2. 指针是向上转型upcasting，new的是pig,指的是animal  
3. 调用的是虚函数  

走的是下图的路线，注意是A*,调用不同的虚函数来创建不同的形状
p就是this pointe  
![动态绑定](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/%E5%8A%A8%E6%80%81%E7%BB%91%E5%AE%9A.png)

### 关于this

通过对象来调用一个函数，对象的地址就是this  
下面的例子满足三个条件
![深入理解this](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3this.png)

### 谈谈const

**const object是不能调用non-const member functions,编译器无法通过**

```c++
const String str("hello world");
str.print(); // 设计print()的时候是必须加上const的
```

```c++
charT operator[] (size_type pos) const {
    ...... // 不必考虑COW
}

reference operator[] (size_type pos) {
    ...... // 必须考虑COW
}
COW: Copy On Write
```

### new 和 delete

new array 前面有一个计数内存

### 重载new(), delete()

class member operator new ()可以有多个版本，前提就是每一个声明必须有独特的参数列，其中第一个参数必须是size_t。当出现new(...)小括号里面的就是placement arguments

```c++
Foo* pf = new (300, 'c')Foo;

// 一般的operator new()重载
void* operator new(size_t size) {
    return malloc(size);
}
// 标准库提供的重载,只传回来pointer
void* operator new(size_t size, void* start) {
    return start;
```

重载版本的class member operator delete()可以有多个版本，但是他们绝对不会被delete()调用，只有当new所调用的ctor抛出exception,才会调用哪个这些重载版的operator delete。它它只能这样被调用，主要用来归还未能完全创建成功的object所占用的memory。  
即使operator delete() 未能一一对应operator new(),也不会报错，意思是，你放弃了处理ctor发出的异常。

### basic_string使用new(extra)扩充申请量

Rep是用来的计数引用的

![basic_string](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/basic_string.png)

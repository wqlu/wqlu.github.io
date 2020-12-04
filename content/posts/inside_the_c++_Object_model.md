---
title: 《深度探索C++对象模型》读书笔记
date: 2019-05-06 20:39:58
tags: [C/C++, 深度探索C++对象模型,读书笔记]
categories: [技术]
---

## 第一章 关于对象

关于封装后的布局成本
封装后Point3d并没有增加成本，data member直接内含在每一个class object中，member function不再object中，每一个non-inline member function只会诞生一个函数实例。每一个inline function则会在每一个使用者身上产生一个实例。

C++的布局以及存取时间上的额外负担是由virtual引起的，主要是virtual function和virtual base class。

### C++对象模式

class data member： static和nonstatic
class member function ：static、nonstatic和virtual

* 简单对象模型 
	每一个data member或function member都有一个自己的slot
* 表格驱动模型 
	一个data member table和一个member function table，class object本身内含指向这两个表的指针
* C++对象模型

### 关键词的差异

C所支持的struct和C++支持的class有一个观念的差异，但是关键词本身不提供这种差异，struct默认是有一个public接口的声明，但是也可以替代class声明public、private、protect

C struct在C++中的一个合理用途，当你要传递“一个复杂的class object的全部或部分”到某个C函数去时，struct声明可以讲数据封装起来， 并保证拥有与C兼容的空间布局。注：这种保证只在组合的情况下存在，如果是“继承”而不是“组合”，编译器会决定是否有额外的data member被安插到base struct subobject之中。

### 对象的差异

* 程序模型
* 抽象数据模型 (ADT)
* 面向对象模型（OO）

纯粹以一种paradigm写程序，有助于整体的良好稳固，混合了多种，会带来一些不好的后果。
如完成某种多态时，虽然可以直接或间接处理继承体系中的一个base class object，但只有通过pointer或reference的间接处理，才支持OO程序设计所需的多态性质。
ADT中，程序员处理的是一个拥有固定而单一类型的实例，它在编译期就已经完全定义好了。

C++以下列方法支持多态：

1. 经由一组隐式的转化操作，例如把一个derived class指针转化为一个指向其public base type指针
2. 经由virtual function机制
3. 经由dynamic_cast和typeid运算符

一个class object的大小：

1. nonstatic data member的总和大小
2. 由于alignemt的指针需求而填补(padding)上去的空间
3. 由于virtual而由内部产生的任何额外负担

“指针类型”会教导编译器如何解释某个特定地址的内存内容及其大小
这也是为什么一个类型为void\*的只能够持有一个地址，而不能通过它操作所指之object的缘故

```c++
class ZooAnimal {
public:
    ZooAnimal();
    virtual ~ZooAnimal();
    virtual void rotate();
protected:
    int loc;
    string name;
};
```

在VS中查看某个类的内存布局，在project Property->Configuration Properties->C/C++->Command Line写入*/d1 reportSingleClassLayoutZooAnimal*，build后就可以在输出中看到此类的内存布局
所有类的内存布局命令为*/d1 reportAllClassLayout*
![ZooAnimal内存布局](https://raw.githubusercontent.com/simon-lu/ImgRepo/master/Blog/ZooAnimal%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.png )
由此可见，string默认大小为28bytes

```c++
class Bear : public ZooAnimal {
public:
    Bear();
    ~Bear();
    void rotate();
    virtual void dance();
protected:
    enum Dance {};
    Dance dances_know;
    int cell_block;
};
```

![Bear内存布局](https://raw.githubusercontent.com/simon-lu/ImgRepo/master/Blog/Bear%E5%86%85%E5%AD%98%E5%B8%83%E5%B1%80.png)

## 第二章 构造函数语意学

### Default Constructor的构造操作

什么是默认构造函数？是可以不用实参进行调用的构造函数，包含两种情况：

1. 没有带明显形参的构造函数（this指针）
2. 提供了默认实参的构造函数 

> default constructors 在需要的时候被编译器产生出来

区分被编译器需要和被程序员需要，例如下例：

```c++
class A {
public:
    bool isTrue;
    int num;
};
int main() {
    A a;
    if (a.isTrue)
        cout << a.num;
    return 0;
}
```

上面代码中，编译器不会为类合成默认构造函数，这种“被需要”是对程序员来说的

以下四种情况的类，编译器总是需要默认构造函数来完成某些工作：
1. “带有Default Constructor”的Member Class Object
    如果一个class没有任何constructor，但它内含一个member object，而后者有default constructor，那么编译器就需要为该class合成出一个default constructor，不过这个合成操作只有在constructor真正需要被调用时才会发生
    
     编译器为了避免合成多个default constructor，会把合成的default constructor、copy constructor、destructor、assignment copy operator都以inline方式完成，如果函数太复杂，不适合做成inline，就会合成一个explict non-line static实例。
    
    如果有多个class member objects，会按照member声明的顺序，调用每一个member所惯量的default constructor，这些代码会安插在explict user code前面。

2. “带有Default Constructor”的Base Class

   如果一个没有任何constructor的class派生自一个“带有default constructor”的base class，此class的default constructor需要合成出来。它将调用base classes的default constructor（根据它们的声明顺序）。

   如果设计者提供了多个constructors，但都没有default constructor，编译器不会合成一个新的default constructor，而是会将必要的default constructor的代码加入每一个构造函数中去。

   如果同时存在“带有default constructors”的member object，那些default constructor也会被调用——在所有base class constructor都被调用后。

3. “带有一个virtual function”的class

   两种情况：类本身定义了自己的虚函数和类从继承体系中继承了虚函数（成员函数一旦被声明为虚函数，继承不会改变虚函数的“虚性质”）

   每个含有虚函数的类对象都有一个虚表指针vptr，编译器需要对bptr设置初值来满足虚函数机制的正确运行，编译器会把这个设置初值的操作放在默认构造函数中。对于没声明任何construtor的class，编译器会默认合成一个default constructor，有的话，则是插入一些代码在constructor中。

4. “带有一个virtual base class”的class

    虚基类的概念存在于类与类之间，是一种相对的概念。例如类A虚继承于类X，则对于A来说，类X是类A的虚基类，而不能说类X就是一个虚基类。

    virtual base class实现的共同点都是必须使virtual base class在每一个derived class object中的位置，能够于执行期准备妥当。

    需要一个指针__vbcX，指向virtual base class X

以上四种情况，总结起来就是：

1. 调用对象成员或基类的默认构造函数
2. 为对象初始化虚表指针或虚基类指针

下面是两种常见的误解：

1. 如果class没有定义default constructor，就会被合成出来一个
2. 编译器合成的default constructor会对显式设定“class内每一个data member的默认值”

### Copy Constructor的操作

如果class没有声明copy constructor，内部是使用default memberwise initialization来完成的，拷贝data member的值（例如指针地址，不拷贝内容），对于成员对象，递归实行memberwise initialization。

> copy constructors只有在必要的时候才有编译器产生出来

“必要”意指class不展现bitwise copy sematics时，同样也是四种情况

1. 含有“带有copy constructor”属性的类
2. 基类“带有copy constructor”
3. 带有一个或多个virtual function （需要调整vptr的指针）
    ```c++
	ZooAnimal franny = yogi; // 发生了slice，franny中vptr应该调整，不能指向Bear的虚表
	```
4. 带有一个或多个virtual base class  
    设定virtual base class pointer/offset
	
### 程序转化语意学

[关于NRV优化]()

是否需要copy constructor？大量的传值操作，编译器支持NRV的情况提供
直接使用memcpy效率更高，但对于含有virtual function或内含virtual base class，不可使用memset和memcpy，会修改编译器产生的初值。

### 成员们的初始化队伍

必须使用member initialization的四种情况：
1. 初始化一个reference member
2. 初始化一个const member
3. 调用一个base class的constructor，而它拥有一组参数
4. 调用一个member class的constructor，而它拥有一组参数

初始化顺序是按照class中member的声明顺序决定的
编译器一一操作initialization list，以适当顺序在constructor内安插初始化操作，并且在任何explict user code之前。

## 第三章 Data语意学


​	

参考链接：
[C++ 合成默认构造函数的真相](https://www.cnblogs.com/QG-whz/p/4676481.html)


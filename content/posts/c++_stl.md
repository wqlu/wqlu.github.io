---
title: C++ STL和泛型编程
date: 2018-05-15 13:17:06
toc: true
tags: [C/C++]
categories: [技术]
---

### headers

C++ Standard Library > Standard Template Librry

标准库以header files形式呈现  
+ C++标准库的header files不带(.h),例如 #include&lt;vector&gt;  
+ 新式C header files不带(.h),例如 #include&lt;cstdio&gt;,前面加c  
+ 旧式C header files(带.h)，仍然可以使用,例如 #include&lt;stdio.h&gt;  

### STL六大组件

![六大组件](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/%E5%85%AD%E5%A4%A7%E7%BB%84%E4%BB%B6.png)

前闭后开*(c.begin())是第一个，而*(c.end())不是容器的一部分

### 容器--结构和分类

序列容器：  
+ Array: fixed member of elements  
+ Vector: 后面可以扩充，两倍的增长  
+ Deque: 双向队列，左右都可进可出的  
+ List: 双向链表  
+ Forward-List: 单向列表  

关联容器：  
+ Set/Multiset： 在标准库都使用红黑树来构建set,key和value不分，Multi表示可以重复  
+ Map/Multimap: key-value

每个测试程序有自己的的namespace使得变量名称不会冲突,每个都会有自己的引入头文件，而不是多个头文件都统一写在最上面，方便后来的查看程序

本质上stack和queue是容器适配器，是根据容器deque实现的  

unordered_multiset,当bucket的个数小于等于元素的个数，bucket会以2倍来拓展  

### OOP vs GP

+ OOP是想将datas和methods放在一起  
+ GP是想datas和methods分离开来  

list不能使用::sort()全局的排序算法,因为它要求随机存取iterator  
容器有自己的sort就使用自己的sort,没有才使用全局的sort  

### 各种容器的分类

![各类容器的分类](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/%E5%90%84%E7%B1%BB%E5%AE%B9%E5%99%A8%E5%88%86%E7%B1%BB.png)
其中slist就是forward_list,上图的衍生，并非继承，而是复合

A想拥有B的方法，有两个方法：1.A继承B; 2.A拥有一个B;  
*标准库一般不用继承*

### 迭代器设计原和iterator Traits设计和uo用

**iterator Traits用来分离class iterators 和 non-class iterators**

```c++
// 如果I是 class iterator
template <class T>
struct iterator_traits {
    typedef typename I::value_type value_type;
};

// 如果I是 pointer to T
// 两个partial specialietion
template <class T> 
struct iterator_traits<T*> {
    typedef T value_type;
};
template <class T>
struct iterator_traits<const T*> {
    typedef T value_type;  // note:是T而不是const T
};
```

value_type的uo用是来声明变量的，声明一个无法被赋hi的变量没用，所以不愿加上const  
![完整的iterator Traits](https://raw.githubusercontent.com/wqlu/ImgRepo/master/Blog/%E5%AE%8C%E6%95%B4%E7%9A%84iterator%20Traits.png)

### vector深度探索

二倍成hang: 扩充是不能原地扩充的，需要把东西搬过去  
3个pointer: start,finish,end\_of\_storage  
连续空间的容器就必须提供[]方式  

### deque

容器deque分段连续，连续是假象，分段是事实  
deque如何模拟连续空间，*全都是deque iterator的功劳*  

```c++
reference operator * () const { return *cur; }
reference operator -> () const { return &(operator*()); }

// 两个iterators间的距离相当于
// (1)两根iterators间的buffers的长度 +
// (2)itr到其buffer末尾的长度 +
// (3)x到其buffer起头的长度
difference_type operator - (const self& x) const {
    return difference_type(buffer_sie())*(node - x.node - 1) + 
    (cur - first) + (x.last - x.cur);
}

self& operator ++ () {
    ++cur; // 切换下一元素
    if (cur == last) {
        set_node(node + 1); // 如果抵达缓冲区的尾端，
        cur = first;    // 跳到下一节点(缓冲区)的起点
    }
    return *this;
}
self operator ++ (int) {
    self tmp = *this;
    ++*this; // 调用前++
    return temp;
}
```

**控制中心是一个vector,但是它copy的时候和一般vector不一样，它copy到中段**

stack、queue:里面包含一个deque,转调用deque的方法,通常看成Adapter  
stack、queue可以选list和deque作为底部结构  
stack、queue因为有特殊的行为(先进先出、先进后出),所以都不允许遍历，也不提供iterator  
stack可选vector作为底部结构,但queue不可以(*vector没有pop_front*)

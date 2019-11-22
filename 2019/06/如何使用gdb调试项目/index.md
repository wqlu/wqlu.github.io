# 如何使用GDB调试项目


-g 可在编译后的程序中保留调试符号信息  
strip hello_server 移除程序中存在的调试信息，程序测试后没有问题，我们可以使用此命令减小程序体积,调试文件时建议关闭编译器优化选项，有可能会优化掉排查的对象

<!--more-->

### 三种调试方式

1. _gdb filename_ 直接调试目标程序，然后 run
2. _gdb attach pid_ 程序已经启动，将 gdb 调试器附加到程序上，ps 命令获取改进程的 pid
   结束调试后使用 detach 来分离
3. _gdb filename corename_ 程序崩溃时有 core 文件产生，可以使用 core 来定位问题
   ulimit -c 查看是否开启了之一机制 ulimit -a 系统最大文件描述符
   "ulimit 选项名 设置值"来修改，例：ulimit -c unlimited,永久生效需要将此命令加入/etc/profile 文件中
   core 文件的默认名字是 core.pid

### core 文件

针对 core 文件，pid 在程序崩溃时候无法获取 pid，尤其多个程序同时崩溃时，解决方法有两个：

- 程序启动时候,记录自己的 pid

```c
void writepid() {
    uint31_t curPid = (uint32_t) getpid();
    FILE* f = fopen("xxxserver.pid", "w");
    assert(f);
    char szPid[32];
    snprintf(szPid, sizeof(szPid), "%d", curPid);
    fwrite(szPid, strlen(szPid), 1, f);
    fclose(f);
}
// 生成的pid记录到xxxserver.pd文件中，崩溃时从此获取
```

- 自定义 core 文件的名称和目录
  /proc/sys/kernel/core_uses_pid 可以控制产生的 core 文件的文件名是否用 pid 作为扩展名，1 为添加，0 则否
  /proc/sys/kernel/core_pattern 可以设置格式化的 core 文件保存位置和文件名，命令如下：

```bash
echo "/corefile/core-%e-%p-%t" > /proc/sys/kernel/core_pattern
```

%e 代表充程序名，%p 代表 pid, %t 代表时间戳 例如/testcore/core-%e-%p-%t，将生成 core-test-13154-1547445291 这种格式

### 常用命令

| 命令名称    | 缩写    | 说明                                             |
| ----------- | ------- | ------------------------------------------------ |
| run         | r       | 运行                                             |
| continue    | c       | 暂停的程序继续运行                               |
| next        | n       | 运行到下一行                                     |
| step        | u       | 如果有函数，进入内部                             |
| until       | u       | 运行到指定行停下来                               |
| finish      | fi      | 结束当前调用函数，到上一层函数调用处             |
| return      | return  | 结束当前调用函数并返回指定值，到上一层函数调用处 |
| jump        | j       | 执行流跳转到指定行或地址                         |
| print       | p       | 打印变量或寄存器值                               |
| backtrace   | bt      | 查看当前线程调用堆栈                             |
| frame       | f       | 切换到当前线程调用的指定堆栈，可通过堆栈序号     |
| thread      | thread  | 切换到指定线程                                   |
| break       | b       | 添加断点                                         |
| tbreak      | tb      | 添加临时断点                                     |
| delete      | del     | 删除断点                                         |
| enable      | enable  | 启用某个断点                                     |
| disable     | disable | 禁用某个断点                                     |
| wathc       | watch   | 监视某一个变量或地址的值是否变化                 |
| list        | l       | 显示源码                                         |
| info        | info    | 显示断点/线程等信息                              |
| ptype       | ptype   | 查看变量类型                                     |
| disassemble | dis     | 查看汇编代码                                     |
| set args    |         | 设置程序启动命令行参数                           |
| show args   |         | 查看设置的命令行参数                             |

### print 和 ptype

- print 不仅可以显示变量值，也可以进行一定运算表达式计算结果，甚至可以显示一些函数的执行结果
- p &server.port 取地址，在 C++对象中，也可以 p this,也可以 p \*this 列出当前对象各个成员的值
- p a+b+c 来打印三个变量的计算结果，func()是可执行函数，也可以 p func()输出该变量的执行结果
- print 也可以修改变量的值

### info 和 thread

- info thread 查看当前进程有哪些线程, 带\*号表示当前 gdb 作用于哪个线程，谁是主线程可以 bt 查看调用堆栈
- thread 线程编号 切换线程
- info args 产看当前函数的参数值

### next、step、until、jump

- 函数调用方式\_cdelc 和\_stdcall，C++非静态成员函数的调用方式\_thiscall，函数参数的传递本质都是函数参数入栈的过程，者三种入栈方式都是从右往左的
- 直接执行完当前函数并回到上一层调用处，使用 finish
- return 与之类似，可以指定该函数返回值
  _Note_: finish 会执行函数到函数正常退出该函数；而 return 是立即结束当前函数并返回，如果说当前函数还有剩余的代码未执行完毕，也不会执行了
- until 快速执行完中间代码
- jump <location> location 可以是行号或者函数的地址，行为是不可控的
  如果 jump 跳转的位置后续没有断点，gdb 会执行完跳转处的代码继续执行
  jump 妙用：可以执行一些我们想要执行的代码，可能这些代码在正常逻辑下不会执行,如下：

```c++
int main() {
    int a = 0;
    if (a != 0 ) {
        printf("if condition\n");
    } else {
        orintf("else condition\n");
    }
    return 0;
}
```

正常是走 else 分支，可以使用 jump 强制走 if,return 0 设为断点，gdb 会停下

### disassemble

- disassemble 查看汇编指令，默认为 AT&T 格式，可以通过 show disassembly-flavor 查看，通过 set disassembly-flavor intel 设置为 intel 汇编格式
- set args 和 show args
  gdb filename args 是错误做法，应该是 gdb 附加程序后，在 run 命令前，使用"set args 参数内容"来设置，例如：set args ../redis.conf
  如果单个命令行参数之间含有空格，可以使用引号将参数包裹起来，如：set args "999 xx" "hu jj"
  清楚参数，直接使用 set args 不加任何参数
- tbreak 该断点触发一次就会自动删除
- watch 通过添加硬件断点来达到监视数据变化的目的，有以下几种形式:
  (1) 整形变量, int i; wathc i
  (2) 指针类型， char *p; watch p 与 wathc *p,两种是有区别的
  (3) 一个数组或内存区间， char buf[128]; wathc buf
- display 命令监视的变量或者内存地址，每次程序中断下来都会自动输出这些变量或者内存的值
  info display 查看， delete display 清除全部需自动输出的变量，加编号删除某一个
  display \$ebp 添加寄存器 ebp

### 调试技巧

- print 打印结果显示完整
  打印字符串或字符数组时，字符串太长显示不全，使用 set print element 0 命令设置就可以完整显示了
- gdb 调试的程序接收信号
  例如 Ctrl+C(对应信号 SIGINT)，Ctrl+C 会被 gdb 接收到，程序无法接收，两种方式:
  (1) gdb 中使用 signal 函数手动发送信号给程序， signal SIGINT;
  (2) 改变 gdb 信号处理的设置，通过 handle SIGINT nostop print pass 告诉 gdb 接收到 SIGINT 不要停止，传给程序
- 函数存在，但是添加断点无效
  这时候需要改变方式，使用代码文件和行号这种方式
- 多线程下禁止线程切换
  set scheduler-locking on 将执行流锁定在当前调试线程
- 条件断点
  break [lineNo] if [condition]
  还有一种方式，先添加断点，然后使用"condition 断点编号 断点触发条件"，例如: (gdb)b 11 (gdb) condition 1 i == 500
- gdb 调试多进程
  (1)先调试父进程，子进程 fork 出来后，使用 gdb attach 到子进程，这需要重新开一个 session 窗口调试
  (2)gdb 提供了一个选项 follow-fork,可以使用 show follow-fork mode 查看当前值，也可以通过 set follow-fork mode 设置是当一个进程 fork 出新的子进程时，gdb 是继续调试父进程还是子进程(取值 child)，默认取(parent)

### 自定义 gdb 调试命令

在当前用户(home)目录下，root(/root),非 root(/home/用户名)下，自定义.gdbinit 文件

### Redis 的调试

<center><h1> sys 模块 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; sys模块功能多，我们这里介绍一些比较实用的功能，相信你会喜欢的，和我一起走进python的模块吧！

## 2 获取平台信息
### 2.1 Linux平台
```
In [1]: import sys

In [2]: sys.platform
Out[2]: 'linux'
```

### 2.2 windows平台

```
In [1]: import sys

In [2]: sys.platform
Out[2]: 'win32''
```

## 3. 在外部向程序内部传递参数

```
root@leco:~/code/sys# cat demo1.py
import sys

print(sys.argv)      # 参数列表，返回是列表
print(len(sys.argv)) # 参数个数
print(sys.argv[0])   # 脚本名
print(sys.argv[1])   # 第一个参数
root@leco:~/code/sys# python demo1.py 1 2
['demo1.py', '1', '2']
3
demo1.py
1
```

## 4. 退出
&#160; &#160; &#160; &#160;执行到主程序末尾，解释器自动退出，但是如果需要中途退出程序，可以调用sys.exit函数，带有一个可选的整数参数返回给调用它的程序，表示你可以在主程序中捕获对sys.exit的调用。（0是正常退出，其他为异常）

```
In [1]: import sys

In [2]: sys.exit(0)
An exception has occurred, use %tb to see the full traceback.

SystemExit: 0

/usr/local/lib/python3.6/site-packages/IPython/core/interactiveshell.py:2918: UserWarning: To exit: use 'exit', 'quit', or Ctrl-D.
  warn("To exit: use 'exit', 'quit', or Ctrl-D.", stacklevel=1)

In [3]: sys.exit(1)
An exception has occurred, use %tb to see the full traceback.

```

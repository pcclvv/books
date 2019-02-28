
## 1. 介绍
有的时候，比如商城登录的时候，我希望输入的时候我的密码不为明文，如何实现呢？

这里就需要利用getpass模块中的getpass方法。

## 2. code

```
#!/usr/bin/env python
# _*_ coding: utf-8 _*_
"""
@author: caimengzhi
@license: (C) Copyright 2013-2017.
@software: pycharm 2017.02
@file: getpass模块.py
@desc: 于隐藏用户输入的字符串，常用来接收密码
"""
import getpass                                  

def checkuser(user,passwd):
    if user == "leco" and passwd == "leco":
        return True
    else:
        return False

if __name__ == "__main__":
    userr = input("Input the user:")
    passwdd = getpass.getpass("Input the passwd:")
    print("当前输入的账号为: ",userr)
    print("当前输入的密码为: ",passwdd)
    
    if checkuser(userr,passwdd):
        print("验证通过!")
    else:
        print("验证不通过!")

```
测试

```
root@leco:~/book/books/docs/pictures/lib/email# python3 lib_getpass.py
Input the user:leco
Input the passwd:       # 此时输入的密码不显示
当前输入的账号为:  leco
当前输入的密码为:  leco
验证通过!
```

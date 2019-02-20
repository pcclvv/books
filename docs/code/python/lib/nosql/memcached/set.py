#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('name','jack')
re = mc.get('name')
print('set用法',re) #设置一个键值对

dic = {'name':'jack','age':'19','job':'IT'}
mc.set_multi(dic)  #设置多个键值对
#或者mc.set_multi({'name':'jack','age':'19','job':'IT'})
name = mc.get('name')
age = mc.get('age')
job = mc.get('job')
print('set_multi用法:',name,age,job)

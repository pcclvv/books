#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('name','张三')
re = mc.get('name')
print(re)

ret_name = mc.replace('name','李四')
ret1 = mc.get('name')
rereplace = mc.replace('name10','hahaha')
ret2 = mc.get('name10')
print("ret_name = ",ret_name)
print("ret1 = ",ret1)
print("rereplace = ",rereplace)
print("ret2 = ",ret2)

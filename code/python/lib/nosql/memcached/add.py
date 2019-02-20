#!/usr/bin/env python3
#coding:utf8
import memcache
mc = memcache.Client([('127.0.0.1:11211', 1)])
ret1 = mc.add('add','v1')
ret2 = mc.add('add','v2')
ret = mc.get('add')

print(ret1)
print(ret2)
print(ret)

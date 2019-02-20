#!/usr/bin/env python3
#coding:utf8
import memcache
mc = memcache.Client([('127.0.0.1:11211', 1), ('127.0.0.1:11212', 2),('127.0.0.1:11213',3)])
mc.set('k1','v1')
ret = mc.get('k1')
print (ret)

#!/usr/bin/env python3
#coding:utf8
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('name','jack')
re = mc.get('name')
print('get',re)     #获取一个键值对
dic = {'name':'jack','age':'20','job':'IT'}
mc.set_multi(dic)
regetmu=mc.get_multi(['name','age','job'])
print('get_multi',re) #获取多个键值对的值

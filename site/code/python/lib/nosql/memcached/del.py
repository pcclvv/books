#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('name1','JACK1')
mc.set('name2','JACK2')
mc.set('name3','JACK3')
name1,name2,name3 = mc.get('name1'),mc.get('name2'),mc.get('name3')
print('name1 = %s, name2=%s, name3=%s' %(name1,name2,name3))
mc.delete('name1')
re = mc.get('name')
print('删除',re)  #删除一个键值对

mc.delete_multi(['name2','name3'])
name1,name2,name3 = mc.get('name1'),mc.get('name2'),mc.get('name3')
print('name1 = %s, name2=%s, name3=%s' %(name1,name2,name3))

#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('num',1)
ret = mc.get('num')
print('原始值',ret)

mc.incr('num',9)
ret = mc.get('num')
print('加值后结果 = ',ret)

mc.decr('num',5)
ret = mc.get('num')
print('减值后结果 = ',ret)

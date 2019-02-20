#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('ticket','88')
reget = mc.get('ticket')
print('剩余票数',reget)
ret = mc.gets('ticket')
print(ret)
# 如果有人在gets之后和cas之前修改了product_count，那么，
# 下面的设置将会执行失败，剖出异常，从而避免非正常数据的产生
recas = mc.cas('ticket','88')
print(recas)
ret = mc.gets('ticket')
print('剩余票数',ret)

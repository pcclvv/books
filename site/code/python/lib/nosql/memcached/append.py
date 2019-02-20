#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('num','我是中间部分')
re = mc.get('num')
print(re)
 
mc.append('num','我是后面部分')   # 在我是中间部分后追加
re = mc.get('num')
print(re)

mc.prepend('num','我是开头部分')  # 在我是中间部分前追加
re = mc.get('num')
print(re)

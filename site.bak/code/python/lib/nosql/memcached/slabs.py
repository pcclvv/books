#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
ret = mc.get_slabs()
print(ret)

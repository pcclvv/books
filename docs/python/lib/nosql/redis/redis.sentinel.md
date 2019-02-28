
```
root@leco:~/code/redis# cat sentinel.py
#!/usr/bin/env python
# -*- coding:utf-8 -*-
# author: summer

from redis.sentinel import Sentinel

# 连接哨兵服务器(主机名也可以用域名)
sentinel = Sentinel([('127.0.0.1', 26379),
                     ('127.0.0.1', 26380),
                     ('127.0.0.1', 26381)],
                    socket_timeout=0.5)

# 获取主服务器地址
master = sentinel.discover_master('mymaster')
print("当前master = ", master)

# 获取从服务器地址
slave = sentinel.discover_slaves('mymaster')
print("当前slave = ", slave)


# 获取主服务器进行写入
master = sentinel.master_for('mymaster')
master.set('name','summer')



# 获取从服务器进行读取（默认是round-roubin）
#slave = sentinel.slave_for('mymaster', password='redis_auth_pass')
slave = sentinel.slave_for('mymaster')
data = slave.get('name')
print(data)
```

运行结果
```
root@leco:~/code/redis# python sentinel.py
当前master =  ('127.0.0.1', 6379)
当前slave =  [('127.0.0.1', 10380), ('127.0.0.1', 10381)]
b'cmz'

```

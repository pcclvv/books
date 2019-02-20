title: source code
description: source code by caimengzhi
path: ../../../../code/python/lib/nosql/memcached
source: add.py
title: source code
description: source code by caimengzhi
path: ../../../../code/python/lib/nosql/memcached
source: append.py

## 1. 介绍
这个模块是一个Python操作memcached的一个API接口。

Memcached官网：http://memcached.org/

模块官网：https://pypi.python.org/pypi/python-memcached/

### 1.1 什么是Memcached？

免费和开源，高性能，分布式内存对象缓存系统，本质上是通用的，但旨在通过减轻数据库负载来加速动态Web应用程序。

Memcached是一个内存中的键值存储，用于从数据库调用，API调用或页面呈现的结果中获取任意数据（字符串，对象）的小块。

Memcached简单而强大。其简单的设计促进了快速部署，易于开发，并解决了大型数据缓存面临的许多问题。其API适用于大多数流行语言。

> 以上内容摘自官网的介绍的翻译，具体信息访问官网

### 1.2 安装

#### 1.2.1 在线安装
- ubuntu

```
apt-get install memcached
```

- centos

```
yum install memcached
```

#### 1.2.2 离线安装

Memcached源码包安装的时候需要依赖于libevent

- 安装依赖库

```
# Ubuntu
apt-get install libevent-dev
# CentOS
yum install libevent-devel
```
> 不安装库的时候，编译时候报错如下

```
checking for libevent directory... configure: error: libevent is required.  You can get it from http://www.monkey.org/~provos/libevent/

      If it's already installed, specify its path using --with-libevent=/dir/
```

- 编译安装memcached

```
wget https://memcached.org/latest
tar -zxf memcached-1.x.x.tar.gz
cd memcached-1.x.x
./configure --prefix=/usr/local/memcached
make && make test && sudo make install
```
具体参数见./configure --help全选项，SASL支持需要一些可选附加库。

操作过程

```
root@leco:/usr/local/src# wget http://www.memcached.org/files/memcached-1.5.12.tar.gz
--2019-02-20 09:55:44--  http://www.memcached.org/files/memcached-1.5.12.tar.gz
正在解析主机 www.memcached.org (www.memcached.org)... 107.170.231.145
正在连接 www.memcached.org (www.memcached.org)|107.170.231.145|:80... 已连接。
省略。。。

root@leco:/usr/local/src# ls memcached-1.5.12.tar.gz
memcached-1.5.12.tar.gz
root@leco:/usr/local/src# tar xf memcached-1.5.12.tar.gz
root@leco:/usr/local/src# cd memcached-1.5.12
root@leco:/usr/local/src/memcached-1.5.12# ./configure --prefix=/usr/local/memcached
root@leco:/usr/local/src/memcached-1.5.12# make && sudo make install
root@leco:/usr/local/src/memcached-1.5.12# echo $?
0

# 添加环境变量
root@leco:/usr/local/src/memcached-1.5.12# vim /etc/profile
root@leco:/usr/local/src/memcached-1.5.12# tail -1 /etc/profile
export PATH=$PATH:/usr/local/memcached/bin
root@leco:/usr/local/src/memcached-1.5.12# source /etc/profile
```
以上是源码包安装，可以安装最新版本的，要是在线安装，都是基于系统源安装的。推荐源码安装

#### 1.2.3 启动

```
root@leco:~# memcached -d -m 10 -u root -l 0.0.0.0 -p 11211 -c 256 -P /tmp/memcached.pid
root@leco:~# netstat -lnp|grep 11211
tcp        0      0 0.0.0.0:11211           0.0.0.0:*               LISTEN      7862/memcached
unix  2      [ ACC ]     流        LISTENING     100911211 11507/unity-files-d @leco-com.canonical.Unity.Scope.files.T5294429510698002

root@leco:~# telnet localhost 11211
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
如果出现以上内容就代表启动成功！
```
参数说明

参数|描述
---|---
-d	|是启动一个守护进程
-m	|是分配给Memcache使用的内存数量，单位是MB
-u	|是运行Memcache的用户
-l	|是监听的服务器IP地址
-p	|是设置Memcache监听的端口,最好是1024以上的端口
-c	|选项是最大运行的并发连接数，默认是1024，按照你服务器的负载量来设定
-P	|是设置保存Memcache的pid文件

#### 1.2.4 设置开机启动

```
echo 'memcached -d -m 10 -u root -l 0.0.0.0 -p 11211 -c 256 -P /tmp/memcached.pid' >> /etc/rc.local
```

#### 1.2.5 停止

```
pkill `cat /tmp/memcached.pid`
```

## 2. memcached库
### 2.1 安装

```
root@leco:/home/leco# pip install python3-memcached
Collecting python3-memcached
  Downloading https://files.pythonhosted.org/packages/14/fa/cd0d93c30722db0cfa777ec9cd0203fa7da2771a5c70c9908f471944b6e2/python3-memcached-1.51.tar.gz
Building wheels for collected packages: python3-memcached
  Running setup.py bdist_wheel for python3-memcached ... done
  Stored in directory: /root/.cache/pip/wheels/6b/50/29/888c59a274ac0e5d3831987eec3a6f6c4562e021c2fc0311b0
Successfully built python3-memcached
Installing collected packages: python3-memcached
Successfully installed python3-memcached-1.51

root@leco:~/book# pip -V
pip 9.0.1 from /usr/local/lib/python3.6/site-packages (python 3.6)
root@leco:~/book# python3.6
Python 3.6.1 (default, Mar 21 2018, 13:46:25)
[GCC 5.4.0 20160609] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import memcache
>>>
```
导入没有报错就表示安装成功。

### 2.2 测试

```
root@leco:~/book# ipython
Python 3.6.1 (default, Mar 21 2018, 13:46:25)
Type 'copyright', 'credits' or 'license' for more information
IPython 6.2.1 -- An enhanced Interactive Python. Type '?' for help.
# 导入模块
In [1]: import memcache
# 链接，ip：port
In [2]: conn = memcache.Client(['127.0.0.1:11211'])
# 设置 key:value
In [3]: conn.set('k1', 'v1')
Out[3]: True
# 取值
In [4]: conn.get('k1')
Out[4]: 'v1
```
### 2.3 其他命令测试

用nc命令操作memcached

功能|命令
---|---
存储数据 |printf "set key 0 10 6\r\nresult\r\n" |nc 192.168.5.110 11211
获取数据|printf "get key\r\n" |nc 192.168.5.110 11211
删除数据|printf "delete key\r\n" |nc 192.168.5.110 11211
查看状态|printf "stats\r\n" |nc 192.168.5.110 11211
模拟top命令查看状态|watch "echo stats" |nc 192.168.5.110 11211
清空缓存|printf "flush_all\r\n" |nc 192.168.5.110 11211 (小心操作，清空了缓存就没了）

### 2.3 集群
python-memcached模块原生支持集群操作，其原理是在内存中维护一个主机列表，且集群中主机的权重值和主机在列表中重复出现的次数成正比。

```
主机     权重
1.1.1.1   1
1.1.1.2   2
1.1.1.3   1
 
那么在内存中主机列表为：
    host_list = ["1.1.1.1", "1.1.1.2", "1.1.1.2", "1.1.1.3", ]
```
用户如果要在内存中创建一个键值对（如：k1 = "value1"），那么要执行以下步骤：

1. 根据算法将k1转换成一个数字
1. 将数字和主机列表长度求余数，得到一个值N（0 <= N < 长度）
1. 在主机列表中根据第二步得到的值为索引获取主机，例如: host_list[N]
1. 连接将第三步中获取的主机，将k1 = "value1" 放置在该服务器的内存中

另外在启动两个服务

```
memcached -d -m 10 -u root -l 0.0.0.0 -p 11212 -c 256 -P /tmp/memcached2.pid
memcached -d -m 10 -u root -l 0.0.0.0 -p 11213 -c 256 -P /tmp/memcached3.pid
```
操作过程

```
root@leco:~# memcached -d -m 10 -u root -l 0.0.0.0 -p 11212 -c 256 -P /tmp/memcached2.pid
root@leco:~# memcached -d -m 10 -u root -l 0.0.0.0 -p 11213 -c 256 -P /tmp/memcached3.pid
root@leco:~# netstat -lnp|grep memcached
tcp        0      0 0.0.0.0:11211           0.0.0.0:*               LISTEN      7862/memcached
tcp        0      0 0.0.0.0:11212           0.0.0.0:*               LISTEN      11748/memcached
tcp        0      0 0.0.0.0:11213           0.0.0.0:*               LISTEN      11759/memcached
```

```
root@leco:~/code/memcached# cat test1.py
#!/usr/bin/env python3
#coding:utf8
import memcache
mc = memcache.Client([('127.0.0.1:11211', 1), ('127.0.0.1:11212', 2),('127.0.0.1:11213',3)])
mc.set('k1','value1')
ret = mc.get('k1')
print (ret)
```
运行结果

```
root@leco:~/code/memcached# python3.6 test1.py
value1
```

### 2.4 存储操作
#### 2.4.1 set/set_multi
- set : 设置一个键值对，如果Key不存在，则创建，如果key存在，则修改。
- set_multi : 设置多个键值对，如果key不存在，则创建，如果key存在，则修改。

```
root@leco:~/code/memcached# cat set.py
#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('name','jack')
re = mc.get('name')
print('set用法',re) #设置一个键值对

dic = {'name':'jack','age':'19','job':'IT'}
mc.set_multi(dic)  #设置多个键值对
#或者mc.set_multi({'name':'jack','age':'19','job':'IT'})
name = mc.get('name')
age = mc.get('age')
job = mc.get('job')
print('set_multi用法:',name,age,job)
```
运行结果

```
root@leco:~/code/memcached# python3 set.py
set用法 jack
set_multi用法: jack 19 IT
```
#### 2.4.2 add
添加一条键值对，如果已经存在的key，重复执行add操作返回值为flase。

```
root@leco:~/code/memcached# cat add.py
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
```
运行结果

```
root@leco:~/code/memcached# python2 add.py
True  # 第一添加add 这个键时候，之前是没有的，所有可以创建。
False # 第二次再次添加add这个键时候，之前有了add这个键，所以创建失败
v1
```
#### 2.4.3 replace
replace修改某个key的值，如果key不存在，返回False

```
root@leco:~/code/memcached# cat replace.py
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
root@leco:~/code/memcached# python3 replace.py
张三
ret_name =  True   # key存在替换成功
ret1 =  李四       # 修改后的值
rereplace =  False # key不存在，替换失败
ret2 =  None       # 不存在的key，返回False
```
#### 2.4.4 append/prepend
- append : 修改指定key的值，在该值后面追加内容。
- prepend : 修改指定key的值，在该值前面插入内容。

```
root@leco:~/code/memcached# cat append.py
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
```
运行结果

```
root@leco:~/code/memcached# python3 append.py
我是中间部分
我是中间部分我是后面部分
我是开头部分我是中间部分我是后面部分
```


#### 2.4.5 gets/cas
使用缓存系统共享数据资源就必然绕不开数据争夺和脏数据（数据混乱）的问题。

假设去往徐州的高铁G88列车剩余票数保存在memcache中，ticket_count = 88

A用户刷新页面从memecache中读取到ticket_count = 88

B用户刷新页面从memecache中读取到ticket_count = 88

A,B用户均购买该趟列车的票，并修改ticket_count的值

A修改后，ticket_count = 87

B修改后，ticket_count = 87

然而正确数字应该是86，数据就混乱了。

如果想要避免这种情况的发生，则可以使用  gets　和　cas

```
root@leco:~/code/memcached# cat gets.py
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
root@leco:~/code/memcached# python3 gets.py
剩余票数 88
88
True
剩余票数 88
```
本质上每次执行gets时，会从memcache中获取一个自增的数字，通过cas去修改gets的值时，会携带之前获取的自增和memcache中的自增值进行比较，如果相等，则可以提交，如果不相等，那么表示在gets和cas执行之间，又有其他人执行了gets，则不允许修改。

### 2.5 查找操作
#### 2.5.1 get,get_multi
- get : 获取一个键值对。
- get_multi : 获取多个键值对。

```
root@leco:~/code/memcached# cat get.py
#!/usr/bin/env python3
#coding:utf8
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
mc.set('name','jack')
re = mc.get('name')
print('get',re)                              # 获取一个键值对
dic = {'name':'jack','age':'20','job':'IT'}
mc.set_multi(dic)
regetmu=mc.get_multi(['name','age','job'])
print('get_multi',re)                        # 获取多个键值对的值
root@leco:~/code/memcached# python3 get.py
get jack
get_multi jack
```
> 若是get的key不存在的话，返回为空。


#### 2.5.2 delete/delete_multi
- delete : 在Memcached中删除指定的一个键值对。
- delete_multi : 在Memcached中删除指定多个键值对。

```
root@leco:~/code/memcached# cat del.py
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
```
运行结果

```
root@leco:~/code/memcached# python3 del.py
name1 = JACK1, name2=JACK2, name3=JACK3
删除 jack
name1 = None, name2=None, name3=None
```

#### 2.5.4 incre/decr
- decr : 自减，将Memcached中的一个值增加N（N默认为1）
- incr  : 自增，将Memcached中的一个值减少N（N默认为1）

```
root@leco:~/code/memcached# cat decr.py
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
root@leco:~/code/memcached# python3 decr.py
原始值 1
加值后结果 =  10
减值后结果 =  5
```

### 2.6 统计操作
#### 2.6.1 stats
Memcached stats命令用于返回统计信息例如PID（进程号），版本号，连接数等。

```
root@leco:~/code/memcached# cat stats.py
#!/usr/bin/env python
# -*- coding:utf-8 -*-
import memcache
mc = memcache.Client(['127.0.0.1:11211'])
ret = mc.get_stats()
print(ret)
root@leco:~/code/memcached# python3 stats.py
[(b'127.0.0.1:11211 (1)', {b'pid': b'7862', b'uptime': b'6680', b'time': b'1550635332', b'version': b'1.5.12', b'libevent': b'2.0.21-stable', b'pointer_size': b'64', b'rusage_user': b'0.537668', b'rusage_system': b'0.414349', b'max_connections': b'256', b'curr_connections': b'2', b'total_connections': b'31', b'rejected_connections': b'0', b'connection_structures': b'4', b'reserved_fds': b'20', b'cmd_get': b'77', b'cmd_set': b'65', b'cmd_flush': b'0', b'cmd_touch': b'0', b'get_hits': b'67', b'get_misses': b'10', b'get_expired': b'0', b'get_flushed': b'0', b'delete_misses': b'4', b'delete_hits': b'6', b'incr_misses': b'0', b'incr_hits': b'2', b'decr_misses': b'0', b'decr_hits': b'1', b'cas_misses': b'0', b'cas_hits': b'0', b'cas_badval': b'0', b'touch_hits': b'0', b'touch_misses': b'0', b'auth_cmds': b'0', b'auth_errors': b'0', b'bytes_read': b'2630', b'bytes_written': b'4681', b'limit_maxbytes': b'10485760', b'accepting_conns': b'1', b'listen_disabled_num': b'0', b'time_in_listen_disabled_us': b'0', b'threads': b'4', b'conn_yields': b'0', b'hash_power_level': b'16', b'hash_bytes': b'524288', b'hash_is_expanding': b'0', b'slab_reassign_rescues': b'0', b'slab_reassign_chunk_rescues': b'0', b'slab_reassign_evictions_nomem': b'0', b'slab_reassign_inline_reclaim': b'0', b'slab_reassign_busy_items': b'0', b'slab_reassign_busy_deletes': b'0', b'slab_reassign_running': b'0', b'slabs_moved': b'0', b'lru_crawler_running': b'0', b'lru_crawler_starts':b'3825', b'lru_maintainer_juggles': b'14452', b'malloc_fails': b'0', b'log_worker_dropped': b'0', b'log_worker_written': b'0', b'log_watcher_skipped': b'0', b'log_watcher_sent': b'0', b'bytes': b'520', b'curr_items': b'8', b'total_items': b'56', b'slab_global_page_pool': b'0', b'expired_unfetched': b'0', b'evicted_unfetched': b'0', b'evicted_active': b'0', b'evictions': b'0', b'reclaimed': b'0', b'crawler_reclaimed': b'0', b'crawler_items_checked': b'41', b'lrutail_reflocked': b'4', b'moves_to_cold': b'24', b'moves_to_warm': b'8', b'moves_within_lru': b'1', b'direct_reclaims': b'0', b'lru_bumps_dropped': b'0'})]

```

#### 2.6.2 slabs
Memcached stats slabs 命令用于显示各个slab的信息，包括chunk的大小、数目、使用情况等。


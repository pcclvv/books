
## 1. 介绍
Redis是一个基于内存的高效的键值型非关系型数据库，存取效率极高，而且支持多种存储数据结构，使用也非常简单。本节中，我们就来介绍一下Python的Redis操作，主要介绍RedisPy这个库的用法。

### 1.1 准备工作
在开始之前，请确保已经安装好了Redis及RedisPy库。如果要做数据导入/导出操作的话，还需要安装RedisDump。

### 1.2 Redis StrictRedis

RedisPy库提供两个类Redis和StrictRedis来实现Redis的命令操作。

StrictRedis实现了绝大部分官方的命令，参数也一一对应，比如set()方法就对应Redis命令的set方法。而Redis是StrictRedis的子类，它的主要功能是用于向后兼容旧版本库里的几个方法。为了做兼容，它将方法做了改写，比如lrem()方法就将value和num参数的位置互换，这和Redis命令行的命令参数不一致。官方推荐使用StrictRedis

### 1.3 安装
Redis 和 python操作模块 安装 及 启动
- ubuntu系统

```
apt-get install redis-server
pip3 install Redis
/etc/init.d/redis-server restart
```

- centos系统

```
yum install redis-server
pip3 install Redis
/etc/init.d/redis-server restart
```

- 查看版本：

```
redis-cli info  # redis详细信息
redis-cli --version  |  redis-cli -v
redis-server --version  |  redis-server -v
```
-  简单使用：

```
127.0.0.1:6379> set name 'keke'    # 设置 键为name 对应的值为keke
OK
127.0.0.1:6379> set age '3'
OK 
127.0.0.1:6379> keys *             # 查看所有的键
1) "age"
2) "name"
127.0.0.1:6379> get name           # 查看键为name对应的值
"keke"
127.0.0.1:6379> get age
"3"
127.0.0.1:6379> set sex female ex 2  # 设置值，只存活2秒
OK
127.0.0.1:6379> keys *
1) "age"
2) "name"
127.0.0.1:6379> set sex female ex 10 
OK
127.0.0.1:6379> keys *
1) "age"
2) "sex"
3) "name"
127.0.0.1:6379> get sex
"female"
127.0.0.1:6379> keys *
1) "age"
2) "name"
127.0.0.1:6379> flushdb   # 清空当前db下的所有键值，谨慎操作
OK
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379>
127.0.0.1:6379> flushall  # 清空所有db下的键值
OK
```

## 2. 基本命令
### 2.1 redis key命令

Redis keys 命令|命令及描述
---|---
DEL key|该命令用于在 key 存在时删除 key。
DUMP key |序列化给定 key ，并返回被序列化的值。
EXISTS key |检查给定 key 是否存在。
EXPIRE key seconds|为给定 key 设置过期时间，以秒计。
EXPIREAT key timestamp |EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。 不同在于 EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp)。
PEXPIRE key milliseconds |设置 key 的过期时间以毫秒计。
PEXPIREAT key milliseconds-timestamp |设置 key 过期时间的时间戳(unix timestamp) 以毫秒计
KEYS pattern |查找所有符合给定模式( pattern)的 key 。
MOVE key db |将当前数据库的 key 移动到给定的数据库 db 当中。
PERSIST key |移除 key 的过期时间，key 将持久保持。
PTTL key |以毫秒为单位返回 key 的剩余的过期时间。
TTL key |以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live)。
RANDOMKEY |从当前数据库中随机返回一个 key 。
RENAME key newkey |修改 key 的名称
RENAMENX key newkey |仅当 newkey 不存在时，将 key 改名为 newkey 。
TYPE key |返回 key 所储存的值的类型。

### 2.2 redis 字符串命令

Redis 字符串命令|命令及描述
---|---
SET key value |设置指定 key 的值
GET key |获取指定 key 的值。
GETRANGE key start end |返回 key 中字符串值的子字符
GETSET key value|将给定 key 的值设为 value ，并返回 key 的旧值(old value)。
GETBIT key offset|对 key 所储存的字符串值，获取指定偏移量上的位(bit)。
MGET key1 [key2..]|获取所有(一个或多个)给定 key 的值。
SETBIT key offset value|对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit)。
SETEX key seconds value|将值 value 关联到 key ，并将 key 的过期时间设为 seconds (以秒为单位)。
SETNX key value|只有在 key 不存在时设置 key 的值。
SETRANGE key offset value|用 value 参数覆写给定 key 所储存的字符串值，从偏移量 offset 开始。
STRLEN key|返回 key 所储存的字符串值的长度。
MSET key value [key value ...]|同时设置一个或多个 key-value 对。
MSETNX key value [key value ...] |同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在。
PSETEX key milliseconds value|这个命令和 SETEX 命令相似，但它以毫秒为单位设置 key 的生存时间，而不是像 SETEX 命令那样，以秒为单位。
INCR key|将 key 中储存的数字值增一。
INCRBY key increment|将 key 所储存的值加上给定的增量值（increment） 。
INCRBYFLOAT key increment|将 key 所储存的值加上给定的浮点增量值（increment） 。
DECR key|将 key 中储存的数字值减一。
DECRBY key decrement|key 所储存的值减去给定的减量值（decrement） 。
APPEND key value|如果 key 已经存在并且是一个字符串， APPEND 命令将指定的 value 追加到该 key 原来值（value）的末尾。

### 2.3 redis hash串命令

Redis hash 命令|命令及描述
---|---
HDEL key field1 [field2] |删除一个或多个哈希表字段
HEXISTS key field |查看哈希表 key 中，指定的字段是否存在。
HGET key field |获取存储在哈希表中指定字段的值。
HGETALL key |获取在哈希表中指定 key 的所有字段和值
HINCRBY key field increment |为哈希表 key 中的指定字段的整数值加上增量 increment 。
HINCRBYFLOAT key field increment |为哈希表 key 中的指定字段的浮点数值加上增量 increment 。
HKEYS key |获取所有哈希表中的字段
HLEN key |获取哈希表中字段的数量
HMGET key field1 [field2] |获取所有给定字段的值
HMSET key field1 value1 [field2 value2 ] |同时将多个 field-value (域-值)对设置到哈希表 key 中。
HSET key field value |将哈希表 key 中的字段 field 的值设为 value 。
HSETNX key field value |只有在字段 field 不存在时，设置哈希表字段的值。
HVALS key |获取哈希表中所有值
HSCAN key cursor [MATCH pattern] [COUNT count] |迭代哈希表中的键值对。

### 2.4 redis 列表命令

Redis 列表命令|命令及描述
---|---
BLPOP key1 [key2 ] timeout |移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
BRPOP key1 [key2 ] timeout |移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
BRPOPLPUSH source destination timeout |从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止。
LINDEX key index |通过索引获取列表中的元素
LINSERT key BEFORE|AFTER pivot value |在列表的元素前或者后插入元素
LLEN key |获取列表长度
LPOP key |移出并获取列表的第一个元素
LPUSH key value1 [value2] |将一个或多个值插入到列表头部
LPUSHX key value |将一个值插入到已存在的列表头部
LRANGE key start stop |获取列表指定范围内的元素
LREM key count value |移除列表元素
LSET key index value |通过索引设置列表元素的值
LTRIM key start stop |对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除。
RPOP key |移除列表的最后一个元素，返回值为移除的元素。
RPOPLPUSH source destination |移除列表的最后一个元素，并将该元素添加到另一个列表并返回
RPUSH key value1 [value2] |在列表中添加一个或多个值
RPUSHX key value |为已存在的列表添加值

### 2.5 redis 列表集合命令

Redis 集合命令|命令及描述
---|---
SADD key member1 [member2] |向集合添加一个或多个成员
SCARD key |获取集合的成员数
SDIFF key1 [key2] |返回给定所有集合的差集
SDIFFSTORE destination key1 [key2] |返回给定所有集合的差集并存储在 destination 中
SINTER key1 [key2] |返回给定所有集合的交集
SINTERSTORE destination key1 [key2] |返回给定所有集合的交集并存储在 destination 中
SISMEMBER key member |判断 member 元素是否是集合 key 的成员
SMEMBERS key |返回集合中的所有成员
SMOVE source destination member |将 member 元素从 source 集合移动到 destination 集合
SPOP key |移除并返回集合中的一个随机元素
SRANDMEMBER key [count] |返回集合中一个或多个随机数
SREM key member1 [member2] |移除集合中一个或多个成员
SUNION key1 [key2] |返回所有给定集合的并集
SUNIONSTORE destination key1 [key2] |所有给定集合的并集存储在 destination 集合中
SSCAN key cursor [MATCH pattern] [COUNT count] |迭代集合中的元素

### 2.6 redis 列有序集合命令

Redis 有序集合命令|命令及描述
---|---
ZADD key score1 member1 [score2 member2] |向有序集合添加一个或多个成员，或者更新已存在成员的分数
ZCARD key |获取有序集合的成员数
ZCOUNT key min max |计算在有序集合中指定区间分数的成员数
ZINCRBY key increment member |有序集合中对指定成员的分数加上增量 increment
ZINTERSTORE destination numkeys key [key ...] |计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 key 中
ZLEXCOUNT key min max |在有序集合中计算指定字典区间内成员数量
ZRANGE key start stop [WITHSCORES] |通过索引区间返回有序集合成指定区间内的成员
ZRANGEBYLEX key min max [LIMIT offset count] |通过字典区间返回有序集合的成员
ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT] |通过分数返回有序集合指定区间内的成员
ZRANK key member |返回有序集合中指定成员的索引
ZREM key member [member ...] |移除有序集合中的一个或多个成员
ZREMRANGEBYLEX key min max |移除有序集合中给定的字典区间的所有成员
ZREMRANGEBYRANK key start stop |移除有序集合中给定的排名区间的所有成员
ZREMRANGEBYSCORE key min max |移除有序集合中给定的分数区间的所有成员
ZREVRANGE key start stop [WITHSCORES] |返回有序集中指定区间内的成员，通过索引，分数从高到底
ZREVRANGEBYSCORE key max min [WITHSCORES] |返回有序集中指定分数区间内的成员，分数从高到低排序
ZREVRANK key member |返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序
ZSCORE key member |返回有序集中，成员的分数值
ZUNIONSTORE destination numkeys key [key ...] |计算给定的一个或多个有序集的并集，并存储在新的 key 中
ZSCAN key cursor [MATCH pattern] [COUNT count] |迭代有序集合中的元素（包括元素成员和元素分值）

### 2.7 redis HyperLogLog命令

Redis HyperLogLog 命令|命令及描述
---|---
PFADD key element [element ...] |添加指定元素到 HyperLogLog 中。
PFCOUNT key [key ...] |返回给定 HyperLogLog 的基数估算值。
PFMERGE destkey sourcekey [sourcekey ...] |将多个 HyperLogLog 合并为一个 HyperLogLog

### 2.8 redis 发布订阅命令
Redis 发布订阅命令|命令及描述
---|---
PSUBSCRIBE pattern [pattern ...] |订阅一个或多个符合给定模式的频道。
PUBSUB subcommand [argument [argument ...]] |查看订阅与发布系统状态。
PUBLISH channel message |将信息发送到指定的频道。
PUNSUBSCRIBE [pattern [pattern ...]] |退订所有给定模式的频道。
SUBSCRIBE channel [channel ...] |订阅给定的一个或多个频道的信息。
UNSUBSCRIBE [channel [channel ...]] |指退订给定的频道。

### 2.9 redis 事务命令

Redis 事务命令|命令及描述
---|---
DISCARD |取消事务，放弃执行事务块内的所有命令。
EXEC |执行所有事务块内的命令。
MULTI |标记一个事务块的开始。
UNWATCH |取消 WATCH 命令对所有 key 的监视。
WATCH key [key ...] |监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断

### 2.10 redis 脚本命令

Redis 脚本命令|命令及描述
---|---
EVAL script numkeys key [key ...] arg [arg ...] |执行 Lua 脚本。
EVALSHA sha1 numkeys key [key ...] arg [arg ...] |执行 Lua 脚本。
SCRIPT EXISTS script [script ...] |查看指定的脚本是否已经被保存在缓存当中。
SCRIPT FLUSH |从脚本缓存中移除所有脚本。
SCRIPT KILL |杀死当前正在运行的 Lua 脚本。
SCRIPT LOAD script |将脚本 script 添加到脚本缓存中，但并不立即执行这个脚本。

### 2.11 redis 链接命令

Redis 连接命令|命令及描述
---|---
AUTH password |验证密码是否正确
ECHO message |打印字符串
PING |查看服务是否运行
QUIT |关闭当前连接
SELECT index |切换到指定的数据库

### 2.12 redis 服务器命令

Redis 服务器命令|命令及描述
---|---
BGREWRITEAOF |异步执行一个 AOF（AppendOnly File） 文件重写操作
BGSAVE |在后台异步保存当前数据库的数据到磁盘
CLIENT KILL [ip:port] [ID client-id] |关闭客户端连接
CLIENT LIST |获取连接到服务器的客户端连接列表
CLIENT GETNAME |获取连接的名称
CLIENT PAUSE timeout |在指定时间内终止运行来自客户端的命令
CLIENT SETNAME connection-name |设置当前连接的名称
CLUSTER SLOTS |获取集群节点的映射数组
COMMAND |获取 Redis 命令详情数组
COMMAND COUNT |获取 Redis 命令总数
COMMAND GETKEYS |获取给定命令的所有键
TIME |返回当前服务器时间
COMMAND INFO command-name [command-name ...] |获取指定 Redis 命令描述的数组
CONFIG GET parameter |获取指定配置参数的值
CONFIG REWRITE |对启动 Redis 服务器时所指定的 redis.conf 配置文件进行改写
CONFIG SET parameter value |修改 redis 配置参数，无需重启
CONFIG RESETSTAT |重置 INFO 命令中的某些统计数据
DBSIZE |返回当前数据库的 key 的数量
DEBUG OBJECT key |获取 key 的调试信息
DEBUG SEGFAULT |让 Redis 服务崩溃
FLUSHALL|删除所有数据库的所有key
FLUSHDB |删除当前数据库的所有key
INFO [section] |获取 Redis 服务器的各种信息和统计数值
LASTSAVE |返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示
MONITOR |实时打印出 Redis 服务器接收到的命令，调试用
ROLE |返回主从实例所属的角色
SAVE |同步保存数据到硬盘
SHUTDOWN [NOSAVE] [SAVE] |异步保存数据到硬盘，并关闭服务器
SLAVEOF host port |将当前服务器转变为指定服务器的从属服务器(slave server)
SLOWLOG subcommand [argument] |管理 redis 的慢日志
SYNC |用于复制功能(replication)的内部命令


## 3. 详细
### 3.1 安装redis库
```
pip install redis
```
### 3.2 Python操作Redis
- 连接
redis-py提供两个类Redis和StrictRedis用于实现Redis的命令，StrictRedis用于实现大部分官方的命令，并使用官方的语法和命令，Redis是StrictRedis的子类，用于向后兼容旧版本的redis-py。

```
import redis

r = redis.Redis(host='127.0.0.1', port=6379)
r.set('name', 'Jack')
print (r.get('name'))
```
- 连接池
redis-py使用connection pool来管理对一个redis server的所有连接，避免每次建立、释放连接的开销。默认，每个Redis实例都会维护一个自己的连接池。可以直接建立一个连接池，然后作为参数Redis，这样就可以实现多个Redis实例共享一个连接池。

```
import redis

pool = redis.ConnectionPool(host='127.0.0.1', port=6379)
r = redis.Redis(connection_pool=pool)
r.set('name', 'Jack')
print r.get('name')
```
### 3.2 string
#### 3.2.1 set

- set 
- setnx   setnx(name, value)
- setex   setex(name, value, time)
- psetex  psetex(name, time_ms, value)

```
set(name, value, ex=None, px=None, nx=False, xx=False)
```
help set
在Redis中设置值，默认，不存在则创建，存在则修改

参数：
- ex，过期时间（秒）
- px，过期时间（毫秒）
- nx，如果设置为True，则只有name不存在时，当前set操作才执行
- xx，如果设置为True，则只有name存在时，当前set操作才执行


```
setex(name, value, time)
#设置过期时间（秒）

psetex(name, time_ms, value)
#设置过期时间（豪秒）
```
操作过程

```
In [5]: r.set('k1','v1')
Out[5]: True

In [6]: r.get('key1')

In [7]: r.get('k1')
Out[7]: b'v1'
```

#### 3.2.3 mset
mset(*args, **kwargs)

```
#批量设置值
r.mset(name1='zhangsan', name2='lisi')
#或
r.mget({"name1":'zhangsan', "name2":'lisi'})
```
操作过程

```
In [14]: r.mset(name1='zhangsan', name2='lisi')
Out[14]: True

In [15]: r.mget({"name1":'zhangsan', "name2":'lisi'})
Out[15]: [b'zhangsan', b'lisi']
```

#### 3.2.4 mget
mget(keys, *args)

```
#批量获取
print(r.mget("name1","name2"))
#或
li=["name1","name2"]
print(r.mget(li))
```
操作过程

```
In [16]: r.mget("name1","name2")
Out[16]: [b'zhangsan', b'lisi']

In [17]: name=["name1","name2"]

In [18]: r.mget(name)
Out[18]: [b'zhangsan', b'lisi']
```

#### 3.2.5 getset
getset(name, value)

```
#设置新值，打印原值
print(r.getset("name1","wangwu")) #输出:zhangsan
print(r.get("name1")) #输出:wangwu
```
操作过程

```
In [26]: r.get("name1")
Out[26]: b'zhangsan'

In [27]: r.getset("name1","wangwu")
Out[27]: b'zhangsan'

In [28]: r.get("name1")
Out[28]: b'wangwu'
```

#### 3.2.6 getrange
getrange(key, start, end)

```
#根据字节获取子序列
r.set("name","zhangsan")
print(r.getrange("name",0,4))#输出:zhang
```
操作过程

```
In [29]: r.set("name","zhangsan")
Out[29]: True

In [30]: r.getrange('name',0,4)
Out[30]: b'zhang'
```

#### 3.2.7 setrange
setrange(name, offset, value)

```
#修改字符串内容，从指定字符串索引开始向后替换，如果新值太长时，则向后添加
r.set("name","zhangsan")
r.setrange("name",1,"ww")
print(r.get("name")) #输出:zwwngsan

r.set("name","zhangsan")
r.setrange("name",6,"wwww")
print(r.get("name")) #输出:zwwwwsan

r.set("name","zhangsan")
r.setrange("name",6,"wwwwwwwwwww")
print(r.get("name")) #输出:zwwwwwwwwwww
```
操作过程

```
In [31]: r.set("name","zhangsan")
Out[31]: True

In [32]: r.setrange("name",1,"ww")
Out[32]: 8

In [33]: r.get("name")
Out[33]: b'zwwngsan'

In [34]: r.set("name","zhangsan")
Out[34]: True

In [35]: r.setrange("name",1,"wwww")
Out[35]: 8

In [36]: r.get("name")
Out[36]: b'zwwwwsan'

In [37]: r.set("name","zhangsan")
Out[37]: True

In [38]: r.setrange("name",1,"wwwwwwwwwww")
Out[38]: 12

In [39]: r.get("name")
Out[39]: b'zwwwwwwwwwww'

```
#### 3.2.8 setbit
setbit(name, offset, value)

```
#对二进制表示位进行操作
''' name:redis的name
    offset，位的索引（将值对应的ASCII码变换成二进制后再进行索引）
    value，值只能是 1 或 0 '''

str="345"
r.set("name",str)
for i in str:
    print(i,ord(i),bin(ord(i)))#输出 值、ASCII码中对应的值、对应值转换的二进制
'''
输出:
51 0b110011
52 0b110100
53 0b110101'''

r.setbit("name",6,0)#把第7位改为0，也就是3对应的变成了0b110001
print(r.get("name"))#输出：145
```
操作过程

```
In [45]: str="345"

In [46]: r.set("name",str)
Out[46]: True

In [47]: r.setbit("name",6,0)
Out[47]: 1

In [48]: r.get("name")
Out[48]: b'145'
```
#### 3.2.9 getbit
getbit(name, offset)

```
#获取name对应值的二进制中某位的值(0或1)
r.set("name","3") # 对应的二进制0b110011
print(r.getbit("name",5))   #输出:0
print(r.getbit("name",6))   #输出:1
```
操作过程

```
In [49]: r.set("name","3")
Out[49]: True

In [50]: r.get('name')
Out[50]: b'3'

In [51]: r.getbit("name",5)
Out[51]: 0

In [52]: r.getbit("name",6)
Out[52]: 1
```

#### 3.2.10 bitcount
bitcount(key, start=None, end=None)

```
#获取对应二进制中1的个数
r.set("name","345")#0b110011 0b110100 0b110101
print(r.bitcount("name",start=0,end=1)) #输出:7
''' key:Redis的name
    start:字节起始位置
    end:字节结束位置'''
```
操作过程

```
In [56]: r.set("name","345")
Out[56]: True

In [57]:
    ...: r.bitcount("name",start=0,end=1)
Out[57]: 7
```

#### 3.2.11 strlen
strlen(name)

```
#返回name对应值的字节长度（一个汉字3个字节）
r.set("name","zhangsan")
print(r.strlen("name")) #输出:8
```
操作过程

```
In [58]: r.set("name","zhangsan")
Out[58]: True

In [59]: r.strlen("name")
Out[59]: 8

In [60]: r.set("name","张三")
Out[60]: True

In [61]: r.strlen("name")
Out[61]: 6
```

#### 3.2.12 incr
incr(self, name, amount=1)

```
#自增mount对应的值，当mount不存在时，则创建mount＝amount，否则，则自增,amount为自增数(整数)
print(r.incr("mount",amount=2))#输出:2
print(r.incr("mount"))#输出:3
print(r.incr("mount",amount=3))#输出:6
print(r.incr("mount",amount=6))#输出:12
print(r.get("mount")) #输出:12
```
操作过程

```
In [66]: r.incr("num",amount=2)
Out[66]: 2

in [67]: r.incr("num",amount=10)
Out[67]: 12

In [68]: r.incr("num")
Out[68]: 13

In [69]: r.get('num')
Out[69]: b'13'

In [70]: r.incr("num",amount=20)
Out[70]: 33

In [71]: r.incr("num",amount=30)
Out[71]: 63

In [72]: r.get('num')
Out[72]: b'63'
```

#### 3.2.13 incrbyfloat
incrbyfloat(self, name, amount=1.0)
类似 incr() 自增,amount为自增数(浮点数)

#### 3.2.14 decr
decr(self, name, amount=1)
自减name对应的值,当name不存在时,则创建name＝amount，否则，则自减，amount为自增数(整数)

#### 3.2.15 append
append(name, value)

```
#在name对应的值后面追加内容
r.set("name","zhangsan")
print(r.get("name"))    #输出:'zhangsan
r.append("name","lisi")
print(r.get("name"))    #输出:zhangsanlisi
```
操作过程

```
In [73]: r.set("name","zhangsan")
Out[73]: True

In [74]: r.get('name')
Out[74]: b'zhangsan'

In [75]: r.append('name','lisi')
Out[75]: 12

In [76]: r.get('name')
Out[76]: b'zhangsanlisi'
```

### 3.3 Hash
redis中的Hash 在内存中类似于一个name对应一个dic来存储 
#### 3.3.1 hset
hset(name, key, value)

```
name对应的hash中设置一个键值对（不存在，则创建，否则，修改）
r.hset("hash_name","key1","values1")
```
操作过程

```
In [12]: r.hset('hash_name','key1','values1')
Out[12]: 1
127.0.0.1:6379> TYPE hash_name
hash
127.0.0.1:6379> HGETALL hash_name
1) "key1"
2) "values1"
127.0.0.1:6379> HGET hash_name key1
"values1"
```

#### 3.3.2 hget
hget(name,key)  取单个key值
```
r.hset("hash_name","key1","values1")
#在hash_name对应的hash中根据key获取value
print(r.hget("hash_name","key1"))#输出:aa
```
操作过程

```
In [13]: r.hset("hash_name","key1","values1")
Out[13]: 0

In [14]: r.hget("hash_name","key1")
Out[14]: b'values1'
```

#### 3.3.3 hgetall
hgetall(name) 获取name对应hash的所有键值

```
In [22]: r.hset("hash_name","key1","values1")
Out[22]: 1

In [23]: r.hset("hash_name","key2","values2")
Out[23]: 1

In [24]: r.hset("hash_name","key3","values3")
Out[24]: 1

In [25]: r.hget('hash_name','key1')
Out[25]: b'values1'

In [26]: r.hget('hash_name','key')

In [27]: r.hget('hash_name','key2')
Out[27]: b'values2'

In [28]: r.hget('hash_name','key3')
Out[28]: b'values3'

In [29]: r.hgetall('hash_name')
Out[29]: {b'key1': b'values1', b'key2': b'values2', b'key3': b'values3'}

```


#### 3.3.4 hmset
hmset(name, mapping)  在name对应的hash中批量设置键值对,mapping:字典

```
In [33]: dic={"name":"summer","job":"IT"}

In [34]: r.hmset('dic_name',dic)
Out[34]: True

127.0.0.1:6379> HGETALL dic_name
1) "name"
2) "summer"
3) "job"
4) "IT"

```

#### 3.3.5 hmget/hmgetall
hmget(name, keys, *args) 在name对应的hash中获取多个key的值

```
In [36]: r.hmget('dic_name','name')
Out[36]: [b'summer']

In [37]: r.hmget('dic_name','job')
Out[37]: [b'IT']

```

#### 3.3.6 hlen/hkeys/hvals
hlen(name)、hkeys(name)、hvals(name)

```
dic={"name":"summer","job":"IT",'age':30}
r.hmset("dic_name",dic)

#hlen(name) 获取hash中键值对的个数
print(r.hlen("dic_name"))

#hkeys(name) 获取hash中所有的key的值
print(r.hkeys("dic_name"))

#hvals(name) 获取hash中所有的value的值
print(r.hvals("dic_name"))
```
操作过程

```
In [40]: dic={"name":"summer","job":"IT",'age':30}

In [41]: r.hmset('dic_name',dic)
Out[41]: True

In [42]: r.hlen('dic_name')
Out[42]: 3

In [43]: r.hkeys('dic_name')
Out[43]: [b'name', b'job', b'age']

In [44]: r.hvals('dic_name')
Out[44]: [b'summer', b'IT', b'30']
```


#### 3.3.7 hexists
hexists(name, key)  检查name对应的hash是否存在当前传入的key

```
In [45]: r.hexists("dic_name","a1")
Out[45]: False

In [46]: r.hexists("dic_name","name")
Out[46]: True
```

#### 3.3.8 hdel
hdel(name,*keys) 删除指定name对应的key所在的键值对

```
In [46]: r.hexists("dic_name","name")
Out[46]: True

In [47]: r.hkeys('dic_name')
Out[47]: [b'name', b'job', b'age']

In [48]: r.hvals('dic_name')
Out[48]: [b'summer', b'IT', b'30']

In [49]: r.hdel('dic_name','job')
Out[49]: 1

In [50]: r.hkeys('dic_name')
Out[50]: [b'name', b'age']

127.0.0.1:6379> HGETALL dic_name
1) "name"
2) "summer"
3) "age"
4) "30"
```

#### 3.3.9 hincrby
hincrby(name, key, amount=1)  

自增hash中key对应的值，不存在则创建key=amount(amount为整数)

```
In [52]: r.hincrby("num","data",amount=2)
Out[52]: 2
127.0.0.1:6379> keys *
1) "num"
2) "hash_name"
3) "dic_name"
127.0.0.1:6379> type num
hash
127.0.0.1:6379> HGETALL num
1) "data"
2) "2"

```

#### 3.3.10 hincrbyfloat
hincrbyfloat(name, key, amount=1.0)
自增hash中key对应的值，不存在则创建key=amount(amount为浮点数)

```
In [54]: r.hincrby("floatnum","float1",amount=2)
Out[54]: 2
127.0.0.1:6379> keys *
1) "floatnum"
2) "num"
3) "hash_name"
4) "dic_name"
127.0.0.1:6379> type floatnum
hash
127.0.0.1:6379> HGETALL floatnum
1) "float1"
2) "2"
127.0.0.1:6379> HGET floatnum float1
"2"
```

#### 3.3.11 hscan
hscan(name, cursor=0, match=None, count=None)

#### 3.3.12 hscan_iter
hscan_iter(name, match=None, count=None)

### 3.4 List
redis中的List在在内存中按照一个name对应一个List来存储 
#### 3.4.1 lpush
lpush(name,values) 

在name对应的list中添加元素，每个新的元素都添加到列表的最左边

```
# 在name对应的list中添加元素，每个新的元素都添加到列表的最左边
r.lpush('list',5)
r.lpush('list',2,3,4) # 保存在列表中的顺序为5，4，3，2
```
操作过程

```
In [58]: r.lpush('list',2)
Out[58]: 1

In [59]: r.lpush('list',3,4,5)
Out[59]: 4

127.0.0.1:6379> LRANGE list 0 6
1) "5"
2) "4"
3) "3"
4) "2"
```

#### 3.4.2 rpush
rpush(name,values)
同lpush，但每个新的元素都添加到列表的最右边

```
In [61]: r.rpush('rlist',2)
Out[61]: 1

In [62]: r.rpush('rlist',3,4,5)
Out[62]: 4
127.0.0.1:6379> keys *
1) "rlist"
2) "list"
127.0.0.1:6379> LRANGE rlist 0 6
1) "2"
2) "3"
3) "4"
4) "5"
```


#### 3.4.3 lpushx
lpushx(name,value)

在name对应的list中添加元素，只有name已经存在时，值添加到列表的最左边

#### 3.4.4 rpushx
rpushx(name,value)

在name对应的list中添加元素，只有name已经存在时，值添加到列表的最右边

#### 3.4.5 llen
llen(name) name对应的list元素的个数

```
In [63]: r.llen('rlist')
Out[63]: 4
```

#### 3.4.6 linsert
linsert(name, where, refvalue, value))

```
# 在name对应的列表的某一个值前或后插入一个新值
r.linsert("rlist","BEFORE","2","before")#在列表内找到第一个元素2，在它前面插入SS

'''参数：
     name: redis的name
     where: BEFORE（前）或AFTER（后）
     refvalue: 列表内的值
     value: 要插入的数据'''
```
操作

```
插入之前
127.0.0.1:6379> LRANGE rlist 0 6
1) "2"
2) "3"
3) "4"
4) "5"
In [64]: r.linsert("rlist","BEFORE","2","before")
Out[64]: 5
插入之后
127.0.0.1:6379> LRANGE rlist 0 6
1) "before"
2) "2"
3) "3"
4) "4"
5) "5"
```

#### 3.4.7 lset
r.lset(name, index, value)

```
#对list中的某一个索引位置重新赋值
r.lset("rlist",0,"bbb")
```
操作过程

```
修改之前
127.0.0.1:6379> LRANGE rlist 0 -1
1) "before"
2) "2"
3) "3"
4) "4_before"
5) "4"
6) "4_after"
7) "4_before"
8) "5"

# 修改第0位是0
In [68]: r.lset('rlist',0,0)
Out[68]: True

修改之后
127.0.0.1:6379> LRANGE rlist 0 -1
1) "0"
2) "2"
3) "3"
4) "4_before"
5) "4"
6) "4_after"
7) "4_before"
8) "5"
```

#### 3.4.8 lrem
r.lrem(name, value, num) 

```
删除name对应的list中的指定值
r.lrem("rlist","data",num=0)

''' 
参数：
    name:  redis的name
    value: 要删除的值
    num:   num=0 删除列表中所有的指定值；
           num=2 从前到后，删除2个；
           num=-2 从后向前，删除2个
```
操作过程

```
删除之前
127.0.0.1:6379> LRANGE rlist 0 -1
1) "0"
2) "2"
3) "3"
4) "4_before"
5) "4"
6) "4_after"
7) "4_before"
8) "5"

In [69]: r.lrem('rlist','4_before',3)
Out[69]: 2

删除之后
127.0.0.1:6379> LRANGE rlist 0 -1
1) "0"
2) "2"
3) "3"
4) "4"
5) "4_after"
6) "5"
```

#### 3.4.9 lpop
lpop(name) 移除列表的左侧第一个元素，返回值则是第一个元素
操作过程

```
127.0.0.1:6379> LRANGE rlist 0 -1
1) "0"
2) "2"
3) "3"
4) "4"
5) "4_after"
6) "5"

In [70]: r.lpop("rlist")
Out[70]: b'0'

127.0.0.1:6379> LRANGE rlist 0 -1
1) "2"
2) "3"
3) "4"
4) "4_after"
5) "5"
```

#### 3.4.10 lindex
lindex(name, index) 根据索引获取列表内元素
操作过程

```
127.0.0.1:6379> LRANGE rlist 0 -1
1) "2"
2) "3"
3) "4"
4) "4_after"
5) "5"
In [72]: r.lindex('rlist','2')
Out[72]: b'4'

In [73]: r.lindex('rlist','3')
Out[73]: b'4_after
```

#### 3.4.11 lrange
lrange(name, start, end) 分片获取元素

```
127.0.0.1:6379> LRANGE rlist 0 -1
1) "2"
2) "3"
3) "4"
4) "4_after"
5) "5"
In [74]: r.lrange('rlist',0,3)
Out[74]: [b'2', b'3', b'4', b'4_after']

In [75]: r.lrange('rlist',0,-1)
Out[75]: [b'2', b'3', b'4', b'4_after', b'5']

```

#### 3.4.12 ltrim
ltrim(name, start, end) 移除列表内没有在该索引之内的值

```
127.0.0.1:6379> LRANGE rlist 0 -1
1) "2"
2) "3"
3) "4"
4) "4_after"
5) "5"

In [76]: r.ltrim('rlist',0,2) # 保留索引 0 到2的值，其他都删除
Out[76]: True

127.0.0.1:6379> LRANGE rlist 0 -1
1) "2"
2) "3"
3) "4"
```

#### 3.4.13 rpoplpush
rpoplpush(src, dst)

从一个列表取出最右边的元素，同时将其添加至另一个列表的最左边
- src 要取数据的列表
- dst 要添加数据的列表

#### 3.4.14 brpoplpush
brpoplpush(src, dst, timeout=0)

同rpoplpush，多了个timeout, timeout：取数据的列表没元素后的阻塞时间，0为一直阻塞

#### 3.4.15 blpop
blpop(keys, timeout)

```
将多个列表排列,按照从左到右去移除各个列表内的元素
r.lpush("rlist1",3,4,5)
r.lpush("rlist2",3,4,5)

while True:
    print(r.blpop(["rlist1","rlist2"],timeout=0))
    print(r.lrange("rlist1",0,-1),r.lrange("rlist2",0,-1))

'''keys: redis的name的集合
   timeout: 超时时间，获取完所有列表的元素之后，阻塞等待列表内有数据的时间（秒）, 0 表示永远阻塞'''
```
操作过程

```
In [86]: r.lpush("rlist2",3,4,5)
Out[86]: 3
In [87]: r.lpush("rlist1",3,4,5)
Out[87]: 3
127.0.0.1:6379> LRANGE rlist1 0 -1
1) "5"
2) "4"
3) "3"
127.0.0.1:6379> LRANGE rlist2 0 -1
1) "5"
2) "4"
3) "3"

In [90]: r.blpop(["rlist1","rlist2"],timeout=0)
Out[90]: (b'rlist1', b'5')

127.0.0.1:6379> LRANGE rlist1 0 -1
1) "4"
2) "3"
127.0.0.1:6379> LRANGE rlist2 0 -1
1) "5"
2) "4"
3) "3"
```

#### 3.4.16 brpop
r.brpop(keys, timeout)

同blpop，将多个列表排列,按照从右像左去移除各个列表内的元素
操作过程

```
127.0.0.1:6379> flushall
OK

In [5]: r.lpush("list1",1,2,3,4,5)
Out[5]: 5

In [6]: r.lpush("list2",1,2,3,4,5)
Out[6]: 5

127.0.0.1:6379> LRANGE list1 0 -1
1) "5"
2) "4"
3) "3"
4) "2"
5) "1"
127.0.0.1:6379> LRANGE list2 0 -1
1) "5"
2) "4"
3) "3"
4) "2"
5) "1"

In [7]: r.blpop(["list1","list2"],timeout=0)
Out[7]: (b'list1', b'5')

127.0.0.1:6379> LRANGE list1 0 -1
1) "4"
2) "3"
3) "2"
4) "1"
127.0.0.1:6379> LRANGE list2 0 -1
1) "5"
2) "4"
3) "3"
4) "2"
5) "1"
```

### 3.4 Set 
Set集合就是不允许重复的列表 

#### 3.4.1 sadd
sadd(name,values) 给name对应的集合中添加元素

```
In [8]: r.sadd('set1','aa')
Out[8]: 1

In [9]: r.sadd('set1','aa','bb')
Out[9]: 1

127.0.0.1:6379> keys *
1) "set1"
2) "list2"
3) "list1"
4) "list"
127.0.0.1:6379> type set1
set
127.0.0.1:6379> SMEMBERS set1
1) "bb"
2) "aa"
```

#### 3.4.2 smembers
smembers(name) 获取name对应的集合的所有成员

```
In [10]: r.smembers('set1')
Out[10]: {b'aa', b'bb'}
```

#### 3.4.3 scard
scard(name) 获取name对应的集合中的元素个数

```
In [11]: r.scard('set1')
Out[11]: 2

```

#### 3.4.4 sdiff
sdiff(keys, *args)

```
在第一个set1对应的集合中且不在其他name对应的集合的元素集合
In [13]: r.sadd("set1","aa","bb")
Out[13]: 0

In [14]: r.sadd("set2","bb","cc")
Out[14]: 2

In [15]: r.sadd("set3","bb","cc","dd")
Out[15]: 3

In [16]: r.sdiff("set1","set2","set3")
Out[16]: {b'aa'}
```

#### 3.4.5 sdiffstore
sdiffstore(dest, keys, *args)
相当于把sdiff获取的值加入到dest对应的集合中

```
In [17]: r.sdiffstore('set_dest',"set1","set2","set3")
Out[17]: 1

In [18]: r.smembers('set_dest')
Out[18]: {b'aa'}
```

#### 3.4.6 sinter
sinter(keys, *args)  获取多个name对应集合的并集

```
In [19]: r.sinter('set1','set2','set3')
Out[19]: {b'bb'}
```

#### 3.4.7 sinterstore
获取多个对应集合的并集，再讲其加入到dest对应的集合中
```
In [20]: r.sinterstore('sinterstore','set1','set2','set3')
Out[20]: 1

In [21]: r.smembers('sinterstore')
Out[21]: {b'bb'}
```

#### 3.4.8 sismember
sismember(name, value) 检查value是否是name对应的集合内的元素

```
In [22]: r.sismember('set1','abc')
Out[22]: False

In [23]: r.sismember('set1','aa')
Out[23]: True

In [24]: r.smembers('set1')
Out[24]: {b'aa', b'bb'}
```


#### 3.4.9 smove
smove(src, dst, value) 把src 集合中的value值移动到dst集合中
```
In [25]: r.smembers('set1')
Out[25]: {b'aa', b'bb'}

In [26]: r.smembers('set2')
Out[26]: {b'bb', b'cc'}

In [27]: r.smove('set1','set2','aa')
Out[27]: True

In [28]: r.smembers('set2')
Out[28]: {b'aa', b'bb', b'cc'}

In [29]: r.smembers('set1')
Out[29]: {b'bb'}
```

#### 3.4.10 spop
spop(name) 从集合的左侧移除一个元素，并将其返回

```
In [36]: r.smembers('set2')
Out[36]: {b'aa', b'bb', b'cc'}

In [37]: r.spop('set2')
Out[37]: b'aa'

In [38]: r.smembers('set2')
Out[38]: {b'bb', b'cc'}
```

#### 3.4.11 srandmember
srandmember(name, numbers) 从name对应的集合中随机获取numbers个元素

```
In [40]: r.sadd("set_random",1,2,3,4,5,6)
Out[40]: 6

In [41]: r.smembers('set_random')
Out[41]: {b'1', b'2', b'3', b'4', b'5', b'6'}

In [42]: r.srandmember('set_random',2)
Out[42]: [b'1', b'2']

In [43]: r.srandmember('set_random',2)
Out[43]: [b'5', b'2']
```

#### 3.4.12 srem
srem(name, values) 删除name对应的集合中的某些值

```
In [45]: r.smembers('set')
Out[45]: {b'1', b'2', b'3', b'4', b'5', b'6'}

In [46]: r.srem('set','3')
Out[46]: 1

In [47]: r.smembers('set')
Out[47]: {b'1', b'2', b'4', b'5', b'6'}
```

#### 3.4.14 sunion
sunion(keys, *args) 获取多个name对应的集合的并集

```
In [54]: r.sadd("set1",1,2,3,4,5,6)
Out[54]: 0

In [55]: r.sadd("set2",4,5,6,7,8.9)
Out[55]: 0

In [56]: r.sunion('set1','set2')
Out[56]: {b'1', b'2', b'3', b'4', b'5', b'6', b'7', b'8.9', b'bb', b'cc'}
```

#### 3.4.14 sunionstore
sunionstore(dest,keys, *args)

获取多个name对应的集合的并集，并将结果保存到dest集合中对应的集合中

```
In [57]: r.sunionstore('union_set','set1','set2')
Out[57]: 10

In [58]: r.smembers('union_set')
Out[58]: {b'1', b'2', b'3', b'4', b'5', b'6', b'7', b'8.9', b'bb', b'cc'}
```

### 3.5 有序集合 
在集合的基础上，为每元素排序，元素的排序需要根据另外一个值来进行比较，所以，对于有序集合，每一个元素有两个值，即：值和分数，分数专门用来做排序。

#### 3.5.1 zadd
zadd(name, *args, **kwargs)  在name对应的有序集合中添加元素

```
In [59]: r.zadd("zset1", "a1", 2, "a2", 3,"a4",5)
Out[59]: 3

In [63]: r.zadd("zset2",a=10,b=20)
Out[63]: 2

127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a1"
2) "2"
3) "a2"
4) "3"
5) "a4"
6) "5"
127.0.0.1:6379> ZRANGE zset2 0 -1 WITHSCORES
1) "a"
2) "10"
3) "b"
4) "20"
```

#### 3.5.2 zcard
zcard(name) 获取有序集合内元素的数量
```
In [64]: r.zcard('zset1')
Out[64]: 3

In [65]: r.zcard('zset2')
Out[65]: 2
```

#### 3.5.3 zcount
zcount(name, min, max) 获取有序集合中分数在[min,max]之间的个数

```
In [66]: r.zcount("zset1",1,5)
Out[66]: 3
```

#### 3.5.4 zincrby
zincrby(name, value, amount)  自增有序集合内value对应的分数

```
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a1"
2) "2"
3) "a2"
4) "3"
5) "a4"
6) "5"

In [68]: r.zincrby("zset1","a1",amount=2)
Out[68]: 4.0

127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a2"
2) "3"
3) "a1"
4) "4"
5) "a4"
6) "5"

```

> 本来a1=2 然后加2后变成4也就是 a1=4,所以向后排列


#### 3.5.5 zrange
zrange( name, start, end, desc=False, withscores=False, score_cast_func=float)

按照索引范围获取name对应的有序集合的元素
aa=r.zrange("zset_name",0,1,desc=False,withscores=True,score_cast_func=int)
print(aa)

```
参数：
    name    redis的name
    start   有序集合索引起始位置
    end     有序集合索引结束位置
    desc    排序规则，默认按照分数从小到大排序
    withscores  是否获取元素的分数，默认只获取元素的值
    score_cast_func 对分数进行数据转换的函数
```

```
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a2"
2) "3"
3) "a1"
4) "4"
5) "a4"
6) "5"

In [69]: r.zrange('zset1',0,1)
Out[69]: [b'a2', b'a1']

In [70]: r.zrange('zset1',0,-1)
Out[70]: [b'a2', b'a1', b'a4']
```


#### 3.5.6 zrevrange
zrevrange(name, start, end, withscores=False, score_cast_func=float)
同zrange，集合是从大到小排序的
```
In [71]: r.zrevrange('zset1',0,-1)
Out[71]: [b'a4', b'a1', b'a2']
```

#### 3.5.7 zrank/zrevrank
zrank(name, value)、zrevrank(name, value)

获取value值在name对应的有序集合中的排行位置（从0开始）

```
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a2"
2) "3"
3) "a1"
4) "4"
5) "a4"
6) "5"

In [72]: r.zrank('zset1','a1')
Out[72]: 1

In [73]: r.zrank('zset1','a2')
Out[73]: 0

In [74]: r.zrevrank('zset1','a1')
Out[74]: 1

```

#### 3.5.8 zscore
zscore(name, value) 获取name对应有序集合中 value 对应的分数
```
In [75]: r.zscore('zset1','a2')
Out[75]: 3.0
```

#### 3.5.9 zrem
zrem(name, values) 删除name对应的有序集合中值是values的成员

```
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a2"
2) "3"
3) "a1"
4) "4"
5) "a4"
6) "5"

In [76]: r.zrem('zset1','a1','a2')
Out[76]: 2

127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a4"
2) "5"
```

#### 3.5.10 zremrangebyrank
zremrangebyrank(name, min, max)  根据排行范围删除

```
127.0.0.1:6379> flushall
OK
In [78]: r.zadd('zset1',a1=10,a2=20,a3=30,a4=40,a5=50)
Out[78]: 5
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
 1) "a1"
 2) "10"
 3) "a2"
 4) "20"
 5) "a3"
 6) "30"
 7) "a4"
 8) "40"
 9) "a5"
10) "50"
In [80]: r.zremrangebyrank('zet1', 1, 20)
Out[80]: 0

In [81]: r.zremrangebyrank('zset1', 1, 20)
Out[81]: 4

127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a1"
2) "10"

```

#### 3.5.11 zremrangebyscore
zremrangebyscore(name, min, max) 根据分数范围删除

```
127.0.0.1:6379> flushall
OK
In [82]: r.zadd('zset1',a1=10,a2=20,a3=30,a4=40,a5=50)
Out[82]: 5
127.0.0.1:6379> keys *
1) "zset1"
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
 1) "a1"
 2) "10"
 3) "a2"
 4) "20"
 5) "a3"
 6) "30"
 7) "a4"
 8) "40"
 9) "a5"
10) "50"
In [83]: r.zremrangebyscore('zset1',1,30)
Out[83]: 3
127.0.0.1:6379> ZRANGE zset1 0 -1 WITHSCORES
1) "a4"
2) "40"
3) "a5"
4) "50"
```
> 分数从 1 到 30(include 30) 的都被删除了

#### 3.5.12 zinterstore
zinterstore(dest, keys, aggregate=None)

```
In [84]: r.zadd("zset_name", "a1", 6, "a2", 2,"a3",5)
Out[84]: 3

In [85]: r.zadd('zset_name1', a1=7,b1=10, b2=5)
Out[85]: 3

127.0.0.1:6379> ZRANGE zset_name 0 -1 WITHSCORES
1) "a2"
2) "2"
3) "a3"
4) "5"
5) "a1"
6) "6"
127.0.0.1:6379> ZRANGE zset_name1 0 -1 WITHSCORES
1) "b2"
2) "5"
3) "a1"
4) "7"
5) "b1"
6) "10"

# 获取两个有序集合的交集并放入dest集合，如果遇到相同值不同分数，则按照aggregate进行操作
# aggregate的值为: SUM  MIN  MAX

In [86]: r.zinterstore("zset_name2",("zset_name1","zset_name"),aggregate="MAX")
Out[86]: 1

127.0.0.1:6379> keys *
1) "zset_name"
2) "zset_name2"
3) "zset_name1"
4) "zset1"
127.0.0.1:6379> ZRANGE zset_name2 0 -1 WITHSCORES
1) "a1"
2) "7"
```

#### 3.5.14 zunionstore
zunionstore(dest, keys, aggregate=None)
获取两个有序集合的并集并放入dest集合，其他同zinterstore，

```
In [89]: r.zadd("zset_union_name1", "a1", 6, "a2", 2,"a3",5)
Out[89]: 3

In [90]: r.zadd('zset_union_name2', a1=7,b1=10, b2=5)
Out[90]: 3

In [91]: r.zunionstore("zset_union_name",("zset_union_name1","zset_union_name2"),aggregate="MAX")
Out[91]: 5

In [92]: print(r.zscan("zset_union_name"))
(0, [(b'a2', 2.0), (b'a3', 5.0), (b'b2', 5.0), (b'a1', 7.0), (b'b1', 10.0)])
```

### 3.6 其他操作
#### 3.6.1 delete
delete(*names)

```
#根据name删除redis中的任意数据类型
In [80]: r.exists('name')
Out[80]: True

In [81]: r.delete('name')
Out[81]: 1

In [82]: r.exists('name')
Out[82]: False

In [83]: r.get('name')

```

#### 3.6.2 exists
exists(name)

```
#检测redis的name是否存在
In [79]: r.get('name')
Out[79]: b'zhangsanlisi'

In [80]: r.exists('name')
Out[80]: True

```

#### 3.6.3 keys
keys(pattern='*')

```
#根据* ？等通配符匹配获取redis的name
In [88]: r.keys(pattern='*')
Out[88]: [b'num', b'k1', b'k2', b'mount', b'k3']
```

#### 3.6.4 expire
expire(name ,time)

```
# 为某个name设置超时时间
In [92]: r.get('k1')
Out[92]: b'v1'

In [93]: r.expire('k1',2)  # 配置过期时间为2秒
Out[93]: True

In [94]: r.get('k1')

```

#### 3.6.5 rename
rename(src, dst)

```
# 重命名
In [97]: r.rename('k2','k22')
Out[97]: True

In [98]: r.get('k2')

In [99]: r.get('k22')
Out[99]: b'v2'
```

#### 3.6.6 move
move(name, db))

```
# 将redis的某个值移动到指定的db下
In [105]: r.move('k3',2)
Out[105]: True

127.0.0.1:6379> keys *
1) "num"
2) "k22"
3) "mount"

127.0.0.1:6379[3]> select 2
OK
127.0.0.1:6379[2]> keys *
1) "k3"
127.0.0.1:6379[2]>

```

#### 3.6.7 randomkey
randomkey()

```
#随机获取一个redis的name（不删除）
In [100]: r.randomkey()
Out[100]: b'mount'

In [101]: r.randomkey()
Out[101]: b'k3'
```

#### 3.6.8 type
type(name)

```
# 获取name对应值的类型
In [102]: r.type('k3')
Out[102]: b'string'
```

#### 3.6.9 dbsize
数据库中多少个条数

```
In [96]: r.dbsize()
Out[96]: 1
```

#### 3.6.10 flushdb/flushall
- flushdb 清空数据库
- flushall 删除所有现有的数据库

```
In [97]: r.flushdb()
Out[97]: True
In [99]: r.flushall()
Out[99]: True
```
redis操作

```
127.0.0.1:6379> SELECT 1
OK
127.0.0.1:6379[1]> set  k1 1
OK
127.0.0.1:6379[1]> select 2
OK
127.0.0.1:6379[2]> set k2 2
OK
127.0.0.1:6379[2]> keys *
1) "k2"
127.0.0.1:6379[2]> FLUSHDB
OK
127.0.0.1:6379[2]> keys *
(empty list or set)
127.0.0.1:6379[2]> select 1
OK
127.0.0.1:6379[1]> keys *
1) "k1"
127.0.0.1:6379[1]>
127.0.0.1:6379[1]>
127.0.0.1:6379[1]> select 2
OK
127.0.0.1:6379[2]> set k2 2
OK
127.0.0.1:6379[2]> FLUSHALL
OK
127.0.0.1:6379[2]> keys *
(empty list or set)
127.0.0.1:6379[2]> select 1
OK
127.0.0.1:6379[1]> keys *
(empty list or set)
```


#### 3.6.11 save
强行把数据库保存到硬盘。保存时阻塞

```
In [98]: r.save()
Out[98]: True
```

<center><h1> redis transcation </h1></center>
## 1、基本概念

### 1.1 什么是redis的事务？

简单理解，可以认为redis事务是一些列redis命令的集合，并且有如下两个特点：

- 事务是一个单独的隔离操作：事务中的所有命令都会序列化、按顺序地执行。事务在执行的过程中，不会被其他客户端发送来的命令请求所打断。
- 事务是一个原子操作：事务中的命令要么全部被执行，要么全部都不执行。

### 1.2 事务的性质ACID

一般来说，事务有四个性质称为ACID，分别是原子性，一致性，隔离性和持久性。

- 原子性atomicity：redis事务保证事务中的命令要么全部执行要不全部不执行。有些文章认为redis事务对于执行错误不回滚违背了原子性，是偏颇的。
- 一致性consistency：redis事务可以保证命令失败的情况下得以回滚，数据能恢复到没有执行之前的样子，是保证一致性的，除非redis进程意外终结。
- 隔离性Isolation：redis事务是严格遵守隔离性的，原因是redis是单进程单线程模式，可以保证命令执行过程中不会被其他客户端命令打断。
- 持久性Durability：redis事务是不保证持久性的，这是因为redis持久化策略中不管是RDB还是AOF都是异步执行的，不保证持久性是出于对性能的考虑。

### 1.3 redis事务的错误

使用事务时可能会遇上以下两种错误：

- 入队错误：事务在执行 EXEC 之前，入队的命令可能会出错。比如说，命令可能会产生语法错误（参数数量错误，参数名错误，等等），或者其他更严重的错误，比如内存不足（如果服务器使用 maxmemory 设置了最大内存限制的话）。
- 执行错误：命令可能在 EXEC 调用之后失败。举个例子，事务中的命令可能处理了错误类型的键，比如将列表命令用在了字符串键上面，诸如此类。

!!! note "注意"
    第三种错误，redis进程终结，本文并没有讨论这种错误。

 
## 2. redis事务的用法

redis事务是通过MULTI，EXEC，DISCARD和WATCH四个原语实现的。

1. MULTI命令用于开启一个事务，它总是返回OK。
1. MULTI执行之后，客户端可以继续向服务器发送任意多条命令，这些命令不会立即被执行，而是被放到一个队列中，当EXEC命令被调用时，所有队列中的命令才会被执行。
1. 另一方面，通过调用DISCARD，客户端可以清空事务队列，并放弃执行事务。

Unwatch
&#160; &#160; &#160; &#160;之前加的监控锁都会被取消掉了，之前执行的写操作命令全部取消


### 2.1 正常操作

```
127.0.0.1:6379> FLUSHALL
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set key 1
QUEUED
127.0.0.1:6379> set key2 2
QUEUED
127.0.0.1:6379> sadd key3 3
QUEUED
127.0.0.1:6379> exec
1) OK
2) OK
3) (integer) 1
127.0.0.1:6379> keys *
1) "key2"
2) "key3"
3) "key"
```
&#160; &#160; &#160; &#160;EXEC 命令的回复是一个数组，数组中的每个元素都是执行事务中的命令所产生的回复。 其中，回复元素的先后顺序和命令发送的先后顺序一致。

&#160; &#160; &#160; &#160;当客户端处于事务状态时，所有传入的命令都会返回一个内容为 QUEUED 的状态回复（status reply），这些被入队的命令将在 EXEC命令被调用时执行。

### 2.2 放弃事务
当执行 DISCARD 命令时，事务会被放弃，事务队列会被清空，并且客户端会从事务状态中退出：

```
127.0.0.1:6379> get key
"1"
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set key 10
QUEUED
127.0.0.1:6379> DISCARD
OK
127.0.0.1:6379> exec
(error) ERR EXEC without MULTI
127.0.0.1:6379> get key
"1"
```

### 2.3 入队错误回滚

```
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set key 1
QUEUED
127.0.0.1:6379> HSET key2 1
(error) ERR wrong number of arguments for 'hset' command
127.0.0.1:6379> SADD key3 1
QUEUED
127.0.0.1:6379> exec
(error) EXECABORT Transaction discarded because of previous errors.
127.0.0.1:6379> keys *
(empty list or set)
```
对于入队错误，redis 2.6.5版本后，会记录这种错误，并且在执行EXEC的时候，报错并回滚事务中所有的命令，并且终止事务

### 2.4 执行错误放过

```
127.0.0.1:6379> flushall
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set k1 v1
QUEUED
127.0.0.1:6379> set k2 v2 v3
QUEUED
127.0.0.1:6379> exec
1) OK
2) (error) ERR syntax error
127.0.0.1:6379> keys *
1) "k1"
127.0.0.1:6379> get k1
"v1"
```
当遇到执行错误时，redis放过这种错误，保证事务执行完成。

!!! note "不同之处"
    与mysql中事务不同，在redis事务遇到执行错误的时候，不会进行回滚，而是简单的放过了，并保证其他的命令正常执行。这个区别在实现业务的时候，需要自己保证逻辑符合预期。

### 2.5 watch
WATCH 命令可以为 Redis 事务提供 check-and-set （CAS）行为。

被 WATCH 的键会被监视，并会发觉这些键是否被改动过了。 如果有至少一个被监视的键在 EXEC 执行之前被修改了， 那么整个事务都会被取消， EXEC 返回空多条批量回复（null multi-bulk reply）来表示事务已经失败。

```
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379> watch key1
OK
127.0.0.1:6379> set key1 3
OK
127.0.0.1:6379> MULTI
OK
127.0.0.1:6379> set key1 3
QUEUED
127.0.0.1:6379> set key2 3
QUEUED
127.0.0.1:6379> exec
(nil)
127.0.0.1:6379> keys *
1) "key1"
```
使用上面的代码， 如果在 WATCH 执行之后， EXEC 执行之前， 有其他客户端修改了 key1 的值， 那么当前客户端的事务就会失败。 程序需要做的， 就是不断重试这个操作， 直到没有发生碰撞为止。

这种形式的锁被称作乐观锁， 它是一种非常强大的锁机制。 并且因为大多数情况下， 不同的客户端会访问不同的键， 碰撞的情况一般都很少， 所以通常并不需要进行重试。


## 3. demo
这里展示一个用python实现对key计数减一的原子操作。

```
#!/usr/bin/python
# _*_ coding: utf-8 _*_
"""
@Time    : 2019/2/21 13:25
@File    : pipeline_demo.py
@Author  : summer
@Software: PyCharm
"""
import redis
from redis import WatchError
from concurrent.futures import ProcessPoolExecutor

r = redis.Redis(host='127.0.0.1', port=6379)


# 减库存函数, 循环直到减库存完成
# 库存充足, 减库存成功, 返回True
# 库存不足, 减库存失败, 返回False
def decr_stock():

    # python中redis事务是通过pipeline的封装实现的
    with r.pipeline() as pipe:
        while True:
            try:
                # watch库存键, multi后如果该key被其他客户端改变, 事务操作会抛出WatchError异常
                pipe.watch('stock:count')
                count = int(pipe.get('stock:count'))
                if count > 0:  # 有库存
                    # 事务开始
                    pipe.multi()
                    pipe.decr('stock:count')
                    # 把命令推送过去
                    # execute返回命令执行结果列表, 这里只有一个decr返回当前值
                    print(pipe.execute()[0])
                    return True
                else:
                    return False
            except WatchError as ex:
                # 打印WatchError异常, 观察被watch锁住的情况
                print(ex, '锁住了')
                pipe.unwatch()


def worker():
    while True:
        # 没有库存就退出
        if not decr_stock():
            break


# 实验开始 设置库存为20
r.set("stock:count", 20)


# 多进程模拟多个客户端提交
if __name__ == '__main__':

    with ProcessPoolExecutor(max_workers=2) as pool:
        for _ in range(10):
            pool.submit(worker)
```

 

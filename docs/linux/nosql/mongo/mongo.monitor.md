<center><h1> MongoDB  监控</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;在你已经安装部署并允许MongoDB服务后，你必须要了解MongoDB的运行情况，并查看MongoDB的性能。这样在大流量得情况下可以很好的应对并保证MongoDB正常运作。

&#160; &#160; &#160; &#160;MongoDB中提供了mongostat 和 mongotop 两个命令来监控MongoDB的运行情况。


## 2. mongostat 命令
&#160; &#160; &#160; &#160;mongostat是mongodb自带的状态检测工具，在命令行下使用。它会间隔固定时间获取mongodb的当前运行状态，并输出。如果你发现数据库突然变慢或者有其他问题的话，你第一手的操作就考虑采用mongostat来查看mongo的状态。

&#160; &#160; &#160; &#160;启动你的Mongod服务 然后输入mongostat命令，如下所示：

```
[root@leco ~]# mongostat
insert query update delete getmore command dirty used flushes vsize   res qrw arw net_in net_out conn                time
    *0    *0     *0     *0       0     2|0  0.0% 0.0%       0 1.00G 43.0M 0|0 1|0   161b   63.5k    5 Feb 27 13:58:31.473
    *0    *0     *0     *0       0     1|0  0.0% 0.0%       0 1.00G 43.0M 0|0 1|0   157b   62.2k    5 Feb 27 13:58:32.473
    *0    *0     *0     *0       0     1|0  0.0% 0.0%       0 1.00G 43.0M 0|0 1|0   157b   62.1k    5 Feb 27 13:58:33.474
    *0    *0     *0     *0       0     2|0  0.0% 0.0%       0 1.00G 43.0M 0|0 1|0   158b   62.3k    5 Feb 27 13:58:34.472
    *0    *0     *0     *0       0     2|0  0.0% 0.0%       0 1.00G 43.0M 0|0 1|0   158b   62.2k    5 Feb 27 13:58:35.472
    *0    *0     *0     *0       0     1|0  0.0% 0.0%       0 1.00G 43.0M 0|0 1|0   157b   62.1k    5 Feb 27 13:58:36.473

```

!!! tip "参数说明"
    ```python
    insert 每秒插入量
    query 每秒查询量
    update 每秒更新量
    delete 每秒删除量
    conn 当前连接数
    qr|qw 客户端查询排队长度（读|写）最好为0，如果有堆积，数据库处理慢。
    ar|aw 活跃客户端数量（读|写）
    time 当前时间
    ```


## 3. mongotop 命令
### 3.1 不带参数
&#160; &#160; &#160; &#160;mongotop也是mongodb下的一个内置工具，mongotop提供了一个方法，用来跟踪一个MongoDB的实例，查看哪些大量的时间花费在读取和写入数据。 mongotop提供每个集合的水平的统计数据。默认情况下，mongotop返回值的每一秒。

&#160; &#160; &#160; &#160;启动你的Mongod服务,然后输入mongotop命令，如下所示：

```
[root@leco ~]# mongotop
2019-02-27T13:59:52.914+0800	connected to: 127.0.0.1

                    ns    total    read    write    2019-02-27T13:59:53+08:00
  admin.$cmd.aggregate      0ms     0ms      0ms
    admin.system.roles      0ms     0ms      0ms
  admin.system.version      0ms     0ms      0ms
               cmz.col      0ms     0ms      0ms
              cmz.col2      0ms     0ms      0ms
              cmz.col3      0ms     0ms      0ms
              cmz.test      0ms     0ms      0ms
config.system.sessions      0ms     0ms      0ms
     local.startup_log      0ms     0ms      0ms
  local.system.replset      0ms     0ms      0ms
```

!!! tip "参数说明"
    ```python
    ns   ： 数据库命名空间，后者结合了数据库名称和集合。
    total： mongod在这个命令空间上花费的总时间。
    read ： 在这个命令空间上mongod执行读操作花费的时间。
    write： 在这个命名空间上mongod进行写操作花费的时间。
    ```



### 3.2 带参数

```
[root@leco ~]# mongotop 10
2019-02-27T14:00:54.803+0800	connected to: 127.0.0.1

                    ns    total    read    write    2019-02-27T14:01:04+08:00
  admin.$cmd.aggregate      0ms     0ms      0ms
    admin.system.roles      0ms     0ms      0ms
  admin.system.version      0ms     0ms      0ms
               cmz.col      0ms     0ms      0ms
              cmz.col2      0ms     0ms      0ms
              cmz.col3      0ms     0ms      0ms
              cmz.test      0ms     0ms      0ms
config.system.sessions      0ms     0ms      0ms
     local.startup_log      0ms     0ms      0ms
  local.system.replset      0ms     0ms      0ms
```
后面的10是<sleeptime>参数 ，可以不使用，等待的时间长度，以秒为单位，mongotop等待调用之间。通过的默认mongotop返回数据的每一秒。

### 3.3 locks
&#160; &#160; &#160; &#160;报告每个数据库的锁的使用中，使用mongotop - 锁，这将产生以下输出：
```
root@leco:~/book/books/docs/linux/nosql/mongo# mongotop --locks
connected to: 127.0.0.1

                            db       total        read       write		2019-02-27T06:02:29
                          test         0ms         0ms         0ms
                         local         0ms         0ms         0ms
                       example         0ms         0ms         0ms
                       crawler         0ms         0ms         0ms
                           cmz         0ms         0ms         0ms
                         admin         0ms         0ms         0ms
                             .         0ms         0ms         0ms
```

输出结果字段说明：

- ns：包含数据库命名空间，后者结合了数据库名称和集合。
- db：包含数据库的名称。名为 . 的数据库针对全局锁定，而非特定数据库。
- total：mongod花费的时间工作在这个命名空间提供总额。
- read：提供了大量的时间，这mongod花费在执行读操作，在此命名空间。
- write：提供这个命名空间进行写操作，这mongod花了大量的时间。

!!! tip "注意"
    ```python
    新版本不在支持该命令
    ```


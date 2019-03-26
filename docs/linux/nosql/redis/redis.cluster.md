<center><h1>redis cluster</h1></center>

## 1. cluster
### 1.1 介绍
&#160; &#160; &#160; &#160;Redis集群搭建的方式有多种，例如使用zookeeper等，但从redis 3.0之后版本支持redis-cluster集群，Redis-Cluster采用无中心结构，每个节点保存数据和整个集群状态,每个节点都和其他所有节点连接。其redis-cluster架构图如下：


### 1.2 其结构特点：

-  1、所有的redis节点彼此互联(PING-PONG机制),内部使用二进制协议优化传输速度和带宽。
-  2、节点的fail是通过集群中超过半数的节点检测失效时才生效。
-  3、客户端与redis节点直连,不需要中间proxy层.客户端不需要连接集群所有节点,连接集群中任何一个可用节点即可。
-  4、redis-cluster把所有的物理节点映射到[0-16383]slot上（不一定是平均分配）,cluster 负责维护node<->slot<->value。
-  5、Redis集群预分好16384个桶，当需要在 Redis 集群中放置一个 key-value 时，根据 CRC16(key) mod 16384的值，决定将一个key放到哪个桶中。

### 1.2 节点分配
&#160; &#160; &#160; &#160;现在我们是三个主节点分别是：A, B, C 三个节点，它们可以是一台机器上的三个端口，也可以是三台不同的服务器。那么，采用哈希槽 (hash slot)的方式来分配16384个slot 的话，它们三个节点分别承担的slot 区间是：

- 节点A覆盖0－5460
- 节点B覆盖5461－10922
- 节点C覆盖10923－16383
 
获取数据：

&#160; &#160; &#160; &#160;如果存入一个值，按照redis cluster哈希槽的算法： CRC16('key')%16384 = 6782。 那么就会把这个key 的存储分配到 B 上了。同样，当我连接(A,B,C)任何一个节点想获取'key'这个key时，也会这样的算法，然后内部跳转到B节点上获取数据 

新增一个主节点：
 
&#160; &#160; &#160; &#160;新增一个节点D，redis cluster的这种做法是从各个节点的前面各拿取一部分slot到D上，我会在接下来的实践中实验。大致就会变成这样：

- 节点A覆盖1365-5460
- 节点B覆盖6827-10922
- 节点C覆盖12288-16383
- 节点D覆盖0-1364,5461-6826,10923-12287

同样删除一个节点也是类似，移动完成后就可以删除这个节点了。
 
### 1.3 Redis Cluster主从模式

&#160; &#160; &#160; &#160;redis cluster 为了保证数据的高可用性，加入了主从模式，一个主节点对应一个或多个从节点，主节点提供数据存取，从节点则是从主节点拉取数据备份，当这个主节点挂掉后，就会有这个从节点选取一个来充当主节点，从而保证集群不会挂掉。

&#160; &#160; &#160; &#160;上面那个例子里, 集群有ABC三个主节点, 如果这3个节点都没有加入从节点，如果B挂掉了，我们就无法访问整个集群了。A和C的slot也无法访问。
&#160; &#160; &#160; &#160; 所以我们在集群建立的时候，一定要为每个主节点都添加了从节点, 比如像这样, 集群包含主节点A、B、C, 以及从节点A1、B1、C1, 那么即使B挂掉系统也可以继续正确工作。B1节点替代了B节点，所以Redis集群将会选择B1节点作为新的主节点，集群将会继续正确地提供服务。 当B重新开启后，它就会变成B1的从节点。

不过需要注意，如果节点B和B1同时挂了，Redis集群就无法继续正确地提供服务了。


## 2. 部署
### 2.1 介绍
 集群中至少应该有奇数个节点，所以至少有三个节点，每个节点至少有一个备份节点，所以下面使用6节点（主节点、备份节点由redis-cluster集群确定）。

 期中安装好一个redis。其他5个复制，修改参数即可。

### 2.2 配置 
```
root@manage01:/usr/local/cmz# tree .
.
├── redis01
│   ├── bin
│   │   ├── redis-benchmark
│   │   ├── redis-check-aof
│   │   ├── redis-check-rdb
│   │   ├── redis-cli
│   │   ├── redis-sentinel
│   │   ├── redis-server
│   │   └── redis-trib.rb
│   ├── conf
│   │   ├── redis.conf
│   │   └── redis.conf.ori
│   ├── data
│   │   ├── appendonly.aof
│   │   ├── dump.rdb
│   │   └── nodes.conf
│   ├── log
│   │   └── redis.log
│   └── nodes.conf
├── redis02
│   ├── bin
│   │   ├── redis-benchmark
│   │   ├── redis-check-aof
│   │   ├── redis-check-rdb
│   │   ├── redis-cli
│   │   ├── redis-sentinel
│   │   ├── redis-server
│   │   └── redis-trib.rb
│   ├── conf
│   │   ├── redis.conf
│   │   └── redis.conf.ori
│   ├── data
│   │   ├── appendonly.aof
│   │   ├── dump.rdb
│   │   └── nodes.conf
│   ├── log
│   │   └── redis.log
│   └── nodes.conf
├── redis03
│   ├── bin
│   │   ├── redis-benchmark
│   │   ├── redis-check-aof
│   │   ├── redis-check-rdb
│   │   ├── redis-cli
│   │   ├── redis-sentinel
│   │   ├── redis-server
│   │   └── redis-trib.rb
│   ├── conf
│   │   ├── redis.conf
│   │   └── redis.conf.ori
│   ├── data
│   │   ├── appendonly.aof
│   │   ├── dump.rdb
│   │   └── nodes.conf
│   ├── log
│   │   └── redis.log
│   └── nodes.conf
├── redis04
│   ├── bin
│   │   ├── redis-benchmark
│   │   ├── redis-check-aof
│   │   ├── redis-check-rdb
│   │   ├── redis-cli
│   │   ├── redis-sentinel
│   │   ├── redis-server
│   │   └── redis-trib.rb
│   ├── conf
│   │   ├── redis.conf
│   │   └── redis.conf.ori
│   ├── data
│   │   ├── appendonly.aof
│   │   ├── dump.rdb
│   │   └── nodes.conf
│   ├── log
│   │   └── redis.log
│   └── nodes.conf
├── redis05
│   ├── bin
│   │   ├── redis-benchmark
│   │   ├── redis-check-aof
│   │   ├── redis-check-rdb
│   │   ├── redis-cli
│   │   ├── redis-sentinel
│   │   ├── redis-server
│   │   └── redis-trib.rb
│   ├── conf
│   │   ├── redis.conf
│   │   └── redis.conf.ori
│   ├── data
│   │   ├── appendonly.aof
│   │   ├── dump.rdb
│   │   └── nodes.conf
│   ├── log
│   │   └── redis.log
│   └── nodes.conf
└── redis06
    ├── bin
    │   ├── redis-benchmark
    │   ├── redis-check-aof
    │   ├── redis-check-rdb
    │   ├── redis-cli
    │   ├── redis-sentinel
    │   ├── redis-server
    │   └── redis-trib.rb
    ├── conf
    │   ├── redis.conf
    │   └── redis.conf.ori
    ├── data
    │   ├── appendonly.aof
    │   ├── dump.rdb
    │   └── nodes.conf
    ├── log
    │   └── redis.log
    └── nodes.conf

30 directories, 84 files

root@manage01:/usr/local/cmz# tree ./ -L 2
./
├── redis01
│   ├── bin
│   ├── conf
│   ├── data
│   ├── log
│   └── nodes.conf
├── redis02
│   ├── bin
│   ├── conf
│   ├── data
│   ├── log
│   └── nodes.conf
├── redis03
│   ├── bin
│   ├── conf
│   ├── data
│   ├── log
│   └── nodes.conf
├── redis04
│   ├── bin
│   ├── conf
│   ├── data
│   ├── log
│   └── nodes.conf
├── redis05
│   ├── bin
│   ├── conf
│   ├── data
│   ├── log
│   └── nodes.conf
└── redis06
    ├── bin
    ├── conf
    ├── data
    ├── log
    └── nodes.conf
    
    
```
配置文件

```
root@manage01:/usr/local/cmz# cat redis01/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis01/log/redis.pid"
port 7001
timeout 300
cluster-enabled yes
cluster-config-file /usr/local/cmz/redis01/nodes.conf
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis01/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis01/data"
appendonly yes
appendfsync always
bind 0.0.0.0
root@manage01:/usr/local/cmz# cat redis02/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis02/log/redis.pid"
port 7002
timeout 300
cluster-enabled yes
cluster-config-file '/usr/local/cmz/redis02/nodes.conf'
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis02/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis02/data"
appendonly yes
appendfsync always
bind 0.0.0.0
root@manage01:/usr/local/cmz# cat redis03/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis03/log/redis.pid"
port 7003
timeout 300
cluster-enabled yes
cluster-config-file '/usr/local/cmz/redis03/nodes.conf'
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis03/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis03/data"
appendonly yes
appendfsync always
bind 0.0.0.0
root@manage01:/usr/local/cmz# cat redis04/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis04/log/redis.pid"
port 7004
timeout 300
cluster-enabled yes
cluster-config-file '/usr/local/cmz/redis04/nodes.conf'
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis04/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis04/data"
appendonly yes
appendfsync always
bind 0.0.0.0
root@manage01:/usr/local/cmz# cat redis05/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis05/log/redis.pid"
port 7005
timeout 300
cluster-enabled yes
cluster-config-file '/usr/local/cmz/redis05/nodes.conf'
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis05/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis05/data"
appendonly yes
appendfsync always
bind 0.0.0.0
root@manage01:/usr/local/cmz# cat redis06/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis06/log/redis.pid"
port 7006
timeout 300
cluster-enabled yes
cluster-config-file '/usr/local/cmz/redis06/nodes.conf'
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis06/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis06/data"
appendonly yes
appendfsync always
bind 0.0.0.0
```
启动测试

```
root@manage01:/usr/local/cmz# pkill redis
root@manage01:/usr/local/cmz# ps axf|grep redis
 9716 pts/18   S+     0:00                          \_ grep --color=auto redis
root@manage01:/usr/local/cmz# cat allstart.sh
#!/bin/bash
./redis01/bin/redis-server redis01/conf/redis.conf
./redis02/bin/redis-server redis02/conf/redis.conf
./redis03/bin/redis-server redis03/conf/redis.conf
./redis04/bin/redis-server redis04/conf/redis.conf
./redis05/bin/redis-server redis05/conf/redis.conf
./redis06/bin/redis-server redis06/conf/redis.conf
root@manage01:/usr/local/cmz# sh allstart.sh
root@manage01:/usr/local/cmz# ps axu|grep redis
root      9724  0.0  0.2  56448  4440 ?        Ssl  11:20   0:00 ./redis01/bin/redis-server 0.0.0.0:7001 [cluster]
root      9729  0.0  0.2  56448  4376 ?        Ssl  11:20   0:00 ./redis02/bin/redis-server 0.0.0.0:7002 [cluster]
root      9734  0.0  0.2  56448  4428 ?        Ssl  11:20   0:00 ./redis03/bin/redis-server 0.0.0.0:7003 [cluster]
root      9739  0.0  0.2  56448  4448 ?        Ssl  11:20   0:00 ./redis04/bin/redis-server 0.0.0.0:7004 [cluster]
root      9744  0.0  0.2  56448  4420 ?        Ssl  11:20   0:00 ./redis05/bin/redis-server 0.0.0.0:7005 [cluster]
root      9749  0.0  0.2  56448  4428 ?        Ssl  11:20   0:00 ./redis06/bin/redis-server 0.0.0.0:7006 [cluster]
root      9755  0.0  0.0  14228   944 pts/18   S+   11:21   0:00 grep --color=auto redis
```
可以看到redis的6个节点已经启动成功

### 2.3 创建集群
先安装ruby

```
root@manage01:/usr/local/cmz# apt-get install ruby
```

使用redis-trib.rb创建集群，先拷贝创建集群的命令过来

```
root@manage01:/usr/local/cmz# cp /usr/local/redis-5.0.3/src/redis-trib.rb .  # 从源码包中拷贝
root@manage01:/usr/local/cmz# l
allstart.sh  redis01/  redis02/  redis03/  redis04/  redis05/  redis06/  redis-trib.rb*
```
使用create命令 --replicas 1 参数表示为每个主节点创建一个从节点，其他参数是实例的地址集合。


```
root@manage01:/usr/local/cmz# ./redis-trib.rb create --replicas 1 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006
WARNING: redis-trib.rb is not longer available!
You should use redis-cli instead.

All commands and features belonging to redis-trib.rb have been moved
to redis-cli.
In order to use them you should call redis-cli with the --cluster
option followed by the subcommand name, arguments and options.

Use the following syntax:
redis-cli --cluster SUBCOMMAND [ARGUMENTS] [OPTIONS]

Example:
redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1

To get help about all subcommands, type:
redis-cli --cluster help

root@manage01:/usr/local/cmz# redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1
The program 'redis-cli' is currently not installed. You can install it by typing:
apt install redis-tools
root@manage01:/usr/local/cmz# ./redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1
>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 127.0.0.1:7004 to 127.0.0.1:7001
Adding replica 127.0.0.1:7005 to 127.0.0.1:7002
Adding replica 127.0.0.1:7006 to 127.0.0.1:7003
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
M: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots:[5461-10922] (5462 slots) master
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
S: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   replicates 35ab300b706b5614d9484b07dd019ac363fe05eb
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
Can I set the above configuration? (type 'yes' to accept): yes
>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
....
>>> Performing Cluster Check (using node 127.0.0.1:7001)
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
M: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
S: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots: (0 slots) slave
   replicates 35ab300b706b5614d9484b07dd019ac363fe05eb
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```
 上面显示创建成功，有3个主节点，3个从节点，每个节点都是成功连接状态。
 
> 之前版本是redis-trib.rb 新版本改了  You should use redis-cli instead.

3个主节点[M]以及分配的哈希卡槽如下：

```
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master

M: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots:[5461-10922] (5462 slots) master   

M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
```
3个从节点[S]以及附属的主节点如下：

```
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave

S: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots: (0 slots) slave
 
```

!!! note "注意"
    ```python
    以上集群安装成功了，如果安装未成功报如下错误
      >>> Creating cluster
           [ERR] Sorry, can't connect to node  ...
    那必须安装ruby了
    ```

## 3. 测试
### 3.1 测试存取值

```
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7001
127.0.0.1:7001> set name caimengzhi
-> Redirected to slot [5798] located at 127.0.0.1:7002
OK
127.0.0.1:7002> get name
"caimengzhi"
127.0.0.1:7002>
```
根据redis-cluster的key值分配，name应该分配到节点7002[5461-10922]上，上面显示redis cluster自动从7001跳转到了7002节点。我们可以测试一下7006从节点获取name值

```
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7006
127.0.0.1:7006> get name
-> Redirected to slot [5798] located at 127.0.0.1:7002
"caimengzhi"
127.0.0.1:7002>
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7005
127.0.0.1:7005> get name
-> Redirected to slot [5798] located at 127.0.0.1:7002
"caimengzhi"
127.0.0.1:7002>
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7004
127.0.0.1:7004> get name
-> Redirected to slot [5798] located at 127.0.0.1:7002
"caimengzhi"
127.0.0.1:7002>
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7003
127.0.0.1:7003> get name
-> Redirected to slot [5798] located at 127.0.0.1:7002
"caimengzhi"
127.0.0.1:7002>
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7002
127.0.0.1:700
```
7006位7003的从节点，从上面也是自动跳转至7002获取值，这也是redis cluster的特点，它是去中心化，每个节点都是对等的，连接哪个节点都可以获取和设置数据。

### 3.2 查看集群信息

```
root@manage01:/usr/local/cmz# ./redis-cli --cluster check 127.0.0.1:7002
127.0.0.1:7002 (35ab300b...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7003 (cc2ba863...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7001 (48d02dac...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7002)
M: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots: (0 slots) slave
   replicates 35ab300b706b5614d9484b07dd019ac363fe05eb
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```

## 4. 集群测试
### 4.1 宕机7002 节点
现在模拟将7002节点挂掉，按照redis-cluster原理会选举会将 7002的从节点7005选举为主节点。

```
root@manage01:/usr/local/cmz# ps axf|grep redis
10355 pts/18   S+     0:00                          \_ grep --color=auto redis
 9724 ?        Ssl    0:01 ./redis01/bin/redis-server 0.0.0.0:7001 [cluster]
 9729 ?        Ssl    0:01 ./redis02/bin/redis-server 0.0.0.0:7002 [cluster]
 9734 ?        Ssl    0:01 ./redis03/bin/redis-server 0.0.0.0:7003 [cluster]
 9739 ?        Ssl    0:01 ./redis04/bin/redis-server 0.0.0.0:7004 [cluster]
 9744 ?        Ssl    0:01 ./redis05/bin/redis-server 0.0.0.0:7005 [cluster]
 9749 ?        Ssl    0:01 ./redis06/bin/redis-server 0.0.0.0:7006 [cluster]
You have new mail in /var/mail/root
root@manage01:/usr/local/cmz# kill 9729
root@manage01:/usr/local/cmz# ps axf|grep redis
10358 pts/18   S+     0:00                          \_ grep --color=auto redis
 9724 ?        Ssl    0:01 ./redis01/bin/redis-server 0.0.0.0:7001 [cluster]
 9734 ?        Ssl    0:01 ./redis03/bin/redis-server 0.0.0.0:7003 [cluster]
 9739 ?        Ssl    0:01 ./redis04/bin/redis-server 0.0.0.0:7004 [cluster]
 9744 ?        Ssl    0:01 ./redis05/bin/redis-server 0.0.0.0:7005 [cluster]
 9749 ?        Ssl    0:01 ./redis06/bin/redis-server 0.0.0.0:7006 [cluster]

root@manage01:/usr/local/cmz# ./redis-cli --cluster check 127.0.0.1:7002
Could not connect to Redis at 127.0.0.1:7002: Connection refused
root@manage01:/usr/local/cmz# ./redis-cli --cluster check 127.0.0.1:7005
Could not connect to Redis at 127.0.0.1:7002: Connection refused
127.0.0.1:7005 (a62e648a...) -> 1 keys | 5462 slots | 0 slaves.
127.0.0.1:7001 (48d02dac...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7003 (cc2ba863...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7005)
M: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots:[5461-10922] (5462 slots) master
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
可以看到集群连接不了7002节点，而7005有原来的S转换为M节点，代替了原来的7002节点。我们可以获取name值：

```
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7005
127.0.0.1:7005> get name
"caimengzhi"
```

### 4.2 恢复7002节点
 现在我们将7002节点恢复，看是否会自动加入集群中以及充当的M还是S节点。
 
```
root@manage01:/usr/local/cmz# ./redis02/bin/redis-server redis02/conf/redis.conf
root@manage01:/usr/local/cmz# !ps
ps axf|grep redis
10405 pts/18   S+     0:00                          \_ grep --color=auto redis
 9724 ?        Ssl    0:02 ./redis01/bin/redis-server 0.0.0.0:7001 [cluster]
 9734 ?        Ssl    0:02 ./redis03/bin/redis-server 0.0.0.0:7003 [cluster]
 9739 ?        Ssl    0:02 ./redis04/bin/redis-server 0.0.0.0:7004 [cluster]
 9744 ?        Ssl    0:02 ./redis05/bin/redis-server 0.0.0.0:7005 [cluster]
 9749 ?        Ssl    0:02 ./redis06/bin/redis-server 0.0.0.0:7006 [cluster]
10398 ?        Ssl    0:00 ./redis02/bin/redis-server 0.0.0.0:7002 [cluster]
root@manage01:/usr/local/cmz# ./redis-cli --cluster check 127.0.0.1:7002
127.0.0.1:7005 (a62e648a...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7001 (48d02dac...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7003 (cc2ba863...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 3 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7002)
S: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots: (0 slots) slave
   replicates a62e648a1a13d95f993fd06819d001aa97e7916b
M: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
可以看到7002节点变成了a5db243087d8bd423b9285fa8513eddee9bb59a6 7005的从节点。

## 5. 集群添加主节点
节点新增包括新增主节点、从节点两种情况。以下分别做一下测试：
### 5.1  新增节点
 新增一个节点7007作为主节点修改配置文件
 
```
root@manage01:/usr/local/cmz# cat redis07/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis07/log/redis.pid"
port 7007
timeout 300
cluster-enabled yes
cluster-config-file /usr/local/cmz/redis07/nodes.conf
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis07/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis07/data"
appendonly yes
appendfsync always
bind 0.0.0.0
root@manage01:/usr/local/cmz# ./redis07/bin/redis-server redis07/conf/redis.conf
root@manage01:/usr/local/cmz# ps axf|grep redis
10582 pts/18   S+     0:00                          \_ grep --color=auto redis
 9724 ?        Ssl    0:02 ./redis01/bin/redis-server 0.0.0.0:7001 [cluster]
 9734 ?        Ssl    0:02 ./redis03/bin/redis-server 0.0.0.0:7003 [cluster]
 9739 ?        Ssl    0:02 ./redis04/bin/redis-server 0.0.0.0:7004 [cluster]
 9744 ?        Ssl    0:02 ./redis05/bin/redis-server 0.0.0.0:7005 [cluster]
 9749 ?        Ssl    0:02 ./redis06/bin/redis-server 0.0.0.0:7006 [cluster]
10398 ?        Ssl    0:00 ./redis02/bin/redis-server 0.0.0.0:7002 [cluster]
10575 ?        Ssl    0:00 ./redis07/bin/redis-server 0.0.0.0:7007 [cluster]

```
将7007节点添加到集群中

```
root@manage01:/usr/local/cmz# ./redis07/bin/redis-server redis07/conf/redis.conf
root@manage01:/usr/local/cmz# ./redis-cli --cluster add-node 127.0.0.1:7007 127.0.0.1:7002
>>> Adding node 127.0.0.1:7007 to cluster 127.0.0.1:7002
>>> Performing Cluster Check (using node 127.0.0.1:7002)
S: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots: (0 slots) slave
   replicates a62e648a1a13d95f993fd06819d001aa97e7916b
M: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
>>> Send CLUSTER MEET to node 127.0.0.1:7007 to make it join the cluster.
[OK] New node added correctly.

```
 add-node是加入集群节点，127.0.0.1:7007为要加入的节点，127.0.0.1:7002 表示加入的集群的一个节点，用来辨识是哪个集群，理论上那个集群的节点都可以。
    
!!! note "注意"
    ```python
    要删除之前拷贝文件中的nodes.conf，否则会报错
    [ERR] Node 127.0.0.1:7007 is not empty. Either the node already knows other nodes (check with CLUSTER NODES) or contains some key in database 0
    ```

可以看到7007加入这个Cluster，并成为一个新的节点。可以check以下7007节点状态
     
     
### 5.3 查看新节点情况

```
root@manage01:/usr/local/cmz# ./redis-cli --cluster check 127.0.0.1:7007
127.0.0.1:7007 (c3b7f31a...) -> 0 keys | 0 slots | 0 slaves.
127.0.0.1:7005 (a62e648a...) -> 1 keys | 5462 slots | 1 slaves.
127.0.0.1:7001 (48d02dac...) -> 0 keys | 5461 slots | 1 slaves.
127.0.0.1:7003 (cc2ba863...) -> 0 keys | 5461 slots | 1 slaves.
[OK] 1 keys in 4 masters.
0.00 keys per slot on average.
>>> Performing Cluster Check (using node 127.0.0.1:7007)
M: c3b7f31a4ed3754c816f316afc6934572cfcb767 127.0.0.1:7007
   slots: (0 slots) master
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
M: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
S: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots: (0 slots) slave
   replicates a62e648a1a13d95f993fd06819d001aa97e7916b
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```
上面信息可以看到有4个M节点，3个S节点，7007成为了M主节点，它没有附属的从节点，而且Cluster并未给7007分配哈希卡槽（0 slots）。

查看链接情况

```
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7007
127.0.0.1:7007> CLUSTER NODES
e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004@17004 slave 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 0 1553572416000 1 connected
39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006@17006 slave cc2ba863bdbed282a02d240ec074c99919d6ce10 0 1553572415652 3 connected
a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005@17005 master - 0 1553572417657 7 connected 5461-10922
48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001@17001 master - 0 1553572413647 1 connected 0-5460
c3b7f31a4ed3754c816f316afc6934572cfcb767 127.0.0.1:7007@17007 myself,master - 0 1553572415000 0 connected
cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003@17003 master - 0 1553572416000 3 connected 10923-16383
35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002@17002 slave a62e648a1a13d95f993fd06819d001aa97e7916b 0 1553572416655 7 connected
127.0.0.1:7007>

```

redis-cluster在新增节点时并未分配卡槽，需要我们手动对集群进行重新分片迁移数据，需要重新分片命令 reshard


```
 redis-trib.rb reshard 127.0.0.1:7005
```
  这个命令是用来迁移slot节点的，后面的127.0.0.1:7005是表示是哪个集群，端口填［7000-7007］都可以，执行结果如下：
 
 
```
root@manage01:/usr/local/cmz# ./redis-cli --cluster reshard 127.0.0.1:7005
[OK] All nodes agree about slots configuration.  
>>> Check for open slots...  
>>> Check slots coverage...  
[OK] All 16384 slots covered.  
How many slots do you want to move (from 1 to 16384)?   
```
它提示我们需要迁移多少slot到7007上，我们平分16384个哈希槽给4个节点：16384/4 = 4096，我们需要移动4096个槽点到7007上。

```
[OK] All 16384 slots covered.  
How many slots do you want to move (from 1 to 16384)? 4096  
What is the receiving node ID?   
```
 需要输入7007的节点id，c3b7f31a4ed3754c816f316afc6934572cfcb767 

```
Please enter all the source node IDs.  
  Type 'all' to use all the nodes as source nodes for the hash slots.  
  Type 'done' once you entered all the source nodes IDs.  
Source node #1: 
```
redis-cli 会向你询问重新分片的源节点（source node），即，要从特点的哪个节点中取出 4096 个哈希槽，还是从全部节点提取4096个哈希槽， 并将这些槽移动到7007节点上面。

如果我们不打算从特定的节点上取出指定数量的哈希槽，那么可以向redis-trib输入 all，这样的话， 集群中的所有主节点都会成为源节点，redis-trib从各个源节点中各取出一部分哈希槽，凑够4096个，然后移动到7007节点上：

```
Source node #1:all  
```
 确认之后，redis-trib就开始执行分片操作，将哈希槽一个一个从源主节点移动到7007目标主节点。重新分片结束后我们可以check以下节点的分配情况。
 
```
>>> Performing Cluster Check (using node 127.0.0.1:7001)
M: 48d02dac3a0b52d58fc1351392bb656e4a3c9f66 127.0.0.1:7001
   slots:[1365-5460] (4096 slots) master
   1 additional replica(s)
S: 39ab11b086c444a8fe04c5e917c98bc69c3add50 127.0.0.1:7006
   slots: (0 slots) slave
   replicates cc2ba863bdbed282a02d240ec074c99919d6ce10
S: 35ab300b706b5614d9484b07dd019ac363fe05eb 127.0.0.1:7002
   slots: (0 slots) slave
   replicates a62e648a1a13d95f993fd06819d001aa97e7916b
M: c3b7f31a4ed3754c816f316afc6934572cfcb767 127.0.0.1:7007
   slots:[0-1364],[5461-6826],[10923-12287] (4096 slots) master
S: e9c3cfa422cb7c666c9b739598b5c3871ee8c1e3 127.0.0.1:7004
   slots: (0 slots) slave
   replicates 48d02dac3a0b52d58fc1351392bb656e4a3c9f66
M: a62e648a1a13d95f993fd06819d001aa97e7916b 127.0.0.1:7005
   slots:[6827-10922] (4096 slots) master
   1 additional replica(s)
M: cc2ba863bdbed282a02d240ec074c99919d6ce10 127.0.0.1:7003
   slots:[12288-16383] (4096 slots) master
   1 additional replica(s)
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.

```
 slots:0-1364,5461-6826,10923-12287 (4096 slots) master,可以看到7007节点分片的哈希槽片不是连续的，间隔的移动。
 
 
```
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7007
127.0.0.1:7007> set age 30
OK
127.0.0.1:7007> get age
"30"
127.0.0.1:7007>
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7007
127.0.0.1:7007> get age
"30"
127.0.0.1:7007>
root@manage01:/usr/local/cmz# ./redis-cli -c -p 7001
127.0.0.1:7001> get age
-> Redirected to slot [741] located at 127.0.0.1:7007
"30"
```
可以看到将7001的age[741]移动到7007节点上，主节点7007添加成功。

## 6. 集群添加从节点
新增一个节点7008节点，使用add-node --slave命令。

```
root@manage01:/usr/local/cmz# cp -aR redis01 redis08
root@manage01:/usr/local/cmz# rm redis08/data/nodes.conf
root@manage01:/usr/local/cmz# vim redis08/conf/redis.conf
root@manage01:/usr/local/cmz# cat !$
cat redis08/conf/redis.conf
daemonize yes
pidfile "/usr/local/cmz/redis08/log/redis.pid"
port 7008
timeout 300
cluster-enabled yes
cluster-config-file /usr/local/cmz/redis08/nodes.conf
cluster-node-timeout 15000
loglevel debug
logfile "/usr/local/cmz/redis08/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/cmz/redis08/data"
appendonly yes
appendfsync always
bind 0.0.0.0
```
启动redis 7008实例

```
root@manage01:/usr/local/cmz# ./redis08/bin/redis-server redis08/conf/redis.conf
root@manage01:/usr/local/cmz# !ps
ps axf|grep redis
11291 pts/18   S+     0:00                          \_ grep --color=auto redis
 9724 ?        Ssl    0:07 ./redis01/bin/redis-server 0.0.0.0:7001 [cluster]
 9734 ?        Ssl    0:07 ./redis03/bin/redis-server 0.0.0.0:7003 [cluster]
 9739 ?        Ssl    0:06 ./redis04/bin/redis-server 0.0.0.0:7004 [cluster]
 9744 ?        Ssl    0:07 ./redis05/bin/redis-server 0.0.0.0:7005 [cluster]
 9749 ?        Ssl    0:06 ./redis06/bin/redis-server 0.0.0.0:7006 [cluster]
10398 ?        Ssl    0:03 ./redis02/bin/redis-server 0.0.0.0:7002 [cluster]
10695 ?        Ssl    0:05 ./redis07/bin/redis-server 0.0.0.0:7007 [cluster]
11286 ?        Ssl    0:00 ./redis08/bin/redis-server 0.0.0.0:7008 [cluster]
```



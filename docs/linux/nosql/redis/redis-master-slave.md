<center><h1>Redis主从</h1></center>
## 1. 介绍

&#160; &#160; &#160; &#160;REmote DIctionary Server(Redis) 是一个由Salvatore Sanfilippo写的key-value存储系统。

&#160; &#160; &#160; &#160;Redis是一个开源的使用ANSI C语言编写、遵守BSD协议、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库，并提供多种语言的API。

&#160; &#160; &#160; &#160;它通常被称为数据结构服务器，因为值（value）可以是 字符串(String), 哈希(Hash), 列表(list), 集合(sets) 和 有序集合(sorted sets)等类型。

## 2. 部署
### 2.1 Redis 主从
Redis支持主从同步。数据可以从主服务器向任意数量的从服务器上同步，同步使用的是发布/订阅机制。

### 2.2 配置
Mater Slave的模式，从Slave向Master发起SYNC命令。

Master 多Slave，可以分层，Slave下可以再接Slave，可扩展成树状结构。

配置非常简单，只需在slave的设定文件中指定master的ip和port


```
root@leco:/usr/local/redis# mkdir redis1/{etc,var,log} -p
root@leco:/usr/local/redis# tree .
.
└── redis1
    ├── etc
    ├── log
    └── var

4 directories, 0 files
root@leco:/usr/local/redis# cp -aR redis1/ redis2
root@leco:/usr/local/redis# vim redis1/etc/redis.conf
root@leco:/usr/local/redis# cat redis1/etc/redis.conf
```

### 2.3 master配置

```
root@leco:/usr/local/redis# cat redis1/etc/redis.conf
daemonize yes
pidfile "/usr/local/redis/redis1/log/redis.pid"
port 8379
timeout 300
loglevel debug
logfile "/usr/local/redis/redis1/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/redis/redis1/var"
appendonly no
appendfsync always
bind 0.0.0.0
```

### 2.4 slave配置

```
root@leco:/usr/local/redis# cat redis2/etc/redis.conf
daemonize yes
pidfile "/usr/local/redis/redis1/log/redis.pid"
port 8380
timeout 300
loglevel debug
logfile "/usr/local/redis/redis1/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/redis/redis1/var"
appendonly no
appendfsync always
bind 0.0.0.0
slaveof 172.17.0.2 8379 
```

!!! note "手动配置主"
    ```python
    在从上配置要同步的主
    127.0.0.1:8380> slaveof localhost 6380
    ```
    
??? note "只读模式"
    ```python
    slave-read-only yes                设置slave为只读模式
    ```

### 2.5 启动

```
root@leco:/usr/local/redis# redis-server /usr/local/redis/redis1/etc/redis.conf
root@leco:/usr/local/redis# redis-server /usr/local/redis/redis2/etc/redis.conf
root@leco:/usr/local/redis# ps axf|egrep '8379|8380' | grep -v grep
 5796 ?        Ssl    0:00 redis-server 0.0.0.0:8379
 6663 ?        Ssl    0:00 redis-server 0.0.0.0:8380

```

### 2.6 检查主从

```
root@leco:/usr/local/redis# redis-cli -p 8379
127.0.0.1:8379> keys *
(empty list or set)
127.0.0.1:8379> set name 'cmz'
OK
127.0.0.1:8379> quit
root@leco:/usr/local/redis# redis-cli -p 8380
127.0.0.1:8380> keys*
(error) ERR unknown command 'keys*'
127.0.0.1:8380> keys *
1) "name"
127.0.0.1:8380> get name
"cmz"

root@leco:/usr/local/redis# redis-cli -p 8379
127.0.0.1:8379> info
# Server
redis_version:3.0.6
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:28b6715d3583bf8e
redis_mode:standalone
os:Linux 4.15.0-45-generic x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:5.4.0
process_id:5796
run_id:32ac4a621301f8c8398439b074ff3cf7b7e0d0f9
tcp_port:8379
uptime_in_seconds:557
uptime_in_days:0
hz:10
lru_clock:7649260
config_file:/usr/local/redis/redis1/etc/redis.conf

# Clients
connected_clients:1
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:1884808
used_memory_human:1.80M
used_memory_rss:3731456
used_memory_peak:1884808
used_memory_peak_human:1.80M
used_memory_lua:36864
mem_fragmentation_ratio:1.98
mem_allocator:jemalloc-3.6.0

# Persistence
loading:0
rdb_changes_since_last_save:1
rdb_bgsave_in_progress:0
rdb_last_save_time:1551152980
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:4
total_commands_processed:158
instantaneous_ops_per_sec:0
total_net_input_bytes:5511
total_net_output_bytes:318
instantaneous_input_kbps:0.02
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:1
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:154
migrate_cached_sockets:0

# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=8380,state=online,offset=266,lag=1
master_repl_offset:266
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:265

# CPU
used_cpu_sys:0.40
used_cpu_user:0.11
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=1,expires=0,avg_ttl=0

```

### 2.7 查看slave

&#160; &#160; &#160; &#160;在主上执行 info repliaction
```
127.0.0.1:8379>  INFO replication
# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=8380,state=online,offset=308,lag=0
master_repl_offset:308
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:2
repl_backlog_histlen:307

```

### 2.8 手动切换身份
&#160; &#160; &#160; &#160;Master不可用的情况下，停止Master，将Slave的设定无效化后，Slave升级为Master
```
root@leco:/usr/local/redis# redis-cli -p 8380
127.0.0.1:8380> info
# Server
redis_version:3.0.6
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:28b6715d3583bf8e
redis_mode:standalone
os:Linux 4.15.0-45-generic x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:5.4.0
process_id:7666
run_id:5e077def1cd19dee9f3a379cc889b363f20b8305
tcp_port:8380
uptime_in_seconds:64
uptime_in_days:0
hz:10
lru_clock:7649736
config_file:/usr/local/redis/redis2/etc/redis.conf

# Clients
connected_clients:2
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:837232
used_memory_human:817.61K
used_memory_rss:3686400
used_memory_peak:837232
used_memory_peak_human:817.61K
used_memory_lua:36864
mem_fragmentation_ratio:4.40
mem_allocator:jemalloc-3.6.0

# Persistence
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1551153544
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:3
total_commands_processed:4
instantaneous_ops_per_sec:0
total_net_input_bytes:130
total_net_output_bytes:1540
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.04
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:0
migrate_cached_sockets:0

# Replication
role:slave                # 是从
master_host:127.0.0.1
master_port:8379
master_link_status:up
master_last_io_seconds_ago:6
master_sync_in_progress:0
slave_repl_offset:43
slave_priority:100
slave_read_only:1
connected_slaves:0
master_repl_offset:0
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:0.06
used_cpu_user:0.01
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=1,expires=0,avg_ttl=0


127.0.0.1:8380> SLAVEOF no one  配置没有主
OK


127.0.0.1:8380> info
# Server
redis_version:3.0.6
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:28b6715d3583bf8e
redis_mode:standalone
os:Linux 4.15.0-45-generic x86_64
arch_bits:64
multiplexing_api:epoll
gcc_version:5.4.0
process_id:7666
run_id:5e077def1cd19dee9f3a379cc889b363f20b8305
tcp_port:8380
uptime_in_seconds:103
uptime_in_days:0
hz:10
lru_clock:7649775
config_file:/usr/local/redis/redis2/etc/redis.conf

# Clients
connected_clients:1
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0

# Memory
used_memory:816360
used_memory_human:797.23K
used_memory_rss:3686400
used_memory_peak:837232
used_memory_peak_human:817.61K
used_memory_lua:36864
mem_fragmentation_ratio:4.52
mem_allocator:jemalloc-3.6.0

# Persistence
loading:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1551153544
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok

# Stats
total_connections_received:3
total_commands_processed:11
instantaneous_ops_per_sec:0
total_net_input_bytes:268
total_net_output_bytes:4961
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:0
migrate_cached_sockets:0

# Replication
role:master                # 变成了master了
connected_slaves:0
master_repl_offset:99
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:0.09
used_cpu_user:0.02
used_cpu_sys_children:0.00
used_cpu_user_children:0.00

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=1,expires=0,avg_ttl=0
127.0.0.1:8380>

```


### 2.9 健康检查
&#160; &#160; &#160; &#160; Slave按照repl-ping-slave-period的间隔（默认10秒），向Master发送ping。

&#160; &#160; &#160; &#160;如果主从间的链接中断后，再次连接的时候，2.8以前按照full sync再同期。2.8以后，因为有backlog的设定，backlog存在master的内存里，重新连接之前，如果redis没有重启，并且offset在backlog保存的范围内，可以实现从断开地方同期，不符合这个条件，还是full sync

&#160; &#160; &#160; &#160; 用monitor命令，可以看到slave在发送ping
```
127.0.0.1:8380> slaveof localhost 8379
OK
127.0.0.1:8380> MONITOR
OK
1551153843.193225 [0 127.0.0.1:8379] "PING"
```

&#160; &#160; &#160; &#160; 用ping命令，可以看到slave在发送ping
```
root@leco:/usr/local/redis# redis-cli -p 8380
127.0.0.1:8380> ping
PONG
```

!!! info "注意"
    ```python
    以上配置master主从是单个机器上启动的多少实例，多机主从，类似，配置文件稍微修改。
    ```

<center><h1> Redis 认证 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; redis没有实现访问控制这个功能，但是它提供了一个轻量级的认证方式，可以编辑redis.conf配置来启用认证。

## 2. 修改配置文件 

```
root@manage01:/usr/local/redis# cat conf/redis.conf
daemonize yes
pidfile "/usr/local/redis/log/redis.pid"
port 6379
timeout 300
loglevel debug
logfile "/usr/local/redis/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
rdbcompression yes
dbfilename "dump.rdb"
dir "/usr/local/redis/data"
appendonly no
appendfsync always
bind 0.0.0.0
requirepass cmz
root@manage01:/usr/local/redis# egrep requirepass  conf/redis.conf
requirepass cmz
```
重启redis。

## 3. 测试
### 3.1 启动带密码
```
root@manage01:/home/loocha# source /etc/profile
root@manage01:/home/loocha# redis-cli
127.0.0.1:6379> keys *
(error) NOAUTH Authentication required.
127.0.0.1:6379>
root@manage01:/home/loocha# redis-cli -a cmz
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:6379> keys *
1) "k1"

终端获取密码
127.0.0.1:6379>  config get requirepass
1) "requirepass"
2) "cmz"

```
### 3.2 终端认证

```
root@manage01:/home/loocha# redis-cli
127.0.0.1:6379> AUTH cmz
OK
127.0.0.1:6379> keys *
1) "k1"
```

!!! note "注意"
    ```python
    启动脚本需要根据是否有密码来配置。
    ```

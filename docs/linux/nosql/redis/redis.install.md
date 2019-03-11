<center><h1> Redis 介绍 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;下载安装,在官网找到最新最稳定的下载地址

[redis安装参考指南](https://redis.io/download)
```
root@manage01:/usr/local/src#  wget http://download.redis.io/releases/redis-5.0.3.tar.gz
--2019-03-11 11:11:06--  http://download.redis.io/releases/redis-5.0.3.tar.gz
Resolving download.redis.io (download.redis.io)... 109.74.203.151
Connecting to download.redis.io (download.redis.io)|109.74.203.151|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1959445 (1,9M) [application/x-gzip]
Saving to: ‘redis-5.0.3.tar.gz’

redis-5.0.3.tar.gz                              100%[====================================================================================================>]   1,87M   643KB/s    in 3,0s

2019-03-11 11:11:10 (643 KB/s) - ‘redis-5.0.3.tar.gz’ saved [1959445/1959445]

root@manage01:/usr/local/src# ls redis-5.0.3.tar.gz
redis-5.0.3.tar.gz
root@manage01:/usr/local/src# tar xf redis-5.0.3.tar.gz -C /usr/local
ccroot@manage01:/usr/local/src# cd /usr/local
root@manage01:/usr/local# ln -sf redis-5.0.3/ redis

root@manage01:/usr/local# cd redis
root@manage01:/usr/local/redis# make

root@manage01:/usr/local/redis# echo $?
0
等于0 就表示编码没有错误。


root@manage01:/usr/local/redis# mkdir bin conf data log
root@manage01:/usr/local/redis# ls
bin  conf  data  log
```

&#160; &#160; &#160; &#160;make完后 redis-5.0.3目录下会出现编译后的redis服务程序redis-server,还有用于测试的客户端程序redis-cli,两个程序位于安装目录 src 目录下：下面启动redis服务.

## 2. 配置

```
root@manage01:/usr/local/redis-s/src# cp -aR redis-check-aof redis-check-rdb redis-cli redis-sentinel redis-server redis-trib.rb redis-benchmark /usr/local/redis/bin/
root@manage01:/usr/local/redis-s/src# cp ../redis.conf /usr/local/redis/conf/

root@manage01:~# cat /usr/local/redis/conf/redis.conf
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
```

!!! note "参数解释"
    ```python
    daemonize no（默认），改成 yes，意思是是否要后台启动。
    ```

```
root@manage01:~# cd /usr/local/redis
root@manage01:/usr/local/redis# tree .
.
├── bin
│   ├── redis-benchmark
│   ├── redis-check-aof
│   ├── redis-check-rdb
│   ├── redis-cli
│   ├── redis-sentinel
│   ├── redis-server
│   └── redis-trib.rb
├── conf
│   ├── redis.conf
│   └── redis.conf.ori
├── data
│   └── dump.rdb
└── log
    ├── redis.log
    └── redis.pid

4 directories, 12 files
中间有省略，最终是这样
```

## 3. 配置环境变量

```
root@manage01:~# grep redis /etc/profile
export PATH=$PATH:/usr/local/redis/bin

root@manage01:~# source  /etc/profile
```

## 4. 启动脚本

```
root@manage01:/usr/local/redis/conf# cat /etc/init.d/redis
#!/bin/sh
#
# Simple Redis init.d script conceived to work on Linux systems
# as it does use of the /proc filesystem.
# chkconfig:   2345 90 10
# description:  Redis is a persistent key-value database
#

REDISPORT=6379
EXEC=/usr/local/redis/bin/redis-server
CLIEXEC=/usr/local/redis/bin/redis-cli

PIDFILE=/usr/local/redis/log/redis.pid
CONF="/usr/local/redis/conf/redis.conf"

case "$1" in
    start)
        if [ -f $PIDFILE ]
        then
                echo "$PIDFILE exists, process is already running or crashed"
        else
                echo "Starting Redis server..."
                $EXEC $CONF
                echo $(ps aux|grep redis|grep -v grep|grep 6379|awk '{print $2}')>$PIDFILE
        fi
        ;;
    stop)
        if [ ! -f $PIDFILE ]
        then
                echo "$PIDFILE does not exist, process is not running"
        else
                PID=$(cat $PIDFILE)
                echo "Stopping ..."
                $CLIEXEC -p $REDISPORT shutdown
                while [ -x /proc/${PID} ]
                do
                    echo "Waiting for Redis to shutdown ..."
                    sleep 1
                done
                echo "Redis stopped"
                cd /usr/local/redis/log/ && rm -f redis.pid
        fi
        ;;
    *)
        echo "Please use start or stop as first argument"
        ;;
esac


root@manage01:/usr/local/redis/conf# chmod +x /etc/init.d/redis
```


## 5. 启动与停止
```
root@manage01:/usr/local/redis/conf# /etc/init.d/redis stop
Stopping ...
Redis stopped
root@manage01:/usr/local/redis/conf# !p
pwd
/usr/local/redis/conf
root@manage01:/usr/local/redis/conf# !ps
ps axf|grep redis
11619 pts/18   S+     0:00  |                       \_ grep --color=auto redis
root@manage01:/usr/local/redis/conf# /etc/init.d/redis start
Starting Redis server...
root@manage01:/usr/local/redis/conf# !ps
ps axf|grep redis
11634 pts/18   S+     0:00  |                       \_ grep --color=auto redis
11622 ?        Ssl    0:00 /usr/local/redis/bin/redis-server 0.0.0.0:6379

```

## 6. 基本测试

```
root@manage01:~# redis-cli
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379> set k1 v1
OK
127.0.0.1:6379> get k1
"v1"
127.0.0.1:6379>
root@manage01:~# redis-cli
127.0.0.1:6379> get k1
"v1"
127.0.0.1:6379>
root@manage01:~# pkill redis
root@manage01:~# !ps
ps axf|grep redis
11273 pts/18   S+     0:00  |                       \_ grep --color=auto redis
root@manage01:~# redis-server /usr/local/redis/conf/redis.conf
root@manage01:~# ps axf|grep redis
11282 pts/18   S+     0:00  |                       \_ grep --color=auto redis
11277 ?        Ssl    0:00 redis-server 0.0.0.0:6379
root@manage01:~# redis-cli
127.0.0.1:6379> keys *
1) "k1"
127.0.0.1:6379> get k1
"v1"
```


<center><h1> Redis 备份与恢复 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; Redis SAVE 命令用于创建当前数据库的备份。

## 2. save

```
SAVE
```
实例

```
root@manage01:/home/loocha# redis-cli
127.0.0.1:6379> AUTH cmz
OK
127.0.0.1:6379> save
OK
root@manage01:/home/loocha# ls /usr/local/redis/data/
dump.rdb
```

该命令将在 redis 会在配置文件中指定的地方创建dump.rdb文件。

```
root@manage01:/home/loocha# egrep dir /usr/local/redis/conf/redis.conf
dir "/usr/local/redis/data"

或者
root@manage01:/home/loocha# redis-cli
127.0.0.1:6379> AUTH cmz
OK
127.0.0.1:6379>  CONFIG GET dir
1) "dir"
2) "/usr/local/redis/data"
```

## 3. bgsave
创建 redis 备份文件也可以使用命令 BGSAVE，该命令在后台执行。

```
127.0.0.1:6379> BGSAVE
Background saving started
```

## 4. 数据恢复
如果需要恢复数据，只需将备份文件 (dump.rdb) 移动到 redis 指定的那目录下并启动服务即可。

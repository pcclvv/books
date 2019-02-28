<center><h1> MySQL 主主 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;在企业中，数据库高可用一直是企业的重中之重，中小企业很多都是使用mysql主从方案，一主多从，读写分离等，但是单主存在单点故障，从库切换成主库需要作改动。因此，如果是双主或者多主，就会增加mysql入口，增加高可用。不过多主需要考虑自增长ID问题，这个需要特别设置配置文件，比如双主，可以使用奇偶，总之，主之间设置自增长ID相互不冲突就能完美解决自增长ID冲突问题。


## 2. MySQL主主
&#160; &#160; &#160; &#160;MySQL的主主，其实说白了就是相互主从。上一节搭建好了主从。在原来的基础上再反过来搭建主从。

## 3. MySQL主主复制的原理
&#160; &#160; &#160; &#160;相互主从。

## 4. 环境准备
### 4.1 环境

IP地址 | 角色 | mysql版本号|系统|主机名字
---|---|---|---|---
192.168.5.110| mysql slave |5.7|ubuntu16|leco
192.168.2.148| mysql master|5.7|ubuntu16|manage01

这样就反过来了，等部署好了，相互主从，就是主主。

### 4.2 配置准备
#### 4.2.1 master准备

- 开启二进制日志
- 配置唯一的server-id
- 获得master二进制日志文件名及位置
- 创建一个用于slave和master通信的用户账号

#### 4.2.2 slave准备

- 配置唯一的server-id
- 使用master分配的用户账号读取master二进制日志
- 启用slave服务


## 5. master 操作
### 5.1 修改master配置文件
&#160; &#160; &#160; &#160;找到主数据库的配置文件my.cnf(或者my.ini)，我的在/etc/mysql/my.cnf,在[mysqld]部分插入如下两行：

```
root@manage01:~# egrep -irn 'log_bin|server-id' /etc/mysql/mysql.conf.d/mysqld.cnf
84:server-id		= 2
85:log_bin			= /var/log/mysql/mysql-bin.log
```
&#160; &#160; &#160; &#160;配置完毕后，重启mysql

```
root@manage01:~# /etc/init.d/mysql restart
[ ok ] Restarting mysql (via systemctl): mysql.service.
```

### 5.2 授权同步账号
&#160; &#160; &#160; &#160;创建用户并授权：用户：repl，密码：repl
```
grant all privileges on *.* to repl@'%' identified by 'repl';
```
操作过程

```
mysql> select host,user from mysql.user;
+-------------+------------------+
| host        | user             |
+-------------+------------------+
| %           | loocha           |
| 192.168.5.% | loocha           |
| localhost   | airflow          |
| localhost   | debian-sys-maint |
| localhost   | mysql.session    |
| localhost   | mysql.sys        |
| localhost   | root             |
| localhost   | seafile          |
+-------------+------------------+
8 rows in set (0,00 sec)

mysql> grant replication slave on *.* to 'repl'@'%' identified by 'repl';
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.01 sec)

mysql> select host,user from mysql.user;
+-------------+------------------+
| host        | user             |
+-------------+------------------+
| %           | loocha           |
| %           | repl             |
| 192.168.5.% | loocha           |
| localhost   | airflow          |
| localhost   | debian-sys-maint |
| localhost   | mysql.session    |
| localhost   | mysql.sys        |
| localhost   | root             |
| localhost   | seafile          |
+-------------+------------------+
9 rows in set (0,00 sec)

```
### 5.3 记录状态
```
# 查看master状态，记录二进制文件名(mysql-bin.000003)和位置(73)：
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000001 |      434 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0,00 sec)
```

!!! note "注意"
    ```python
    注意这个文件mysql-bin.000001和点434
    ```

## 6. slave 操作
### 6.1 修改master配置文件
&#160; &#160; &#160; &#160;找到主数据库的配置文件my.cnf(或者my.ini)，修改server-id。
也就是之前的主，已经配置为server-id=1


### 6.2 链接
### 6.2.1 快速命令
登录到从上操作(master mysql的leco主机上操作)
```
stop slave;
grant all privileges on *.* to repl@'%' identified by 'repl';
change master to master_host='192.168.5.110',\
                 master_port=3306,\
                 master_user='repl',\
                 master_password='repl',\
                 master_log_file='mysql-bin.000001',\
                 master_log_pos=1571;
start slave;
show slave status\G;
```
&#160; &#160; &#160; &#160; 操作过程
```
mysql> stop slave;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> change master to master_host='192.168.2.146',\
    ->                  master_port=3306,\
    ->                  master_user='repl',\
    ->                  master_password='repl',\
    ->                  master_log_file='mysql-bin.000001',\
    ->                  master_log_pos=434;
Query OK, 0 rows affected, 2 warnings (0.04 sec)

mysql> start slave;
Query OK, 0 rows affected (0.00 sec)
```

### 6.2.2 查看状态
&#160; &#160; &#160; &#160; 登录到从上操作(master mysql的leco主机上操作)，在从上查看mysql状态
```
mysql> show slave status\G;
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 192.168.2.146
                  Master_User: repl
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000001
          Read_Master_Log_Pos: 434
               Relay_Log_File: leco-relay-bin.000002
                Relay_Log_Pos: 320
        Relay_Master_Log_File: mysql-bin.000001
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB:
          Replicate_Ignore_DB:
           Replicate_Do_Table:
       Replicate_Ignore_Table:
      Replicate_Wild_Do_Table:
  Replicate_Wild_Ignore_Table:
                   Last_Errno: 0
                   Last_Error:
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 434
              Relay_Log_Space: 526
              Until_Condition: None
               Until_Log_File:
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File:
           Master_SSL_CA_Path:
              Master_SSL_Cert:
            Master_SSL_Cipher:
               Master_SSL_Key:
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error:
               Last_SQL_Errno: 0
               Last_SQL_Error:
  Replicate_Ignore_Server_Ids:
             Master_Server_Id: 2
                  Master_UUID: 28d41b5e-5341-11e8-b65a-f4ec380008c2
             Master_Info_File: /var/lib/mysql/master.info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind:
      Last_IO_Error_Timestamp:
     Last_SQL_Error_Timestamp:
               Master_SSL_Crl:
           Master_SSL_Crlpath:
           Retrieved_Gtid_Set:
            Executed_Gtid_Set:
                Auto_Position: 0
         Replicate_Rewrite_DB:
                 Channel_Name:
           Master_TLS_Version:
1 row in set (0.00 sec)

ERROR:
No query specified
```

> 以上看到两个yes一般都是主从OK。

### 6.2.3 设置

- leco机器上mysql配置
```
auto_increment_offset = 1
auto_increment_increment = 2
```
- manage01机器上mysql配置
```
auto_increment_increment = 2
auto_increment_offset = 2
```
&#160; &#160; &#160; &#160; 为了保证id不冲突，我配置以上两个参数，执行过程如下
```
root@leco:/etc/mysql/mysql.conf.d# egrep -v '#|^$' mysqld.cnf
[mysqld_safe]
socket		= /var/run/mysqld/mysqld.sock
nice		= 0
[mysqld]
user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
tmpdir		= /tmp
lc-messages-dir	= /usr/share/mysql
skip-external-locking
auto_increment_offset = 1
auto_increment_increment = 2
key_buffer_size		= 16M
max_allowed_packet	= 16M
thread_stack		= 192K
thread_cache_size       = 8
myisam-recover-options  = BACKUP
query_cache_limit	= 1M
query_cache_size        = 16M
log_error = /var/log/mysql/error.log
server-id		= 1
log_bin			= /var/log/mysql/mysql-bin.log
expire_logs_days	= 10
max_binlog_size   = 100M
[mysql]
auto-rehash
root@leco:/etc/mysql/mysql.conf.d# /etc/init.d/mysql restart
[ ok ] Restarting mysql (via systemctl): mysql.service.

root@manage01:/etc/mysql/mysql.conf.d# egrep -v '#|^$' mysqld.cnf
[mysqld_safe]
socket		= /var/run/mysqld/mysqld.sock
nice		= 0
[mysqld]
user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
tmpdir		= /tmp
lc-messages-dir	= /usr/share/mysql
skip-external-locking
character-set-server=utf8
auto_increment_offset = 2
auto_increment_increment = 2
bind-address		= 0.0.0.0
key_buffer_size		= 16M
max_allowed_packet	= 16M
thread_stack		= 192K
thread_cache_size       = 8
myisam-recover-options  = BACKUP
query_cache_limit	= 1M
query_cache_size        = 16M
log_error = /var/log/mysql/error.log
server-id		= 2
log_bin			= /var/log/mysql/mysql-bin.log
expire_logs_days	= 10
max_binlog_size   = 100M
root@manage01:/etc/mysql/mysql.conf.d# /etc/init.d/mysql restart
[ ok ] Restarting mysql (via systemctl): mysql.service.
```


## 7. 测试
### 7.1 leco主机添加主数据

```
root@leco:~# mysql -uroot -p
Enter password:
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> drop table cmz;
ERROR 1051 (42S02): Unknown table 'summer.cmz'
mysql> create table cmz(
    -> id int not null primary key auto_increment,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.08 sec)

mysql> insert into cmz(name,age,score) values("cmz from leco data",18,88);
Query OK, 1 row affected (0.01 sec)

mysql> insert into cmz(name,age,score) values("cmz1 from leco data",40,88);
Query OK, 1 row affected (0.01 sec)

mysql> select * from cmz;
+----+---------------------+-----+-------+
| id | name                | age | score |
+----+---------------------+-----+-------+
|  1 | cmz from leco data  |  18 |    88 |
|  3 | cmz1 from leco data |  40 |    88 |
+----+---------------------+-----+-------+
2 rows in set (0.00 sec)
```

### 7.2 manage01主机查看数据

```
root@manage01:~# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 5.7.23-0ubuntu0.16.04.1-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use summer
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from cmz;
+----+---------------------+-----+-------+
| id | name                | age | score |
+----+---------------------+-----+-------+
|  1 | cmz from leco data  |  18 |    88 |
|  3 | cmz1 from leco data |  40 |    88 |
+----+---------------------+-----+-------+
2 rows in set (0,00 sec)
```

> 这样来看leco主机上添加的数据同步到manage01主机上了。

### 7.3 manage01主机天添加数据

```
root@manage01:~# mysql -uroot -p
Enter password:
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
root@manage01:~# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 5.7.23-0ubuntu0.16.04.1-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> insert into cmz(name,age,score) values("cmz2 from manage01",18,66);
Query OK, 1 row affected (0,13 sec)

mysql> insert into cmz(name,age,score) values("cmz3 from manage01",40,66);
Query OK, 1 row affected (0,16 sec)

mysql> select * from cmz;
+----+---------------------+-----+-------+
| id | name                | age | score |
+----+---------------------+-----+-------+
|  1 | cmz from leco data  |  18 |    88 |
|  3 | cmz1 from leco data |  40 |    88 |
|  4 | cmz2 from manage01  |  18 |    66 |
|  6 | cmz3 from manage01  |  40 |    66 |
+----+---------------------+-----+-------+
4 rows in set (0,00 sec)
```

### 7.4 leco主机查看数据

```
root@leco:~# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from cmz;
+----+---------------------+-----+-------+
| id | name                | age | score |
+----+---------------------+-----+-------+
|  1 | cmz from leco data  |  18 |    88 |
|  3 | cmz1 from leco data |  40 |    88 |
|  4 | cmz2 from manage01  |  18 |    66 |
|  6 | cmz3 from manage01  |  40 |    66 |
+----+---------------------+-----+-------+
4 rows in set (0.00 sec)

```

> 这样来看manage01主机上添加的数据同步到leco主机上了。到此为止，双主就搞好了。

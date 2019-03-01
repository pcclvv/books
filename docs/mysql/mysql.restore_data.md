<center><h1> MySQL binlog 恢复数据库 </h1></center>

## 1. binlog介绍
&#160; &#160; &#160; &#160; 众所周知，binlog日志对于mysql数据库来说是十分重要的。在数据丢失的紧急情况下，我们往往会想到用binlog日志功能进行数据恢复（定时全备份+binlog日志恢复增量数据部分），为你一路保驾护航！

### 1.1 了解binlog
&#160; &#160; &#160; &#160;MySQL的二进制日志binlog可以说是MySQL最重要的日志，它记录了所有的DDL和DML语句（除了数据查询语句select），以事件形式记录，还包含语句所执行的消耗的时间，MySQL的二进制日志是事务安全型的。 

#### 1.1.1 DDL
&#160; &#160; &#160; &#160; Data Definition Language,主要的命令有CREATE、ALTER、DROP等，DDL主要是用在定义或改变表（TABLE）的结构，数据类型，表之间的链接和约束等初始化工作上，他们大多在建立表时使用。

#### 1.1.2 DML
&#160; &#160; &#160; &#160; Data Manipulation Language 数据操纵语言,主要的命令是SELECT、UPDATE、INSERT、DELETE，就象它的名字一样，这4条命令是用来对数据库里的数据进行操作的语言

### 1.3 binlog常用选项

```
--start-datetime： 从二进制日志中读取指定等于时间戳或者晚于本地服务器的时间
--stop-datetime：  从二进制日志中读取指定小于时间戳或者等于本地服务器的时间 取值和上述一样
--start-position： 从二进制日志中读取指定position 事件位置作为开始。
--stop-position：  从二进制日志中读取指定position 事件位置作为事件截至
```

### 1.4 使用场景

- MySQL主从复制：MySQL Replication在Master端开启binlog，Master把它的二进制日志传递给slaves来达到master-slave数据一致的目的
- 数据恢复了，通过使用mysqlbinlog工具来使恢复数据。

### 1.5 binlog包括文件

- 二进制日志索引文件（文件名后缀为.index）用于记录所有的二进制文件
- 二进制日志文件（文件名后缀为.00000*）记录数据库所有的DDL和DML(除了数据查询语句select)语句事件

### 1.6 开始binlog

&#160; &#160; &#160; &#160;我的是ubuntu系统，其他系统配置文件可能有所不同
```
root@leco:~# grep -i log_bin /etc/mysql/mysql.conf.d/mysqld.cnf
log_bin			= /var/log/mysql/mysql-bin.log
```

!!! note "注意"
    ```python
    1. mysql-bin 是日志的基本名或前缀名
    2. 每次服务器（数据库）重启，服务器会调用flush logs;，新创建一个binlog日志！
    3. 修改mysql配置文件后一定要重启。
    ```

### 1.7 查看开启

```
root@leco:~# mysql -uroot -proot -e ' show variables like "log_bin";'
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+
```
是ON就是开始了bin log。


## 2. binlog常用命令
### 2.1 查看binlog日志列表
查看所有binlog日志列表

```
mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      1648 |
| mysql-bin.000002 |       677 |
| mysql-bin.000003 |       613 |
| mysql-bin.000004 |       554 |
| mysql-bin.000005 |      1239 |
| mysql-bin.000006 |       177 |
| mysql-bin.000007 |      1749 |
| mysql-bin.000008 |       154 |
+------------------+-----------+
8 rows in set (0.00 sec)

```

### 2.2 查看最新日志情况
查看master状态，即最后(最新)一个binlog日志的编号名称，及其最后一个操作事件pos结束点(Position)值

```
mysql>  show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000008 |      154 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```

### 2.3 刷新日志
flush刷新log日志，自此刻开始产生一个新编号的binlog日志文件

```
mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      1648 |
| mysql-bin.000002 |       677 |
| mysql-bin.000003 |       613 |
| mysql-bin.000004 |       554 |
| mysql-bin.000005 |      1239 |
| mysql-bin.000006 |       177 |
| mysql-bin.000007 |      1749 |
| mysql-bin.000008 |       154 |
+------------------+-----------+
8 rows in set (0.00 sec)

mysql>  flush logs;
Query OK, 0 rows affected (0.07 sec)

mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      1648 |
| mysql-bin.000002 |       677 |
| mysql-bin.000003 |       613 |
| mysql-bin.000004 |       554 |
| mysql-bin.000005 |      1239 |
| mysql-bin.000006 |       177 |
| mysql-bin.000007 |      1749 |
| mysql-bin.000008 |       201 |
| mysql-bin.000009 |       154 |
+------------------+-----------+
9 rows in set (0.00 sec)
```


> 注意：每当mysqld服务重启时，会自动执行此命令，刷新binlog日志；在mysqldump备份数据时加 -F 选项也会刷新binlog日志；

### 2.4 清空日志

```
mysql> reset master;
Query OK, 0 rows affected (0.12 sec)

mysql> show master logs; 
+------------------+-----------+
| Log_name | File_size |
+------------------+-----------+
| mysql-bin.000001 | 106 |
+------------------+-----------+
1 row in set (0.00 sec)
```

## 3. 查看binlog日志内容

### 3.1 mysqbinlog
使用mysqlbinlog自带查看命令法：

- -->binlog是二进制文件，普通文件查看器cat、more、vim等都无法打开，必须使用自带的mysqlbinlog命令查看
- -->binlog日志与数据库文件在同目录中
- -->在MySQL5.5以下版本使用mysqlbinlog命令时如果报错，就加上 "--no-defaults" 选项

```
root@leco:~# cd /var/log/mysql/
root@leco:/var/log/mysql# ls
error.log       error.log.2.gz  error.log.4.gz  error.log.6.gz  mysql-bin.000001  mysql-bin.000003  mysql-bin.000005  mysql-bin.000007  mysql-bin.000009
error.log.1.gz  error.log.3.gz  error.log.5.gz  error.log.7.gz  mysql-bin.000002  mysql-bin.000004  mysql-bin.000006  mysql-bin.000008  mysql-bin.index
root@leco:/var/log/mysql# mysqlbinlog -v mysql-bin.000009
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#190301 15:50:43 server id 1  end_log_pos 123 CRC32 0x19c50202 	Start: binlog v 4, server v 5.7.25-0ubuntu0.16.04.2-log created 190301 15:50:43
# Warning: this binlog is either in use or was not closed properly.
BINLOG '
U+R4XA8BAAAAdwAAAHsAAAABAAQANS43LjI1LTB1YnVudHUwLjE2LjA0LjItbG9nAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEzgNAAgAEgAEBAQEEgAAXwAEGggAAAAICAgCAAAACgoKKioAEjQA
AQICxRk=
'/*!*/;
# at 123
#190301 15:50:43 server id 1  end_log_pos 154 CRC32 0x91c319ef 	Previous-GTIDs
# [empty]
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
```

!!! note "解释"
    ```python
    1. server id 1      是mysql的id，本机是1所有显示1
    2. 190301 15:50:43  执行时间。
    3. end_log_pos 154  sql结束的pos节点
    ```

### 3.2 参数查询
&#160; &#160; &#160; &#160;上面这种办法读取出binlog日志的全文内容比较多，不容易分辨查看到pos点信息
&#160; &#160; &#160; &#160;下面介绍一种更为方便的查询命令：

```
show binlog events [IN 'log_name'] [FROM pos] [LIMIT [offset,] row_count];
```

!!! note "解释"
    ```python
    1. IN 'log_name'：  指定要查询的binlog文件名(不指定就是第一个binlog文件)
    2. FROM pos：       指定从哪个pos起始点开始查起(不指定就是从整个文件首个pos点开始算)
    3. LIMIT [offset,]：偏移量(不指定就是0)
    4. row_count：      查询总条数(不指定就是所有行)
    ```

```
mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      1648 |
| mysql-bin.000002 |       677 |
| mysql-bin.000003 |       613 |
| mysql-bin.000004 |       554 |
| mysql-bin.000005 |      1239 |
| mysql-bin.000006 |       177 |
| mysql-bin.000007 |      1749 |
| mysql-bin.000008 |       201 |
| mysql-bin.000009 |       154 |
+------------------+-----------+
9 rows in set (0.00 sec)

mysql> show binlog events in "mysql-bin.000009";
+------------------+-----+----------------+-----------+-------------+--------------------------------------------------------+
| Log_name         | Pos | Event_type     | Server_id | End_log_pos | Info                                                   |
+------------------+-----+----------------+-----------+-------------+--------------------------------------------------------+
| mysql-bin.000009 |   4 | Format_desc    |         1 |         123 | Server ver: 5.7.25-0ubuntu0.16.04.2-log, Binlog ver: 4 |
| mysql-bin.000009 | 123 | Previous_gtids |         1 |         154 |                                                        |
+------------------+-----+----------------+-----------+-------------+--------------------------------------------------------+
2 rows in set (0.01 sec)

mysql> show binlog events in "mysql-bin.000009"\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000009
        Pos: 4
 Event_type: Format_desc
  Server_id: 1
End_log_pos: 123
       Info: Server ver: 5.7.25-0ubuntu0.16.04.2-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000009
        Pos: 123
 Event_type: Previous_gtids
  Server_id: 1
End_log_pos: 154
       Info:
2 rows in set (0.00 sec)

ERROR:
No query specified

mysql> show binlog events in "mysql-bin.000007"\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000007
        Pos: 4
 Event_type: Format_desc
  Server_id: 1
End_log_pos: 123
       Info: Server ver: 5.7.25-0ubuntu0.16.04.2-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000007
        Pos: 123
 Event_type: Previous_gtids
  Server_id: 1
End_log_pos: 154
       Info:
*************************** 3. row ***************************
   Log_name: mysql-bin.000007
        Pos: 154
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 219
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 4. row ***************************
   Log_name: mysql-bin.000007
        Pos: 219
 Event_type: Query
  Server_id: 1
End_log_pos: 298
       Info: BEGIN
*************************** 5. row ***************************
   Log_name: mysql-bin.000007
        Pos: 298
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 389
       Info: # insert into cmz(name,age,score) values("cmz1 from leco data",40,88)
*************************** 6. row ***************************
   Log_name: mysql-bin.000007
        Pos: 389
 Event_type: Table_map
  Server_id: 1
End_log_pos: 442
       Info: table_id: 109 (summer.cmz)
*************************** 7. row ***************************
   Log_name: mysql-bin.000007
        Pos: 442
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 510
       Info: table_id: 109 flags: STMT_END_F
*************************** 8. row ***************************
   Log_name: mysql-bin.000007
        Pos: 510
 Event_type: Xid
  Server_id: 1
End_log_pos: 541
       Info: COMMIT /* xid=15 */
*************************** 9. row ***************************
   Log_name: mysql-bin.000007
        Pos: 541
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 606
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 10. row ***************************
   Log_name: mysql-bin.000007
        Pos: 606
 Event_type: Query
  Server_id: 1
End_log_pos: 685
       Info: BEGIN
*************************** 11. row ***************************
   Log_name: mysql-bin.000007
        Pos: 685
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 776
       Info: # insert into cmz(name,age,score) values("cmz1 from leco data",40,88)
*************************** 12. row ***************************
   Log_name: mysql-bin.000007
        Pos: 776
 Event_type: Table_map
  Server_id: 1
End_log_pos: 829
       Info: table_id: 109 (summer.cmz)
*************************** 13. row ***************************
   Log_name: mysql-bin.000007
        Pos: 829
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 897
       Info: table_id: 109 flags: STMT_END_F
*************************** 14. row ***************************
   Log_name: mysql-bin.000007
        Pos: 897
 Event_type: Xid
  Server_id: 1
End_log_pos: 928
       Info: COMMIT /* xid=16 */
*************************** 15. row ***************************
   Log_name: mysql-bin.000007
        Pos: 928
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 993
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 16. row ***************************
   Log_name: mysql-bin.000007
        Pos: 993
 Event_type: Query
  Server_id: 1
End_log_pos: 1072
       Info: BEGIN
*************************** 17. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1072
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 1163
       Info: # insert into cmz(name,age,score) values("cmz1 from leco data",40,88)
*************************** 18. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1163
 Event_type: Table_map
  Server_id: 1
End_log_pos: 1216
       Info: table_id: 109 (summer.cmz)
*************************** 19. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1216
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 1284
       Info: table_id: 109 flags: STMT_END_F
*************************** 20. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1284
 Event_type: Xid
  Server_id: 1
End_log_pos: 1315
       Info: COMMIT /* xid=17 */
*************************** 21. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1315
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 1380
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 22. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1380
 Event_type: Query
  Server_id: 1
End_log_pos: 1459
       Info: BEGIN
*************************** 23. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1459
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 1550
       Info: # insert into cmz(name,age,score) values("cmz1 from leco data",40,88)
*************************** 24. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1550
 Event_type: Table_map
  Server_id: 1
End_log_pos: 1603
       Info: table_id: 109 (summer.cmz)
*************************** 25. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1603
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 1671
       Info: table_id: 109 flags: STMT_END_F
*************************** 26. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1671
 Event_type: Xid
  Server_id: 1
End_log_pos: 1702
       Info: COMMIT /* xid=18 */
*************************** 27. row ***************************
   Log_name: mysql-bin.000007
        Pos: 1702
 Event_type: Rotate
  Server_id: 1
End_log_pos: 1749
       Info: mysql-bin.000008;pos=4
27 rows in set (0.00 sec)

ERROR:
No query specified

```
上面这条语句可以将指定的binlog日志文件，分成有效事件行的方式返回，并可使用limit指定pos点的起始偏移，查询条数！

其他查询

```
a）查询第一个(最早)的binlog日志：
mysql> show binlog events\G;

b）指定查询 mysql-bin.000002这个文件：
mysql> show binlog events in 'mysql-bin.000002'\G;

c）指定查询 mysql-bin.000002这个文件，从pos点:624开始查起：
mysql> show binlog events in 'mysql-bin.000002' from 624\G;

d）指定查询 mysql-bin.000002这个文件，从pos点:624开始查起，查询10条（即10条语句）
mysql> show binlog events in 'mysql-bin.000002' from 624 limit 10\G;

e）指定查询 mysql-bin.000002这个文件，从pos点:624开始查起，偏移2行（即中间跳过2个），查询10条
mysql> show binlog events in 'mysql-bin.000002' from 624 limit 2,10\G;
```

## 4. binlog恢复数据
### 4.1 环境准备

```
drop database summer;
create database summer charset utf8;
use summer;
drop table cmz;
create table cmz(
id int not null primary key auto_increment,
name varchar(20),
age int not null,
score int not null
);

insert into cmz(name,age,score) values("cmz1",18,88);
insert into cmz(name,age,score) values("cmz2",28,88);
insert into cmz(name,age,score) values("cmz3",38,88);
insert into cmz(name,age,score) values("cmz4",48,88);

select * from cmz;
```
执行过程

```
mysql> drop database summer;
ERROR 1008 (HY000): Can't drop database 'summer'; database doesn't exist
mysql> create database summer charset utf8;
Query OK, 1 row affected (0.00 sec)

mysql> use summer;
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

mysql>
mysql> insert into cmz(name,age,score) values("cmz1",18,88);
Query OK, 1 row affected (0.01 sec)

mysql> insert into cmz(name,age,score) values("cmz2",28,88);
Query OK, 1 row affected (0.02 sec)

mysql> insert into cmz(name,age,score) values("cmz3",38,88);
Query OK, 1 row affected (0.03 sec)

mysql> insert into cmz(name,age,score) values("cmz4",48,88);
Query OK, 1 row affected (0.01 sec)

mysql>
mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 |  18 |    88 |
|  3 | cmz2 |  28 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
+----+------+-----+-------+
4 rows in set (0.00 sec)

```

## 5 场景模拟
### 5.1 全量备份
&#160; &#160; &#160; &#160;假设每天零点全量备份一次。

```
root@leco:~# mkdir /mysqldataback
root@leco:~# crontab -l
0 0 * * * mysqldump -uroot -p -B -F -R -x --master-data=2 summer|gzip >/mysqldataback/summer_$(date +%F).sql.gz

root@leco:~# mysqldump -uroot -p -B -F -R -x --master-data=2 summer|gzip >/mysqldataback/summer_$(date +%F).sql.gz
Enter password:
root@leco:~# ls /mysqldataback/
summer_2019-03-01.sql.gz
root@leco:~# du -sh  /mysqldataback/
8.0K	/mysqldataback/
root@leco:~# du -sh  /mysqldataback/summer_2019-03-01.sql.gz
4.0K	/mysqldataback/summer_2019-03-01.sql.gz

```
!!! note "参数说明"
    ```python
    1. -B：指定数据库
    2. -F：刷新日志
    3. -R：备份存储过程等
    4. -x：锁表
    5. --master-data：在备份语句里添加CHANGE MASTER语句以及binlog文件及位置点信息
    ```
&#160; &#160; &#160; &#160;待到数据库备份完成，就不用担心数据丢失了，因为有完全备份数据在！！

&#160; &#160; &#160; &#160;由于上面在全备份的时候使用了-F选项，那么当数据备份操作刚开始的时候系统就会自动刷新log，这样就会自动产生
一个新的binlog日志，这个新的binlog日志就会用来记录备份之后的数据库“增删改”操作
查看一下：

```
root@leco:~# mysql -uroot -proot -e ' show master status;'
mysql: [Warning] Using a password on the command line interface can be insecure.
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000013 |      154 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
```
也就是说， mysql-bin.000013 是用来记录0点之后对数据库的所有“增删改”操作。

### 5.2 开工
&#160; &#160; &#160; &#160;早上开始，由于业务的需求会对数据库进行各种“增删改”操作。比如我们在cmz表中做了增删改查操作。
快速命令
```
insert into cmz(name,age,score) values("cmz5",58,88);
insert into cmz(name,age,score) values("cmz6",68,88);
update cmz set age=100 where name='cmz1';
update cmz set age=200 where name='cmz2';
```
操作过程
```
mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+------------------+
| Tables_in_summer |
+------------------+
| cmz              |
+------------------+
1 row in set (0.00 sec)

mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 |  18 |    88 |
|  3 | cmz2 |  28 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
+----+------+-----+-------+
4 rows in set (0.00 sec)

mysql> insert into cmz(name,age,score) values("cmz5",58,88);
Query OK, 1 row affected (0.01 sec)

mysql> insert into cmz(name,age,score) values("cmz6",68,88);
Query OK, 1 row affected (0.01 sec)

mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 |  18 |    88 |
|  3 | cmz2 |  28 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
|  9 | cmz5 |  58 |    88 |
| 11 | cmz6 |  68 |    88 |
+----+------+-----+-------+
6 rows in set (0.00 sec)

```


接着有又操作。

```
mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 |  18 |    88 |
|  3 | cmz2 |  28 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
|  9 | aa   |   1 |     1 |
| 11 | bb   |   1 |     1 |
| 13 | cc   |   1 |     1 |
| 15 | dd   |   1 |     1 |
+----+------+-----+-------+
8 rows in set (0.00 sec)

mysql> update cmz set age=100 where name='cmz1';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update cmz set age=200 where name='cmz2';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 | 100 |    88 |
|  3 | cmz2 | 200 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
|  9 | cmz5 |  58 |    88 |
| 11 | cmz6 |  68 |    88 |
+----+------+-----+-------+
6 rows in set (0.00 sec)
```
以上也就是最新的数据，这个时间点。某个人手贱。删除了这个表。

```
mysql> show tables;
+------------------+
| Tables_in_summer |
+------------------+
| cmz              |
+------------------+
1 row in set (0.00 sec)

mysql> drop table cmz;
Query OK, 0 rows affected (0.05 sec)

mysql> show tables;
Empty set (0.00 sec)
```
此时来找你。问你怎么办，此时你不要惊慌。喝杯水压压惊。我草，我该上场了。

此时你别手抖，先仔细查看最后一个binlog日志，并记录下关键的pos点，到底是哪个pos点的操作导致了数据库的破坏(通常在最后几步)；先备份一下最后一个binlog日志文件：

```
root@leco:~# cd /var/log/mysql/
root@leco:/var/log/mysql# ll
总用量 124
drwxr-x---  2 mysql adm     4096 3月   1 17:21 ./
drwxrwxr-x 31 root  syslog  4096 3月   1 07:35 ../
-rw-r-----  1 mysql adm     9428 3月   1 14:26 error.log
-rw-r-----  1 mysql adm     6604 3月   1 02:00 error.log.1.gz
-rw-r-----  1 mysql adm     2902 2月  27 09:09 error.log.2.gz
-rw-r-----  1 mysql adm     4906 2月  26 18:08 error.log.3.gz
-rw-r-----  1 mysql adm     1460 2月  25 09:52 error.log.4.gz
-rw-r-----  1 mysql adm      324 2月  24 20:01 error.log.5.gz
-rw-r-----  1 mysql adm       20 2月  23 07:35 error.log.6.gz
-rw-r-----  1 mysql adm       20 2月  22 07:35 error.log.7.gz
-rw-r-----  1 mysql mysql   1648 3月   1 10:55 mysql-bin.000001
-rw-r-----  1 mysql mysql    677 3月   1 10:56 mysql-bin.000002
-rw-r-----  1 mysql mysql    613 3月   1 11:04 mysql-bin.000003
-rw-r-----  1 mysql mysql    554 3月   1 14:23 mysql-bin.000004
-rw-r-----  1 mysql mysql   1239 3月   1 14:25 mysql-bin.000005
-rw-r-----  1 mysql mysql    177 3月   1 14:26 mysql-bin.000006
-rw-r-----  1 mysql mysql   1749 3月   1 14:26 mysql-bin.000007
-rw-r-----  1 mysql mysql    201 3月   1 15:50 mysql-bin.000008
-rw-r-----  1 mysql mysql   2246 3月   1 16:12 mysql-bin.000009
-rw-r-----  1 mysql mysql  10105 3月   1 17:09 mysql-bin.000010
-rw-r-----  1 mysql mysql   1105 3月   1 17:14 mysql-bin.000011
-rw-r-----  1 mysql mysql   7882 3月   1 17:21 mysql-bin.000012
-rw-r-----  1 mysql mysql   1786 3月   1 17:25 mysql-bin.000013
-rw-r-----  1 mysql mysql    416 3月   1 17:21 mysql-bin.index
root@leco:/var/log/mysql#
```
接着执行一次刷新日志索引操作，重新开始新的binlog日志记录文件。按理说mysql-bin.0000013，这个文件不会再有后续写入了，因为便于我们分析原因及查找ops节点，以后所有数据库操作都会写入到下一个日志文件。

```
mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      1648 |
| mysql-bin.000002 |       677 |
| mysql-bin.000003 |       613 |
| mysql-bin.000004 |       554 |
| mysql-bin.000005 |      1239 |
| mysql-bin.000006 |       177 |
| mysql-bin.000007 |      1749 |
| mysql-bin.000008 |       201 |
| mysql-bin.000009 |      2246 |
| mysql-bin.000010 |     10105 |
| mysql-bin.000011 |      1105 |
| mysql-bin.000012 |      7882 |
| mysql-bin.000013 |      1786 |
+------------------+-----------+
13 rows in set (0.00 sec)


mysql> flush logs;
Query OK, 0 rows affected (0.07 sec)

mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      1648 |
| mysql-bin.000002 |       677 |
| mysql-bin.000003 |       613 |
| mysql-bin.000004 |       554 |
| mysql-bin.000005 |      1239 |
| mysql-bin.000006 |       177 |
| mysql-bin.000007 |      1749 |
| mysql-bin.000008 |       201 |
| mysql-bin.000009 |      2246 |
| mysql-bin.000010 |     10105 |
| mysql-bin.000011 |      1105 |
| mysql-bin.000012 |      7882 |
| mysql-bin.000013 |      1833 |
| mysql-bin.000014 |       154 |
+------------------+-----------+
14 rows in set (0.00 sec)

```

接下来，读取binlog日志，分析问题。登录服务器，并查看(推荐此种方法)

```
mysql> show binlog events in 'mysql-bin.000013'\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000013
        Pos: 4
 Event_type: Format_desc
  Server_id: 1
End_log_pos: 123
       Info: Server ver: 5.7.25-0ubuntu0.16.04.2-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000013
        Pos: 123
 Event_type: Previous_gtids
  Server_id: 1
End_log_pos: 154
       Info:
*************************** 3. row ***************************
   Log_name: mysql-bin.000013
        Pos: 154
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 219
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 4. row ***************************
   Log_name: mysql-bin.000013
        Pos: 219
 Event_type: Query
  Server_id: 1
End_log_pos: 298
       Info: BEGIN
*************************** 5. row ***************************
   Log_name: mysql-bin.000013
        Pos: 298
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 374
       Info: # insert into cmz(name,age,score) values("cmz5",58,88)
*************************** 6. row ***************************
   Log_name: mysql-bin.000013
        Pos: 374
 Event_type: Table_map
  Server_id: 1
End_log_pos: 427
       Info: table_id: 133 (summer.cmz)
*************************** 7. row ***************************
   Log_name: mysql-bin.000013
        Pos: 427
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 480
       Info: table_id: 133 flags: STMT_END_F
*************************** 8. row ***************************
   Log_name: mysql-bin.000013
        Pos: 480
 Event_type: Xid
  Server_id: 1
End_log_pos: 511
       Info: COMMIT /* xid=516 */
*************************** 9. row ***************************
   Log_name: mysql-bin.000013
        Pos: 511
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 576
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 10. row ***************************
   Log_name: mysql-bin.000013
        Pos: 576
 Event_type: Query
  Server_id: 1
End_log_pos: 655
       Info: BEGIN
*************************** 11. row ***************************
   Log_name: mysql-bin.000013
        Pos: 655
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 731
       Info: # insert into cmz(name,age,score) values("cmz6",68,88)
*************************** 12. row ***************************
   Log_name: mysql-bin.000013
        Pos: 731
 Event_type: Table_map
  Server_id: 1
End_log_pos: 784
       Info: table_id: 133 (summer.cmz)
*************************** 13. row ***************************
   Log_name: mysql-bin.000013
        Pos: 784
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 837
       Info: table_id: 133 flags: STMT_END_F
*************************** 14. row ***************************
   Log_name: mysql-bin.000013
        Pos: 837
 Event_type: Xid
  Server_id: 1
End_log_pos: 868
       Info: COMMIT /* xid=517 */
*************************** 15. row ***************************
   Log_name: mysql-bin.000013
        Pos: 868
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 933
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 16. row ***************************
   Log_name: mysql-bin.000013
        Pos: 933
 Event_type: Query
  Server_id: 1
End_log_pos: 1012
       Info: BEGIN
*************************** 17. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1012
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 1076
       Info: # update cmz set age=100 where name='cmz1'
*************************** 18. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1076
 Event_type: Table_map
  Server_id: 1
End_log_pos: 1129
       Info: table_id: 133 (summer.cmz)
*************************** 19. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1129
 Event_type: Update_rows
  Server_id: 1
End_log_pos: 1201
       Info: table_id: 133 flags: STMT_END_F
*************************** 20. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1201
 Event_type: Xid
  Server_id: 1
End_log_pos: 1232
       Info: COMMIT /* xid=520 */
*************************** 21. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1232
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 1297
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 22. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1297
 Event_type: Query
  Server_id: 1
End_log_pos: 1376
       Info: BEGIN
*************************** 23. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1376
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 1440
       Info: # update cmz set age=200 where name='cmz2'
*************************** 24. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1440
 Event_type: Table_map
  Server_id: 1
End_log_pos: 1493
       Info: table_id: 133 (summer.cmz)
*************************** 25. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1493
 Event_type: Update_rows
  Server_id: 1
End_log_pos: 1565
       Info: table_id: 133 flags: STMT_END_F
*************************** 26. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1565
 Event_type: Xid
  Server_id: 1
End_log_pos: 1596
       Info: COMMIT /* xid=521 */
*************************** 27. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1596
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 1661
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 28. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1661
 Event_type: Query
  Server_id: 1
End_log_pos: 1786
       Info: use `summer`; DROP TABLE `cmz` /* generated by server */
*************************** 29. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1786
 Event_type: Rotate
  Server_id: 1
End_log_pos: 1833
       Info: mysql-bin.000014;pos=4
29 rows in set (0.00 sec)

ERROR:
No query specified

```
&#160; &#160; &#160; &#160;通过分析，造成数据库破坏的pos点区间是介于 1661--1786 之间（这是按照日志区间的pos节点算的），因为在上面的binlog日志看出在28 row看到执行了drop指令，只要恢复到1661之前就可。


### 5.3 开始恢复 
#### 5.3.1 恢复之前0点备份
快速命令

```
cd /mysqldataback/
gzip -d summer_2019-03-01.sql.gz
mysql -uroot -proot -v < summer_2019-03-01.sql
```
操作过程
```
root@manage01:/var/log/mysql# cd /mysqldataback/
root@manage01:/mysqldataback# ls
mysql-bin.000004  summer_2019-03-01.sql.gz
root@manage01:/mysqldataback# gzip -d summer_2019-03-01.sql.gz
root@manage01:/mysqldataback# ls
mysql-bin.000004  summer_2019-03-01.sql
root@manage01:/mysqldataback# mysql -uroot -proot -v < summer_2019-03-01.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
--------------
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
--------------

--------------
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
--------------

--------------
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
--------------

--------------
/*!40101 SET NAMES utf8 */
--------------

--------------
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */
--------------

--------------
/*!40103 SET TIME_ZONE='+00:00' */
--------------

--------------
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */
--------------

--------------
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
--------------

--------------
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
--------------

--------------
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
--------------

--------------
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `summer` /*!40100 DEFAULT CHARACTER SET utf8 */
--------------

--------------
DROP TABLE IF EXISTS `cmz`
--------------

--------------
/*!40101 SET @saved_cs_client     = @@character_set_client */
--------------

--------------
/*!40101 SET character_set_client = utf8 */
--------------

--------------
CREATE TABLE `cmz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `age` int(11) NOT NULL,
  `score` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8
--------------

--------------
/*!40101 SET character_set_client = @saved_cs_client */
--------------

--------------
LOCK TABLES `cmz` WRITE
--------------

--------------
/*!40000 ALTER TABLE `cmz` DISABLE KEYS */
--------------

--------------
INSERT INTO `cmz` VALUES (1,'cmz1',18,88),(3,'cmz2',28,88),(5,'cmz3',38,88),(7,'cmz4',48,88)
--------------

--------------
/*!40000 ALTER TABLE `cmz` ENABLE KEYS */
--------------

--------------
UNLOCK TABLES
--------------

--------------
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */
--------------

--------------
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */
--------------

--------------
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */
--------------

--------------
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */
--------------

--------------
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
--------------

--------------
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
--------------

--------------
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
--------------

--------------
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
--------------
```

登录查看，0点时候备份的sql是否恢复过来了。
```
mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+------------------+
| Tables_in_summer |
+------------------+
| cmz              |
+------------------+
1 row in set (0,00 sec)

mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  2 | cmz1 |  18 |    88 |
|  4 | cmz2 |  28 |    88 |
|  6 | cmz3 |  38 |    88 |
|  8 | cmz4 |  48 |    88 |
+----+------+-----+-------+
4 rows in set (0,00 sec)

```
这样就恢复了截至当日凌晨(0:00)前的备份数据都恢复了。但是这个仅仅只0点备份的时候，0点以后到drop之间的数据怎么恢复呢

#### 5.3.2 方法1 - 恢复-修改错sql
语法

```
mysqlbinlog mysql-bin.0000xx | mysql -u用户名 -p密码 数据库名
```

!!! note "参数解释"
    ```python
    常用参数选项解释：
    --start-position=875 起始pos点
    --stop-position=954 结束pos点
    --start-datetime="2016-9-25 22:01:08" 起始时间点
    --stop-datetime="2019-9-25 22:09:46" 结束时间点
    --database=zyyshop 指定只恢复zyyshop数据库(一台主机上往往有多个数据库，只限本地log日志)
    
    不常用选项： 
    -u --user=name 连接到远程主机的用户名
    -p --password[=name] 连接到远程主机的密码
    -h --host=name 从远程主机上获取binlog日志
    --read-from-remote-server 从某个MySQL服务器上读取binlog日志
    
    实际是将读出的binlog日志内容，通过管道符传递给mysql命令。这些命令、文件尽量写成绝对路径；
    ```

&#160; &#160; &#160; &#160;知道了这么恢复的话，开始恢复备份之后到drop之间的数据。
&#160; &#160; &#160; &#160;要编辑那个mysql-bin.000004 文件。将drop那条命令去掉。


```
root@leco:/mysqldataback# cp /var/log/mysql/mysql-bin.000013 .
root@leco:/mysqldataback# ls
mysql-bin.000013  summer_2019-03-01.sql
root@leco:/mysqldataback# mysqlbinlog mysql-bin.000013 >mysql-bin.000013.sql
root@leco:/mysqldataback# ls
mysql-bin.000013  mysql-bin.000013.sql  summer_2019-03-01.sql
root@leco:/mysqldataback# vim mysql-bin.000013.sql
root@leco:/mysqldataback# # DROP TABLE `cmz` /* generated by server */  删除这个语句
root@leco:/mysqldataback# mysql -uroot -proot <mysql-bin.000013.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1790 (HY000) at line 122: @@SESSION.GTID_NEXT cannot be changed by a client that owns a GTID. The client owns ANONYMOUS. Ownership is released on COMMIT or ROLLBACK.

```
登录数据库查看
```
mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from cmz;
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 | 100 |    88 |
|  3 | cmz2 | 200 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
|  9 | cmz5 |  58 |    88 |
| 11 | cmz6 |  68 |    88 |
+----+------+-----+-------+
6 rows in set (0.00 sec)
```

&#160; &#160; &#160; &#160;这样数据就全部恢复出来了。恢复数据一共两个点

- 1. 先恢复最近备份那个点，也就是上面的0点备份的文件
- 2. 然后再恢复无操作之前的文件，就可以恢复以上数据。

#### 5.3.3 方法2 - 恢复- 点
删除表

```
mysql> show tables;
+------------------+
| Tables_in_summer |
+------------------+
| cmz              |
+------------------+
1 row in set (0.00 sec)

mysql> drop table cmz;
Query OK, 0 rows affected (0.04 sec)

mysql> show tables;
Empty set (0.00 sec)
```
开始恢复。

```
root@leco:/mysqldataback# ll
总用量 24
drwxr-xr-x  2 root root 4096 3月   1 17:35 ./
drwxr-xr-x 33 root root 4096 3月   1 16:10 ../
-rw-r-----  1 root root 1833 3月   1 17:34 mysql-bin.000013     # 最初删除drop table cmz，就是记录在这个binlog中的。
-rw-r--r--  1 root root 5432 3月   1 17:35 mysql-bin.000013.sql
-rw-r--r--  1 root root 2331 3月   1 17:21 summer_2019-03-01.sql
root@leco:/mysqldataback#
```
我们查看sql的执行情况

```
mysql> show binlog events in 'mysql-bin.000013'\G;
*************************** 1. row ***************************
   Log_name: mysql-bin.000013
        Pos: 4
 Event_type: Format_desc
  Server_id: 1
End_log_pos: 123
       Info: Server ver: 5.7.25-0ubuntu0.16.04.2-log, Binlog ver: 4
*************************** 2. row ***************************
   Log_name: mysql-bin.000013
        Pos: 123
 Event_type: Previous_gtids
  Server_id: 1
End_log_pos: 154
       Info:
*************************** 3. row ***************************
   Log_name: mysql-bin.000013
        Pos: 154
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 219
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 4. row ***************************
   Log_name: mysql-bin.000013
        Pos: 219
 Event_type: Query
  Server_id: 1
End_log_pos: 298
       Info: BEGIN
*************************** 5. row ***************************
   Log_name: mysql-bin.000013
        Pos: 298
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 374
       Info: # insert into cmz(name,age,score) values("cmz5",58,88)
*************************** 6. row ***************************
   Log_name: mysql-bin.000013
        Pos: 374
 Event_type: Table_map
  Server_id: 1
End_log_pos: 427
       Info: table_id: 133 (summer.cmz)
*************************** 7. row ***************************
   Log_name: mysql-bin.000013
        Pos: 427
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 480
       Info: table_id: 133 flags: STMT_END_F
*************************** 8. row ***************************
   Log_name: mysql-bin.000013
        Pos: 480
 Event_type: Xid
  Server_id: 1
End_log_pos: 511
       Info: COMMIT /* xid=516 */
*************************** 9. row ***************************
   Log_name: mysql-bin.000013
        Pos: 511
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 576
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 10. row ***************************
   Log_name: mysql-bin.000013
        Pos: 576
 Event_type: Query
  Server_id: 1
End_log_pos: 655
       Info: BEGIN
*************************** 11. row ***************************
   Log_name: mysql-bin.000013
        Pos: 655
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 731
       Info: # insert into cmz(name,age,score) values("cmz6",68,88)
*************************** 12. row ***************************
   Log_name: mysql-bin.000013
        Pos: 731
 Event_type: Table_map
  Server_id: 1
End_log_pos: 784
       Info: table_id: 133 (summer.cmz)
*************************** 13. row ***************************
   Log_name: mysql-bin.000013
        Pos: 784
 Event_type: Write_rows
  Server_id: 1
End_log_pos: 837
       Info: table_id: 133 flags: STMT_END_F
*************************** 14. row ***************************
   Log_name: mysql-bin.000013
        Pos: 837
 Event_type: Xid
  Server_id: 1
End_log_pos: 868
       Info: COMMIT /* xid=517 */
*************************** 15. row ***************************
   Log_name: mysql-bin.000013
        Pos: 868
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 933
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 16. row ***************************
   Log_name: mysql-bin.000013
        Pos: 933
 Event_type: Query
  Server_id: 1
End_log_pos: 1012
       Info: BEGIN
*************************** 17. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1012
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 1076
       Info: # update cmz set age=100 where name='cmz1'
*************************** 18. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1076
 Event_type: Table_map
  Server_id: 1
End_log_pos: 1129
       Info: table_id: 133 (summer.cmz)
*************************** 19. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1129
 Event_type: Update_rows
  Server_id: 1
End_log_pos: 1201
       Info: table_id: 133 flags: STMT_END_F
*************************** 20. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1201
 Event_type: Xid
  Server_id: 1
End_log_pos: 1232
       Info: COMMIT /* xid=520 */
*************************** 21. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1232
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 1297
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 22. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1297
 Event_type: Query
  Server_id: 1
End_log_pos: 1376
       Info: BEGIN
*************************** 23. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1376
 Event_type: Rows_query
  Server_id: 1
End_log_pos: 1440
       Info: # update cmz set age=200 where name='cmz2'
*************************** 24. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1440
 Event_type: Table_map
  Server_id: 1
End_log_pos: 1493
       Info: table_id: 133 (summer.cmz)
*************************** 25. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1493
 Event_type: Update_rows
  Server_id: 1
End_log_pos: 1565
       Info: table_id: 133 flags: STMT_END_F
*************************** 26. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1565
 Event_type: Xid
  Server_id: 1
End_log_pos: 1596
       Info: COMMIT /* xid=521 */
*************************** 27. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1596
 Event_type: Anonymous_Gtid
  Server_id: 1
End_log_pos: 1661
       Info: SET @@SESSION.GTID_NEXT= 'ANONYMOUS'
*************************** 28. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1661
 Event_type: Query
  Server_id: 1
End_log_pos: 1786
       Info: use `summer`; DROP TABLE `cmz` /* generated by server */
*************************** 29. row ***************************
   Log_name: mysql-bin.000013
        Pos: 1786
 Event_type: Rotate
  Server_id: 1
End_log_pos: 1833
       Info: mysql-bin.000014;pos=4
29 rows in set (0.00 sec)

ERROR:
No query specified
```
从上面可以看到。在drop的时候。mysql的pos开始至1661结束1786，也就是我们恢复到1661，即可。

开始恢复

```
# 先恢复之前全备份
root@leco:/mysqldataback# mysql -uroot -proot <summer_2019-03-01.sql

# 然后根据pos位置恢复
root@leco:/mysqldataback# mysqlbinlog  --stop-position=1661 mysql-bin.000013| mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
root@leco:/mysqldataback# mysql -uroot -proot -e 'use summer;select * from cmz;'
mysql: [Warning] Using a password on the command line interface can be insecure.
+----+------+-----+-------+
| id | name | age | score |
+----+------+-----+-------+
|  1 | cmz1 | 100 |    88 |
|  3 | cmz2 | 200 |    88 |
|  5 | cmz3 |  38 |    88 |
|  7 | cmz4 |  48 |    88 |
|  9 | cmz5 |  58 |    88 |
| 11 | cmz6 |  68 |    88 |
+----+------+-----+-------+

```
然后看到，数据都恢复了。





!!! note "总结"
    ```python
    所谓恢复，就是让mysql将保存在binlog日志中指定段落区间的sql语句逐个重新执行一次而已。
    ```


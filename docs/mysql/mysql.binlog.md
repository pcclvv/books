<center><h1> MySQL binlog </h1></center>

## 1. 介绍

&#160; &#160; &#160; &#160; binlog 基本认识

&#160; &#160; &#160; &#160;MySQL的二进制日志可以说是MySQL最重要的日志了，它记录了所有的DDL和DML(除了数据查询语句)语句，以事件形式记录，还包含语句所执行的消耗的时间，MySQL的二进制日志是事务安全型的。

&#160; &#160; &#160; &#160;一般来说开启二进制日志大概会有1%的性能损耗(参见MySQL官方中文手册 5.1.24版)。二进制有两个最重要的使用场景: 

- MySQL Replication在Master端开启binlog，Mster把它的二进制日志传递给slaves来达到master-slave数据一致的目的。 
- 自然就是数据恢复了，通过使用mysqlbinlog工具来使恢复数据。

&#160; &#160; &#160; &#160;二进制日志包括两类文件：二进制日志索引文件（文件名后缀为.index）用于记录所有的二进制文件，二进制日志文件（文件名后缀为.00000*）记录数据库所有的DDL和DML(除了数据查询语句)语句事件。 

## 2. 开启binlog

&#160; &#160; &#160; &#160;找到配置文件，配置好以下，然后重启mysql。

```
root@leco:/etc/mysql/mysql.conf.d# grep 'log_bin' mysqld.cnf
log_bin			= /var/log/mysql/mysql-bin.log

```
登录查看

```
mysql> show variables like 'log_bin';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| log_bin       | ON    |
+---------------+-------+
1 row in set (0.01 sec)
```

> ON表示已经开启binlog日志



## 3. 常用操作
### 3.1 日志列表
&#160; &#160; &#160; &#160;查看所有binlog日志列表

```
mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      2846 |
| mysql-bin.000002 |      1058 |
| mysql-bin.000003 |     10287 |
+------------------+-----------+
3 rows in set (0.00 sec)
```

### 3.2 查看最新
&#160; &#160; &#160; &#160;查看master状态，即最后(最新)一个binlog日志的编号名称，及其最后一个操作事件pos结束点(Position)值

```
mysql> show master status;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000003 |    10287 |              |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)

```

### 3.3 刷新
&#160; &#160; &#160; &#160;刷新log日志，自此刻开始产生一个新编号的binlog日志文件
```
mysql> flush logs;
Query OK, 0 rows affected (0.06 sec)

mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |      2846 |
| mysql-bin.000002 |      1058 |
| mysql-bin.000003 |     10334 |
| mysql-bin.000004 |       154 |
+------------------+-----------+
4 rows in set (0.00 sec)
```
可以看出多了一个mysql-bin.000004 文件

!!! tip "注意"
    ```python
    每当mysqld服务重启时，会自动执行此命令，刷新binlog日志；在mysqldump备份数据时加 -F 选项也会刷新binlog日志；
    ```

### 3.4 清除
&#160; &#160; &#160; &#160;重置(清空)所有binlog日志

```
mysql> reset master;
Query OK, 0 rows affected (0.03 sec)

mysql> show master logs;
+------------------+-----------+
| Log_name         | File_size |
+------------------+-----------+
| mysql-bin.000001 |       154 |
+------------------+-----------+
1 row in set (0.00 sec)

```

!!! danger "注意"
    ```python
    在生产环境上，不要操作。
    ```

## 4. 查看日志内容
### 4.1 日志路径

```
mysql> show variables like 'log_%';
+----------------------------------------+--------------------------------+
| Variable_name                          | Value                          |
+----------------------------------------+--------------------------------+
| log_bin                                | ON                             |
| log_bin_basename                       | /var/log/mysql/mysql-bin       |
| log_bin_index                          | /var/log/mysql/mysql-bin.index |
| log_bin_trust_function_creators        | OFF                            |
| log_bin_use_v1_row_events              | OFF                            |
| log_builtin_as_identified_by_password  | OFF                            |
| log_error                              | /var/log/mysql/error.log       |
| log_error_verbosity                    | 3                              |
| log_output                             | FILE                           |
| log_queries_not_using_indexes          | OFF                            |
| log_slave_updates                      | OFF                            |
| log_slow_admin_statements              | OFF                            |
| log_slow_slave_statements              | OFF                            |
| log_statements_unsafe_for_binlog       | ON                             |
| log_syslog                             | OFF                            |
| log_syslog_facility                    | daemon                         |
| log_syslog_include_pid                 | ON                             |
| log_syslog_tag                         |                                |
| log_throttle_queries_not_using_indexes | 0                              |
| log_timestamps                         | UTC                            |
| log_warnings                           | 2                              |
+----------------------------------------+--------------------------------+
21 rows in set (0.00 sec)

```
也可以查看服务器的配置文件中查找。

```
root@leco:/etc/mysql/mysql.conf.d# egrep  'log_bin' mysqld.cnf
log_bin			= /var/log/mysql/mysql-bin.log
root@leco:/var/log/mysql# ll
总用量 52
drwxr-x---  2 mysql adm    4096 3月   1 10:46 ./
drwxrwxr-x 31 root  syslog 4096 3月   1 07:35 ../
-rw-r-----  1 mysql adm       0 3月   1 07:35 error.log
-rw-r-----  1 mysql adm    6604 3月   1 02:00 error.log.1.gz
-rw-r-----  1 mysql adm    2902 2月  27 09:09 error.log.2.gz
-rw-r-----  1 mysql adm    4906 2月  26 18:08 error.log.3.gz
-rw-r-----  1 mysql adm    1460 2月  25 09:52 error.log.4.gz
-rw-r-----  1 mysql adm     324 2月  24 20:01 error.log.5.gz
-rw-r-----  1 mysql adm      20 2月  23 07:35 error.log.6.gz
-rw-r-----  1 mysql adm      20 2月  22 07:35 error.log.7.gz
-rw-r-----  1 mysql mysql   154 3月   1 10:46 mysql-bin.000001
-rw-r-----  1 mysql mysql    32 3月   1 10:46 mysql-bin.index

```

### 4.2 binlog查看
#### 4.2.1 非SQL方式显示

```
root@leco:/var/log/mysql# mysqlbinlog -v mysql-bin.000004
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#190301 11:04:46 server id 1  end_log_pos 123 CRC32 0x14abee01 	Start: binlog v 4, server v 5.7.25-0ubuntu0.16.04.2-log created 190301 11:04:46
# Warning: this binlog is either in use or was not closed properly.
BINLOG '
TqF4XA8BAAAAdwAAAHsAAAABAAQANS43LjI1LTB1YnVudHUwLjE2LjA0LjItbG9nAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAEzgNAAgAEgAEBAQEEgAAXwAEGggAAAAICAgCAAAACgoKKioAEjQA
AQHuqxQ=
'/*!*/;
# at 123
#190301 11:04:46 server id 1  end_log_pos 154 CRC32 0x0bab435e 	Previous-GTIDs
# [empty]
# at 154
#190301 11:04:49 server id 1  end_log_pos 219 CRC32 0x6b8e78b8 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=no
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 219
#190301 11:04:49 server id 1  end_log_pos 317 CRC32 0x82a1e13d 	Query	thread_id=16	exec_time=0	error_code=0
use `summer`/*!*/;
SET TIMESTAMP=1551409489/*!*/;
SET @@session.pseudo_thread_id=16/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1436549152/*!*/;
SET @@session.auto_increment_increment=2, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=8/*!*/;
SET @@session.time_zone='SYSTEM'/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
flush privileges
/*!*/;
# at 317
#190301 11:13:38 server id 1  end_log_pos 382 CRC32 0x2b5aab56 	Anonymous_GTID	last_committed=1	sequence_number=2	rbr_only=no
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 382
#190301 11:13:38 server id 1  end_log_pos 507 CRC32 0xcffec2b7 	Query	thread_id=16	exec_time=0	error_code=0
SET TIMESTAMP=1551410018/*!*/;
DROP TABLE `cmz` /* generated by server */
/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;
root@leco:/var/log/mysql#


```

&#160; &#160; &#160; &#160;mysqlbinlog有一个参数--verbose(或-v)，将自动生成带注释的SQL语句（在行事件中重构伪SQL语句），其实这个并非原始SQL语句，而是伪SQL，如果使用这个参数两次(如-v -v)，则输出列的描述信息，会生成字段的类型、长度、是否为null等属性信息：

&#160; &#160; &#160; &#160;以上显示不是我们真实输入的SQL语句。其实这里的SQL语句不是原始SQL语句，那么能否看到原始SQL语句呢？答案是可以，但是必须设置系统变量binlog_rows_query_log_events。

#### 4.2.2 SQL方式显示
开启

```
root@leco:/var/log/mysql# vim /etc/mysql/mysql.conf.d/mysqld.cnf
root@leco:/var/log/mysql# /etc/init.d/mysql restart
[ ok ] Restarting mysql (via systemctl): mysql.service.
mysql> show variables like 'binlog_rows_query_log_events';
+------------------------------+-------+
| Variable_name                | Value |
+------------------------------+-------+
| binlog_rows_query_log_events | ON    |
+------------------------------+-------+
1 row in set (0.00 sec)
```
插入点数据

```
mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> insert into cmz(name,age,score) values("cmz1 from leco data",40,88);
Query OK, 1 row affected (0.01 sec)

mysql> insert into cmz(name,age,score) values("cmz1 from leco data",40,88);
Query OK, 1 row affected (0.01 sec)

mysql> insert into cmz(name,age,score) values("cmz1 from leco data",40,88);
Query OK, 1 row affected (0.01 sec)

mysql> insert into cmz(name,age,score) values("cmz1 from leco data",40,88);
Query OK, 1 row affected (0.01 sec)

mysql> flush logs;
Query OK, 0 rows affected (0.06 sec)
```
此时在查看binlog日志

```
root@leco:/var/log/mysql# mysqlbinlog --base64-output=DECODE-ROWS  -vv mysql-bin.000005
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#190301 14:23:31 server id 1  end_log_pos 123 CRC32 0xc790f07e 	Start: binlog v 4, server v 5.7.25-0ubuntu0.16.04.2-log created 190301 14:23:31
# at 123
#190301 14:23:31 server id 1  end_log_pos 154 CRC32 0xc5c3c48e 	Previous-GTIDs
# [empty]
# at 154
#190301 14:24:16 server id 1  end_log_pos 219 CRC32 0x34abaaba 	Anonymous_GTID	last_committed=0	sequence_number=1	rbr_only=no
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 219
#190301 14:24:16 server id 1  end_log_pos 420 CRC32 0xa5400620 	Query	thread_id=18	exec_time=0	error_code=0
use `summer`/*!*/;
SET TIMESTAMP=1551421456/*!*/;
SET @@session.pseudo_thread_id=18/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1436549152/*!*/;
SET @@session.auto_increment_increment=2, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8 *//*!*/;
SET @@session.character_set_client=33,@@session.collation_connection=33,@@session.collation_server=8/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
create table cmz(
id int not null primary key auto_increment,
name varchar(20),
age int not null,
score int not null
)
/*!*/;
# at 420
#190301 14:24:19 server id 1  end_log_pos 485 CRC32 0x57042dad 	Anonymous_GTID	last_committed=1	sequence_number=2	rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 485
#190301 14:24:19 server id 1  end_log_pos 564 CRC32 0xbd0e31f3 	Query	thread_id=18	exec_time=0	error_code=0
SET TIMESTAMP=1551421459/*!*/;
BEGIN
/*!*/;
# at 564
#190301 14:24:19 server id 1  end_log_pos 654 CRC32 0xe97dcc67 	Rows_query
# insert into cmz(name,age,score) values("cmz from leco data",18,88)
# at 654
#190301 14:24:19 server id 1  end_log_pos 707 CRC32 0x0e55c20a 	Table_map: `summer`.`cmz` mapped to number 131
# at 707
#190301 14:24:19 server id 1  end_log_pos 774 CRC32 0x45930630 	Write_rows: table id 131 flags: STMT_END_F
### INSERT INTO `summer`.`cmz`
### SET
###   @1=1 /* INT meta=0 nullable=0 is_null=0 */
###   @2='cmz from leco data' /* VARSTRING(20) meta=20 nullable=1 is_null=0 */
###   @3=18 /* INT meta=0 nullable=0 is_null=0 */
###   @4=88 /* INT meta=0 nullable=0 is_null=0 */
# at 774
#190301 14:24:19 server id 1  end_log_pos 805 CRC32 0x06220d41 	Xid = 257
COMMIT/*!*/;
# at 805
#190301 14:24:19 server id 1  end_log_pos 870 CRC32 0xff42bcfd 	Anonymous_GTID	last_committed=2	sequence_number=3	rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'ANONYMOUS'/*!*/;
# at 870
#190301 14:24:19 server id 1  end_log_pos 949 CRC32 0xa586b903 	Query	thread_id=18	exec_time=0	error_code=0
SET TIMESTAMP=1551421459/*!*/;
BEGIN
/*!*/;
# at 949
#190301 14:24:19 server id 1  end_log_pos 1040 CRC32 0x1c25f21f 	Rows_query
# insert into cmz(name,age,score) values("cmz1 from leco data",40,88)
# at 1040
#190301 14:24:19 server id 1  end_log_pos 1093 CRC32 0x6c8d4461 	Table_map: `summer`.`cmz` mapped to number 131
# at 1093
#190301 14:24:19 server id 1  end_log_pos 1161 CRC32 0x32c5030c 	Write_rows: table id 131 flags: STMT_END_F
### INSERT INTO `summer`.`cmz`
### SET
###   @1=3 /* INT meta=0 nullable=0 is_null=0 */
###   @2='cmz1 from leco data' /* VARSTRING(20) meta=20 nullable=1 is_null=0 */
###   @3=40 /* INT meta=0 nullable=0 is_null=0 */
###   @4=88 /* INT meta=0 nullable=0 is_null=0 */
# at 1161
#190301 14:24:19 server id 1  end_log_pos 1192 CRC32 0xc1579343 	Xid = 258
COMMIT/*!*/;
# at 1192
#190301 14:25:08 server id 1  end_log_pos 1239 CRC32 0x4fde8e8c 	Rotate to mysql-bin.000006  pos: 4
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
/*!50003 SET COMPLETION_TYPE=@OLD_COMPLETION_TYPE*/;
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=0*/;

```

可以看到以上出现我们输入的真实SQL语句。


## 5. binlog相关参数
### 5.1 binlog配置
&#160; &#160; &#160; &#160; 开启binlog日志(在[mysqld]下修改或添加如下配置)

```
server-id=1
log-bin=mysql-bin
binlog_format=MIXED
```
### 5.1 binlog模式

&#160; &#160; &#160; &#160; Mysql复制主要有三种方式：基于SQL语句的复制(statement-based replication, SBR)，基于行的复制(row-based replication, RBR)，混合模式复制(mixed-based replication, MBR)。对应的，binlog的格式也有三种：STATEMENT，ROW，MIXED。
 
- STATEMENT模式（SBR）

&#160; &#160; &#160; &#160; 每一条会修改数据的sql语句会记录到binlog中。优点是并不需要记录每一条sql语句和每一行的数据变化，减少了binlog日志量，节约IO，提高性能。缺点是在某些情况下会导致master-slave中的数据不一致(如sleep()函数， last_insert_id()，以及user-defined functions(udf)等会出现问题)
 
- ROW模式（RBR）

&#160; &#160; &#160; &#160; 不记录每条sql语句的上下文信息，仅需记录哪条数据被修改了，修改成什么样了。而且不会出现某些特定情况下的存储过程、或function、或trigger的调用和触发无法被正确复制的问题。缺点是会产生大量的日志，尤其是alter table的时候会让日志暴涨。
 
- MIXED模式（MBR）

&#160; &#160; &#160; &#160; 以上两种模式的混合使用，一般的复制使用STATEMENT模式保存binlog，对于STATEMENT模式无法复制的操作使用ROW模式保存binlog，MySQL会根据执行的SQL语句选择日志保存方式。


### 5.2 binlog 保存天数

```
mysql> show variables like '%expire_logs_days%';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| expire_logs_days | 10    |
+------------------+-------+
1 row in set (0.00 sec)

```

> 0 表示永不过期

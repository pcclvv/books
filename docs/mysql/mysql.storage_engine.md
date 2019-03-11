<center><h1> MySQL 存储引擎 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; 什么是存储引擎

- mysql中建立的库===>文件夹
- 库中建立的表===>文件
- 存储引擎就是表的类型

&#160; &#160; &#160; &#160; 现实生活中我们用来存储数据的文件有不同的类型，每种文件类型对应各自不同的处理机制：比如处理文本用txt类型，处理表格用excel，处理图片用png等

&#160; &#160; &#160; &#160; 数据库中的表也应该有不同的类型，表的类型不同，会对应mysql不同的存取机制，表类型又称为存储引擎。

&#160; &#160; &#160; &#160; 存储引擎说白了就是如何存储数据、如何为存储的数据建立索引和如何更新、查询数据等技术的实现方
法。因为在关系数据库中数据的存储是以表的形式存储的，所以存储引擎也可以称为表类型（即存储和
操作此表的类型）

&#160; &#160; &#160; &#160; 在Oracle 和SQL Server等数据库中只有一种存储引擎，所有数据存储管理机制都是一样的。而MySql
数据库提供了多种存储引擎。用户可以根据不同的需求为数据表选择不同的存储引擎，用户也可以根据
自己的需要编写自己的存储引擎

## 2. mysql支持的存储引擎

```
mysql> show engines\G;
*************************** 1. row ***************************
      Engine: MyISAM
     Support: YES
     Comment: MyISAM storage engine
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 2. row ***************************
      Engine: MRG_MYISAM
     Support: YES
     Comment: Collection of identical MyISAM tables
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 3. row ***************************
      Engine: CSV
     Support: YES
     Comment: CSV storage engine
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 4. row ***************************
      Engine: BLACKHOLE
     Support: YES
     Comment: /dev/null storage engine (anything you write to it disappears)
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 5. row ***************************
      Engine: PERFORMANCE_SCHEMA
     Support: YES
     Comment: Performance Schema
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 6. row ***************************
      Engine: InnoDB
     Support: DEFAULT
     Comment: Supports transactions, row-level locking, and foreign keys
Transactions: YES
          XA: YES
  Savepoints: YES
*************************** 7. row ***************************
      Engine: ARCHIVE
     Support: YES
     Comment: Archive storage engine
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 8. row ***************************
      Engine: MEMORY
     Support: YES
     Comment: Hash based, stored in memory, useful for temporary tables
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 9. row ***************************
      Engine: FEDERATED
     Support: NO
     Comment: Federated MySQL storage engine
Transactions: NULL
          XA: NULL
  Savepoints: NULL
rows in set (0.00 sec)

ERROR: 
No query specified
```

```
mysql> show engines;
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| Engine             | Support | Comment                                                        | Transactions | XA   | Savepoints |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
| MyISAM             | YES     | MyISAM storage engine                                          | NO           | NO   | NO         |
| MRG_MYISAM         | YES     | Collection of identical MyISAM tables                          | NO           | NO   | NO         |
| CSV                | YES     | CSV storage engine                                             | NO           | NO   | NO         |
| BLACKHOLE          | YES     | /dev/null storage engine (anything you write to it disappears) | NO           | NO   | NO         |
| PERFORMANCE_SCHEMA | YES     | Performance Schema                                             | NO           | NO   | NO         |
| InnoDB             | DEFAULT | Supports transactions, row-level locking, and foreign keys     | YES          | YES  | YES        |
| ARCHIVE            | YES     | Archive storage engine                                         | NO           | NO   | NO         |
| MEMORY             | YES     | Hash based, stored in memory, useful for temporary tables      | NO           | NO   | NO         |
| FEDERATED          | NO      | Federated MySQL storage engine                                 | NULL         | NULL | NULL       |
+--------------------+---------+----------------------------------------------------------------+--------------+------+------------+
rows in set (0.00 sec)

mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| t1            |
+---------------+
row in set (0.00 sec)

# 创建指定引擎的表
mysql> create table t2(id int) engine=innodb;
Query OK, 0 rows affected (0.03 sec)

# 查看创建的过程
mysql> show create table t2\G;
*************************** 1. row ***************************
       Table: t2
Create Table: CREATE TABLE `t2` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
row in set (0.00 sec)

ERROR: 
No query specified

# 其他类型的引擎方式
mysql> create table t3(id int) engine=memory;  # 存在内存中，只有表结构，没有数据
Query OK, 0 rows affected (0.00 sec)

mysql> create table t4(id int) engine=blackhole; # 存入的数据就没啦
Query OK, 0 rows affected (0.00 sec)

mysql> create table t5(id int) engine=myisam;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into t3 values(1);
Query OK, 1 row affected (0.00 sec)

mysql> insert into t4 values(1);
Query OK, 1 row affected (0.00 sec)

mysql> insert into t5 values(1);
Query OK, 1 row affected (0.00 sec)

mysql> select * from t3;  # 存于内存，重启mysql就啦
+------+
| id   |
+------+
|    1 |
+------+
row in set (0.00 sec)

mysql> select * from t4;  # 数据没有啦，黑洞
Empty set (0.00 sec)

mysql> select * from t5;
+------+
| id   |
+------+
|    1 |
+------+
row in set (0.00 sec)

# 重启mysql 查看t3的数据
Usage: /etc/init.d/mysql start|stop|restart|reload|force-reload|status
leco@leco:/etc/mysql/mysql.conf.d$ /etc/init.d/mysql restart
[ ok ] Restarting mysql (via systemctl): mysql.service.
leco@leco:/etc/mysql/mysql.conf.d$ mysql -uroot -pleco
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.21-0ubuntu0.16.04.1 (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use db1;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| t1            |
| t2            |
| t3            |
| t4            |
| t5            |
+---------------+
rows in set (0.00 sec)

mysql> desc t3;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
row in set (0.00 sec)

mysql> select * from t3;  # 发现数据么有啦
Empty set (0.00 sec)
```

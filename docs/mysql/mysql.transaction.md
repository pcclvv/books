<center><h1> MySQL 事务 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; MySQL 事务主要用于处理操作量大，复杂度高的数据。比如说，在人员管理系统中，你删除一个人员，你即需要删除人员的基本资料，也要删除和该人员相关的信息，如信箱，文章等等，这样，这些数据库操作语句就构成一个事务！

&#160; &#160; &#160; &#160;在 MySQL 中只有使用了 Innodb 数据库引擎的数据库或表才支持事务。
事务处理可以用来维护数据库的完整性，保证成批的 SQL 语句要么全部执行，要么全部不执行。
事务用来管理 insert,update,delete 语句

&#160; &#160; &#160; &#160;一般来说，事务是必须满足4个条件（ACID）：：原子性（Atomicity，或称不可分割性）、一致性（Consistency）、隔离性（Isolation，又称独立性）、持久性（Durability）。

- 原子性：一个事务（transaction）中的所有操作，要么全部完成，要么全部不完成，不会结束在中间某个环节。事务在执行过程中发生错误，会被回滚（Rollback）到事务开始前的状态，就像这个事务从来没有执行过一样。

- 一致性：在事务开始之前和事务结束以后，数据库的完整性没有被破坏。这表示写入的资料必须完全符合所有的预设规则，这包含资料的精确度、串联性以及后续数据库可以自发性地完成预定的工作。

- 隔离性：数据库允许多个并发事务同时对其数据进行读写和修改的能力，隔离性可以防止多个事务并发执行时由于交叉执行而导致数据的不一致。事务隔离分为不同级别，包括读未提交（Read uncommitted）、读提交（read committed）、可重复读（repeatable read）和串行化（Serializable）。

- 持久性：事务处理结束后，对数据的修改就是永久的，即便系统故障也不会丢失。

!!! note "提示"
    ```python
    在 MySQL 命令行的默认设置下，事务都是自动提交的，即执行 SQL 语句后就会马上执行 COMMIT 操作。因此要显式地开启一个事务务须使用命令 BEGIN 或 START TRANSACTION，或者执行命令 SET AUTOCOMMIT=0，用来禁止使用当前会话的自动提交。
    ```

## 2. 事务控制语句

- BEGIN 或 START TRANSACTION 显式地开启一个事务；

- COMMIT 也可以使用 COMMIT WORK，不过二者是等价的。COMMIT 会提交事务，并使已对数据库进行的所有修改成为永久性的；

- ROLLBACK 也可以使用 ROLLBACK WORK，不过二者是等价的。回滚会结束用户的事务，并撤销正在进行的所有未提交的修改；

- SAVEPOINT identifier，SAVEPOINT 允许在事务中创建一个保存点，一个事务中可以有多个 SAVEPOINT；
 
- RELEASE SAVEPOINT identifier 删除一个事务的保存点，当没有指定的保存点时，执行该语句会抛出一个异常；

- ROLLBACK TO identifier 把事务回滚到标记点；

- SET TRANSACTION 用来设置事务的隔离级别。InnoDB 存储引擎提供事务的隔离级别有READ U NCOMMITTED、READ COMMITTED、REPEATABLE READ 和 SERIALIZABLE。

## 3. 事务处理

- 用 BEGIN, ROLLBACK, COMMIT来实现
```
BEGIN 开始一个事务
ROLLBACK 事务回滚
COMMIT 事务确认
```

- 直接用 SET 来改变 MySQL 的自动提交模式:
```
SET AUTOCOMMIT=0 禁止自动提交
SET AUTOCOMMIT=1 开启自动提交
```


## 4. 测试
### 4.1 环境准备

```
create database shiwu charset utf8;
use shiwu;
create table user(
id int primary key auto_increment,
name char(32),
balance int
);

insert into user(name,balance)
values
('cmz',1000),
('leco',1000),
('loocha',1000);

select * from user;
#原子操作
start transaction; # 开启事务
update user set balance=900 where name='cmz'; #买支付100元
update user set balance=1010 where name='leco'; #中介拿走10元
update user set balance=1090 where name='loocha'; #卖家拿到90元
commit;

#出现异常，回滚到初始状态
start transaction;
update user set balance=900 where name='cmz'; #买支付100元
update user set balance=1010 where name='leco'; #中介拿走10元
uppdate user set balance=1090 where name='loocha'; #卖家拿到90元,出现异常没有拿到
rollback;
commit;
```

执行过程

```
root@leco:~/book/books/docs/mysql# mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 70
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database shiwu charset utf8;
Query OK, 1 row affected (0.00 sec)

mysql> use shiwu;
Database changed
mysql> create table user(
    -> id int primary key auto_increment,
    -> name char(32),
    -> balance int
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql>
mysql> insert into user(name,balance)
    -> values
    -> ('cmz',1000),
    -> ('leco',1000),
    -> ('loocha',1000);
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql>
mysql> select * from user;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | cmz    |    1000 |
|  3 | leco   |    1000 |
|  5 | loocha |    1000 |
+----+--------+---------+
3 rows in set (0.00 sec)
```

### 4.2 原子操作

```
mysql> # 以下是原子操作
mysql> start transaction; # 开启事务
Query OK, 0 rows affected (0.00 sec)

mysql> update user set balance=900 where name='cmz'; #买支付100元
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update user set balance=1010 where name='leco'; #中介拿走10元
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> update user set balance=1090 where name='loocha'; #卖家拿到90元
Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> commit;
Query OK, 0 rows affected (0.01 sec)

mysql> select * from user;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | cmz    |     900 |
|  3 | leco   |    1010 |
|  5 | loocha |    1090 |
+----+--------+---------+
3 rows in set (0.00 sec)
```

### 4.3 事务回滚

```
mysql> select * from user;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | cmz    |     900 |
|  3 | leco   |    1010 |
|  5 | loocha |    1090 |
+----+--------+---------+
3 rows in set (0.00 sec)

mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)

mysql> update user set balance=900 where name='cmz'; #买支付100元
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> update user set balance=1010 where name='leco'; #中介拿走10元
Query OK, 0 rows affected (0.00 sec)
Rows matched: 1  Changed: 0  Warnings: 0

mysql> uppdate user set balance=1090 where name='loocha'; #卖家拿到90元,出现异常没有拿到
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'uppdate user set balance=1090 where name='loocha'' at line 1
mysql> rollback;
Query OK, 0 rows affected (0.00 sec)

mysql> commit;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from user;
+----+--------+---------+
| id | name   | balance |
+----+--------+---------+
|  1 | cmz    |     900 |
|  3 | leco   |    1010 |
|  5 | loocha |    1090 |
+----+--------+---------+
3 rows in set (0.00 sec)

```


<center><h1> MySQL 表复制 </h1></center>

## 1. 介绍
```
1. 复制表结构 + 记录（数据）
2. 只复制表结构，不复制记录
   1. 复制部分表结构
   2. 复制全部表结构

复制表结构＋记录 （key不会复制: 主键、外键和索引）
# 复制表结构哦和数据
```

## 2. 案例
```
root@leco:~# mysql -uroot -p 
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.21-0ubuntu0.16.04.1 (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db1                |
| db2                |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
6 rows in set (0.00 sec)

mysql> use db2;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------+
| Tables_in_db2 |
+---------------+
| t1            |
+---------------+
1 row in set (0.00 sec)

mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> select × from t1;
ERROR 1054 (42S22): Unknown column '×' in 'field list'
mysql> select * from t1;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | cmz    | male   |   18 |
|    2 | leco   | female |   10 |
|    3 | loocha | male   |    8 |
+------+--------+--------+------+
3 rows in set (0.00 sec)

mysql> create table new_t1 select * from t1;
Query OK, 3 rows affected (0.03 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> show tables;
+---------------+
| Tables_in_db2 |
+---------------+
| new_t1        |
| t1            |
+---------------+
2 rows in set (0.00 sec)

mysql> desc new_t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.01 sec)

mysql> select * from new_t1;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | cmz    | male   |   18 |
|    2 | leco   | female |   10 |
|    3 | loocha | male   |    8 |
+------+--------+--------+------+
3 rows in set (0.00 sec)

# 只复制表结构，不复制数据 
mysql> create table t2 select * from t1 where 1=2;  # 条件为假，查不到任何记录，此时就只会复制表结构，不复制表数据
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> show tables;
+---------------+
| Tables_in_db2 |
+---------------+
| new_t1        |
| t1            |
| t2            |
+---------------+
3 rows in set (0.00 sec)

mysql> desc t2;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> select * from t2;
Empty set (0.00 sec)

mysql> create table t3 like t1;
Query OK, 0 rows affected (0.03 sec)

mysql> show tables;
+---------------+
| Tables_in_db2 |
+---------------+
| new_t1        |
| t1            |
| t2            |
| t3            |
+---------------+
4 rows in set (0.00 sec)

mysql> desc t3;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> select * from t3;
Empty set (0.00 sec)
```

!!! note "注意"
    ```
    create table t2 select * from t1 where 1=2; 和 create table t3 like t1;都是创建表结构有神码区别？
    前者可以选择性的复制，比如只复制其中部分字段的表结构，而后者是全部复制表结构字段。
    ```

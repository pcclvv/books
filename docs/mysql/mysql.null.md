<center><h1> MySQL NULL </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; 我们已经知道MySQL使用SQL SELECT命令及WHERE子句来读取数据表中的数据，但是当提供的查询条件字段为NULL时，该命令可能就无法正常工作。

&#160; &#160; &#160; &#160;为了处理这种情况时，MySQL提供了三大运算符：

- IS NULL：当列的值是NULL，此运算符返回true。
- IS NOT NULL：当列的值不为NULL，运算符返回true。
- <=>：  比较操作符（不同于=运算符），当比较的的两个值为NULL时返回true。


!!! note "注意"
    ```python
    关于NULL的条件比较运算是比较特殊的。你不能使用= NULL或！= NULL在列中查找NULL值。
    在MySQL中，NULL值与任何其他值的比较（即使是NULL）永远返回false，即NULL = NULL返回false。
    MySQL中处理NULL使用IS NULL和IS NOT NULL运算符。
    ```

## 2. 例子
### 2.1 环境

```
use leco;
drop table info;
create table info(
name varchar(40) NOT NULL,
count  int
);
insert into info(name,count) values("cmz1",NULL);
insert into info(name,count) values("cmz2",NULL);
insert into info(name,count) values("cmz3",1);
insert into info(name,count) values("cmz4",2);
desc info;
select * from info;
```
### 2.2 过程

```
leco@leco:~$ mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 118
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use leco;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> drop table info;
ERROR 1051 (42S02): Unknown table 'leco.info'
mysql> create table info(
    -> name varchar(40) NOT NULL,
    -> count  int
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> insert into info(name,count) values("cmz1",NULL);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("cmz2",NULL);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("cmz3",1);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("cmz4",2);
Query OK, 1 row affected (0.02 sec)

mysql> desc info;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| name  | varchar(40) | NO   |     | NULL    |       |
| count | int(11)     | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> select * from info;
+------+-------+
| name | count |
+------+-------+
| cmz1 |  NULL |
| cmz2 |  NULL |
| cmz3 |     1 |
| cmz4 |     2 |
+------+-------+
4 rows in set (0.00 sec)

mysql> select * from info where count=NULL;
Empty set (0.00 sec)

mysql> select * from info where count='NULL';
Empty set, 1 warning (0.00 sec)

mysql> select * from info where count is NULL;
+------+-------+
| name | count |
+------+-------+
| cmz1 |  NULL |
| cmz2 |  NULL |
+------+-------+
2 rows in set (0.00 sec)

mysql> select * from info where count is not NULL;
+------+-------+
| name | count |
+------+-------+
| cmz3 |     1 |
| cmz4 |     2 |
+------+-------+
2 rows in set (0.00 sec)

mysql> select * from info where count <=> NULL;
+------+-------+
| name | count |
+------+-------+
| cmz1 |  NULL |
| cmz2 |  NULL |
+------+-------+
2 rows in set (0.00 sec)
```

!!! note "注意"
    ```python
    1. 实例中你可以看到=和！=运算符是不起作用的.
    2. 列是否为NULL，必须使用IS NULL和IS NOT NULL
    ```


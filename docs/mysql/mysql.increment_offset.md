
<center><h1> MySQL 自增和偏移 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;MySQL中对于表上ID自增列可以在创建表的时候来指定列上的auto_increment属性；等同于SQL server中的identity属性；Oracle则是通过Sequence方式来实现。在MySQL中，系统变量auto_increment_increment，auto_increment_offset 影响自增列的值及其变化规则。本文主要描述这两个系统变量的相关用法。

```
auto_increment_increment   控制列中的值的增量值，也就是步长。  
auto_increment_offset      确定AUTO_INCREMENT列值的起点，也就是初始值。
```

> 变量范围：可以在全局以及session级别设置这2个变量  


```
mysql> show variables like 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 2     |
| auto_increment_offset    | 1     |
+--------------------------+-------+
2 rows in set (0.00 sec)
```


## 2. 演示

&#160; &#160; &#160; &#160;演示auto_increment_increment与auto_increment_offset

### 2.1 环境准备

```
drop database leco;
create database leco charset utf8;
use leco;
create table emp(
id int not null auto_increment primary key, 
name varchar(20)
);  
insert into emp(name) values("summer");
insert into emp(name) values("caimengzhi");
insert into emp(name) values("我曾");
insert into emp(name) values("世本常态");
```
操作过程
```
mysql> drop database leco;
Query OK, 7 rows affected (0.14 sec)

mysql> create database leco charset utf8;
Query OK, 1 row affected (0.00 sec)

mysql> use leco;
Database changed
mysql> use leco;
Database changed
mysql> create table emp(
    -> id int not null auto_increment primary key,
    -> name varchar(20)
    -> );
Query OK, 0 rows affected (0.08 sec)
```

### 2.2 插入数据
```
mysql> insert into emp(name) values("世本常态");
Query OK, 1 row affected (0.01 sec)

mysql> insert into emp(name) values("summer");
Query OK, 1 row affected (0.01 sec)

mysql> insert into emp(name) values("caimengzhi");
Query OK, 1 row affected (0.03 sec)

mysql> insert into emp(name) values("我曾");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 世本常态     |
|  3 | summer       |
|  5 | caimengzhi   |
|  7 | 我曾         |
+----+--------------+
4 rows in set (0.00 sec)

mysql> show variables like 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 2     |
| auto_increment_offset    | 1     |
+--------------------------+-------+
2 rows in set (0.01 sec)
```
&#160; &#160; &#160; &#160;我们从上面结果来看。id从1开始步长为2。

### 2.3 设置步长

&#160; &#160; &#160; &#160;以下都是临时生效，重启mysql后失效。
```
mysql> set auto_increment_increment =  10;
Query OK, 0 rows affected (0.00 sec)

mysql>  show variables like 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 10    |
| auto_increment_offset    | 1     |
+--------------------------+-------+
2 rows in set (0.00 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 世本常态     |
|  3 | summer       |
|  5 | caimengzhi   |
|  7 | 我曾         |
+----+--------------+
4 rows in set (0.00 sec)

mysql> insert into emp(name) values("南京");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 世本常态     |
|  3 | summer       |
|  5 | caimengzhi   |
|  7 | 我曾         |
| 11 | 南京         |
+----+--------------+
5 rows in set (0.00 sec)

mysql> insert into emp(name) values("南京2");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 世本常态     |
|  3 | summer       |
|  5 | caimengzhi   |
|  7 | 我曾         |
| 11 | 南京         |
| 21 | 南京2        |
+----+--------------+
6 rows in set (0.00 sec)

mysql> insert into emp(name) values("南京3");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | 世本常态     |
|  3 | summer       |
|  5 | caimengzhi   |
|  7 | 我曾         |
| 11 | 南京         |
| 21 | 南京2        |
| 31 | 南京3        |
+----+--------------+
7 rows in set (0.00 sec)
```
清空表再来一次

```
mysql> truncate emp;
Query OK, 0 rows affected (0.05 sec)

mysql> insert into emp(name) values("cmz1");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  1 | cmz1 |
+----+------+
1 row in set (0.00 sec)

mysql> insert into emp(name) values("cmz2");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  1 | cmz1 |
| 11 | cmz2 |
+----+------+
2 rows in set (0.00 sec)
```


### 2.4 设置偏移量

```
mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  1 | cmz1 |
| 11 | cmz2 |
+----+------+
2 rows in set (0.00 sec)

mysql> set auto_increment_offset = 5;
Query OK, 0 rows affected (0.00 sec)

mysql>  show variables like 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 10    |
| auto_increment_offset    | 5     |
+--------------------------+-------+
2 rows in set (0.00 sec)

mysql> insert into emp(name) values("cmz3");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  1 | cmz1 |
| 11 | cmz2 |
| 25 | cmz3 |
+----+------+
3 rows in set (0.00 sec)

```
&#160; &#160; &#160; &#160;上面emp表最后一位的id是11。本来要是继续插入数据的话，id应该是11+10=21,
此时又设置了偏移量。所以是25.

&#160; &#160; &#160; &#160;清表重来一次。

```
mysql> truncate emp;
Query OK, 0 rows affected (0.04 sec)

mysql> insert into emp(name) values("cmz1");
Query OK, 1 row affected (0.01 sec)

mysql> insert into emp(name) values("cmz2");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  5 | cmz1 |
| 15 | cmz2 |
+----+------+
2 rows in set (0.00 sec)
```


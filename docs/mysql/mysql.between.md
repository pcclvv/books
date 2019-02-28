<center><h1> MySQL BETWEEN </h1></center>

## 1. 介绍
### 1.1 环境准备

```
drop table info;
create table info(
id int not null primary key auto_increment,
name varchar(20),
age int not null,
score int not null
);
insert into info(name,age,score) values("张三",18,80);
insert into info(name,age,score) values("张三",40,66);
insert into info(name,age,score) values("李四",20,55);
insert into info(name,age,score) values("王五",30,89);
insert into info(name,age,score) values("赵六",40,77);
```
操作过程
```
mysql> drop table info;
Query OK, 0 rows affected (0.03 sec)

mysql> create table info(
    -> id int not null primary key auto_increment,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> insert into info(name,age,score) values("张三",18,80);
Query OK, 1 row affected (0.00 sec)

mysql> insert into info(name,age,score) values("张三",40,66);
Query OK, 1 row affected (0.00 sec)

mysql> insert into info(name,age,score) values("李四",20,55);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,age,score) values("王五",30,89);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,age,score) values("赵六",40,77);
Query OK, 1 row affected (0.00 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)


```

## 2. 开始
### 2.1 语法
&#160; &#160; &#160; &#160;BETWEEN 操作符在 WHERE 子句中使用，作用是选取介于两个值之间的数据范围。这些值可以是数值、文本或者日期。

```
SELECT column_name(s)
FROM table_name
WHERE column_name
BETWEEN value1 AND value2
```


### 2.2 操作
&#160; &#160; &#160; &#160;查询年龄是在20到40之间（前后都包）的人员信息
```
mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

mysql> select * from info where age between 20 and 40;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
4 rows in set (0.00 sec)
```

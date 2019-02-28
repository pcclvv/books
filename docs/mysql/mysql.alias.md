<center><h1> MySQL ALIAS </h1></center>

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
&#160; &#160; &#160; &#160;通过使用 SQL，可以为列名称和表名称指定别名（Alias）。

### 2.1 表alias

```
SELECT column_name(s)
FROM table_name
AS alias_name
```
操作

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

mysql> select name from info as alias_name;
+--------+
| name   |
+--------+
| 张三   |
| 张三   |
| 李四   |
| 王五   |
| 赵六   |
+--------+
5 rows in set (0.00 sec)

```


### 2.2 列alias

```
SELECT column_name AS alias_name
FROM table_name
```
操作，查看以下命令的区别

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

mysql> select name from info;
+--------+
| name   |
+--------+
| 张三   |
| 张三   |
| 李四   |
| 王五   |
| 赵六   |
+--------+
5 rows in set (0.00 sec)

mysql> select name as "姓名" from info;
+--------+
| 姓名   |
+--------+
| 张三   |
| 张三   |
| 李四   |
| 王五   |
| 赵六   |
+--------+
5 rows in set (0.00 sec)
```

&#160; &#160; &#160; &#160; 以上我们看出，as就是起别名，若是没有as就会直接显示之前的字段，使用了as之后，就会显示as之后起的别名也就是上面的姓名。

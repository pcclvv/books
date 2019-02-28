<center><h1> MySQL INSERT </h1></center>

## 1. 介绍
### 1.1 环境准备

```
drop table info;
create table info(
id int not null,
name varchar(20),
age int not null,
score int not null
);
```
操作过程
```
mysql> drop table info;
Query OK, 0 rows affected (0.02 sec)

mysql> create table info(
    -> id int not null,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> desc info;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | NO   |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
| age   | int(11)     | NO   |     | NULL    |       |
| score | int(11)     | NO   |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> select * from info;
Empty set (0.00 sec)

```

## 2. 开始
### 2.1 语法
&#160; &#160; &#160; &#160;INSERT INTO 语句用于向表格中插入新的行

```
INSERT INTO table_name (列1, 列2,...) VALUES (值1, 值2,....)
```
或者
```
INSERT INTO table_name VALUES (值1, 值2,....)
```

### 2.2 操作

```
mysql> insert into info(id,name,age,score) values(1,"张三",18,80);
Query OK, 1 row affected (0.00 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
+----+--------+-----+-------+
1 row in set (0.00 sec)

mysql> insert into info values(2,"李四",20,55);
Query OK, 1 row affected (0.01 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 李四   |  20 |    55 |
+----+--------+-----+-------+
2 rows in set (0.00 sec)

```


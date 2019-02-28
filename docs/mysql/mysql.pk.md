<center><h1> MySQL PRIMARY KEY </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;PRIMARY KEY 约束

- PRIMARY KEY 约束唯一标识数据库表中的每条记录。
- 主键必须包含唯一的值。
- 主键列不能包含 NULL 值。
- 每个表都应该有一个主键，并且每个表只能有一个主键。

## 1. 操作
### 1.1 实例

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

mysql> desc info;
+-------+-------------+------+-----+---------+----------------+
| Field | Type        | Null | Key | Default | Extra          |
+-------+-------------+------+-----+---------+----------------+
| id    | int(11)     | NO   | PRI | NULL    | auto_increment |
| name  | varchar(20) | YES  |     | NULL    |                |
| age   | int(11)     | NO   |     | NULL    |                |
| score | int(11)     | NO   |     | NULL    |                |
+-------+-------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

```
&#160; &#160; &#160; &#160;我们能看到第四列也就是key那一列，只有id是有PRI，有这个PRI就是表示该字段是表的主键。

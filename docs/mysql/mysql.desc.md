<center><h1> MySQL DESC </h1></center>

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
```
操作过程
```
mysql> drop table info;
Query OK, 0 rows affected (0.02 sec)

mysql> create table info(
    -> id int not null primary key auto_increment,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.06 sec)
```

## 2. 开始
### 2.1 语法
&#160; &#160; &#160; &#160;desc 查询表定义

```
desc table_name
```


### 2.2 操作

```
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

- Field:  字段表示的是列名
- Type:   字段表示的是列的数据类型
- Null:   字段表示这个列是否能取空值
- Key:    在mysql中key 和index 是一样的意思，这个Key列可能会看到有如下的值：PRI(主键)、MUL(普通的b-tree索引)、UNI(唯一索引)
- Default: 列的默认值
- Extra:  其它信息，本文是自动增长

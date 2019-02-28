<center><h1> MySQL LIMIT </h1></center>

## 1. 介绍
### 1.1 环境准备

```
truncate leco;

insert into leco(id,name,sex,age) values(1,"张三","female",18);
insert into leco(id,name,sex,age) values(2,"李四","male",20);
insert into leco(id,name,sex,age) values(3,"王五","male",30);
insert into leco(id,name,sex,age) values(4,"赵六","female",40);
```
操作过程
```
mysql> truncate leco;
values(8,"张三4","female",18);Query OK, 0 rows affected (0.04 sec)

mysql>
mysql> insert into leco(id,name,sex,age) values(1,"张三","female",18);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(2,"李四","male",20);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(3,"王五","male",30);
Query OK, 1 row affected (0.02 sec)

mysql> insert into leco(id,name,sex,age) values(4,"赵六","female",40);
Query OK, 1 row affected (0.01 sec)

mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
4 rows in set (0.00 sec)
```


### 1.2 开始
&#160; &#160; &#160; &#160;LIMIT 子句用于规定要返回的记录的数目。

&#160; &#160; &#160; &#160;MySQL 和 Oracle 中的 SQL SELECT TOP 是等价的
```
SELECT column_name(s)
FROM table_name
LIMIT number
```

## 2. Limit 用法

&#160; &#160; &#160; &#160; 以下我们将在 SQL LIMIT 命令中使用 从MySQL数据表 leco 中读取数据。

```
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
4 rows in set (0.00 sec)

mysql> select * from leco limit 2;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    2 | 李四   | male   |   20 |
+------+--------+--------+------+
2 rows in set (0.00 sec)
```

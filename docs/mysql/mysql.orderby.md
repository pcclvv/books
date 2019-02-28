<center><h1> MySQL AND_OR </h1></center>

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
insert into info(id,name,age,score) values(1,"张三",18,80);
insert into info(id,name,age,score) values(4,"张三",40,66);
insert into info(id,name,age,score) values(2,"李四",20,55);
insert into info(id,name,age,score) values(3,"王五",30,89);
insert into info(id,name,age,score) values(4,"赵六",40,77);

```
操作过程
```
mysql> drop table info;
Query OK, 0 rows affected (0.03 sec)

mysql> create table info(
    -> id int not null,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.06 sec)

mysql> insert into info(id,name,age,score) values(1,"张三",18,80);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(id,name,age,score) values(4,"张三",40,66);
Query OK, 1 row affected (0.00 sec)

mysql> insert into info(id,name,age,score) values(2,"李四",20,55);
Query OK, 1 row affected (0.03 sec)

mysql> insert into info(id,name,age,score) values(3,"王五",30,89);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(id,name,age,score) values(4,"赵六",40,77);
Query OK, 1 row affected (0.00 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  4 | 张三   |  40 |    66 |
|  2 | 李四   |  20 |    55 |
|  3 | 王五   |  30 |    89 |
|  4 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)
```


### 1.2 开始
&#160; &#160; &#160; &#160;ORDER BY 语句用于对结果集进行排序。

- ORDER BY 语句用于根据指定的列对结果集进行排序。
- ORDER BY 语句默认按照升序对记录进行排序。
- 如果您希望按照降序对记录进行排序，可以使用 DESC 关键字。
 

```
SELECT column1, column2, ... FROM table_name
ORDER BY column1, column2, ... ASC|DESC;
```


## 2. 用法

&#160; &#160; &#160; &#160; 以下我们将在 SQL AND_OR 命令中使用 从MySQL数据表 leco 中读取数据。

### 2.1 升序

&#160; &#160; &#160; &#160;  在leco表中找出分数升序排列
```
mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  4 | 张三   |  40 |    66 |
|  2 | 李四   |  20 |    55 |
|  3 | 王五   |  30 |    89 |
|  4 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

mysql> select * from info order by score;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  2 | 李四   |  20 |    55 |
|  4 | 张三   |  40 |    66 |
|  4 | 赵六   |  40 |    77 |
|  1 | 张三   |  18 |    80 |
|  3 | 王五   |  30 |    89 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

或者
mysql> select * from info order by score asc;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  2 | 李四   |  20 |    55 |
|  4 | 张三   |  40 |    66 |
|  4 | 赵六   |  40 |    77 |
|  1 | 张三   |  18 |    80 |
|  3 | 王五   |  30 |    89 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)


```

### 2.1 降序

&#160; &#160; &#160; &#160;  在leco表中找出分数降序排列
```
mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  4 | 张三   |  40 |    66 |
|  2 | 李四   |  20 |    55 |
|  3 | 王五   |  30 |    89 |
|  4 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

mysql> select * from info order by score desc;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  3 | 王五   |  30 |    89 |
|  1 | 张三   |  18 |    80 |
|  4 | 赵六   |  40 |    77 |
|  4 | 张三   |  40 |    66 |
|  2 | 李四   |  20 |    55 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)
```

### 2.3 多条件结合 

&#160; &#160; &#160; &#160; 分数升序后年龄降序
```
mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  4 | 张三   |  40 |    66 |
|  2 | 李四   |  20 |    55 |
|  3 | 王五   |  30 |    89 |
|  4 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

mysql> select * from info order by score;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  2 | 李四   |  20 |    55 |
|  4 | 张三   |  40 |    66 |
|  4 | 赵六   |  40 |    77 |
|  1 | 张三   |  18 |    80 |
|  3 | 王五   |  30 |    89 |
+----+--------+-----+-------+
5 rows in set (0.01 sec)

mysql> select * from info order by score, age desc;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  2 | 李四   |  20 |    55 |
|  4 | 张三   |  40 |    66 |
|  4 | 赵六   |  40 |    77 |
|  1 | 张三   |  18 |    80 |
|  3 | 王五   |  30 |    89 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

```


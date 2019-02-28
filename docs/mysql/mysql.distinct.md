<center><h1> MySQL DISTINCT </h1></center>

## 1. 介绍
### 1.1 环境准备

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

mysql> insert into leco(id,name,sex,age) values(5,"张三","female",18);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(6,"张三","female",18);
Query OK, 1 row affected (0.00 sec)

mysql> insert into leco(id,name,sex,age) values(7,"张三","female",18);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(8,"张三","female",18);
Query OK, 1 row affected (0.00 sec)

mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
|    5 | 张三   | female |   18 |
|    6 | 张三   | female |   18 |
|    7 | 张三   | female |   18 |
|    8 | 张三   | female |   18 |
+------+--------+--------+------+
8 rows in set (0.00 sec)
```


### 1.2 开始
&#160; &#160; &#160; &#160;distinct一般是用来去除查询结果中的重复记录的，而且这个语句在select、insert、delete和update中只可以在select中使用，具体的语法如下。

&#160; &#160; &#160; &#160;以下是 SQL SELECT 语句使用 distinct 子句从数据表中读取数据的通用语法：

```
select distinct expression[,expression...] from tables [where conditions];
```

## 2. DISTINCT 用法

&#160; &#160; &#160; &#160; 以下我们将在 SQL SELECT 命令中使用 DISTINCT子句来从MySQL数据表 leco 中读取数据。

```
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
|    5 | 张三   | female |   18 |
|    6 | 张三   | female |   18 |
|    7 | 张三   | female |   18 |
|    8 | 张三   | female |   18 |
+------+--------+--------+------+
8 rows in set (0.00 sec)

mysql> select DISTINCT name from leco;
+--------+
| name   |
+--------+
| 张三   |
| 李四   |
| 王五   |
| 赵六   |
+--------+
4 rows in set (0.00 sec)

mysql> select name from leco;
+--------+
| name   |
+--------+
| 张三   |
| 李四   |
| 王五   |
| 赵六   |
| 张三   |
| 张三   |
| 张三   |
| 张三   |
+--------+
8 rows in set (0.00 sec)
```
&#160; &#160; &#160; &#160; 从上例中可以发现，当distinct应用到多个字段的时候，其应用的范围是其后面的所有字段，而不只是紧挨着它的一个字段，而且distinct只能放到所有字段的前面，如下语句是错误的：

```
mysql> select id,DISTINCT name from leco;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'DISTINCT name from leco' at line 1
```
&#160; &#160; &#160; &#160;而以下是对的

```
mysql> select DISTINCT id,name from leco;
+------+--------+
| id   | name   |
+------+--------+
|    1 | 张三   |
|    2 | 李四   |
|    3 | 王五   |
|    4 | 赵六   |
|    5 | 张三   |
|    6 | 张三   |
|    7 | 张三   |
|    8 | 张三   |
+------+--------+
8 rows in set (0.00 sec)

```

!!! note "注意"
    ```python
    再次强调，distinct 是作用于整条查询，而不是作用于紧跟其后的字段。
    ```


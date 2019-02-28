<center><h1> MySQL AND_OR </h1></center>

## 1. 介绍
### 1.1 环境准备

```
truncate leco;

insert into leco(id,name,sex,age) values(1,"张三","female",18);
insert into leco(id,name,sex,age) values(4,"张三","male",40);
insert into leco(id,name,sex,age) values(2,"李四","male",20);
insert into leco(id,name,sex,age) values(3,"王五","male",30);
insert into leco(id,name,sex,age) values(4,"赵六","female",40);
```
操作过程
```
mysql> truncate leco;
Query OK, 0 rows affected (0.04 sec)

mysql> insert into leco(id,name,sex,age) values(1,"张三","female",18);
Query OK, 1 row affected (0.00 sec)

mysql> insert into leco(id,name,sex,age) values(4,"张三","male",40);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(2,"李四","male",20);
Query OK, 1 row affected (0.02 sec)

mysql> insert into leco(id,name,sex,age) values(3,"王五","male",30);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(4,"赵六","female",40);
Query OK, 1 row affected (0.01 sec)

mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    4 | 张三   | male   |   40 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
5 rows in set (0.00 sec)

```


### 1.2 开始
&#160; &#160; &#160; &#160;AND 和 OR 运算符用于基于一个以上的条件对记录进行过滤。

&#160; &#160; &#160; &#160;AND 和 OR 运算符

- AND 和 OR 可在 WHERE 子语句中把两个或多个条件结合起来。
- 如果第一个条件和第二个条件都成立，则 AND 运算符显示一条记录。
- 如果第一个条件和第二个条件中只要有一个成立，则 OR 运算符显示一条记录。
 


## 2. 用法

&#160; &#160; &#160; &#160; 以下我们将在 SQL AND_OR 命令中使用 从MySQL数据表 leco 中读取数据。

### 2.1 AND 

&#160; &#160; &#160; &#160;  在leco表中找出name是张三且sex是male的信息
```
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    4 | 张三   | male   |   40 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
5 rows in set (0.00 sec)

mysql> select * from leco where name = "张三" and sex = 'male';
+------+--------+------+------+
| id   | name   | sex  | age  |
+------+--------+------+------+
|    4 | 张三   | male |   40 |
+------+--------+------+------+
1 row in set (0.00 sec)

```

### 2.2 OR
&#160; &#160; &#160; &#160;  在leco表中找出name是张三或者name是李四的人信息
```
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    4 | 张三   | male   |   40 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
5 rows in set (0.00 sec)

mysql> select * from leco where name = "张三" or name= '李四';
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    4 | 张三   | male   |   40 |
|    2 | 李四   | male   |   20 |
+------+--------+--------+------+
3 rows in set (0.00 sec)
```

### 2.3 结合 AND 和 OR 运算符

&#160; &#160; &#160; &#160; 找出年龄是18岁或者20岁，且sex是female的人员信息
```
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    4 | 张三   | male   |   40 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
5 rows in set (0.00 sec)

mysql> select * from leco where (age=18 or age=20) and sex='female';
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
+------+--------+--------+------+
1 row in set (0.01 sec)

```

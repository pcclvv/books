<center><h1> MySQL LIKE </h1></center>

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

mysql>
mysql> insert into leco(id,name,sex,age) values(5,"张三1","female",18);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(6,"张三2","female",18);
Query OK, 1 row affected (0.00 sec)

mysql> insert into leco(id,name,sex,age) values(7,"张三3","female",18);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(8,"张三4","female",18);
Query OK, 1 row affected (0.00 sec)

mysql> select * from leco;
+------+---------+--------+------+
| id   | name    | sex    | age  |
+------+---------+--------+------+
|    1 | 张三    | female |   18 |
|    2 | 李四    | male   |   20 |
|    3 | 王五    | male   |   30 |
|    4 | 赵六    | female |   40 |
|    5 | 张三1   | female |   18 |
|    6 | 张三2   | female |   18 |
|    7 | 张三3   | female |   18 |
|    8 | 张三4   | female |   18 |
+------+---------+--------+------+
8 rows in set (0.00 sec)
```


### 1.2 开始
&#160; &#160; &#160; &#160;我们知道在 MySQL 中使用 SQL SELECT 命令来读取数据， 同时我们可以在 SELECT 语句中使用 WHERE 子句来获取指定的记录。WHERE 子句中可以使用等号 = 来设定获取数据的条件，如 "name = '张三'"。但是有时候我们需要获取 leco 字段含有 "张三" 字符的所有记录，这时我们就需要在 WHERE 子句中使用 SQL LIKE 子句。SQL LIKE 子句中使用百分号 %字符来表示任意字符，类似于UNIX或正则表达式中的星号 *。如果没有使用百分号 %, LIKE 子句与等号 = 的效果是一样的。

&#160; &#160; &#160; &#160;以下是 SQL SELECT 语句使用 LIKE 子句从数据表中读取数据的通用语法：

```
SELECT field1, field2,...fieldN 
FROM table_name
WHERE field1 LIKE condition1 [AND [OR]] filed2 = 'somevalue'
```

- 你可以在 WHERE 子句中指定任何条件。
- 你可以在 WHERE 子句中使用LIKE子句。
- 你可以使用LIKE子句代替等号 =。
- LIKE 通常与 % 一同使用，类似于一个元字符的搜索。
- 你可以使用 AND 或者 OR 指定一个或多个条件。
- 你可以在 DELETE 或 UPDATE 命令中使用 WHERE...LIKE 子句来指定条件。

> 当你想删除数据表中指定的记录时 WHERE 子句是非常有用的。



## 2. like 用法

&#160; &#160; &#160; &#160; 以下我们将在 SQL SELECT 命令中使用 WHERE...LIKE 子句来从MySQL数据表 leco 中读取数据。

```
mysql> select * from leco;
+------+---------+--------+------+
| id   | name    | sex    | age  |
+------+---------+--------+------+
|    1 | 张三    | female |   18 |
|    2 | 李四    | male   |   20 |
|    3 | 王五    | male   |   30 |
|    4 | 赵六    | female |   40 |
|    5 | 张三1   | female |   18 |
|    6 | 张三2   | female |   18 |
|    7 | 张三3   | female |   18 |
|    8 | 张三4   | female |   18 |
+------+---------+--------+------+
8 rows in set (0.00 sec)

mysql> select * from leco where name like '%张三';
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
+------+--------+--------+------+
1 row in set (0.00 sec)

mysql> select * from leco where name like '张三%';
+------+---------+--------+------+
| id   | name    | sex    | age  |
+------+---------+--------+------+
|    1 | 张三    | female |   18 |
|    5 | 张三1   | female |   18 |
|    6 | 张三2   | female |   18 |
|    7 | 张三3   | female |   18 |
|    8 | 张三4   | female |   18 |
+------+---------+--------+------+
5 rows in set (0.01 sec)

```

## 3. 匹配
### 3.1 匹配位
&#160; &#160; &#160; &#160; like 匹配/模糊匹配，会与 % 和 _ 结合使用。

```
％ - 百分号表示零个，一个或多个字符
_ - 下划线表示单个字符
```


运算符 | 描述
---|---
'%a'  |   以a结尾的数据
'a%'  |   以a开头的数据
'%a%' |   含有a的数据
'_a_' |   三位且中间字母是a的
'_a'  |   两位且结尾字母是a的
'a_'  |   两位且开头字母是a的

### 3.2 例子

```
查询以 张三 字段开头的信息。
SELECT * FROM leco WHERE name LIKE '张三%';

查询包含 张三 字段的信息。
SELECT * FROM leco WHERE name LIKE '%张三%';

查询以 张三 字段结尾的信息。
SELECT * FROM leco WHERE name LIKE '%张三';
```


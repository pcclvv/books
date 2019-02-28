<center><h1> MySQL delete </h1></center>

## 1. 介绍

&#160; &#160; &#160; &#160;你可以使用 SQL 的 DELETE FROM 命令来==删除 MySQL 数据表中的记录==。

&#160; &#160; &#160; &#160;你可以在 mysql> 命令提示符执行该命令。以下是 SQL DELETE 语句从 MySQL 数据表中删除数据的通用语法：

```
DELETE FROM table_name [WHERE Clause]
```

- 如果没有指定 WHERE 子句，MySQL 表中的所有记录将被删除。
- 你可以在 WHERE 子句中指定任何条件
- 您可以在单个表中一次性删除记录。

> 当你想删除数据表中指定的记录时 WHERE 子句是非常有用的。

??? danger "注意"
    ```python
    删除表格中的记录时要小心！
    注意SQL DELETE 语句中的 WHERE 子句！
    WHERE子句指定需要删除哪些记录。如果省略了WHERE子句，表中所有记录都将被删除！
    ```


## 2. delete 用法

&#160; &#160; &#160; &#160;delete 语句用于从表中删除数据。

### 2.1 删除部分
快捷命令

```
select * from leco;
delete from leco where id=1;
select * from leco;
delete from leco where name = "赵六";
select * from leco;
```
操作过程

```
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   20 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   20 |
|    4 | 赵六   | female |   20 |
+------+--------+--------+------+
4 rows in set (0.00 sec)

mysql> delete from leco where id=1;
Query OK, 1 row affected (0.01 sec)

mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   20 |
|    4 | 赵六   | female |   20 |
+------+--------+--------+------+
3 rows in set (0.00 sec)

mysql> delete from leco where name = "赵六";
Query OK, 1 row affected (0.00 sec)

mysql> select * from leco;
+------+--------+------+------+
| id   | name   | sex  | age  |
+------+--------+------+------+
|    2 | 李四   | male |   20 |
|    3 | 王五   | male |   20 |
+------+--------+------+------+
2 rows in set (0.00 sec)
```



### 2.2 清空表
#### 2.2.1 delete

快捷命令
```
insert into leco(id,name,sex,age) values(1,"张三","female",18);
insert into leco(id,name,sex,age) values(2,"李四","male",20);
insert into leco(id,name,sex,age) values(3,"王五","male",30);
insert into leco(id,name,sex,age) values(4,"赵六","female",40);
delete from leco;
```
操作过程
```
mysql> select * from leco;
+------+--------+------+------+
| id   | name   | sex  | age  |
+------+--------+------+------+
|    2 | 李四   | male |   20 |
|    3 | 王五   | male |   20 |
+------+--------+------+------+
2 rows in set (0.00 sec)

mysql> delete from leco;
Query OK, 2 rows affected (0.00 sec)

mysql> select * from leco;
Empty set (0.00 sec)

```


#### 2.2.2  truncate

```
truncate table_name;
```
例子

```
mysql> insert into leco(id,name,sex,age) values(1,"张三","female",18);
Query OK, 1 row affected (0.00 sec)

mysql> insert into leco(id,name,sex,age) values(2,"李四","male",20);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(3,"王五","male",30);
Query OK, 1 row affected (0.03 sec)

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

mysql> truncate leco;
Query OK, 0 rows affected (0.04 sec)

mysql> select * from leco;
Empty set (0.00 sec)
```

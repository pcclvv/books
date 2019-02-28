<center><h1> MySQL 表操作 </h1></center>

## 1. 介绍

&#160; &#160; &#160; &#160;创建MySQL数据表需要以下信息

- 表名
- 表字段名
- 定义每个表字段

## 2. 创建表语法

&#160; &#160; &#160; &#160;以下为创建MySQL数据表的SQL通用语法：

```
create table 表名(
字段名1 类型[(宽度) 约束条件],
字段名2 类型[(宽度) 约束条件],
字段名3 类型[(宽度) 约束条件]
);
```

??? tip "注意"
    ```python
    1. 在同一张表中，字段名是不能相同
    2. 宽度和约束条件可选
    3. 字段名和类型是必须的
    ```


### 2.1 创建表的例子
&#160; &#160; &#160; &#160;以下例子中我们将在 cmz 数据库中创建数据表leco：
```
create table leco( 
id int, 
name varchar(50), 
sex enum('male','female'), 
age int(3)
)engine=innodb default charset=utf8;
```

操作过程
```
mysql> create database cmz charset utf8;
Query OK, 1 row affected (0.00 sec)

mysql> use cmz
Database changed

mysql> create table leco(
    -> id int,
    -> name varchar(50),
    -> sex enum('male','female'),
    -> age int(3)
    -> )ENGINE=InnoDB DEFAULT CHARSET=utf8;;
Query OK, 0 rows affected (0.06 sec)

ERROR:
No query specified

mysql> show tables;
+---------------+
| Tables_in_cmz |
+---------------+
| leco          |
+---------------+
1 row in set (0.00 sec)

```

## 2. 查看表

&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 show tables 命令查看表，语法如下:

```
SHOW TABLES;
```

操作过程

```
mysql> show tables;
ERROR 1046 (3D000): No database selected
mysql> use cmz;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------+
| Tables_in_cmz |
+---------------+
| leco          |
+---------------+
1 row in set (0.00 sec)
```

??? tip "注意"
    ```python
    1. 一定要先选择数据库，然后查看数据库中的所有表
    2. 宽度和约束条件可选
    3. 字段名和类型是必须的
    ```


## 3. 查看数据库表字段

&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 DESC 命令查看表中字段，语法如下:

```
DESC TABLE_NAME
```
操作过程
```
mysql> desc leco;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
```

## 4. 插入数据
&#160; &#160; &#160; &#160;MySQL 表中使用 INSERT INTO SQL语句来插入数据，语法如下。

```
INSERT INTO table_name ( field1, field2,...fieldN )
                       VALUES
                       ( value1, value2,...valueN );
```

> 如果数据是字符型，必须使用单引号或者双引号，如："value"。


```
mysql> insert into leco(id,name,sex,age) values(1,"张三","female",18);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(2,"李四","male",20);
Query OK, 1 row affected (0.01 sec)

mysql> insert into leco(id,name,sex,age) values(3,"王五","male",30);
Query OK, 1 row affected (0.02 sec)

mysql> insert into leco(id,name,sex,age) values(4,"赵六","female",40);
Query OK, 1 row affected (0.00 sec)

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


## 4. 查看数据
&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 select 命令查看数据，语法如下:

```
SELECT column_name,column_name
FROM table_name
[WHERE Clause]
[LIMIT N][ OFFSET M]
```

- 查询语句中你可以使用一个或者多个表，表之间使用逗号(,)分割，并使用WHERE语句来设定查询条件。
- SELECT 命令可以读取一条或者多条记录。
- 可以使用星号（*）来代替其他字段，SELECT语句会返回表的所有字段数据
- 可以使用 WHERE 语句来包含任何条件。
- 可以使用 LIMIT 属性来设定返回的记录数。
- 可以通过OFFSET指定SELECT语句开始查询的数据偏移量。默认情况下偏移量为0。

操作过程

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

mysql> select id,name from leco;
+------+--------+
| id   | name   |
+------+--------+
|    1 | 张三   |
|    2 | 李四   |
|    3 | 王五   |
|    4 | 赵六   |
+------+--------+
4 rows in set (0.00 sec)
```


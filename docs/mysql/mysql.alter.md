<center><h1> MySQL ALTER</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;	当我们需要修改数据表名或者修改数据表字段时，就需要使用到MySQL ALTER命令。


```
1. 修改表名
      ALTER TABLE 表名 
                          RENAME 新表名;

2. 增加字段
      ALTER TABLE 表名
                          ADD 字段名  数据类型 [完整性约束条件…],
                          ADD 字段名  数据类型 [完整性约束条件…];
      ALTER TABLE 表名
                          ADD 字段名  数据类型 [完整性约束条件…]  FIRST;
      ALTER TABLE 表名
                          ADD 字段名  数据类型 [完整性约束条件…]  AFTER 字段名;

3. 删除字段
      ALTER TABLE 表名 
                          DROP 字段名;

4. 修改字段
      ALTER TABLE 表名 
                          MODIFY  字段名 数据类型 [完整性约束条件…];
      ALTER TABLE 表名 
                          CHANGE 旧字段名 新字段名 旧数据类型 [完整性约束条件…];
      ALTER TABLE 表名 
                          CHANGE 旧字段名 新字段名 新数据类型 [完整性约束条件…];
```
## 2. 环境准备
快速命令

```
create database db1 charset utf8;
use db1;
create table t1( id int, name varchar(50), sex enum('male','female'), age int(3));
desc t1; 
insert into t1 values(1,"小明","male",18),(2,"小红",'female',20),(3,"小强","male",30),(4,"张三","female",28);
select * from t1;
show create table t1\G; 
```

执行过程
```
root@leco:/home/leco# mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 67
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> create database db1 charset utf8;
ERROR 1007 (HY000): Can't create database 'db1'; database exists
mysql> use db1;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> create table t1( id int, name varchar(50), sex enum('male','female'), age int(3));
ERROR 1050 (42S01): Table 't1' already exists
mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> insert into t1 values(1,"小明","male",18),(2,"小红",'female',20),(3,"小强","male",30),(4,"张三","female",28);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> select * from t1;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 小明   | male   |   18 |
|    2 | 小红   | female |   20 |
|    3 | 小强   | male   |   30 |
|    4 | 张三   | female |   28 |
+------+--------+--------+------+
4 rows in set (0.00 sec)

mysql> show create table t1\G;
*************************** 1. row ***************************
       Table: t1
Create Table: CREATE TABLE `t1` (
  `id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `sex` enum('male','female') DEFAULT NULL,
  `age` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
1 row in set (0.00 sec)

ERROR:
No query specified
```

## 3. 用法
### 3.1 修改表名
语法

```
修改表名
      ALTER TABLE 表名 
                          RENAME 新表名;
```
操作

```
mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| t1            |
+---------------+
1 row in set (0.00 sec)

mysql> alter table  t1 rename info;
Query OK, 0 rows affected (0.04 sec)

mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| info          |
+---------------+
1 row in set (0.00 sec)
```

### 3.2 增加字段
语法

```
ALTER TABLE 表名
                    ADD 字段名  数据类型 [完整性约束条件…],

ALTER TABLE 表名
                    ADD 字段名  数据类型 [完整性约束条件…]  FIRST;
ALTER TABLE 表名
                    ADD 字段名  数据类型 [完整性约束条件…]  AFTER字段名;
```
操作

```
mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| info          |
+---------------+
1 row in set (0.00 sec)

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> alter table info add hobby varchar(50);
Query OK, 0 rows affected (0.15 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

mysql> alter table info add addr varchar(50) first;
Query OK, 0 rows affected (0.15 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| addr  | varchar(50)           | YES  |     | NULL    |       |
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
6 rows in set (0.00 sec)

mysql> alter table info add job varchar(50) after age;
Query OK, 0 rows affected (0.16 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| addr  | varchar(50)           | YES  |     | NULL    |       |
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
7 rows in set (0.00 sec)
```

!!! note "注解"
    ```python
    1. 默认添加的字段都是插入到最后
    2. 我们可以通过after，指定要插入的字段在什么位置
    3. frst是插入到第一个位置
    ```
    
### 3.3 删除字段
语法

```
ALTER TABLE 表名 
                          DROP 字段名;
```
操作

```
mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| addr  | varchar(50)           | YES  |     | NULL    |       |
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
7 rows in set (0.00 sec)

mysql> alter table info drop addr;
Query OK, 0 rows affected (0.16 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
6 rows in set (0.00 sec)
```


!!! danger "注意"
    ```python
    谨慎删除字段，因为删除字段后。表中对应的数据也会被删除，请看以下操作。
    ```
    
```
mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
6 rows in set (0.00 sec)

mysql> select * from info;
+------+--------+--------+------+------+-------+
| id   | name   | sex    | age  | job  | hobby |
+------+--------+--------+------+------+-------+
|    1 | 小明   | male   |   18 | NULL | NULL  |
|    2 | 小红   | female |   20 | NULL | NULL  |
|    3 | 小强   | male   |   30 | NULL | NULL  |
|    4 | 张三   | female |   28 | NULL | NULL  |
+------+--------+--------+------+------+-------+
4 rows in set (0.00 sec)

mysql> alter table info drop age;
Query OK, 0 rows affected (0.15 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

mysql> select * from info;
+------+--------+--------+------+-------+
| id   | name   | sex    | job  | hobby |
+------+--------+--------+------+-------+
|    1 | 小明   | male   | NULL | NULL  |
|    2 | 小红   | female | NULL | NULL  |
|    3 | 小强   | male   | NULL | NULL  |
|    4 | 张三   | female | NULL | NULL  |
+------+--------+--------+------+-------+
4 rows in set (0.00 sec)
```

### 3.4 修改字段
语法
```
ALTER TABLE 表名 
                    MODIFY  字段名 数据类型 [完整性约束条件…];
ALTER TABLE 表名 
                    CHANGE 旧字段名 新字段名 旧数据类型 [完整性约束条件…];
ALTER TABLE 表名 
                    CHANGE 旧字段名 新字段名 新数据类型[完整性约束条件…];
```
操作

```
mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
mysql> alter table info modify id int not null;
Query OK, 0 rows affected (0.16 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)


---------------------------------------------------------------
mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

mysql> alter table info change id my_id int not null;
Query OK, 0 rows affected (0.03 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| my_id | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

---------------------------------------------------------------
mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| my_id | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.01 sec)

mysql> alter table info change my_id my_id  bigint not null;
Query OK, 8 rows affected (0.17 sec)
Records: 8  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| my_id | bigint(20)            | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

mysql> alter table info change my_id id int not null;
Query OK, 8 rows affected (0.17 sec)
Records: 8  Duplicates: 0  Warnings: 0

mysql> desc info;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| job   | varchar(50)           | YES  |     | NULL    |       |
| hobby | varchar(50)           | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
5 rows in set (0.00 sec)

```

## 4. 其他用法
### 4.1 增加主键
先恢复表结构[删除重新建]
```
mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> alter table t1 modify id int(11) not null primary key auto_increment;
Query OK, 4 rows affected (0.17 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> desc info;
ERROR 1146 (42S02): Table 'db1.info' doesn't exist
mysql> desc t1;
+-------+-----------------------+------+-----+---------+----------------+
| Field | Type                  | Null | Key | Default | Extra          |
+-------+-----------------------+------+-----+---------+----------------+
| id    | int(11)               | NO   | PRI | NULL    | auto_increment |
| name  | varchar(50)           | YES  |     | NULL    |                |
| sex   | enum('male','female') | YES  |     | NULL    |                |
| age   | int(3)                | YES  |     | NULL    |                |
+-------+-----------------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)
```
或者

```
mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> alter table t1 add primary key(id);     # 推荐写法
Query OK, 0 rows affected (0.16 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   | PRI | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

```

### 4.2 删除主键
先恢复表结构[删除重新建]

```
mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   | PRI | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> alter table t1 drop primary key;
Query OK, 4 rows affected (0.17 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
```

### 4.3 增加复合主键

```
mysql> alter table t1 drop primary key;
Query OK, 4 rows affected (0.17 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | YES  |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

mysql> alter table t1 add primary key(id,name);
Query OK, 0 rows affected (0.15 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   | PRI | NULL    |       |
| name  | varchar(50)           | NO   | PRI | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)

```

### 4.4 删除复合主键
和删除单一主键一样

```
mysql> alter table t1 drop primary key;
Query OK, 4 rows affected (0.17 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> desc t1;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | NO   |     | NULL    |       |
| name  | varchar(50)           | NO   |     | NULL    |       |
| sex   | enum('male','female') | YES  |     | NULL    |       |
| age   | int(3)                | YES  |     | NULL    |       |
+-------+-----------------------+------+-----+---------+-------+
4 rows in set (0.00 sec)
```


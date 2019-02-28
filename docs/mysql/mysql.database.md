<center><h1> MySQL 库操作 </h1></center>

## 1. 创建数据库

&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 create 命令创建数据库，语法如下:


```
CREATE DATABASE 数据库名;
```

操作过程
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db1                |
| leco               |
| mysql              |
| performance_schema |
| prv_app_scbxy      |
| qiushibaike        |
| s12day113          |
| sys                |
+--------------------+
9 rows in set (0.00 sec)

mysql> create database cmz;
Query OK, 1 row affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| cmz                |
| db1                |
| leco               |
| mysql              |
| performance_schema |
| prv_app_scbxy      |
| qiushibaike        |
| s12day113          |
| sys                |
+--------------------+
10 rows in set (0.00 sec)

```

## 2. 查看数据库

&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 show 命令查看数据库，语法如下:

```
SHOW DATABASES;
```

操作过程

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| cmz                |
| db1                |
| leco               |
| mysql              |
| performance_schema |
| prv_app_scbxy      |
| qiushibaike        |
| s12day113          |
| sys                |
+--------------------+
10 rows in set (0.00 sec)
```

## 3. 选择数据库

&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 use 命令选择数据库，语法如下:

```
USE DATABASENAME;
```
操作过程
```
mysql> use leco;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+----------------+
| Tables_in_leco |
+----------------+
| innodb_t1      |
| innodb_t2      |
| t1             |
| t2             |
| t3             |
| t4             |
| tb_dept        |
+----------------+
7 rows in set (0.00 sec)

mysql> use cmz;
Database changed
mysql> show tables;
Empty set (0.00 sec)
```


## 4. 删除数据库
&#160; &#160; &#160; &#160;我们可以在登陆 MySQL 服务后，使用 drop 命令选择数据库，语法如下:

```
drop database <数据库名>;
```
操作过程

```
mysql> show tables;
Empty set (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| cmz                |
| db1                |
| leco               |
| mysql              |
| performance_schema |
| prv_app_scbxy      |
| qiushibaike        |
| s12day113          |
| sys                |
+--------------------+
10 rows in set (0.00 sec)

mysql> drop database cmz;
Query OK, 0 rows affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db1                |
| leco               |
| mysql              |
| performance_schema |
| prv_app_scbxy      |
| qiushibaike        |
| s12day113          |
| sys                |
+--------------------+
9 rows in set (0.00 sec)
```


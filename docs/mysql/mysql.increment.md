<center><h1> MySQL AUTO INCREMENT </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;Auto-increment 会在新记录插入表中时生成一个唯一的数字。

&#160; &#160; &#160; &#160;我们通常希望在每次插入新记录时自动创建主键字段的值。我们可以在表中创建一个自动增量（auto-increment）字段。

## 1. 操作
### 1.1 不设置字段id
以下SQL语句将info表中的id列定义为自动递增（auto-increment）主键字段：
```
drop table info;
create table info(
id int not null primary key auto_increment,
name varchar(20),
age int not null,
score int not null
);
insert into info(name,age,score) values("张三",18,80);
insert into info(name,age,score) values("张三",40,66);
insert into info(name,age,score) values("李四",20,55);
insert into info(name,age,score) values("王五",30,89);
insert into info(name,age,score) values("赵六",40,77);
```
操作过程
```
mysql> drop table info;
Query OK, 0 rows affected (0.03 sec)

mysql> create table info(
    -> id int not null primary key auto_increment,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> insert into info(name,age,score) values("张三",18,80);
Query OK, 1 row affected (0.00 sec)

mysql> insert into info(name,age,score) values("张三",40,66);
Query OK, 1 row affected (0.00 sec)

mysql> insert into info(name,age,score) values("李四",20,55);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,age,score) values("王五",30,89);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,age,score) values("赵六",40,77);
Query OK, 1 row affected (0.00 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

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

&#160; &#160; &#160; &#160;我们能看到第6列也就是Extra那一列，只有id是有auto_increment，有这个auto_increment就是表示该字段是表字段，insert的时候可以不设置。不设置的话，每次步长是根据mysql的配置字段配置。默认是1.

#### 1.1.1 临时修改步长
```
mysql> SHOW VARIABLES LIKE 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 1     |  # 查看步长
| auto_increment_offset    | 1     |
+--------------------------+-------+
2 rows in set (0.01 sec)
```
配置自增步长，数据表自增将以10为间隔自增。

```
mysql> SET @@auto_increment_increment=10;
Query OK, 0 rows affected (0.00 sec)

mysql> SHOW VARIABLES LIKE 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 10    |  # 步长被设置了10，也就是每次插入的数据的时候，都会别前一个id的基础上加上这个步长10
| auto_increment_offset    | 1     |
+--------------------------+-------+
2 rows in set (0.00 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
+----+--------+-----+-------+
5 rows in set (0.00 sec)

mysql> insert into info(name,age,score) values("刘七",30,66);
Query OK, 1 row affected (0.00 sec)

mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
| 11 | 刘七   |  30 |    66 |
+----+--------+-----+-------+
6 rows in set (0.00 sec)

```

&#160; &#160; &#160; &#160;如果以上方法还不生效，或者重启mysql后，又变回来了。那肯定是在my.cnf里面设置了全局变量。这个必须到配置文件里面去修改了；这种修改永久有效。而且无法通过上面的操作再次被修改。

#### 1.1.2 永久修改步长
&#160; &#160; &#160; &#160;修改配置文件重启mysql

```
root@leco:/etc/mysql/mysql.conf.d# pwd
/etc/mysql/mysql.conf.d
root@leco:/etc/mysql/mysql.conf.d# egrep -v '#|^$' mysqld.cnf
[mysqld_safe]
socket		= /var/run/mysqld/mysqld.sock
nice		= 0
[mysqld]
user		= mysql
pid-file	= /var/run/mysqld/mysqld.pid
socket		= /var/run/mysqld/mysqld.sock
port		= 3306
basedir		= /usr
datadir		= /var/lib/mysql
tmpdir		= /tmp
lc-messages-dir	= /usr/share/mysql
skip-external-locking
auto_increment_increment = 2
key_buffer_size		= 16M
max_allowed_packet	= 16M
thread_stack		= 192K
thread_cache_size       = 8
myisam-recover-options  = BACKUP
query_cache_limit	= 1M
query_cache_size        = 16M
log_error = /var/log/mysql/error.log
expire_logs_days	= 10
max_binlog_size   = 100M
[mysql]
auto-rehash

# 重启
root@leco:/etc/mysql/mysql.conf.d# /etc/init.d/mysql restart
[ ok ] Restarting mysql (via systemctl): mysql.service.
```

!!! tip "注意"
    ```python
    1. 一点要找到mysql的配置，不同版本的mysql。配置文件路径稍微有点不同
    2. 在配置文件中的mysqld下配置
    3. 配置完毕后重启mysql
    ```

测试

```
mysql> select * from info;
+----+--------+-----+-------+
| id | name   | age | score |
+----+--------+-----+-------+
|  1 | 张三   |  18 |    80 |
|  2 | 张三   |  40 |    66 |
|  3 | 李四   |  20 |    55 |
|  4 | 王五   |  30 |    89 |
|  5 | 赵六   |  40 |    77 |
| 11 | 刘七   |  30 |    66 |
+----+--------+-----+-------+
6 rows in set (0.00 sec)

mysql> insert into info(name,age,score) values("葛大爷",30,66);
Query OK, 1 row affected (0.01 sec)

mysql> select * from info;
+----+-----------+-----+-------+
| id | name      | age | score |
+----+-----------+-----+-------+
|  1 | 张三      |  18 |    80 |
|  2 | 张三      |  40 |    66 |
|  3 | 李四      |  20 |    55 |
|  4 | 王五      |  30 |    89 |
|  5 | 赵六      |  40 |    77 |
| 11 | 刘七      |  30 |    66 |
| 13 | 葛大爷    |  30 |    66 |
+----+-----------+-----+-------+
7 rows in set (0.00 sec)
```
&#160; &#160; &#160; &#160;从结果来看，我新增的葛大爷的id是在六七的id=11的基础上加配置文件配置的步长2 也就是等于13，完美。


### 1.2 设置自增id

```
drop table info;
create table info(
id int not null primary key auto_increment,
name varchar(20),
age int not null,
score int not null
);
insert into info(name,age,score) values("张三",18,80);
insert into info(name,age,score) values("张三",40,66);
insert into info(name,age,score) values("李四",20,55);
insert into info(id,name,age,score) values(100,"王五",30,89);
insert into info(name,age,score) values("赵六",40,77);
```

&#160; &#160; &#160; &#160; 还原mysql的步长，也就是在配置文件中去掉那个步长配置。重启。

操作过程

```
root@leco:/etc/mysql/mysql.conf.d# mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 3
Server version: 5.7.25-0ubuntu0.16.04.2 (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> use cmz;        # 选择库
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> drop table info;  # 删除表，使用新的表。
Query OK, 0 rows affected (0.03 sec)

mysql> create table info(
    -> id int not null primary key auto_increment,
    -> name varchar(20),
    -> age int not null,
    -> score int not null
    -> );
Query OK, 0 rows affected (0.05 sec)

mysql> insert into info(name,age,score) values("张三",18,80);
,age,score) values("赵六",40,77);Query OK, 1 row affected (0.00 sec)

mysql> insert into info(name,age,score) values("张三",40,66);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(name,age,score) values("李四",20,55);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(id,name,age,score) values(100,"王五",30,89);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(name,age,score) values("赵六",40,77);
Query OK, 1 row affected (0.00 sec)

mysql> select * from info;
+-----+--------+-----+-------+
| id  | name   | age | score |
+-----+--------+-----+-------+
|   1 | 张三   |  18 |    80 |
|   2 | 张三   |  40 |    66 |
|   3 | 李四   |  20 |    55 |
| 100 | 王五   |  30 |    89 |
| 101 | 赵六   |  40 |    77 |
+-----+--------+-----+-------+
5 rows in set (0.00 sec)
```

&#160; &#160; &#160; &#160; 从上面结果看出，我们在不设置步长的时候，每次插入数据的时候，id都是默认自动增长1，而我们认为设置id（insert into info(id,name,age,score) values(100,"王五",30,89);）后，每次都会基于设置的id自增长。

!!! danger "删除"
    ```python
    以上的删除，修改等操作，在正式环境上请酌情使用。
    ```


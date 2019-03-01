<center><h1> MySQL 删除表数据 </h1></center>

## 1. 介绍

---

&#160; &#160; &#160; &#160; ==truncate和delete都可以删除表数据，有什么区别呢？==

- truncate是整体删除（速度较快）， delete是逐条删除（速度较慢）。
- truncate不写服务器log，delete写服务器log，也就是truncate效率比delete高的原因。
- truncate不激活trigger(触发器)，但是会重置Identity（标识列、自增字段），相当于自增列会被置为初始值，又重新从1开始记录，而不是接着原来的ID数。而delete删除以后，Identity依旧是接着被删除的最近的那一条记录ID加1后进行记录。
- 如果只需删除表中的部分记录，只能使用DELETE语句配合where条件。 DELETE FROM wp_comments WHERE……


---

&#160; &#160; &#160; &#160; ==MySql的Delete、Truncate、Drop分析==

- truncate 和 delete 只删除数据不删除表的结构(定义),drop 语句将删除表的结构被依赖的约束(constrain)、触发器(trigger)、索引(index);依赖于该表的存储过程/函数将保留,但是变为 invalid 状态。
- delete 语句是数据库操作语言(dml)，这操作会放到rollback segement 中，事务提交之后才生效;如果有相应的 trigger，执行的时候将被触发。,truncate、drop 是数据库定义语言(ddl)，操作立即生效，原数据不放到 rollback segment 中，不能回滚，操作不触发 trigger。
- delete 语句不影响表所占用的 extent，高水线(high watermark)保持原位置不动显然 drop 语句将表所占用的空间全部释放。,truncate 语句缺省情况下见空间释放到 minextents个 extent，除非使用reuse storage;truncate 会将高水线复位(回到最开始)。
- 速度，一般来说: drop> truncate > delete
- 安全性：小心使用 drop 和 truncate，尤其没有备份的时候.否则哭都来不及



## 2. 演示

&#160; &#160; &#160; &#160;演示drop，delete，truncate

### 2.1 drop 删除
&#160; &#160; &#160; &#160;drop删除表数据和表结构，说白了就是直接把表直接删掉了。
```
mysql> use summer;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tabales;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'tabales' at line1
mysql> show tables;
+------------------+
| Tables_in_summer |
+------------------+
| cmz              |
| info             |
+------------------+
2 rows in set (0.00 sec)

mysql> drop table cmz;
Query OK, 0 rows affected (0.05 sec)

mysql> show tables;
+------------------+
| Tables_in_summer |
+------------------+
| info             |
+------------------+
1 row in set (0.00 sec)
```
删除后，看不到表名为cmz这张表了。

### 2.1 delete 删除
准备环境
```
drop database leco;
create database leco charset utf8;
use leco;
create table emp(
id int not null auto_increment primary key, 
name varchar(20)
);  
insert into emp(name) values("summer");
insert into emp(name) values("caimengzhi");
insert into emp(name) values("我曾");
insert into emp(name) values("世本常态");
```
操作过程
```
mysql> create database leco charset utf8;
Query OK, 1 row affected (0.01 sec)

mysql> use leco;
Database changed
mysql> create table emp(
    -> id int not null auto_increment primary key,
    -> name varchar(20)
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> insert into emp(name) values("summer");
Query OK, 1 row affected (0.02 sec)

mysql> insert into emp(name) values("caimengzhi");
Query OK, 1 row affected (0.02 sec)

mysql> insert into emp(name) values("我曾");
Query OK, 1 row affected (0.02 sec)

mysql> insert into emp(name) values("世本常态");
Query OK, 1 row affected (0.01 sec)

mysql> show tables;
+----------------+
| Tables_in_leco |
+----------------+
| emp            |
+----------------+
1 row in set (0.00 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | summer       |
|  3 | caimengzhi   |
|  5 | 我曾         |
|  7 | 世本常态     |
+----+--------------+
4 rows in set (0.00 sec)
```
开始删除

```
mysql> delete from emp;
Query OK, 4 rows affected (0.01 sec)
mysql> select * from emp;
Empty set (0.00 sec)
```
再继续插入数据

```
mysql> insert into emp(name) values("cmz");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  9 | cmz  |
+----+------+
1 row in set (0.00 sec)
```
此时看到数据的id变成9了，也就是id在原来的基础上增加了，仅仅是删除了数据，没有删除id，而truncate删除数据也会删除id[恢复为0]。继续向下看。


### 2.2 truncate 删除
准备环境
```
drop database leco;
create database leco charset utf8;
use leco;
create table emp(
id int not null auto_increment primary key, 
name varchar(20)
);  
insert into emp(name) values("summer");
insert into emp(name) values("caimengzhi");
insert into emp(name) values("我曾");
insert into emp(name) values("世本常态");
```
操作过程
```
mysql> create database leco charset utf8;
Query OK, 1 row affected (0.01 sec)

mysql> use leco;
Database changed
mysql> create table emp(
    -> id int not null auto_increment primary key,
    -> name varchar(20)
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> insert into emp(name) values("summer");
Query OK, 1 row affected (0.02 sec)

mysql> insert into emp(name) values("caimengzhi");
Query OK, 1 row affected (0.02 sec)

mysql> insert into emp(name) values("我曾");
Query OK, 1 row affected (0.02 sec)

mysql> insert into emp(name) values("世本常态");
Query OK, 1 row affected (0.01 sec)

mysql> show tables;
+----------------+
| Tables_in_leco |
+----------------+
| emp            |
+----------------+
1 row in set (0.00 sec)

mysql> select * from emp;
+----+--------------+
| id | name         |
+----+--------------+
|  1 | summer       |
|  3 | caimengzhi   |
|  5 | 我曾         |
|  7 | 世本常态     |
+----+--------------+
4 rows in set (0.00 sec)
```
开始删除数据

```
mysql> truncate emp;
Query OK, 0 rows affected (0.05 sec)

mysql> select * from emp;
Empty set (0.00 sec)
```
继续添加数据
```
mysql> insert into emp(name) values("cmz");
Query OK, 1 row affected (0.01 sec)

mysql> select * from emp;
+----+------+
| id | name |
+----+------+
|  1 | cmz  |
+----+------+
1 row in set (0.00 sec)
```

&#160; &#160; &#160; &#160;我们从上面结果来看。id从0开始了。


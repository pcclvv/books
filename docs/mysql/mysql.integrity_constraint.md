<center><h1> MySQL 完整性约束 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; 约束条件与数据类型的宽度一样，都是可选参数，用于保证数据的完整性和一致性，主要分为以下几种

```
PRIMARY KEY (PK)    标识该字段为该表的主键，可以唯一的标识记录
FOREIGN KEY (FK)    标识该字段为该表的外键
NOT NULL            标识该字段不能为空
UNIQUE KEY (UK)     标识该字段的值是唯一的
AUTO_INCREMENT      标识该字段的值自动增长（整数类型，而且为主键）
DEFAULT             为该字段设置默认值

UNSIGNED 无符号
ZEROFILL 使用0填充
```

!!! note "注意"
    ```python
    1. 是否允许为空，默认NULL，可设置NOT NULL，字段不允许为空，必须赋值
    2. 字段是否有默认值，缺省的默认值是NULL，如果插入记录时不给字段赋值，此字段使用默认值
        sex enum('male','female') not null default 'male'
       age int unsigned NOT NULL default 20 必须为正值（无符号） 不允许为空 默认是20
    3. 是否是key
        主键 primary key
        外键 foreign key
        索引 (index,unique...)
    ```


## 2. not null与default
&#160; &#160; &#160; &#160;是否可空，null表示空，非字符串

```
not null - 不可空
null     - 可空
```

&#160; &#160; &#160; &#160;默认值，创建列时可以指定默认值，当插入数据时如果未主动设置，则自动添加默认值


```
create table t15(
 id int(11) unsigned zerofill
);

mysql> create table t15(
    ->  id int(11) unsigned zerofill
    -> );
Query OK, 0 rows affected (0.38 sec)

mysql> desc t15;
+-------+---------------------------+------+-----+---------+-------+
| Field | Type                      | Null | Key | Default | Extra |
+-------+---------------------------+------+-----+---------+-------+
| id    | int(11) unsigned zerofill | YES  |     | NULL    |       |
+-------+---------------------------+------+-----+---------+-------+
row in set (0.01 sec)
int约束是整形，11表示宽度，unsigned 表示无符号，zerofill表示不够用0填充。

create table t16(
 id int(11),
 name char(6),
 sex enum('male','female') not null default 'male'
);
mysql> create table t16(
    ->  id int(11),
    ->  name char(6),
    ->  sex enum('male','female') not null default 'male'
    -> );
Query OK, 0 rows affected (0.42 sec)

mysql> desc t16;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | char(6)               | YES  |     | NULL    |       |
| sex   | enum('male','female') | NO   |     | male    |       |
+-------+-----------------------+------+-----+---------+-------+
rows in set (0.00 sec)
# enum表示枚举，not null 表示不为空，default 'male' 表示sex不传入的话默认值是male

例子
mysql> insert into t16(id,name) values(1,'cmz'); # sex没有传入，默认为male
Query OK, 1 row affected (0.36 sec)

mysql> desc t16;
+-------+-----------------------+------+-----+---------+-------+
| Field | Type                  | Null | Key | Default | Extra |
+-------+-----------------------+------+-----+---------+-------+
| id    | int(11)               | YES  |     | NULL    |       |
| name  | char(6)               | YES  |     | NULL    |       |
| sex   | enum('male','female') | NO   |     | male    |       |
+-------+-----------------------+------+-----+---------+-------+
rows in set (0.00 sec)

mysql> select * from t16;
+------+------+------+
| id   | name | sex  |
+------+------+------+
|    1 | cmz  | male |
+------+------+------+
row in set (0.00 sec)
```

```
==================not null====================
mysql> create table t1(id int); #id字段默认可以插入空
mysql> desc t1;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | YES  |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
mysql> insert into t1 values(); #可以插入空


mysql> create table t2(id int not null); #设置字段id不为空
mysql> desc t2;
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| id    | int(11) | NO   |     | NULL    |       |
+-------+---------+------+-----+---------+-------+
mysql> insert into t2 values(); #不能插入空
ERROR 1364 (HY000): Field 'id' doesn't have a default value



==================default====================
#设置id字段有默认值后，则无论id字段是null还是not null，都可以插入空，插入空默认填入default指定的默认值
mysql> create table t3(id int default 1);
mysql> alter table t3 modify id int not null default 1;



==================综合练习====================
mysql> create table student(
    -> name varchar(20) not null,
    -> age int(3) unsigned not null default 18,
    -> sex enum('male','female') default 'male',
    -> hobby set('play','study','read','music') default 'play,music'
    -> );
mysql> desc student;
+-------+------------------------------------+------+-----+------------+-------+
| Field | Type                               | Null | Key | Default    | Extra |
+-------+------------------------------------+------+-----+------------+-------+
| name  | varchar(20)                        | NO   |     | NULL       |       |
| age   | int(3) unsigned                    | NO   |     | 18         |       |
| sex   | enum('male','female')              | YES  |     | male       |       |
| hobby | set('play','study','read','music') | YES  |     | play,music |       |
+-------+------------------------------------+------+-----+------------+-------+
mysql> insert into student(name) values('cmz');
mysql> select * from student;
+------+-----+------+------------+
| name | age | sex  | hobby      |
+------+-----+------+------------+
| cmz |  18 | male | play,music |
+------+-----+------+------------+
```

## 3. unique
&#160; &#160; &#160; &#160;创建唯一索引的目的不是为了提高访问速度，而只是为了避免数据出现重复。唯一索引可以有多个但索引列的值必须唯一，索引列的值允许有空值。如果能确定某个数据列将只包含彼此各不相同的值，在为这个数据列创建索引的时候就应该使用关键字UNIQUE。

```
#-------------------------------------------unique key
# 单列唯一
    # 方式1
    create table department(
      id int,
      name char(10) unique
    );
    # 方式2
    create table department(
      id int,
      name char(10),
      unique(name)
    );
    insert into department values(1,'IT'),(2,'sales');
    insert into department values(3,'IT'); # 会报错

    mysql> create table department(
        ->   id int,
        ->   name char(10) unique
        -> );
    Query OK, 0 rows affected (0.04 sec)
    mysql> insert into department values(1,'IT'),(2,'sales');
    Query OK, 2 rows affected (0.04 sec)
    Records: 2  Duplicates: 0  Warnings: 0
    mysql> desc department;
    +-------+----------+------+-----+---------+-------+
    | Field | Type     | Null | Key | Default | Extra |
    +-------+----------+------+-----+---------+-------+
    | id    | int(11)  | YES  |     | NULL    |       |
    | name  | char(10) | YES  | UNI | NULL    |       |
    +-------+----------+------+-----+---------+-------+
rows in set (0.00 sec)
    mysql> select * from department;
    +------+-------+
    | id   | name  |
    +------+-------+
    |    1 | IT    |
    |    2 | sales |
    +------+-------+
rows in set (0.00 sec)
    mysql> insert into department values(3,'IT');
    ERROR 1062 (23000): Duplicate entry 'IT' for key 'name'
    其他要是确定唯一性，就添加unique即可。

# 联合唯一

create table services(
 id int,
 ip char(15),
 port int,
 unique(id),
 unique(ip,port)
);
insert into services values
(1,'192.168.1.100',80),
(2,'192.168.1.100',8080),
(3,'192.168.1.110',80);
insert into services values (1,'192.168.1.100',80); #会报错

mysql> create table services(
    ->  id int,
    ->  ip char(15),
    ->  port int,
    ->  unique(id),
    ->  unique(ip,port)
    -> );
Query OK, 0 rows affected (0.41 sec)

mysql> desc services;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| id    | int(11)  | YES  | UNI | NULL    |       |
| ip    | char(15) | YES  | MUL | NULL    |       |
| port  | int(11)  | YES  |     | NULL    |       |
+-------+----------+------+-----+---------+-------+
rows in set (0.01 sec)
mysql> insert into services values
    -> (1,'192.168.1.100',80),
    -> (2,'192.168.1.100',8080),
    -> (3,'192.168.1.110',80);
Query OK, 3 rows affected (0.37 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select * from services;
+------+---------------+------+
| id   | ip            | port |
+------+---------------+------+
|    1 | 192.168.1.100 |   80 |
|    2 | 192.168.1.100 | 8080 |
|    3 | 192.168.1.110 |   80 |
+------+---------------+------+
rows in set (0.00 sec)
mysql> insert into services values (1,'192.168.1.100',80); #会报错
ERROR 1062 (23000): Duplicate entry '1' for key 'id'
```

## 4. primary key
&#160; &#160; &#160; &#160;primary key字段的值不为空且唯一，一个表中可以：

```
1. 单列做主键
2. 多列做主键（复合主键）
3. 一个表内只能有一个主键primary key
```

```
# primary key
约束 not null unique
存储引擎(innodb)，对于innodb存储引擎来说，一个表内必须有一个主键。

# 单列主键
create table t17(
 id int primary key,
 name char(16)
);
insert into t17 values
(1,'cmz'),
(2,'leco'),
(3,'nanjing');
insert into t17 values (1,'nanjing'); # 重复了

mysql> create table t17(
    ->  id int primary key,
    ->  name char(16)
    -> );
Query OK, 0 rows affected (0.48 sec)

mysql> desc t17;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| id    | int(11)  | NO   | PRI | NULL    |       |
| name  | char(16) | YES  |     | NULL    |       |
+-------+----------+------+-----+---------+-------+
rows in set (0.01 sec)
mysql> insert into t17 values (1,'nanjing');
ERROR 1062 (23000): Duplicate entry '1' for key 'PRIMARY'

# mysql建表的时候要是没有指定主键，mysql会搜整个表找一个不为空，且唯一的作为主键
要是找不到，就会默认使用隐藏主键。
create table t18(
 id int not null unique,
 name char(16)
);
mysql> create table t18(
    ->  id int not null unique,
    ->  name char(16)
    -> );
Query OK, 0 rows affected (0.40 sec)

mysql> desc t18;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| id    | int(11)  | NO   | PRI | NULL    |       |  # 可以看出作为了主键
| name  | char(16) | YES  |     | NULL    |       |
+-------+----------+------+-----+---------+-------+
rows in set (0.00 sec)
通常一个表中有一个id字段作为主键。

# 符合主键
多个字段联合在一起作为主键
create table t19(
ip char(15),
port int,
primary key(ip,port)
);

create table loocha(
ip varchar(15),
port char(5),
service_name varchar(10) not null,
primary key(ip,port)
);

mysql> create table t19(
    -> ip char(15),
    -> port int,
    -> primary key(ip,port)
    -> );
Query OK, 0 rows affected (0.39 sec)

mysql> desc t19;
+-------+----------+------+-----+---------+-------+
| Field | Type     | Null | Key | Default | Extra |
+-------+----------+------+-----+---------+-------+
| ip    | char(15) | NO   | PRI | NULL    |       |
| port  | int(11)  | NO   | PRI | NULL    |       |
+-------+----------+------+-----+---------+-------+
rows in set (0.00 sec)


mysql> create table loocha(
    -> ip varchar(15),
    -> port char(5),
    -> service_name varchar(10) not null,
    -> primary key(ip,port)
    -> );
Query OK, 0 rows affected (0.03 sec)

mysql> desc loocha
    -> ;
+--------------+-------------+------+-----+---------+-------+
| Field        | Type        | Null | Key | Default | Extra |
+--------------+-------------+------+-----+---------+-------+
| ip           | varchar(15) | NO   | PRI | NULL    |       |
| port         | char(5)     | NO   | PRI | NULL    |       |
| service_name | varchar(10) | NO   |     | NULL    |       |
+--------------+-------------+------+-----+---------+-------+
rows in set (0.01 sec)

insert into t19 values ('192.168.1.110',80);
insert into t19 values ('192.168.1.110',80); # 报错
mysql> insert into t19 values ('192.168.1.110',80);
Query OK, 1 row affected (0.01 sec)

mysql> insert into t19 values ('192.168.1.110',80);
ERROR 1062 (23000): Duplicate entry '192.168.1.110-80' for key 'PRIMARY'
mysql> select * from t19;
+---------------+------+
| ip            | port |
+---------------+------+
| 192.168.1.110 |   80 |
+---------------+------+
row in set (0.00 sec)
```

```
============单列做主键===============
#方法一：not null+unique
create table department1(
id int not null unique, #主键
name varchar(20) not null unique,
comment varchar(100)
);

mysql> desc department1;
+---------+--------------+------+-----+---------+-------+
| Field   | Type         | Null | Key | Default | Extra |
+---------+--------------+------+-----+---------+-------+
| id      | int(11)      | NO   | PRI | NULL    |       |
| name    | varchar(20)  | NO   | UNI | NULL    |       |
| comment | varchar(100) | YES  |     | NULL    |       |
+---------+--------------+------+-----+---------+-------+
rows in set (0.01 sec)

#方法二：在某一个字段后用primary key
create table department2(
id int primary key, #主键
name varchar(20),
comment varchar(100)
);

mysql> desc department2;
+---------+--------------+------+-----+---------+-------+
| Field   | Type         | Null | Key | Default | Extra |
+---------+--------------+------+-----+---------+-------+
| id      | int(11)      | NO   | PRI | NULL    |       |
| name    | varchar(20)  | YES  |     | NULL    |       |
| comment | varchar(100) | YES  |     | NULL    |       |
+---------+--------------+------+-----+---------+-------+
rows in set (0.00 sec)

#方法三：在所有字段后单独定义primary key
create table department3(
id int,
name varchar(20),
comment varchar(100),
constraint pk_name primary key(id); #创建主键并为其命名pk_name

mysql> desc department3;
+---------+--------------+------+-----+---------+-------+
| Field   | Type         | Null | Key | Default | Extra |
+---------+--------------+------+-----+---------+-------+
| id      | int(11)      | NO   | PRI | NULL    |       |
| name    | varchar(20)  | YES  |     | NULL    |       |
| comment | varchar(100) | YES  |     | NULL    |       |
+---------+--------------+------+-----+---------+-------+
rows in set (0.01 sec)

单列主键
==================多列做主键================
create table service(
ip varchar(15),
port char(5),
service_name varchar(10) not null,
primary key(ip,port)
);


mysql> desc service;
+--------------+-------------+------+-----+---------+-------+
| Field        | Type        | Null | Key | Default | Extra |
+--------------+-------------+------+-----+---------+-------+
| ip           | varchar(15) | NO   | PRI | NULL    |       |
| port         | char(5)     | NO   | PRI | NULL    |       |
| service_name | varchar(10) | NO   |     | NULL    |       |
+--------------+-------------+------+-----+---------+-------+
rows in set (0.00 sec)

mysql> insert into service values
    -> ('172.16.45.10','3306','mysqld'),
    -> ('172.16.45.11','3306','mariadb')
    -> ;
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> insert into service values ('172.16.45.10','3306','nginx');
ERROR 1062 (23000): Duplicate entry '172.16.45.10-3306' for key 'PRIMARY'
```

## 5. auto_increment
&#160; &#160; &#160; &#160;数据库应用中，我们经常需要用到自动递增的唯一编号来标识记录。在MySQL中，可通过数据列的auto_increment属性来自动生成。可在建表时可用“auto_increment=n”选项来指定一个自增的初始值。可用“alter table table_name auto_increment=n”命令来重设自增的起始值，当然在设置的时候Mysql会取数据表中auto_increment列的最大值 + 1与n中的较大者作为新的auto_increment值。

&#160; &#160; &#160; &#160;Myql的auto_increment属性具有以下特性：

- 具有auto_increment属性的数据列应该是一个正数序列，如果把该数据列声明为UNSIGNED，这样序列的编号个数可增加一倍。比如tinyint数据列的最大编号是127，如果加上UNSIGNED，那么最大编号变为255
- auto_increment数据列必须有唯一索引，以避免序号重复；必须具备NOT NULL属性

```
# auto_increment 
# 约束字段为自动增长，被约束的字段必须同时被key约束
# primary key or unique key
#-----------------------------------------------------------

# #不指定id，则自动增长
create table t20(
 id int primary key auto_increment,
 name char(16)
);
mysql> create table t20(
    ->  id int primary key auto_increment,
    ->  name char(16)
    -> );
Query OK, 0 rows affected (0.02 sec)

mysql>  desc t20;
+-------+----------+------+-----+---------+----------------+
| Field | Type     | Null | Key | Default | Extra          |
+-------+----------+------+-----+---------+----------------+
| id    | int(11)  | NO   | PRI | NULL    | auto_increment |
| name  | char(16) | YES  |     | NULL    |                |
+-------+----------+------+-----+---------+----------------+
rows in set (0.02 sec)



insert into t20(name) values('cmz1'),('leco'),('loocha');
mysql> insert into t20(name) values('cmz1'),('leco'),('loocha');
Query OK, 3 rows affected (0.36 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select * from t20;
+----+--------+
| id | name   |
+----+--------+
|  1 | cmz1   |
|  2 | leco   |
|  3 | loocha |
+----+--------+
rows in set (0.00 sec)

insert into t20(id,name) values(7,'keke'); 
# 可以手动插入primary key只要保证主键唯一即可，以后在插入就在该基础上自增加
mysql> insert into t20(id,name) values(7,'cmz1');
Query OK, 1 row affected (0.00 sec)

mysql> select * from t20;
+----+--------+
| id | name   |
+----+--------+
|  1 | cmz1   |
|  2 | leco   |
|  3 | loocha |
|  7 | cmz1   |
+----+--------+
rows in set (0.01 sec)
自增长步长默认为1

show variables like 'auto_inc%';
mysql> show variables like 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 1     | # 步长       默认为1
| auto_increment_offset    | 1     | # 起始偏移量 默认为1
+--------------------------+-------+
rows in set (0.08 sec)

# 设置步长 
# session 有效
set session auto_increment_increment=5;
# 全局
set global auto_increment_increment=5;

# 设置起始偏移量
set global auto_increment_offset=3;
强调起始偏移量<=步长

#例子设置不步长和起始偏移量
mysql> set global auto_increment_offset=3;
Query OK, 0 rows affected (0.00 sec)

mysql> set global auto_increment_increment=5;
Query OK, 0 rows affected (0.00 sec)
重新登录。
mysql> show variables like 'auto_inc%';
+--------------------------+-------+
| Variable_name            | Value |
+--------------------------+-------+
| auto_increment_increment | 5     |
| auto_increment_offset    | 3     |
+--------------------------+-------+
rows in set (0.01 sec)

create table t21(
 id int primary key  auto_increment,
 name char(16)
);

mysql>  create table t21(
    ->  id int primary key  auto_increment,
    ->  name char(16)
    -> );
Query OK, 0 rows affected (0.40 sec)
插入数据
insert into t21(name) values
('cmz'),('leco'),('loocha');
mysql> insert into t21(name) values
    -> ('cmz'),('leco'),('loocha');
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> select * from t21;
+----+--------+
| id | name   |
+----+--------+
|  3 | cmz    |
|  8 | leco   |
| 13 | loocha |
+----+--------+
rows in set (0.00 sec)

# 清空表
delete from t20;
mysql> delete from t20;
Query OK, 4 rows affected (0.01 sec)

mysql> select * from t20;
Empty set (0.00 sec)

mysql> show create table t20;
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                                              |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| t20   | CREATE TABLE `t20` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1 |
+-------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
row in set (0.00 sec)
# 虽然清空了表，但是主键没删除
mysql> insert into t20(name) values('cccc');
Query OK, 1 row affected (0.01 sec)

mysql> select * from t20;
+----+------+
| id | name |
+----+------+
|  8 | cccc |
+----+------+
row in set (0.00 sec)

#truncate 清空表，主键也删除
mysql> truncate  t20;
Query OK, 0 rows affected (0.03 sec)

mysql> show create table t20;
+-------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table | Create Table                                                                                                                                             |
+-------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
| t20   | CREATE TABLE `t20` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(16) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 |
+-------+----------------------------------------------------------------------------------------------------------------------------------------------------------+
row in set (0.00 sec)
mysql> insert into t20(name) values('cccc');
Query OK, 1 row affected (0.01 sec)

mysql> select * from t20;
+----+------+
| id | name |
+----+------+
|  1 | cccc |
+----+------+
row in set (0.00 sec)
```

## 6. 案例

&#160; &#160; &#160; &#160;员工信息表有三个字段：工号 姓名 部门,公司有3个部门，但是有1个亿的员工，那意味着部门这个字段需要重复存储，部门名字越长，越浪费

解决方法：

- 我们完全可以定义一个部门表
- 然后让员工信息表关联该表，如何关联，即foreign key


![MySQL 主从](../pictures/mysql/p2.png)

变为两个表，emp和dep表，同时ｅｍｐ的表中dep_id　关联到ｄｅｐ表中的的ｉｄ字段。

![MySQL 主从](../pictures/mysql/p3.png)


```
#1. 先建被关联的表，且保证被关联的字段唯一
#2. 然后在建立关联的表
create table dep(
 id int primary key,
 name char(10),
 comment char(50)
); 

create table emp(
 id int primary key,
 name char(10),
 sex enum('male','female'),
 dep_id int,
 foreign key(dep_id) references dep(id)
 on delete cascade
 on update cascade
);
注意：
　foreign key(dep_id) references dep(id)
　on delete cascade
　on update cascade
　是一句话，也就是
　foreign key(dep_id) references dep(id)　on delete cascade　on update cascade
　其中dep表操作。修改或者删除，ｅｍｐ表就会跟着变动，详见下面测试。
#3. 插入数据
# 先插入被关联表的数据
insert into dep values
(1,"IT","技术部门"),
(2,"销售","销售部门"),
(3,"财务","财务部门");

insert into emp values(1,'cmz','male',1);
insert into emp values(2,'keke','male',2);
insert into emp values(3,'leco','female',3);
    # 操作过程
    mysql> create table dep(
        ->  id int primary key,
        ->  name char(10),
        ->  comment char(50)
        -> ); 
    Query OK, 0 rows affected (0.02 sec)
    mysql> create table emp(
        ->  id int primary key,
        ->  name char(10),
        ->  sex enum('male','female'),
        ->  dep_id int,
        ->  foreign key(dep_id) references dep(id)
        ->  on delete cascade
        ->  on update cascade
        -> );
    Query OK, 0 rows affected (0.04 sec)


    mysql> desc emp;
    +--------+-----------------------+------+-----+---------+-------+
    | Field  | Type                  | Null | Key | Default | Extra |
    +--------+-----------------------+------+-----+---------+-------+
    | id     | int(11)               | NO   | PRI | NULL    |       |
    | name   | char(10)              | YES  |     | NULL    |       |
    | sex    | enum('male','female') | YES  |     | NULL    |       |
    | dep_id | int(11)               | YES  | MUL | NULL    |       |
    +--------+-----------------------+------+-----+---------+-------+
rows in set (0.00 sec)

    mysql> desc dep;
    +---------+----------+------+-----+---------+-------+
    | Field   | Type     | Null | Key | Default | Extra |
    +---------+----------+------+-----+---------+-------+
    | id      | int(11)  | NO   | PRI | NULL    |       |
    | name    | char(10) | YES  |     | NULL    |       |
    | comment | char(50) | YES  |     | NULL    |       |
    +---------+----------+------+-----+---------+-------+
rows in set (0.01 sec)
    插入数据
    mysql> insert into dep values
        -> (1,"IT","技术部门"),
        -> (2,"销售","销售部门"),
        -> (3,"财务","财务部门");
    Query OK, 3 rows affected (0.00 sec)
    Records: 3  Duplicates: 0  Warnings: 0

    mysql> select * from dep;
    +----+--------+--------------+
    | id | name   | comment      |
    +----+--------+--------------+
    |  1 | IT     | 技术部门     |
    |  2 | 销售   | 销售部门     |
    |  3 | 财务   | 财务部门     |
    +----+--------+--------------+
rows in set (0.00 sec)
    mysql> insert into emp values(1,'cmz','male',1);
    Query OK, 1 row affected (0.01 sec)
    mysql> insert into emp values(2,'keke','male',2);
    Query OK, 1 row affected (0.01 sec)
    mysql> insert into emp values(3,'leco','female',3);
    Query OK, 1 row affected (0.01 sec)
    mysql> select * from emp;
    +----+------+--------+--------+
    | id | name | sex    | dep_id |
    +----+------+--------+--------+
    |  1 | cmz  | male   |      1 |
    |  2 | keke | male   |      2 |
    |  3 | leco | female |      3 |
    +----+------+--------+--------+
rows in set (0.00 sec)

    刪除
    刪除了部門，跟他关联的部门人员都会被删除。
    mysql> delete from dep where id=1;
    Query OK, 1 row affected (0.01 sec)

    mysql> select * from dep;
    +----+--------+--------------+
    | id | name   | comment      |
    +----+--------+--------------+
    |  2 | 销售   | 销售部门     |
    |  3 | 财务   | 财务部门     |
    +----+--------+--------------+
rows in set (0.00 sec)

    mysql> select * from emp;
    +----+------+--------+--------+
    | id | name | sex    | dep_id |
    +----+------+--------+--------+
    |  2 | keke | male   |      2 |
    |  3 | leco | female |      3 |
    +----+------+--------+--------+
rows in set (0.00 sec)

    #更新
    #更新了部門，跟他关联的部门人员都会被更新。
    mysql> update dep set id=10 where id=2;
    Query OK, 1 row affected (0.01 sec)
    Rows matched: 1  Changed: 1  Warnings: 0

    mysql> select * from dep;
    +----+--------+--------------+
    | id | name   | comment      |
    +----+--------+--------------+
    |  3 | 财务   | 财务部门     |
    | 10 | 销售   | 销售部门     |
    +----+--------+--------------+
rows in set (0.00 sec)

    mysql> select * from emp;
    +----+------+--------+--------+
    | id | name | sex    | dep_id |
    +----+------+--------+--------+
    |  2 | keke | male   |     10 |
    |  3 | leco | female |      3 |
    +----+------+--------+--------+
rows in set (0.00 sec)
```

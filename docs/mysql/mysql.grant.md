<center><h1> MySQL GRANT </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;授予MySQL帐户的权限决定了帐户可以执行的操作。MySQL权限在它们适用的上下文和不同操作级别上有所不同：

- 管理权限使用户能够管理MySQL服务器的操作。这些权限是全局的，因为它们不是特定于特定数据库的。
 
- 数据库权限适用于数据库及其中的所有对象。可以为特定数据库或全局授予这些权限，以便它们适用于所有数据库。

- 可以为数据库中的特定对象，数据库中给定类型的所有对象（例如，数据库中的所有表）或全局的所有对象授予数据库对象（如表，索引，视图和存储例程）的权限。所有数据库中给定类型的对象

---

&#160; &#160; &#160; &#160;用户权限管理主要有以下作用

- 可以限制用户访问哪些库、哪些表 
- 可以限制用户对哪些表执行SELECT、CREATE、DELETE、DELETE、ALTER等操作 
- 可以限制用户登录的IP或域名 
- 可以限制用户自己的权限是否可以授权给别的用户

### 1.1 授权
&#160; &#160; &#160; &#160; MySQL 赋予用户权限命令的简单格式可概括为：

```
grant 权限 on 数据库对象 to 用户 密码 其他
例子
mysql> grant all privileges on *.* to 'caimengzhi'@'%' identified by 'caimengzhi123456' with grant option;
```

!!! tip "参数解释"
    ```python
    
    1. all privileges：表示将所有权限授予给用户。也可指定具体的权限，如：SELECT、CREATE、DROP等。
    
    2. on：表示这些权限对哪些数据库和表生效，格式：数据库名.表名，这里写“*”表示所有数据库，所有表。如果我要指定将权限应用到test库的user表中，可以这么写：test.user
    
    3. to：将权限授予哪个用户。格式：”用户名”@”登录IP或域名”。%表示没有限制，在任何主机都可以登录。比如：'caimengzhi'@'192.168.0.%'，表示caimengzhi这个用户只能在192.168.0 该IP段登录
    
    4. identified by：指定用户的登录密码
    
    5. with grant option：表示允许用户将自己的权限授权给其它用户，一般用不到，最好有BDA统一管理。
    
    6. 可以使用GRANT给用户添加权限，权限会自动叠加，不会覆盖之前授予的权限，比如你先给用户添加一个SELECT权限，后来又给用户添加了一个INSERT权限，那么该用户就同时拥有了SELECT和INSERT权限。
    ```

[传送门 - 用户详情的权限列表请参考MySQL官网说明](http://dev.mysql.com/doc/refman/5.7/en/privileges-provided.html ) 


## 2. 案例
### 2.1 授权select权限

```
mysql> grant select on db1.* to 'cmz'@'%' identified by 'cmz';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```
### 2.2 查看授予的权限

```
mysql> show grants for 'cmz'@'%';
+--------------------------------------+
| Grants for cmz@%                     |
+--------------------------------------+
| GRANT USAGE ON *.* TO 'cmz'@'%'      |
| GRANT SELECT ON `db1`.* TO 'cmz'@'%' |
+--------------------------------------+
2 rows in set (0.00 sec)
```
### 2.3 用户登录验证

```
root@leco:/home/leco# mysql -ucmz -pcmz
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 56
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| db1                |
+--------------------+
2 rows in set (0.00 sec)

mysql> use db1;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| t1            |
+---------------+
1 row in set (0.01 sec)

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

mysql> drop table t1;
ERROR 1142 (42000): DROP command denied to user 'cmz'@'localhost' for table 't1'
mysql> truncate t1;
ERROR 1142 (42000): DROP command denied to user 'cmz'@'localhost' for table 't1
```
从上面只能看到，除了select和show的其他基本权限都么有了。

继续添加权限

```
mysql> grant create on db1.* to 'cmz'@'%';
Query OK, 0 rows affected (0.01 sec)

mysql> show grants for 'cmz'@'%';
+----------------------------------------------+
| Grants for cmz@%                             |
+----------------------------------------------+
| GRANT USAGE ON *.* TO 'cmz'@'%'              |
| GRANT SELECT, CREATE ON `db1`.* TO 'cmz'@'%' |
+----------------------------------------------+
2 rows in set (0.00 sec)
```
从上面看到权限是累加的。类似以下

```
grant select on db1.* to 'cmz'@'%';
grant insert on db1.* to 'cmz'@'%';
grant update on db1.* to 'cmz'@'%';
grant delete on db1.* to 'cmz'@'%';
```
等价于
```
grant select,insert,update,delete on db1.* to 'cmz'@'%';
```




## 3. 其他授权
### 3.1 授权所有库

```
grant all privileges on *.* to 'cmz'@'%' identified by 'cmz';
```
> privileges 可以省略

cmz账号，管理数据库里面所有库和表。

### 3.2 授权所有某库所有表

```
grant all privileges on db.* to 'cmz'@'%' identified by 'cmz';
```
cmz账号，管理db库下面所有表。

### 3.3 授权所有某库某表

```
grant all privileges on db.table1 to 'cmz'@'%' identified by 'cmz';
```
cmz账号，管理db库下的table1表。



### 3.4 主从账号

```
mysql> grant replication slave on *.* to 'repl'@'%' identified by 'repl';
```



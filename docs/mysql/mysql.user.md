<center><h1> MySQL 用户 </h1></center>

快速命令
```
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
    CREATE USER 'cmz'@'localhost' IDENTIFIED BY '123456';       # 创建用户，只能在mysql的服务器端菜能登录，密码是123456
    CREATE USER 'cmz'@'192.168.5.122' IDENTIFIED BY '123456';   # 创建用户，限制来访的IP地址必须是192.168.5.5.5.5.5.122，密码是123456
    CREATE USER 'cmz'@'%' IDENTIFIED BY '123456';               # 创建用户，不限制来访IP，密码是123456
    CREATE USER 'cmz'@'%' IDENTIFIED BY '';                     # 创建用户，不限制来访IP，不无密码
    CREATE USER 'cmz'@'%';                                      # 创建用户，不限制来访IP，不无密码 和上面相等
   
GRANT privileges ON databasename.tablename TO 'username'@'host'
    GRANT SELECT, INSERT ON cmz.leco TO 'cmz'@'%';  # 授权cmz 用户，拥有cmz库的leco表有select，insert 权限
    GRANT ALL ON *.* TO 'cmz'@'%';                  # 授权cmz 用户，拥有所有权限
    GRANT ALL ON cmz.* TO 'cmz'@'%';                # 授权cmz 用户，拥有所cmz库的下所有表的所有权限
   
SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword');
    SET PASSWORD FOR 'cmz'@'%' = PASSWORD('cmz');
SET PASSWORD = PASSWORD("newpassword");
    SET PASSWORD = PASSWORD("cmz123456");
    
REVOKE privilege ON databasename.tablename FROM 'username'@'host';
    REVOKE SELECT ON *.* FROM 'cmz'@'%';
    
DROP USER 'username'@'host';
    drop user 'cmz';
```

## 1. 创建用户
### 1.1 语法

```
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
```

!!! note "参数解释"
    ```python
    username：  你将创建的用户名
    host：      指定该用户在哪个主机上可以登陆，如果是本地用户可用localhost，如果想让该用户可以从任意远程主机登陆，可以使用通配符%
    password：  该用户的登陆密码，密码可以为空，如果为空则该用户可以不需要密码登陆服务器
    ```

### 1.2 例子

```
CREATE USER 'cmz'@'localhost' IDENTIFIED BY '123456';       # 创建用户，只能在mysql的服务器端菜能登录，密码是123456
CREATE USER 'cmz'@'192.168.5.122' IDENTIFIED BY '123456';   # 创建用户，限制来访的IP地址必须是192.168.2.122，密码是123456
CREATE USER 'cmz'@'%' IDENTIFIED BY '123456';               # 创建用户，不限制来访IP，密码是123456
CREATE USER 'cmz'@'%' IDENTIFIED BY '';                     # 创建用户，不限制来访IP，不无密码
CREATE USER 'cmz'@'%';                                      # 创建用户，不限制来访IP，不无密码 和上面相等
```

### 1.3 环境

```
root@leco:~# mysql -V
mysql  Ver 14.14 Distrib 5.7.25, for Linux (x86_64) using  EditLine wrapper

mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
6 rows in set (0.00 sec)
```
#### 1.3.1 例子1

```
CREATE USER 'cmz'@'localhost' IDENTIFIED BY '123456';
```

```
mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
6 rows in set (0.00 sec)

mysql> CREATE USER 'cmz'@'localhost' IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.01 sec)

mysql> select * from user;
ERROR 1046 (3D000): No database selected
mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | repl             |
| %         | root             |
| localhost | cmz              |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
7 rows in set (0.00 sec)

在服务器端登录
leco@leco:~$ mysql -ucmz -p123456
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 79
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

说明可登录，换其他机器登录
C:\Users\cmz>mysql -h192.168.5.110 -ucmz -pcmz
Warning: Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'cmz'@'192.168.5.1' (using password: YES)
禁止登录了。
```

#### 1.3.2 例子2

```
CREATE USER 'cmz'@'192.168.5.122' IDENTIFIED BY '123456'; 
```

```
# 1. 先删除上面cmz用户。
mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | repl             |
| %         | root             |
| localhost | cmz              |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
7 rows in set (0.00 sec)

mysql> drop user cmz@'localhost';
Query OK, 0 rows affected (0.01 sec)

mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
6 rows in set (0.00 sec)

# 2. 创建用户
mysql> CREATE USER 'cmz'@'192.168.2.112' IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.00 sec)

mysql> select host,user from mysql.user;
+---------------+------------------+
| host          | user             |
+---------------+------------------+
| %             | repl             |
| %             | root             |
| 192.168.2.112 | cmz              |
| localhost     | debian-sys-maint |
| localhost     | mysql.session    |
| localhost     | mysql.sys        |
| localhost     | root             |
+---------------+------------------+
7 rows in set (0.00 sec)

# 3. mysql服务器本地登录
leco@leco:~$ mysql -ucmz -p123456
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'cmz'@'localhost' (using password: YES)
被拒绝，正常。

# 4. 从192.168.5.122 机器登录
C:\Users\cmz>mysql -h192.168.5.110 -ucmz  -p123456
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 100
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql>
测试OK
```

#### 1.3.3 例子3

```
CREATE USER 'cmz'@'%' IDENTIFIED BY '123456'; 
```
```
mysql> CREATE USER 'cmz'@'%' IDENTIFIED BY '123456';
Query OK, 0 rows affected (0.00 sec)
mysql> select host,user from mysql.user where user='cmz';
+------+------+
| host | user |
+------+------+
| %    | cmz  |
+------+------+
1 row in set (0.00 sec)

# 1. mysql服务器本地登录
leco@leco:~$ mysql -ucmz -p123456
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 85
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
测试OK。

# 2. 其他机器登录
C:\Users\cmz>mysql -h192.168.5.110 -ucmz  -p123456
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 87
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
测试OK
```

#### 1.3.4 例子4
```
CREATE USER 'cmz'@'%' IDENTIFIED BY ''; 
```

```
mysql> drop user cmz@'192.168.5.122';
Query OK, 0 rows affected (0.00 sec)

mysql> CREATE USER 'cmz'@'%' IDENTIFIED BY '';
Query OK, 0 rows affected (0.01 sec)

mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | cmz              |
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
7 rows in set (0.00 sec)

# 1. 服务器本地登录
leco@leco:~$ mysql -ucmz
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 104
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
测试OK

# 2. 其他机器登录
C:\Users\cmz>mysql -h192.168.5.110 -ucmz
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 103
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
测试OK
```


## 2. 授权
### 2.1 语法

```
GRANT privileges ON databasename.tablename TO 'username'@'host'
```

!!! note "参数解释"
    ```python
    privileges：  用户的操作权限，如SELECT，INSERT，UPDATE等，如果要授予所的权限则使用ALL
    databasename：数据库名
    tablename：   表名，如果要授予该用户对所有数据库和表的相应操作权限则可用*表示，如*.*
    ```

### 2.2 例子

```
GRANT SELECT, INSERT ON cmz.leco TO 'cmz'@'%';  # 授权cmz 用户，拥有cmz库的leco表有select，insert 权限
GRANT ALL ON *.* TO 'cmz'@'%';                  # 授权cmz 用户，拥有所有权限
GRANT ALL ON cmz.* TO 'cmz'@'%';                # 授权cmz 用户，拥有所cmz库的下所有表的所有权限
```

!!! note "注意"
    ```python
    1. grant 可以授权的同时创建该用户，
    2. 用以上命令授权的用户不能给其它用户授权，如果想让该用户可以授权，用以下命令:
       GRANT privileges ON databasename.tablename TO 'username'@'host' WITH GRANT OPTION;
    ```


### 2.3 环境
#### 2.3.1 例子1

```
GRANT SELECT, INSERT ON cmz.leco TO 'cmz'@'%';  
```

```
mysql> GRANT SELECT, INSERT ON cmz.leco TO 'cmz'@'%';
Query OK, 0 rows affected (0.00 sec)

mysql> select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | cmz              |
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
7 rows in set (0.00 sec)

# 1. 测试
leco@leco:~$ mysql -ucmz -p123456
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'cmz'@'localhost' (using password: YES)
leco@leco:~$ mysql -ucmz
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 107
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
| cmz                |
+--------------------+
2 rows in set (0.00 sec)

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

mysql> drop table leco;
ERROR 1142 (42000): DROP command denied to user 'cmz'@'localhost' for table 'leco'
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

mysql> insert into leco(id,name,sex,age) values(5,"caimengzhi",'male',30);
Query OK, 1 row affected (0.01 sec)


mysql> select * from leco;
+------+------------+--------+------+
| id   | name       | sex    | age  |
+------+------------+--------+------+
|    1 | 张三       | female |   18 |
|    4 | 张三       | male   |   40 |
|    2 | 李四       | male   |   20 |
|    3 | 王五       | male   |   30 |
|    4 | 赵六       | female |   40 |
|    5 | caimengzhi | male   |   30 |
+------+------------+--------+------+
5 rows in set (0.00 sec)

测试OK。
```
其他两个例子不在测试。


## 3. 修改用户密码
### 3.1 语法
```
SET PASSWORD FOR 'username'@'host' = PASSWORD('newpassword');
```
若是设置当前登录用户

```
SET PASSWORD = PASSWORD("newpassword");
```
### 3.2 修改某个用户

```
mysql> SET PASSWORD FOR 'cmz'@'%' = PASSWORD('cmz');
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.00 sec

登录测试
leco@leco:~$ mysql -ucmz -p
Enter password: ERROR 1045 (28000): Access denied for user 'cmz'@'localhost' (using password: NO)
leco@leco:~$ mysql -ucmz -pcmz
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 110
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
测试OK
```

### 3.3 修改当前登录用户

```
leco@leco:~$ mysql -ucmz -pcmz
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 110
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SET PASSWORD = PASSWORD("cmz123456");
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> flush privileges;
ERROR 1227 (42000): Access denied; you need (at least one of) the RELOAD privilege(s) for this operation
mysql> ^DBye
leco@leco:~$ mysql -ucmz -pcmz
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'cmz'@'localhost' (using password: YES)
leco@leco:~$ mysql -ucmz -pcmz123456
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 112
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
测试OK
```

## 4. 撤销权限
### 4.1 语法

```
REVOKE privilege ON databasename.tablename FROM 'username'@'host';
```

!!! note "注意"
    ```python
    privilege, databasename, tablename：同授权部分
    ```

例子
```
REVOKE SELECT ON *.* FROM 'cmz'@'%';
```
### 4.2 撤销例子

```
mysql> show grants for cmz@'%';
+---------------------------------------------------+
| Grants for cmz@%                                  |
+---------------------------------------------------+
| GRANT USAGE ON *.* TO 'cmz'@'%'                   |
| GRANT SELECT, INSERT ON `cmz`.`leco` TO 'cmz'@'%' |
+---------------------------------------------------+
2 rows in set (0.00 sec)

mysql> revoke insert on cmz.leco from cmz@'%';
Query OK, 0 rows affected (0.01 sec)

mysql> show grants for cmz@'%';
+-------------------------------------------+
| Grants for cmz@%                          |
+-------------------------------------------+
| GRANT USAGE ON *.* TO 'cmz'@'%'           |
| GRANT SELECT ON `cmz`.`leco` TO 'cmz'@'%' |
+-------------------------------------------+
2 rows in set (0.00 sec)

# 测试insert权限
leco@leco:~$ mysql -ucmz -pcmz123456
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 113
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
| cmz                |
+--------------------+
2 rows in set (0.00 sec)

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

mysql> select * from leco;
+------+------------+--------+------+
| id   | name       | sex    | age  |
+------+------------+--------+------+
|    1 | 张三       | female |   18 |
|    4 | 张三       | male   |   40 |
|    2 | 李四       | male   |   20 |
|    3 | 王五       | male   |   30 |
|    4 | 赵六       | female |   40 |
|    5 | caimengzhi | male   |   30 |
+------+------------+--------+------+
6 rows in set (0.00 sec)

mysql> insert into cmz(id,name,age,score) values(6,"keke",'female',3);
ERROR 1142 (42000): INSERT command denied to user 'cmz'@'localhost' for table 'cmz'
```
可以看到。之前cmz用户拥有cmz库中leco表的select，insert权限。回收insert后，只有select权限了。

## 5. 删除用户
### 5.1 语法

```
DROP USER 'username'@'host';
```

!!! note "注意"
    ```python
    DROP USER 'username'@'host'; 若是不指定host也就是DROP USER 'username'，就是删除username所有用户。
    ```
### 5.2 例子

```
mysql>  select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | cmz              |
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
7 rows in set (0.00 sec)

mysql> drop user 'cmz';
Query OK, 0 rows affected (0.00 sec)

mysql>  select host,user from mysql.user;
+-----------+------------------+
| host      | user             |
+-----------+------------------+
| %         | repl             |
| %         | root             |
| localhost | debian-sys-maint |
| localhost | mysql.session    |
| localhost | mysql.sys        |
| localhost | root             |
+-----------+------------------+
6 rows in set (0.00 sec)
```


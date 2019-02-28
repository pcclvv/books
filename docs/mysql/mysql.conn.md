<center><h1> MySQL conn </h1></center>

## 1. 描述

&#160; &#160; &#160; &#160;以下是从命令行中连接mysql服务器的简单实例：

### 1.1 交互式登录
```
root@leco:~# mysql -uroot -p
Enter password:    
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.25-0ubuntu0.16.04.2 (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

```

!!! tip "密码输入"
    ```python
    root@leco:~# mysql -uroot -p
    Enter password:    # 这个地方输入mysql的root账号密码 
    ```


### 1.2 非交互式登录

```
root@leco:~# mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.7.25-0ubuntu0.16.04.2 (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>

```

!!! tip "密码输入"
    ```python
    mysql -uroot -proot  # -p root期中root就是密码
    ```
    

### 1.3 退出mysql

```
mysql> exit
Bye
```

## 2. python 链接

```
root@leco:~/code/pymysql# cat pymysql_demo.py
import pymysql  #导入 pymysql
db= pymysql.connect(host="localhost",
                    user="root",
                    password="root",
                    db="leco",
                    port=3306,
                    charset='utf8')

# 使用cursor()方法获取操作游标
cur = db.cursor()

# 1.查询操作
# 编写sql 查询语句  tb_dept 对应我的表名
sql = "select * from tb_dept"
try:
    cur.execute(sql) 	        # 执行sql语句

    results = cur.fetchall()	# 获取查询的所有记录
    print("id","name","description")
    # 遍历结果
    for row in results :
        id = row[0]
        name = row[1]
        info = row[2]
        print(id,name,info)
except Exception as e:
    raise e
finally:
    db.close()	#关闭连接
```
运行结果

```
root@leco:~/code/pymysql# python3 pymysql_demo.py
id name description
1 张三 IT
2 李四 Sale
```


!!! tip "参数解释"
    ```python
    db= pymysql.connect(host="localhost",  # mysql server IP
                    user="root",           # 登录MySQL账号
                    password="root",       # 登录MySQL的用户
                    db="leco",             # MySQL用户的密码      
                    port=3306,             # MySQL的端口
                    charset='utf8')        # 指定字符集，否则中文会乱码
    ```

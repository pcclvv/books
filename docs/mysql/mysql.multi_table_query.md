<center><h1> MySQL 对表查询  </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; MySQL，重中之重来了。

- 多表连接查询
- 复合条件连接查询
- 子查询


```
select * from employee inner join department on employee.dep_id=department.id;
select * from employee left join department on employee.dep_id=department.id;
select * from employee right join department on employee.dep_id=department.id;
```

### 1.1 环境准备

```
use db1;
create table department(
    id int,
    name varchar(20) 
);
create table employee(
    id int primary key auto_increment,
    name varchar(20),
    sex enum('male','female') not null default 'male',
    age int,
    dep_id int
);
insert into department values
(200,'技术'),
(201,'人力资源'),
(202,'销售'),
(203,'运营');

insert into employee(name,sex,age,dep_id) values
('陈裕光','male',18,200),
('乐珈彤','female',48,201),
('朱慧珊','male',38,201),
('科琳·玛丽诺','female',28,202),
('伊万·伦德尔','male',18,200),
('亚伦·迪亚兹','female',18,204);
show tables;
desc department;
desc employee;
select * from department;
select * from employee;
```
执行过程

```
leco@leco:~$ mysql -uroot -proot
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 125
Server version: 5.7.25-0ubuntu0.16.04.2-log (Ubuntu)

Copyright (c) 2000, 2019, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

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
1 row in set (0.00 sec)

mysql> use db1;
Database changed
mysql> create table department(
    ->     id int,
    ->     name varchar(20)
    -> );
artment values
(200,'技术'),
(201,'人力资源'),
(202,'销售'),
(203,'运营');

insert into employee(name,sex,age,dep_id) values
('陈裕光','male',18,200),
('乐珈彤','female',48,201),
('朱慧珊','male',38,201),
('科琳·玛丽诺','female',28,202),
('伊万·伦德尔','male',18,200),
('亚伦·迪亚兹','female',18,204);Query OK, 0 rows affected (0.08 sec)

mysql> create table employee(
    ->     id int primary key auto_increment,
    ->     name varchar(20),
    ->     sex enum('male','female') not null default 'male',
    ->     age int,
    ->     dep_id int
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> insert into department values
    -> (200,'技术'),
    -> (201,'人力资源'),
    -> (202,'销售'),
    -> (203,'运营');
Query OK, 4 rows affected (0.02 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql>
mysql> insert into employee(name,sex,age,dep_id) values
    -> ('陈裕光','male',18,200),
    -> ('乐珈彤','female',48,201),
    -> ('朱慧珊','male',38,201),
    -> ('科琳·玛丽诺','female',28,202),
    -> ('伊万·伦德尔','male',18,200),
    -> ('亚伦·迪亚兹','female',18,204);
Query OK, 6 rows affected (0.01 sec)
Records: 6  Duplicates: 0  Warnings: 0
mysql> show tables;
+---------------+
| Tables_in_db1 |
+---------------+
| department    |
| employee      |
| t1            |
+---------------+
3 rows in set (0.00 sec)

mysql> desc department;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | YES  |     | NULL    |       |
| name  | varchar(20) | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> desc employee;
+--------+-----------------------+------+-----+---------+----------------+
| Field  | Type                  | Null | Key | Default | Extra          |
+--------+-----------------------+------+-----+---------+----------------+
| id     | int(11)               | NO   | PRI | NULL    | auto_increment |
| name   | varchar(20)           | YES  |     | NULL    |                |
| sex    | enum('male','female') | NO   |     | male    |                |
| age    | int(11)               | YES  |     | NULL    |                |
| dep_id | int(11)               | YES  |     | NULL    |                |
+--------+-----------------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)

mysql> select * from department;
+------+--------------+
| id   | name         |
+------+--------------+
|  200 | 技术         |
|  201 | 人力资源     |
|  202 | 销售         |
|  203 | 运营         |
+------+--------------+
4 rows in set (0.00 sec)

mysql> select * from employee;
+----+-------------------+--------+------+--------+
| id | name              | sex    | age  | dep_id |
+----+-------------------+--------+------+--------+
|  1 | 陈裕光            | male   |   18 |    200 |
|  3 | 乐珈彤            | female |   48 |    201 |
|  5 | 朱慧珊            | male   |   38 |    201 |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |
| 11 | 亚伦·迪亚兹       | female |   18 |    204 |
+----+-------------------+--------+------+--------+
6 rows in set (0.00 sec)
```


## 2. 多表连接查询

```
# 重点：外链接语法

SELECT 字段列表
    FROM 表1 INNER|LEFT|RIGHT JOIN 表2
    ON 表1.字段 = 表2.字段;
```

### 2.1 交叉连接
&#160; &#160; &#160; &#160; 不适用任何匹配条件。生成笛卡尔积

```
mysql> select * from employee,department;
+----+-------------------+--------+------+--------+------+--------------+
| id | name              | sex    | age  | dep_id | id   | name         |
+----+-------------------+--------+------+--------+------+--------------+
|  1 | 陈裕光            | male   |   18 |    200 |  200 | 技术         |
|  1 | 陈裕光            | male   |   18 |    200 |  201 | 人力资源     |
|  1 | 陈裕光            | male   |   18 |    200 |  202 | 销售         |
|  1 | 陈裕光            | male   |   18 |    200 |  203 | 运营         |
|  3 | 乐珈彤            | female |   48 |    201 |  200 | 技术         |
|  3 | 乐珈彤            | female |   48 |    201 |  201 | 人力资源     |
|  3 | 乐珈彤            | female |   48 |    201 |  202 | 销售         |
|  3 | 乐珈彤            | female |   48 |    201 |  203 | 运营         |
|  5 | 朱慧珊            | male   |   38 |    201 |  200 | 技术         |
|  5 | 朱慧珊            | male   |   38 |    201 |  201 | 人力资源     |
|  5 | 朱慧珊            | male   |   38 |    201 |  202 | 销售         |
|  5 | 朱慧珊            | male   |   38 |    201 |  203 | 运营         |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |  200 | 技术         |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |  201 | 人力资源     |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |  202 | 销售         |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |  203 | 运营         |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |  200 | 技术         |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |  201 | 人力资源     |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |  202 | 销售         |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |  203 | 运营         |
| 11 | 亚伦·迪亚兹       | female |   18 |    204 |  200 | 技术         |
| 11 | 亚伦·迪亚兹       | female |   18 |    204 |  201 | 人力资源     |
| 11 | 亚伦·迪亚兹       | female |   18 |    204 |  202 | 销售         |
| 11 | 亚伦·迪亚兹       | female |   18 |    204 |  203 | 运营         |
+----+-------------------+--------+------+--------+------+--------------+
24 rows in set (0.00 sec)
```

### 2.2 内连接
&#160; &#160; &#160; &#160; 只连接匹配的行。

- 找两张表共有的部分，相当于利用条件从笛卡尔积结果中筛选出了正确的结果
- department没有204这个部门，因而employee表中关于204这条员工信息没有匹配出来


```
select employee.id,employee.name,employee.age,employee.sex,department.name from employee inner join department on employee.dep_id=department.id;

或者

select * from employee inner join department on employee.dep_id=department.id;
```


```
mysql> select employee.id,employee.name,employee.age,employee.sex,department.name from employee inner join department on employee.dep_id=department.id;
+----+-------------------+------+--------+--------------+
| id | name              | age  | sex    | name         |
+----+-------------------+------+--------+--------------+
|  1 | 陈裕光            |   18 | male   | 技术         |
|  3 | 乐珈彤            |   48 | female | 人力资源     |
|  5 | 朱慧珊            |   38 | male   | 人力资源     |
|  7 | 科琳·玛丽诺       |   28 | female | 销售         |
|  9 | 伊万·伦德尔       |   18 | male   | 技术         |
+----+-------------------+------+--------+--------------+
5 rows in set (0.00 sec)

mysql>  select * from employee inner join department on employee.dep_id=department.id;
+----+-------------------+--------+------+--------+------+--------------+
| id | name              | sex    | age  | dep_id | id   | name         |
+----+-------------------+--------+------+--------+------+--------------+
|  1 | 陈裕光            | male   |   18 |    200 |  200 | 技术         |
|  3 | 乐珈彤            | female |   48 |    201 |  201 | 人力资源     |
|  5 | 朱慧珊            | male   |   38 |    201 |  201 | 人力资源     |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |  202 | 销售         |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |  200 | 技术         |
+----+-------------------+--------+------+--------+------+--------------+
5 rows in set (0.00 sec)

```

### 2.3 左连接
&#160; &#160; &#160; &#160; 优先显示左表全部记录

- 以左表为准，即找出所有员工信息，当然包括没有部门的员工
- 本质就是：在内连接的基础上增加左边有右边没有的结果

```
mysql> select employee.id,employee.name,department.name as depart_name from employee left join department on employee.dep_id=department.id;
+----+-------------------+--------------+
| id | name              | depart_name  |
+----+-------------------+--------------+
|  1 | 陈裕光            | 技术         |
|  9 | 伊万·伦德尔       | 技术         |
|  3 | 乐珈彤            | 人力资源     |
|  5 | 朱慧珊            | 人力资源     |
|  7 | 科琳·玛丽诺       | 销售         |
| 11 | 亚伦·迪亚兹       | NULL         |
+----+-------------------+--------------+
6 rows in set (0.00 sec)
```

### 2.4 右连接
&#160; &#160; &#160; &#160; 优先显示右表全部记录

- 以右表为准，即找出所有部门信息，包括没有员工的部门
- 本质就是：在内连接的基础上增加右边有左边没有的结果

```
mysql> select employee.id,employee.name,department.name as depart_name from employee right join department onemployee.dep_id=department.id;
+------+-------------------+--------------+
| id   | name              | depart_name  |
+------+-------------------+--------------+
|    1 | 陈裕光            | 技术         |
|    3 | 乐珈彤            | 人力资源     |
|    5 | 朱慧珊            | 人力资源     |
|    7 | 科琳·玛丽诺       | 销售         |
|    9 | 伊万·伦德尔       | 技术         |
| NULL | NULL              | 运营         |
+------+-------------------+--------------+
6 rows in set (0.00 sec)
```

### 2.4 全外连接
&#160; &#160; &#160; &#160; 显示左右两个表全部记录

```
全外连接：在内连接的基础上增加左边有右边没有的和右边有左边没有的结果
注意：mysql不支持全外连接 full JOIN
强调：mysql可以使用此种方式间接实现全外连接
```

```
mysql> select * from employee left join department on employee.dep_id = department.id
    -> union
    -> select * from employee right join department on employee.dep_id = department.id
    -> ;
+------+-------------------+--------+------+--------+------+--------------+
| id   | name              | sex    | age  | dep_id | id   | name         |
+------+-------------------+--------+------+--------+------+--------------+
|    1 | 陈裕光            | male   |   18 |    200 |  200 | 技术         |
|    9 | 伊万·伦德尔       | male   |   18 |    200 |  200 | 技术         |
|    3 | 乐珈彤            | female |   48 |    201 |  201 | 人力资源     |
|    5 | 朱慧珊            | male   |   38 |    201 |  201 | 人力资源     |
|    7 | 科琳·玛丽诺       | female |   28 |    202 |  202 | 销售         |
|   11 | 亚伦·迪亚兹       | female |   18 |    204 | NULL | NULL         |
| NULL | NULL              | NULL   | NULL |   NULL |  203 | 运营         |
+------+-------------------+--------+------+--------+------+--------------+
7 rows in set (0.00 sec)
```

### 2.5 符合条件连接查询
&#160; &#160; &#160; &#160; 以内连接的方式查询employee和department表，并且employee表中的age字段值必须大于25,即找出年龄大于25岁的员工以及员工所在的部门

```
mysql> select employee.name,department.name from employee inner join department
    ->     on employee.dep_id = department.id
    ->     where age > 25;
+-------------------+--------------+
| name              | name         |
+-------------------+--------------+
| 乐珈彤            | 人力资源     |
| 朱慧珊            | 人力资源     |
| 科琳·玛丽诺       | 销售         |
+-------------------+--------------+
3 rows in set (0.00 sec)
```


&#160; &#160; &#160; &#160; 以内连接的方式查询employee和department表，并且以age字段的升序方式显示

```
mysql> select employee.id,employee.name,employee.age,department.name from employee,department
    ->     where employee.dep_id = department.id
    ->     and age > 25
    ->     order by age asc;
+----+-------------------+------+--------------+
| id | name              | age  | name         |
+----+-------------------+------+--------------+
|  7 | 科琳·玛丽诺       |   28 | 销售         |
|  5 | 朱慧珊            |   38 | 人力资源     |
|  3 | 乐珈彤            |   48 | 人力资源     |
+----+-------------------+------+--------------+
3 rows in set (0.00 sec)

```


## 3. 子查询

- 子查询是将一个查询语句嵌套在另一个查询语句中。
- 内层查询语句的查询结果，可以为外层查询语句提供查询条件。
- 子查询中可以包含：IN、NOT IN、ANY、ALL、EXISTS 和 NOT EXISTS等关键字
- 还可以包含比较运算符：= 、 !=、> 、<等

### 3.1 IN
&#160; &#160; &#160; &#160;带IN关键字的子查询

- 查询平均年龄在25岁以上的部门名
```
select id,name from department
    where id in 
        (select dep_id from employee group by dep_id having avg(age) > 25);

mysql> select id,name from department
    ->     where id in
    ->         (select dep_id from employee group by dep_id having avg(age) > 25);
+------+--------------+
| id   | name         |
+------+--------------+
|  201 | 人力资源     |
|  202 | 销售         |
+------+--------------+
2 rows in set (0.00 sec)
```

- 查看技术部员工姓名

```
select name from employee
    where dep_id in 
        (select id from department where name='技术');
        
mysql> select name from employee
    ->     where dep_id in
    ->         (select id from department where name='技术');
+-------------------+
| name              |
+-------------------+
| 陈裕光            |
| 伊万·伦德尔       |
+-------------------+
2 rows in set (0.00 sec)
```

- 查看不足1人的部门名

```
select name from department
    where id in 
        (select dep_id from employee group by dep_id having count(id) <=1);
        
mysql> select name from department
    ->     where id in
    ->         (select dep_id from employee group by dep_id having count(id) <=1);
+--------+
| name   |
+--------+
| 销售   |
+--------+
1 row in set (0.00 sec)
```

### 3.2 比较运算符
&#160; &#160; &#160; &#160;带比较运算符的子查询，比较运算符：=、!=、>、>=、<、<=、<>

- 查询大于所有人平均年龄的员工名与年龄

```
mysql> select name,age from employee where age > (select avg(age) from employee);
+-----------+------+
| name      | age  |
+-----------+------+
| 乐珈彤    |   48 |
| 朱慧珊    |   38 |
+-----------+------+
2 rows in set (0.00 sec)
```

- 查询大于部门内平均年龄的员工名、年龄

```
select t1.name,t1.age from emp t1
inner join 
(select dep_id,avg(age) avg_age from emp group by dep_id) t2
on t1.dep_id = t2.dep_id
where t1.age > t2.avg_age;

mysql> select t1.name,t1.age from employee t1
    -> inner join
    -> (select dep_id,avg(age) avg_age from employee group by dep_id) t2
    -> on t1.dep_id = t2.dep_id
    -> where t1.age > t2.avg_age;
+-----------+------+
| name      | age  |
+-----------+------+
| 乐珈彤    |   48 |
+-----------+------+
1 row in set (0.00 sec)

```

### 3.3 EXISTS
&#160; &#160; &#160; &#160;带EXISTS关键字的子查询，EXISTS关字键字表示存在。在使用EXISTS关键字时，内层查询语句不返回查询的记录。而是返回一个真假值，True或False。当返回True时，外层查询语句将进行查询；当返回值为False时，外层查询语句不进行查询。

- department表中存在dept_id=203，Ture

```
select * from employee
    where exists
        (select id from department where id=200);
        
mysql> select * from employee
    ->     where exists
    ->         (select id from department where id=200);
+----+-------------------+--------+------+--------+
| id | name              | sex    | age  | dep_id |
+----+-------------------+--------+------+--------+
|  1 | 陈裕光            | male   |   18 |    200 |
|  3 | 乐珈彤            | female |   48 |    201 |
|  5 | 朱慧珊            | male   |   38 |    201 |
|  7 | 科琳·玛丽诺       | female |   28 |    202 |
|  9 | 伊万·伦德尔       | male   |   18 |    200 |
| 11 | 亚伦·迪亚兹       | female |   18 |    204 |
+----+-------------------+--------+------+--------+
6 rows in set (0.00 sec)
```

- department表中存在dept_id=205，False

```
select * from employee
    where exists
        (select id from department where id=204);

mysql> select * from employee
    ->     where exists
    ->         (select id from department where id=204);
Empty set (0.00 sec)
```


!!! note "union union all"
    ```python
    UNION 语句：用于将不同表中相同列中查询的数据展示出来     （不包括重复数据）
    UNION ALL 语句：用于将不同表中相同列中查询的数据展示出来 （包括重复数据）
    ```

```
mysql> select * from employee left join department on employee.dep_id = department.id
    -> union
    -> select * from employee right join department on employee.dep_id = department.id
    -> ;
+------+-------------------+--------+------+--------+------+--------------+
| id   | name              | sex    | age  | dep_id | id   | name         |
+------+-------------------+--------+------+--------+------+--------------+
|    1 | 陈裕光            | male   |   18 |    200 |  200 | 技术         |
|    9 | 伊万·伦德尔       | male   |   18 |    200 |  200 | 技术         |
|    3 | 乐珈彤            | female |   48 |    201 |  201 | 人力资源     |
|    5 | 朱慧珊            | male   |   38 |    201 |  201 | 人力资源     |
|    7 | 科琳·玛丽诺       | female |   28 |    202 |  202 | 销售         |
|   11 | 亚伦·迪亚兹       | female |   18 |    204 | NULL | NULL         |
| NULL | NULL              | NULL   | NULL |   NULL |  203 | 运营         |
+------+-------------------+--------+------+--------+------+--------------+
7 rows in set (0.00 sec)

mysql> select * from employee left join department on employee.dep_id = department.id
    -> union all
    -> select * from employee right join department on employee.dep_id = department.id;
+------+-------------------+--------+------+--------+------+--------------+
| id   | name              | sex    | age  | dep_id | id   | name         |
+------+-------------------+--------+------+--------+------+--------------+
|    1 | 陈裕光            | male   |   18 |    200 |  200 | 技术         |
|    9 | 伊万·伦德尔       | male   |   18 |    200 |  200 | 技术         |
|    3 | 乐珈彤            | female |   48 |    201 |  201 | 人力资源     |
|    5 | 朱慧珊            | male   |   38 |    201 |  201 | 人力资源     |
|    7 | 科琳·玛丽诺       | female |   28 |    202 |  202 | 销售         |
|   11 | 亚伦·迪亚兹       | female |   18 |    204 | NULL | NULL         |
|    1 | 陈裕光            | male   |   18 |    200 |  200 | 技术         |
|    3 | 乐珈彤            | female |   48 |    201 |  201 | 人力资源     |
|    5 | 朱慧珊            | male   |   38 |    201 |  201 | 人力资源     |
|    7 | 科琳·玛丽诺       | female |   28 |    202 |  202 | 销售         |
|    9 | 伊万·伦德尔       | male   |   18 |    200 |  200 | 技术         |
| NULL | NULL              | NULL   | NULL |   NULL |  203 | 运营         |
+------+-------------------+--------+------+--------+------+--------------+
12 rows in set (0.00 sec)
```


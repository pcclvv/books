<center><h1> MySQL 正则 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; MySQL可以通过 LIKE ...% 来进行模糊匹配。

&#160; &#160; &#160; &#160; MySQL 同样也支持其他正则表达式的匹配， MySQL中使用 REGEXP 操作符来进行正则表达式匹配。

&#160; &#160; &#160; &#160; 下表中的正则模式可应用于 REGEXP 操作符中。

表达式 | 描述
---|---
^	|匹配输入字符串的开始位置。如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置。
$	|匹配输入字符串的结束位置。如果设置了RegExp 对象的 Multiline 属性，$ 也匹配 '\n' 或 '\r' 之前的位置。
.	|匹配除 "\n" 之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用象 '[.\n]' 的模式。
[...]	|字符集合。匹配所包含的任意一个字符。例如， '[abc]' 可以匹配 "plain" 中的 'a'。
[^...]	|负值字符集合。匹配未包含的任意字符。例如， '[^abc]' 可以匹配 "plain" 中的'p'。
p1\|p2\|p3	|匹配 p1 或 p2 或 p3。例如，'z|food' 能匹配 "z" 或 "food"。'(z|f)ood' 则匹配 "zood" 或 "food"。
*	|匹配前面的子表达式零次或多次。例如，zo* 能匹配 "z" 以及 "zoo"。* 等价于{0,}。
+	|匹配前面的子表达式一次或多次。例如，'zo+' 能匹配 "zo" 以及 "zoo"，但不能匹配 "z"。+ 等价于 {1,}。
{n}	|n 是一个非负整数。匹配确定的 n 次。例如，'o{2}' 不能匹配 "Bob" 中的 'o'，但是能匹配 "food" 中的两个 o。
{n,m}	|m 和 n 均为非负整数，其中n <= m。最少匹配 n 次且最多匹配 m 次。

## 2. 例子
### 2.1 环境准备

```
use leco;
drop table info;
create table info(
name varchar(40) NOT NULL,
count  int
);
insert into info(name,count) values("北京",1);
insert into info(name,count) values("南京",2);
insert into info(name,count) values("上海",3);
insert into info(name,count) values("宿迁",4);
insert into info(name,count) values("okay",5);
insert into info(name,count) values("market",6);
insert into info(name,count) values("aecdada",7);
insert into info(name,count) values("ccmz",8);
insert into info(name,count) values("cccmz",9);
insert into info(name,count) values("ccccmz",10);
desc info;
select * from info;

```

### 2.2 执行过程

```
mysql> use leco;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> drop table info;
Query OK, 0 rows affected (0.05 sec)

mysql> create table info(
    -> name varchar(40) NOT NULL,
    -> count  int
    -> );
Query OK, 0 rows affected (0.07 sec)

mysql> insert into info(name,count) values("北京",1);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("南京",2);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("上海",3);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("宿迁",4);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("okay",5);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("market",6);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(name,count) values("aecdada",7);
Query OK, 1 row affected (0.02 sec)

mysql> insert into info(name,count) values("ccmz",8);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(name,count) values("cccmz",9);
Query OK, 1 row affected (0.01 sec)

mysql> insert into info(name,count) values("ccccmz",10);
Query OK, 1 row affected (0.02 sec)

mysql> desc info;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| name  | varchar(40) | NO   |     | NULL    |       |
| count | int(11)     | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+
2 rows in set (0.00 sec)

mysql> select * from info;
+---------+-------+
| name    | count |
+---------+-------+
| 北京    |     1 |
| 南京    |     2 |
| 上海    |     3 |
| 宿迁    |     4 |
| okay    |     5 |
| market  |     6 |
| aecdada |     7 |
| ccmz    |     8 |
| cccmz   |     9 |
| ccccmz  |    10 |
+---------+-------+
10 rows in set (0.00 sec)

```

### 2.3 以开头
查找name字段中以'宿'为开头的所有数据

```
mysql> SELECT name FROM info WHERE name REGEXP '^宿';
+--------+
| name   |
+--------+
| 宿迁   |
+--------+
1 row in set (0.00 sec)
```

### 2.3 以结尾
查找name字段中以'ay'为结尾的所有数据

```
mysql> SELECT name FROM info WHERE name REGEXP 'ay$';
+------+
| name |
+------+
| okay |
+------+
1 row in set (0.00 sec)
```

### 2.4 包含
查找name字段中包含'京'字符串的所有数据

```
mysql> SELECT name FROM info WHERE name REGEXP '京';
+--------+
| name   |
+--------+
| 北京   |
| 南京   |
+--------+
2 rows in set (0.00 sec)
```

### 2.5 或者
r表示匹配其中之一，功能雷同与select语句中的or语句，多个or条件可并入单个正则表达式
```
mysql> SELECT name FROM info WHERE name REGEXP '^[上]|da$';
+---------+
| name    |
+---------+
| 上海    |
| aecdada |
+---------+
2 rows in set (0.00 sec)
```

### 2.6 +

```
mysql> SELECT name FROM info WHERE name REGEXP 'c+';
+---------+
| name    |
+---------+
| aecdada |
| ccmz    |
| cccmz   |
| ccccmz  |
+---------+
4 rows in set (0.00 sec)

```

### 2.7 n

```
mysql> SELECT name FROM info WHERE name REGEXP 'c{2,3}';
+--------+
| name   |
+--------+
| ccmz   |
| cccmz  |
| ccccmz |
+--------+
3 rows in set (0.00 sec)

```

### 2.8 n,m

```
mysql> SELECT name FROM info WHERE name REGEXP 'c{3,}';
+--------+
| name   |
+--------+
| cccmz  |
| ccccmz |
+--------+
2 rows in set (0.00 sec)

```

### 2.9 *

```
mysql>  SELECT name FROM info WHERE name REGEXP 'cc*';
+---------+
| name    |
+---------+
| aecdada |
| ccmz    |
| cccmz   |
| ccccmz  |
+---------+
4 rows in set (0.00 sec)
```
> 匹配型号前面的c的次数是0次到多次。

### 2.10 范围
&#160; &#160; &#160; &#160;集合可以用来定义要匹配的一个或多个字符，比如[0123456789]，为了简化这种类型的集合，可使用（-）来定义一个范围，即[0-9]；（范围不仅仅局限于数值，还可以使字母字符等）

```
mysql>  SELECT * from info;
+---------+-------+
| name    | count |
+---------+-------+
| market  |     6 |
| aecdada |     7 |
| ccmz    |     8 |
| cccmz   |     9 |
| ccccmz  |    10 |
+---------+-------+
5 rows in set (0.00 sec)

mysql> select * from info where count regexp '[0-8]';
+---------+-------+
| name    | count |
+---------+-------+
| market  |     6 |
| aecdada |     7 |
| ccmz    |     8 |
| ccccmz  |    10 |
+---------+-------+
4 rows in set (0.00 sec)
```


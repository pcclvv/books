<center><h1> MySQL SELECT </h1></center>

## 1. 介绍

&#160; &#160; &#160; &#160; 我们执行的SQL执行顺序

```
(8)SELECT (9)DISTINCT  (11)<Top Num> <select list>
(1)FROM [left_table]
(3)<join_type> JOIN <right_table>
(2)        ON <join_condition>
(4)WHERE <where_condition>
(5)GROUP BY <group_by_list>
(6)WITH <CUBE | RollUP>
(7)HAVING <having_condition>
(10)ORDER BY <order_by_list> 
```

## 2. select 用法

&#160; &#160; &#160; &#160;SELECT 语句用于从表中选取数据。结果被存储在一个结果表中（称为结果集），基本语法如下:

### 2.1 显示字段
```
SELECT 列名称 FROM 表名称;
```
例子

```
mysql> select name from leco;
+--------+
| name   |
+--------+
| 张三   |
| 李四   |
| 王五   |
| 赵六   |
+--------+
4 rows in set (0.00 sec)

mysql> mysql> select name,age from leco;
+--------+------+
| name   | age  |
+--------+------+
| 张三   |   18 |
| 李四   |   20 |
| 王五   |   30 |
| 赵六   |   40 |
+--------+------+
4 rows in set (0.00 sec)
```

### 2.2 显示所有字段

```
SELECT * FROM 表名称;
```

??? danger "注意"
    ```python
    1. 星号，表示所有，数据比较大的时候，一定不能直接这样使用
    ```
    
例子

```
mysql> use cmz;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from leco;
+------+--------+--------+------+
| id   | name   | sex    | age  |
+------+--------+--------+------+
|    1 | 张三   | female |   18 |
|    2 | 李四   | male   |   20 |
|    3 | 王五   | male   |   30 |
|    4 | 赵六   | female |   40 |
+------+--------+--------+------+
4 rows in set (0.00 sec)
```

??? tip "注意"
    ```python
    1. mysql的sql语句不区分大小写
    2. 所有select 等于SELECT，我习惯小写
    ```
    
## 3. 注意点
&#160; &#160; &#160; &#160;SELECT就是数据库中的查询语句，能查询你想要的数据，比如所有人员的信息包括ID，姓名，性别，年龄，等。也可以选择其中一部分。

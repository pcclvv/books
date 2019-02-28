<center><h1> MongoDB 集合操作</h1></center>


## 1. 集合语法
### 1.1 创建语法
&#160; &#160; &#160; &#160;MongoDB 中使用 createCollection() 方法来创建集合。语法格式：

```
db.createCollection(name, options)
```

!!! note "参数说明"
    ```python
    name:    要创建的集合名称
    options: 可选参数, 指定有关内存大小及索引的选项
    ```
    
&#160; &#160; &#160; &#160;options 可以是如下参数：

字段 | 类型 | 描述
---|---|---
capped|	布尔|	（可选）如果为 true，则创建固定集合。固定集合是指有着固定大小的集合，当达到最大值时，它会自动覆盖最早的文档。当该值为 true 时，必须指定 size 参数。
autoIndexId	|布尔|	（可选）如为 true，自动在 _id 字段创建索引。默认为 false。
size|	数值|	（可选）为固定集合指定一个最大值（以字节计）。如果 capped 为 true，也需要指定该字段。
max	|数值	|（可选）指定固定集合中包含文档的最大数量。


&#160; &#160; &#160; &#160;在插入文档时，MongoDB 首先检查固定集合的 size 字段，然后检查 max 字段。


### 1.2 删除语法   
&#160; &#160; &#160; &#160;MongoDB 中使用 drop() 方法来删除集合。

```
db.collection.drop()
```
&#160; &#160; &#160; &#160;如果成功删除选定集合，则 drop() 方法返回 true，否则返回 false。

   
## 2. 创建操作
### 2.1 创建集合
&#160; &#160; &#160; &#160;在 cmz 数据库中创建 col 集合：

```
> show dbs;
admin   0.000GB
config  0.000GB
local   0.000GB
> use cmz;
switched to db cmz
> db.test.insert({"name":"caimengzhi"})
WriteResult({ "nInserted" : 1 })
> db.createCollection('col')
{ "ok" : 1 }
> show dbs;
admin   0.000GB
cmz     0.000GB
config  0.000GB
local   0.000GB
```

### 2.2 查看集合
&#160; &#160; &#160; &#160;在 cmz 数据库中创建 col 集合：
如果要查看已有集合，可以使用 show collections 命令：

```
> show collections
col
test
> show tables;
col
test
```

### 2.4 自动创建

&#160; &#160; &#160; &#160;在 MongoDB 中，你不需要创建集合。当你插入一些文档时，MongoDB 会自动创建集合。
```
> db.col2.insert({"name":"caimengzhi"})
WriteResult({ "nInserted" : 1 })
> show tables
col
col2
test
```

## 3. 删除操作
### 3.1 删除集合
&#160; &#160; &#160; &#160;在数据库 mydb 中，我们可以先通过 show collections 命令查看已存在的集合：

```
> use cmz
switched to db cmz
> show tables;
col
col2
test
> db.col2.drop()
true
> show tables
col
test
```
从结果中可以看出 col2 集合已被删除。


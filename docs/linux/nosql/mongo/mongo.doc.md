<center><h1> MongoDB 文档操作</h1></center>
## 1. 文档操作
&#160; &#160; &#160; &#160;文档的数据结构和JSON基本一样。所有存储在集合中的数据都是BSON格式。BSON是一种类json的一种二进制形式的存储格式,简称Binary JSON。

### 1.1 插入文档
&#160; &#160; &#160; &#160;MongoDB 使用 insert() 或 save() 方法向集合中插入文档，语法如下：

```
db.COLLECTION_NAME.insert(document)
```

### 1.2 删除文档   
&#160; &#160; &#160; &#160;MongoDB remove()函数是用来移除集合中的数据。MongoDB数据更新可以使用update()函数。在执行remove()函数前先执行find()命令来判断执行的条件是否正确，这是一个比较好的习惯。

- 2.6 以前版本

```
db.collection.remove(
   <query>,
   <justOne>
)
```

- 2.6 以后版本

```
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
```
 
!!! tip "参数说明"
    ```python
    1. query :       （可选）删除的文档的条件。
    2. justOne :     （可选）如果设为 true 或 1，则只删除一个文档，如果不设置该参数，或使用默认值 false，则删除所有匹配条件的文档。
    3. writeConcern :（可选）抛出异常的级别。
    ```

### 1.3 更新文档 
&#160; &#160; &#160; &#160;MongoDB 使用 update() 和 save() 方法来更新集合中的文档。接下来让我们详细来看下两个函数的应用及其区别。

#### 1.3.1 update() 
&#160; &#160; &#160; &#160;方法用于更新已存在的文档。语法格式如下：

```
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
```

!!! tip "参数说明"
    ```python
    query :  update的查询条件，类似sql update查询内where后面的。
    update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
    upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
    multi :  可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
    writeConcern :可选，抛出异常的级别。
    ```

#### 1.3.2 save() 方法
&#160; &#160; &#160; &#160; save() 方法通过传入的文档来替换已有文档。语法格式如下：

```
db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)
```
!!! tip "参数说明"
    ```python
    document : 文档数据。
    writeConcern :可选，抛出异常        

    ```

### 1.4 查询文档 
&#160; &#160; &#160; &#160;MongoDB 查询文档使用 find() 方法。find() 方法以非结构化的方式来显示所有文档。

&#160; &#160; &#160; &#160;MongoDB 查询数据的语法格式如下：

```
db.collection.find(query, projection)
```

!!! tip "参数说明"
    ```python
    1. query ：可选，使用查询操作符指定查询条件
    2. projection ：可选，使用投影操作符指定返回的键。查询时返回文档中所有键值， 只需省略该参数即可（默认省略）。
    
    ```
    
&#160; &#160; &#160; &#160;如果你需要以易读的方式来读取数据，可以使用 pretty() 方法，语法格式如下：

```
db.col.find().pretty()
```



---
   
## 2. 插入操作
### 2.1 插入文档
&#160; &#160; &#160; &#160;以下文档可以存储在 MongoDB 的 runoob 数据库 的 col 集合中：

```
db.col.insert({title: 'Books 教程', 
    description: '笔记',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 66
})
```
操作过程如下

```
> db
cmz
> show tables;
test
> db.col.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 66
... })
WriteResult({ "nInserted" : 1 })
> show tables;
col
test
```
&#160; &#160; &#160; &#160; 以上实例中 col 是我们的集合名，如果该集合不在该数据库中， MongoDB 会自动创建该集合并插入文档。

### 2.2 查看已插入文档：

```
> db.col.find()
{ "_id" : ObjectId("5c7601540a9870df1141b6be"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
> db.col.find().pretty()
{
	"_id" : ObjectId("5c7601540a9870df1141b6be"),
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 66
}
```

&#160; &#160; &#160; &#160; 我们也可以将数据定义为一个变量，如下所示：

```
document = ({title: 'Books 教程', 
    description: '笔记',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 66
})
```

&#160; &#160; &#160; &#160; 操作过程如下

```
> document = ({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 88
... })
{
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 88
}
>  db.col.insert(document)
WriteResult({ "nInserted" : 1 })

> db.col.find()
{ "_id" : ObjectId("5c7601540a9870df1141b6be"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
{ "_id" : ObjectId("5c76025e513e73f526b80a4c"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
>
```
&#160; &#160; &#160; &#160; 插入文档你也可以使用 db.col.save(document) 命令。如果不指定 _id 字段 save() 方法类似于 insert() 方法。如果指定 _id 字段，则会更新该 _id 的数据。


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
### 3.1 删除文档
&#160; &#160; &#160; &#160;先查询。

```
> db.col.find()
{ "_id" : ObjectId("5c7601540a9870df1141b6be"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
{ "_id" : ObjectId("5c7602120a9870df1141b6bf"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
{ "_id" : ObjectId("5c76025e513e73f526b80a4c"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
```
&#160; &#160; &#160; &#160; 接下来我们移除 likes 为 66 的文档：

```
> db.col.remove({'likes':66})
WriteResult({ "nRemoved" : 2 })  # 删除了两条数据
> db.col.find()
{ "_id" : ObjectId("5c76025e513e73f526b80a4c"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
```

&#160; &#160; &#160; &#160;如果你只想删除第一条找到的记录可以设置 justOne 为 1，如下所示：

```
> db.col.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 66
... })
WriteResult({ "nInserted" : 1 })
> db.col.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 66
... })
WriteResult({ "nInserted" : 1 })
> db.col.find()
{ "_id" : ObjectId("5c76025e513e73f526b80a4c"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
{ "_id" : ObjectId("5c76043e513e73f526b80a4d"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
{ "_id" : ObjectId("5c760441513e73f526b80a4e"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }

# 删除
> db.col.remove({'likes':66},1)
WriteResult({ "nRemoved" : 1 })
> db.col.find()
{ "_id" : ObjectId("5c76025e513e73f526b80a4c"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
{ "_id" : ObjectId("5c760441513e73f526b80a4e"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
```

&#160; &#160; &#160; &#160;如果你想删除所有数据，可以使用以下方式（类似常规 SQL 的 truncate 命令）：

```
> db.col.find()
{ "_id" : ObjectId("5c76025e513e73f526b80a4c"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
{ "_id" : ObjectId("5c760441513e73f526b80a4e"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 66 }
> db.col.remove({})
WriteResult({ "nRemoved" : 2 })
> db.col.find()
```


## 4. 更新操作
### 4.1 update
&#160; &#160; &#160; &#160;我们在集合 col 中插入如下数据：
```
db.col2.insert({title: 'Books 教程', 
    description: '笔记',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 'update 方法'
})
```
&#160; &#160; &#160; &#160; 操作过程
```
> db.col2.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 'update 方法'
... })
WriteResult({ "nInserted" : 1 })
> show tables
col
col2
test
```
&#160; &#160; &#160; &#160; 接着我们通过 update() 方法来更新标题(title):

```
> db.col2.find()
{ "_id" : ObjectId("5c76067e8a8ce9812e5a5980"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }
> db.col2.update({'title':'Books 教程'},{$set:{'title':'cmz noteBooks'}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.col2.find()
{ "_id" : ObjectId("5c76067e8a8ce9812e5a5980"), "title" : "cmz noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }
```
&#160; &#160; &#160; &#160;可以看到标题(title)由原来的 "Books 教程" 更新为了 "cmz noteBooks"。

&#160; &#160; &#160; &#160;以上语句只会修改第一条发现的文档，如果你要修改多条相同的文档，则需要设置 multi 参数为 true。

```
db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}},{multi:true})
```
&#160; &#160; &#160; &#160;操作过程

```
> db.col2.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 'update 方法'
... })
WriteResult({ "nInserted" : 1 })
> db.col2.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 'update 方法'
... })
WriteResult({ "nInserted" : 1 })
> show tables;
col
col2
test
> db.col2.find()
{ "_id" : ObjectId("5c76067e8a8ce9812e5a5980"), "title" : "cmz noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7607388a8ce9812e5a5981"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7607398a8ce9812e5a5982"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }

# 修改
> db.col2.update({'title':'Books 教程'},{$set:{'title':'cmz2 noteBooks'}},{multi:true})
WriteResult({ "nMatched" : 2, "nUpserted" : 0, "nModified" : 2 })
```


### 4.2 save
&#160; &#160; &#160; &#160;以下实例中我们替换了likes
```
> use cmz
switched to db cmz
> db.col2.find()
{ "_id" : ObjectId("5c76067e8a8ce9812e5a5980"), "title" : "cmz noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7607388a8ce9812e5a5981"), "title" : "cmz2 noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL"], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7607398a8ce9812e5a5982"), "title" : "cmz2 noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL"], "likes" : "update 方法" }


# save 操作
> db.col2.save({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 'save 方法'
... })
WriteResult({ "nInserted" : 1 })
> db.col2.find()
{ "_id" : ObjectId("5c76067e8a8ce9812e5a5980"), "title" : "cmz noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7607388a8ce9812e5a5981"), "title" : "cmz2 noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL"], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7607398a8ce9812e5a5982"), "title" : "cmz2 noteBooks", "description" : "笔记", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL"], "likes" : "update 方法" }
{ "_id" : ObjectId("5c7609352c2b43efe00307bb"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : "save 方法" }
```

??? note "更多操作"
    ```python
    只更新第一条记录：
    
    db.col.update( { "count" : { $gt : 1 } } , { $set : { "test2" : "OK"} } );
    全部更新：
    
    db.col.update( { "count" : { $gt : 3 } } , { $set : { "test2" : "OK"} },false,true );
    只添加第一条：
    
    db.col.update( { "count" : { $gt : 4 } } , { $set : { "test5" : "OK"} },true,false );
    全部添加进去:
    
    db.col.update( { "count" : { $gt : 5 } } , { $set : { "test5" : "OK"} },true,true );
    全部更新：
    
    db.col.update( { "count" : { $gt : 15 } } , { $inc : { "count" : 1} },false,true );
    只更新第一条记录：
    
    db.col.update( { "count" : { $gt : 10 } } , { $inc : { "count" : 1} },false,false );
    ```

## 5. 查询操作
### 5.1 基本查询

&#160; &#160; &#160; &#160;我们在集合 col 中先插入的数据：
```
db.col.insert({title: 'Books 教程', 
    description: '笔记',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 88
})
```

&#160; &#160; &#160; &#160;操作过程
```
> db.col.insert({title: 'Books 教程',
...     description: '笔记',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 88
... })
WriteResult({ "nInserted" : 1 })
> db.col.find()
{ "_id" : ObjectId("5c761420fec6d367f28a65d4"), "title" : "Books 教程", "description" : "笔记", "by": "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 88 }
> db.col.find().pretty()
{
	"_id" : ObjectId("5c761420fec6d367f28a65d4"),
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 88
}

```
&#160; &#160; &#160; &#160;除了 find() 方法之外，还有一个 findOne() 方法，它只返回一个文档。

```
> db.col.findOne()
{
	"_id" : ObjectId("5c761420fec6d367f28a65d4"),
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 88
}
```

### 5.2 查询语句条件

&#160; &#160; &#160; &#160;查询语句条件

操作|	格式|	范例|	RDBMS中的类似语句
---|---|---|---
等于|	{<key>:<value>}|	db.col.find({"by":"cmz"}).pretty()	|where by = 'cmz'
小于|	{<key>:{$lt:<value>}}|	db.col.find({"likes":{$lt:50}}).pretty()|	where likes < 50
小于或等于|	{<key>:{$lte:<value>}}|	db.col.find({"likes":{$lte:50}}).pretty()|	where likes <= 50
大于|	{<key>:{$gt:<value>}}|	db.col.find({"likes":{$gt:50}}).pretty()|	where likes > 50
大于或等于|	{<key>:{$gte:<value>}}|	db.col.find({"likes":{$gte:50}}).pretty()|	where likes >= 50
不等于|	{<key>:{$ne:<value>}}|	db.col.find({"likes":{$ne:50}}).pretty()|	where likes != 50

### 5.3 AND条件
&#160; &#160; &#160; &#160;MongoDB 的 find() 方法可以传入多个键(key)，每个键(key)以逗号隔开，即常规 SQL 的 AND 条件。语法格式如下：

```
>db.col.find({key1:value1, key2:value2}).pretty()
```

操作过程

```
> db.col.find({"by":"cmz", "title":"Books 教程"}).pretty()
{
	"_id" : ObjectId("5c761420fec6d367f28a65d4"),
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 88
}
```


### 5.4 OR条件
&#160; &#160; &#160; &#160;MongoDB OR 条件语句使用了关键字 $or,语法格式如下：

```
>db.col.find(
   {
      $or: [
         {key1: value1}, {key2:value2}
      ]
   }
).pretty()
```
操作过程

```
> db.col.find({$or:[{"by":"cmz"},{"title": "Books 教程"}]}).pretty()
{
	"_id" : ObjectId("5c761420fec6d367f28a65d4"),
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 88
}
```

### 5.5 AND 和 OR条件
&#160; &#160; &#160; &#160;以下实例演示了 AND 和 OR 联合使用，类似常规 SQL 语句为： 'where likes>50 AND (by = 'cmz' OR title = 'Books 教程')'

```
> db.col.find({"likes": {$gt:50}, $or: [{"by": "cmz"},{"title": "Books 教程"}]}).pretty()
{
	"_id" : ObjectId("5c761420fec6d367f28a65d4"),
	"title" : "Books 教程",
	"description" : "笔记",
	"by" : "cmz",
	"url" : "https://caimengzhi.github.io/books",
	"tags" : [
		"mongodb",
		"database",
		"NoSQL"
	],
	"likes" : 88
}
```


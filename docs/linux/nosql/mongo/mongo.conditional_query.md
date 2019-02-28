<center><h1> MongoDB 条件查询</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;条件操作符用于比较两个表达式并从mongoDB集合中获取数据。

&#160; &#160; &#160; &#160;MongoDB中条件操作符有：

- (>) 大于 - $gt
- (<) 小于 - $lt
- (>=) 大于等于 - $gte
- (<= ) 小于等于 - $lte

## 2. 测试
### 2.1 清空
&#160; &#160; &#160; &#160;我们使用的数据库名称为"cmz" 我们的集合名称为"col"，以下为我们插入的数据。

&#160; &#160; &#160; &#160;为了方便测试，我们可以先使用以下命令清空集合 "col" 的数据：

```
> db.col.remove({})
WriteResult({ "nRemoved" : 1 })
> db.col.find()
>
```

### 2.2 插入数据

```
db.col.insert({
    title: 'Books 教程', 
    description: 'Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['Java', 'database', 'web'],
    likes: 200
})

db.col.insert({
    title: 'Books 教程', 
    description: 'Python 语言是最近比较流行的语言',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['Python', 'database', 'web'],
    likes: 150
})

db.col.insert({
    title: 'Books 教程', 
    description: 'MongoDB 是一个 Nosql 数据库',
    by: 'cmz',
    url: 'https://caimengzhi.github.io/books',
    tags: ['mongodb', 'database', 'NoSQL'],
    likes: 100
})
```
执行过程

```
> db.col.insert({
...     title: 'Books 教程',
...     description: 'Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['Java', 'database', 'web'],
...     likes: 200
... })
WriteResult({ "nInserted" : 1 })
>
> db.col.insert({
...     title: 'Books 教程',
...     description: 'Python 语言是最近比较流行的语言',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['Python', 'database', 'web'],
...     likes: 150
... })
WriteResult({ "nInserted" : 1 })
>
> db.col.insert({
...     title: 'Books 教程',
...     description: 'MongoDB 是一个 Nosql 数据库',
...     by: 'cmz',
...     url: 'https://caimengzhi.github.io/books',
...     tags: ['mongodb', 'database', 'NoSQL'],
...     likes: 100
... })
WriteResult({ "nInserted" : 1 })
>
> db.col.find()
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d8"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d9"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c761ba5fec6d367f28a65da"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
```

### 2.3 大于操作符
&#160; &#160; &#160; &#160;如果你想获取 "col" 集合中 "likes" 大于 150 的数据，你可以使用以下命令：

```
db.col.find({likes : {$gt : 100}})
```
类似于SQL语句：
```
Select * from col where likes > 100;
```


```
> db.col.find({likes : {$gt : 150}})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d8"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }

```

### 2.3 大于等于操作符
&#160; &#160; &#160; &#160;如果你想获取"col"集合中 "likes" 大于等于 150 的数据，你可以使用以下命令：

```
db.col.find({likes : {$gte : 150}})
```

类似于SQL语句：

```
Select * from col where likes >=150;
```
操作过程

```
> db.col.find({likes : {$gte : 150}})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d8"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d9"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
```

### 2.4 小于操作符
&#160; &#160; &#160; &#160;如果你想获取"col"集合中 "likes" 小于 150 的数据，你可以使用以下命令：
```
db.col.find({likes : {$lt : 150}})
```

类似于SQL语句：

```
Select * from col where likes < 150;
```
操作过程

```
> db.col.find({likes : {$lt : 150}})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65da"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
```

### 2.5 小于等于操作符
&#160; &#160; &#160; &#160;如果你想获取"col"集合中 "likes" 小于等于 150 的数据，你可以使用以下命令：
```
db.col.find({likes : {$lte : 150}})
```

类似于SQL语句：

```
Select * from col where likes <= 150;
```
操作过程

```
> db.col.find({likes : {$lte : 150}})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d9"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c761ba5fec6d367f28a65da"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
```

### 2.6 不等于操作符
&#160; &#160; &#160; &#160;如果你想获取"col"集合中 "likes" 大于100，小于 200 的数据，你可以使用以下命令：
```
db.col.find({likes : {$lt :200, $gt : 100}})
```

类似于SQL语句：

```
Select * from col where likes>100 AND  likes<200;
```
操作过程

```
> db.col.find({likes : {$lt :200, $gt : 100}})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d9"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
```

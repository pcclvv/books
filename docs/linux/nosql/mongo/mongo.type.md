<center><h1> MongoDB $type 操作符</h1></center>

## 1. 描述
&#160; &#160; &#160; &#160;$type操作符是基于BSON类型来检索集合中匹配的数据类型，并返回结果。

&#160; &#160; &#160; &#160;MongoDB 中可以使用的类型如下表所示：


类型 | 数字|描述
---|---|--
Double|	1|	 
String|	2|	 
Object|	3|
Array|	4|	 
Binary data|	5|	 
Undefined|	6|	已废弃。
Object id|	7|	 
Boolean|	8|	 
Date|	9	| 
Null|	10	 |
Regular Expression|	11	| 
JavaScript|	13|	 
Symbol|	14|	 
JavaScript (with scope)	|15	 |
32-bit integer|	16|	 
Timestamp|	17|	 
64-bit integer|	18|	 
Min key	|255	|Query with -1.
Max key|	127|	 



## 2.  操作过程
### 2.1 准备环境
&#160; &#160; &#160; &#160;我们使用的数据库名称为"cmz" 我们的集合名称为"col"，以下为我们插入的数据。

&#160; &#160; &#160; &#160;集合"col"：

```
db.col.remove({})
db.col.find()
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
操作过程

```
>  db.col.find()
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }

```

### 2.2 MongoDB 操作符 - $type 实例
&#160; &#160; &#160; &#160;如果想获取 "col" 集合中 title 为 String 的数据，你可以使用以下命令：

```
db.col.find({"title" : {$type : 2}})
或
db.col.find({"title" : {$type : 'string'}})
```
操作过程

```
> db.col.find({"title" : {$type : 2}})
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }

```

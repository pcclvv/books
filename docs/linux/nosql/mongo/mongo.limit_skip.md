<center><h1> MongoDB  Limit与Skip</h1></center>

## 1. Limit
&#160; &#160; &#160; &#160;如果你需要在MongoDB中读取指定数量的数据记录，可以使用MongoDB的Limit方法，limit()方法接受一个数字参数，该参数指定从MongoDB中读取的记录条数。

&#160; &#160; &#160; &#160;limit()方法基本语法如下所示：

```
db.COLLECTION_NAME.find().limit(NUMBER)
```

操作过程

```
> db.col.find()
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
> db.col.find().limit(2)
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }


> db.col.find({},{"title":1,_id:0}).limit(2)
{ "title" : "Books 教程" }
{ "title" : "Books 教程" }
```

??? tip "注意"
    ```python
    如果你们没有指定limit()方法中的参数则显示集合中的所有数据。
    ```


## 2. Skip
&#160; &#160; &#160; &#160;我们除了可以使用limit()方法来读取指定数量的数据外，还可以使用skip()方法来跳过指定数量的数据，skip方法同样接受一个数字参数作为跳过的记录条数

&#160; &#160; &#160; &#160;skip() 方法脚本语法格式如下：

```
db.COLLECTION_NAME.find().limit(NUMBER).skip(NUMBER)
```
操作过程,以下实例只会显示第二条文档数据
```
> db.col.find()
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }

> db.col.find({},{"description":1,_id:0}).limit(1).skip(1)
{ "description" : "Python 语言是最近比较流行的语言" }
```

??? tip "注意"
    ```python
    skip()方法默认参数为 0 
    ```


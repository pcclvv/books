<center><h1> MongoDB  排序</h1></center>

## 1. sort
&#160; &#160; &#160; &#160;在 MongoDB 中使用 sort() 方法对数据进行排序，sort() 方法可以通过参数指定排序的字段

- 1 为升序排列
- 1 是用于降序排列。

&#160; &#160; &#160; &#160;sort()方法基本语法如下所示：

```
db.COLLECTION_NAME.find().sort({KEY:1})
```

## 1.1 正常排列
```
> db.col.find()
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
```

## 1.2 降序排列
```
> db.col.find().sort({"likes":-1})
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
```
## 1.3 升序排列
```
> db.col.find().sort({"likes":1})
{ "_id" : ObjectId("5c76214efec6d367f28a65dd"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65dc"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
{ "_id" : ObjectId("5c76214dfec6d367f28a65db"), "title" : "Books 教程", "description" : "Java 是由Sun Microsystems公司于1995年5月推出的高级程序设计语言。", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Java", "database", "web" ], "likes" : 200 }
```

!!! tip "注意先后顺序"
    ```python
    skip(), limilt(), sort()三个放在一起执行的时候，执行的顺序是先 sort(), 然后是 skip()，最后是显示的 limit()。
    ```


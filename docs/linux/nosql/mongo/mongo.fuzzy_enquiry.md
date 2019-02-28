<center><h1> MongoDB 模糊查询</h1></center>

## 1. 插入数据

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


## 2.  包含查询
&#160; &#160; &#160; &#160;查询 description 包含"MongoDB"字的文档：

```
> db.col.find({description:/MongoDB/})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65da"), "title" : "Books 教程", "description" : "MongoDB 是一个 Nosql 数据库", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "mongodb", "database", "NoSQL" ], "likes" : 100 }

```


## 3. 以什么开头查询
&#160; &#160; &#160; &#160;查询 description 字段以"Python"字开头的文档：

```
> db.col.find({description:/^Python/})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d9"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }

```

## 4. 已什么结尾查询
&#160; &#160; &#160; &#160;查询 title字段以"教"字结尾的文档：

```
> db.col.find({description:/语言$/})
{ "_id" : ObjectId("5c761ba5fec6d367f28a65d9"), "title" : "Books 教程", "description" : "Python 语言是最近比较流行的语言", "by" : "cmz", "url" : "https://caimengzhi.github.io/books", "tags" : [ "Python", "database", "web" ], "likes" : 150 }
```


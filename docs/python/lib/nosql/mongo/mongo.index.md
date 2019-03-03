<center><h1> mongodb 模块 </h1></center>
## 1. 介绍

MongoDB 是目前最流行的 NoSQL 数据库之一，使用的数据类型 BSON（类似 JSON）。

<p style="text-indent:2em"> Python 要连接 MongoDB 需要 MongoDB 驱动，这里我们使用 PyMongo 驱动来连接。</p>

### 1.1 安装
pip 是一个通用的 Python 包管理工具，提供了对 Python 包的查找、下载、安装、卸载的功能。

```
python3 -m pip3 install pymongo
```
也可以指定安装的版本:

```
python3 -m pip3 install pymongo==3.5.1
```
更新 pymongo 命令：

```
python3 -m pip3 install --upgrade pymongo
```
旧版的 Python 可以使用 easy_install 来安装，easy_install 也是 Python 包管理工具。

```
python -m easy_install pymongo
```
更新 pymongo 命令：

```
python -m easy_install -U pymongo
```

### 1.2 测试pymongo
接下来我们可以创建一个测试文件 test_mongodb.py，代码如下
```
root@leco:/home/leco# cat test_mongodb.py
#!/usr/bin/python3

import pymongo
root@leco:/home/leco# python3 test_mongodb.py
root@leco:/home/leco# echo $?
0
```

执行以上代码文件，如果没有出现错误，表示安装成功。

## 2. 详细

### 2.1 连接MongoDB
连接MongoDB我们需要使用PyMongo库里面的MongoClient，一般来说传入MongoDB的IP及端口即可，第一个参数为地址host，第二个参数为端口port，端口如果不传默认是27017。

```
import pymongo
client = pymongo.MongoClient(host='localhost', port=27017)
```
这样我们就可以创建一个MongoDB的连接对象了。
另外MongoClient的第一个参数host还可以直接传MongoDB的连接字符串，以mongodb开头，例如：

```
client = MongoClient('mongodb://localhost:27017/')
```
可以达到同样的连接效果。

### 2.2 指定数据库
MongoDB中还分为一个个数据库，我们接下来的一步就是指定要操作哪个数据库，在这里我以test_mongo_db数据库为例进行说明，所以下一步我们需要在程序中指定要使用的数据库。调用client的test_mongo_db属性即可返回test_mongo_db数据库。

```
db = client.test_mongo_db
或者
db = client['test_mongo_db']
```

### 2.3 指定集合
MongoDB的每个数据库又包含了许多集合Collection，也就类似与关系型数据库中的表，下一步我们需要指定要操作的集合，在这里我们指定一个集合名称为informations，informations集合。还是和指定数据库类似，指定集合也有两种方式:

```
collection = db.informations
或者
collection = db['informations']
```

### 2.4 插入数据
#### 2.4.1 单条插入
接下来我们便可以进行数据插入了，对于informations这个Collection，我们新建一条数据，以字典的形式表示：

```
information = {"name": "张三", "age": "25"}
```
在这里我们指定了姓名、年龄然后接下来直接调用collection的insert()方法即可插入数据。

```
result = collection.insert(information)
print(result)
```
在MongoDB中，每条数据其实都有一个_id属性来唯一标识，如果没有显式指明_id，MongoDB会自动产生一个ObjectId类型的_id属性。insert()方法会在执行后返回的_id值。运行结果：

```
5c6b659b1607c47f8abe6ab7
```

#### 2.4.2 多条插入
当然我们也可以同时插入多条数据，只需要以列表形式传递即可，示例如下：

```
information = [{"name": "小明", "age": "25"}, {"name": "小强", "age": "24"}]
information_id = collection.insert(information)
print(information_id)

或者
xiaoming={"name": "小明", "age": "25"}
xiaoqiang= {"name": "小强", "age": "24"}
information_id = collection.insert([xiaoming,xiaoqiang])
print(information_id)
```
返回的结果是对应的_id的集合，运行结果：

```
[ObjectId('5c6b65c01607c47f8abe6ab8'), ObjectId('5c6b65c01607c47f8abe6ab9')]

```

#### 2.4.3 新单条插入
实际上在PyMongo 3.X版本中，insert()方法官方已经不推荐使用了，当然继续使用也没有什么问题，官方推荐使用insert_one()和insert_many()方法将插入单条和多条记录分开。

```
lisi = {"name": "李四", "age": "25"}
result = collection.insert_one(lisi)
print(result.inserted_id)
```
返回结果和insert()方法不同，这次返回的是InsertOneResult对象，我们可以调用其inserted_id属性获取_id。结果是

```
5c6b65df1607c47f8abe6aba
```


#### 2.4.4 新多条插入
对于insert_many()方法，我们可以将数据以列表形式传递即可，示例如下：
```
wangwu={"name": "王五", "age": "25"}
zhaoliu= {"name": "赵六", "age": "24"}
result = collection.insert_many([wangwu,zhaoliu])
print(result)
print(result.inserted_ids)
```
结果是:

```
<pymongo.results.InsertManyResult object at 0x7f3cf2dc68c8>
[ObjectId('5c6b66081607c47f8abe6abb'), ObjectId('5c6b66081607c47f8abe6abc')]
```

insert_many()方法返回的类型是InsertManyResult，调用inserted_ids属性可以获取插入数据的_id列表.


### 2.5 查询数据
#### 2.5.1 find_one()
插入数据后我们可以利用find_one(),find_one()查询得到是单个结果。

```
result = collection.find_one({'name': '张三'})
print(type(result))
print(result)
```
结果是:

```
<class 'dict'>
{'_id': ObjectId('5c6b659b1607c47f8abe6ab7'), 'name': '张三', 'age': '25'}
```
可以发现它多了一个_id属性，这就是MongoDB在插入的过程中自动添加的。

我们也可以直接根据ObjectId来查询，这里需要使用bson库里面的ObjectId。

```
In [27]: from bson.objectid import ObjectId

In [28]: result = collection.find_one({'_id':ObjectId('5c6b659b1607c47f8abe6ab7')})

In [29]: print(result)
{'_id': ObjectId('5c6b659b1607c47f8abe6ab7'), 'name': '张三', 'age': '25'}
```
其查询结果依然是字典类型，运行结果：

```
{'_id': ObjectId('5c6b659b1607c47f8abe6ab7'), 'name': '张三', 'age': '25'}
```
当然如果查询结果不存在则会返回None.

#### 2.5.2 find()
find()则返回多个结果。对于多条数据的查询，我们可以使用find()方法，例如在这里查找年龄为25的数据，

```
results = collection.find({'age': '25'})
print(results)
for result in results:
    print(result)
```
结果是:

```
{'_id': ObjectId('5c6b659b1607c47f8abe6ab7'), 'name': '张三', 'age': '25'}
{'_id': ObjectId('5c6b65c01607c47f8abe6ab8'), 'name': '小明', 'age': '25'}
{'_id': ObjectId('5c6b65df1607c47f8abe6aba'), 'name': '李四', 'age': '25'}
{'_id': ObjectId('5c6b66081607c47f8abe6abb'), 'name': '王五', 'age': '25'}
```
返回结果是Cursor类型，相当于一个生成器，我们需要遍历取到所有的结果，每一个结果都是字典类型。

如果要查询年龄大于20的数据，则写法如下：

```
results = collection.find({'age': {'$gt': '20'}})
```
测试

```
In [38]: results = collection.find({'age': {'$gt': '20'}})

In [39]: for data in results:
    ...:     print(data)
    ...: 
{'_id': ObjectId('5c6b659b1607c47f8abe6ab7'), 'name': '张三', 'age': '25'}
{'_id': ObjectId('5c6b65c01607c47f8abe6ab8'), 'name': '小明', 'age': '25'}
{'_id': ObjectId('5c6b65c01607c47f8abe6ab9'), 'name': '小强', 'age': '24'}
{'_id': ObjectId('5c6b65df1607c47f8abe6aba'), 'name': '李四', 'age': '25'}
{'_id': ObjectId('5c6b66081607c47f8abe6abb'), 'name': '王五', 'age': '25'}
{'_id': ObjectId('5c6b66081607c47f8abe6abc'), 'name': '赵六', 'age': '24'}
```
在这里查询的条件键值已经不是单纯的数字了，而是一个字典，其键名为比较符号$gt，意思是大于，键值为20，这样便可以查询出所有年龄大于20的数据。

#### 2.5.3 比较符号
在这里将比较符号归纳如下表：

符号 | 含义|例子
---|---|---
$lt	|小于|{'age': {'$lt': 20}}
$gt	|大于|{'age': {'$gt': 20}}
$lte|小于等于|{'age': {'$lte': 20}}
$gte|大于等于|{'age': {'$gte': 20}}
$ne|不等于|{'age': {'$ne': 20}}
$in|在范围内|{'age': {'$in': [20, 23]}}
$nin|不在范围内|{'age': {'$nin': [20, 23]}}

另外还可以进行正则匹配查询，例如查询名字以M开头的学生数据，示例如下：


```
results = collection.find({'name': {'$regex': '^M.*'}})
```
在这里使用了$regex来指定正则匹配，^M.*代表以M开头的正则表达式，这样就可以查询所有符合该正则的结果。


#### 2.5.4 功能符号
在这里将一些功能符号再归类如下：

符号| 含义 | 例子|例子含义
---|---|---|---
$regex|	匹配正则|	{'name': {'$regex': '^M.*'}}|	name以M开头
$exists|	属性是否存在|	{'name': {'$exists': True}}|	name属性存在
$type|	类型判断|	{'age': {'$type': 'int'}}|	age的类型为int
$mod|	数字模操作|	{'age': {'$mod': [5, 0]}}|	年龄模5余0
$text|	文本查询|	{'$text': {'$search': 'Mike'}}|	text类型的属性中包含Mike字符串
$where|	高级条件查询|	{'$where': 'obj.fans_count == obj.follows_count'}	|自身粉丝数等于关注数

> 这些操作的更详细用法在可以在MongoDB官方文档找到：https://docs.mongodb.com/manual/reference/operator/query/

### 2.5 计数
要统计查询结果有多少条数据，可以调用count()方法，如统计所有数据条数：

```
In [40]: count = collection.find().count()
In [41]: print(count)
6
```
或者统计符合某个条件的数据：

```
In [43]: count = collection.find({'age': '25'}).count()
In [44]: print(count)
4
```

### 2.6 排序
可以调用sort方法，传入排序的字段及升降序标志即可，示例如下：

```
In [45]: results = collection.find().sort('name', pymongo.ASCENDING)
In [46]: print([result['name'] for result in results])
['小强', '小明', '张三', '李四', '王五', '赵六']
```

### 2.7 偏移
在某些情况下我们可能想只取某几个元素，在这里可以利用skip()方法偏移几个位置，比如偏移2，就忽略前2个元素，得到第三个及以后的元素。

```
In [47]: results = collection.find().sort('name', pymongo.ASCENDING).skip(2)
In [48]: print([result['name'] for result in results])
['张三', '李四', '王五', '赵六']
```

### 2.8 limit
可以用limit()方法指定要取的结果个数，示例如下：

```
In [49]: results = collection.find().sort('name', pymongo.ASCENDING).skip(2).limit(2)
In [50]: print([result['name'] for result in results])
['张三', '李四']
```
如果不加limit()原本会返回三个结果，加了限制之后，会截取2个结果返回。

值得注意的是，在数据库数量非常庞大的时候，如千万、亿级别，最好不要使用大的偏移量来查询数据，很可能会导致内存溢出。可以使用类似find({'_id': {'$gt': ObjectId('593278c815c2602678bb2b8d')}}) 这样的方法来查询，记录好上次查询的_id。

### 2.9 更新
#### 2.9.1 update
对于数据更新可以使用update()方法，指定更新的条件和更新后的数据即可，例如：
没修改之前

```
> db.informations.find()
{ "_id" : ObjectId("5c6b659b1607c47f8abe6ab7"), "name" : "张三", "age" : "25" }
{ "_id" : ObjectId("5c6b65c01607c47f8abe6ab8"), "name" : "小明", "age" : "25" }
{ "_id" : ObjectId("5c6b65c01607c47f8abe6ab9"), "name" : "小强", "age" : "24" }
{ "_id" : ObjectId("5c6b65df1607c47f8abe6aba"), "name" : "李四", "age" : "25" }
{ "_id" : ObjectId("5c6b66081607c47f8abe6abb"), "name" : "王五", "age" : "25" }
{ "_id" : ObjectId("5c6b66081607c47f8abe6abc"), "name" : "赵六", "age" : "24" }
```

```
In [51]: condition = {'name': '张三'}
In [52]: user = collection.find_one(condition)
In [53]: user['age']=20
In [54]: result = collection.update(condition, user)
/usr/local/bin/ipython:1: DeprecationWarning: update is deprecated. Use replace_one, update_one or update_many instead.
  #!/usr/local/bin/python3.6
In [55]: print(result)
{'ok': 1, 'nModified': 1, 'n': 1, 'updatedExisting': True}

```
修改之后

```
> db.informations.find()
{ "_id" : ObjectId("5c6b659b1607c47f8abe6ab7"), "name" : "张三", "age" : 20 }
{ "_id" : ObjectId("5c6b65c01607c47f8abe6ab8"), "name" : "小明", "age" : "25" }
{ "_id" : ObjectId("5c6b65c01607c47f8abe6ab9"), "name" : "小强", "age" : "24" }
{ "_id" : ObjectId("5c6b65df1607c47f8abe6aba"), "name" : "李四", "age" : "25" }
{ "_id" : ObjectId("5c6b66081607c47f8abe6abb"), "name" : "王五", "age" : "25" }
{ "_id" : ObjectId("5c6b66081607c47f8abe6abc"), "name" : "赵六", "age" : "24" }
```
返回结果是字典形式，ok即代表执行成功，nModified代表影响的数据条数。
另外update()方法其实也是官方不推荐使用的方法，在这里也分了update_one()方法和update_many()方法，用法更加严格，第二个参数需要使用$类型操作符作为字典的键名，我们用示例感受一下。

#### 2.9.2 update_one

```
condition = {'name': '李四'}
user = collection.find_one(condition)
user['age'] = 26
result = collection.update_one(condition, {'$set': user})
print(result)
print(result.matched_count, result.modified_count)
```
在这里调用了update_one方法，第二个参数不能再直接传入修改后的字典，而是需要使用{'$set': user}这样的形式，其返回结果是UpdateResult类型，然后调用matched_count和modified_count属性分别可以获得匹配的数据条数和影响的数据条数。

再看一个例子

```
condition = {'age': {'$gt': 20}}
result = collection.update_one(condition, {'$inc': {'age': 1}})
print(result)
print(result.matched_count, result.modified_count)
```
在这里我们指定查询条件为年龄大于20，然后更新条件为{'$inc': {'age': 1}} ，也就是年龄加1，执行之后会讲第一条符合条件的数据年龄加1。

#### 2.9.3 update_many
如果调用update_many()方法，则会将所有符合条件的数据都更新，示例如下：

```
condition = {'age': {'$gt': 20}}
result = collection.update_many(condition, {'$inc': {'age': 1}})
print(result)
print(result.matched_count, result.modified_count)
```

### 2.10 删除
#### 2.10.1 remove
删除操作比较简单，直接调用remove()方法指定删除的条件即可，符合条件的所有数据均会被删除，示例如下

```
result = collection.remove({'name': '王五'})
print(result)
```
运行

```
n [66]: result = collection.remove({'name': '王五'})
/usr/local/bin/ipython:1: DeprecationWarning: remove is deprecated. Use delete_one or delete_many instead.
  #!/usr/local/bin/python3.6

In [67]: print(result)
{'ok': 1, 'n': 1}
```
另外依然存在两个新的推荐方法，delete_one()和delete_many()方法.
#### 2.10.2 delete_one

```
result = collection.delete_one({'name': '赵六'})
print(result)
print(result.deleted_count)
```
过程

```
In [68]: result = collection.delete_one({'name': '赵六'})

In [69]: print(result)
<pymongo.results.DeleteResult object at 0x7f3d00039188>

In [70]: print(result.deleted_count)
1
```


#### 2.10.3 delete_many

```
result = collection.delete_many({'age': {'$lt': 10}})
print(result.deleted_count)
```
delete_one()即删除第一条符合条件的数据，delete_many()即删除所有符合条件的数据，返回结果是DeleteResult类型，可以调用deleted_count属性获取删除的数据条数。

#### 2.10.4 更多
另外PyMongo还提供了一些组合方法，如find_one_and_delete() 、find_one_and_replace() 、find_one_and_update() ，就是查找后删除、替换、更新操作，用法与上述方法基本一致。

另外还可以对索引进行操作，如create_index() 、create_indexes() 、drop_index()等。

详细用法可以参见官方文档：http://api.mongodb.com/python/current/api/pymongo/collection.html

另外还有对数据库、集合本身以及其他的一些操作，在这不再一一讲解，可以参见官方文档：http://api.mongodb.com/python/current/api/pymongo/

### 2.11 code

```
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pymongo
import datetime


def get_db():
    # 建立连接
    client = pymongo.MongoClient(host="127.0.0.1", port=27017)
    # host 指定要链接的mongo server的主机。port是端口
    db = client['test_mongo_db']
    #或者 db = client.test_mongo_db
    return db


def get_collection(db):
    # 选择集合(mongo中collection和database都是延时创建的)
    coll = db['informations']
    print (db.collection_names())
    return coll


def insert_one_doc(db):
    # 插入一个document
    coll = db['informations']
    information = {"name": "summer", "age": "25"}
    information_id = coll.insert(information)
    print(information_id)


def insert_multi_docs(db):
    # 批量插入documents,插入一个数组
    coll = db['informations']
    information = [{"name": "小明", "age": "25"}, {"name": "小强", "age": "24"}]
    information_id = coll.insert(information)
    print(information_id)


def get_one_doc(db):
    # 有就返回一个，没有就返回None
    coll = db['informations']
    print(coll.find_one())  # 返回第一条记录
    print(coll.find_one({"name": "summer"}))
    print(coll.find_one({"name": "none"}))


def get_one_by_id(db):
    # 通过objectid来查找一个doc
    coll = db['informations']
    obj = coll.find_one()
    obj_id = obj["_id"]
    print("_id 为ObjectId类型，obj_id:" + str(obj_id))

    print(coll.find_one({"_id": obj_id}))
    # 需要注意这里的obj_id是一个对象，不是一个str，使用str类型作为_id的值无法找到记录
    print("_id 为str类型 ")
    print(coll.find_one({"_id": str(obj_id)}))
    # 可以通过ObjectId方法把str转成ObjectId类型
    from bson.objectid import ObjectId

    print ("_id 转换成ObjectId类型")
    print (coll.find_one({"_id": ObjectId(str(obj_id))}))


def get_many_docs(db):
    # mongo中提供了过滤查找的方法，可以通过各种条件筛选来获取数据集，还可以对数据进行计数，排序等处理
    coll = db['informations']
    # ASCENDING = 1 升序;DESCENDING = -1降序;default is ASCENDING
    for item in coll.find().sort("age", pymongo.DESCENDING):
        print(item)

    count = coll.count()
    print ("集合中所有数据 %s个" % int(count))

    # 条件查询
    count = coll.find({"name":"summer"}).count()
    print ("summer: %s"%count)

def clear_all_datas(db):
    # 清空一个集合中的所有数据
    db["informations"].remove()

if __name__ == '__main__':
    db = get_db()
    my_collection = get_collection(db)
    post = {"author": "Mike", "text": "My first blog post!", "tags": ["mongodb", "python", "pymongo"],
            "date": datetime.datetime.utcnow()}
    # 插入记录
    my_collection.insert(post)
    insert_one_doc(db)
    # 条件查询
    print (my_collection.find_one({"x": "10"}))
    # 查询表中所有的数据
    for data in my_collection.find():
        print(data)
    print (my_collection.count())
    my_collection.update({"author": "Mike"},
                         {"author": "summer", "text": "My first blog post!", "tags": ["mongodb", "python", "pymongo"],
                          "date": datetime.datetime.utcnow()})
    for data in my_collection.find():
        print (data)
    get_one_doc(db)
    get_one_by_id(db)
    get_many_docs(db)
    # clear_all_datas(db)
```



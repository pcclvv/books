<center><h1>复制集_分片集</h1></center>

## 1. sharded+replicat部署搭建
&#160; &#160; &#160; &#160;一个典型的生产上的mongodb的集合是，复制集合结和分片集，Sharded Cluster包括router(mongos)、config server和shards，其中每个shard都可以是单点(standalone)或者复制集(replica set）。接下来的演示包括一个router， 三个config server，两个shard。每一个shard都是有一个primary、一个secondary和一个arbiter组成的replica set。

## 2. 环境准备

IP | 主机名|系统|安装软件|角色
---|---|---|---|---
192.168.178.128 |node3|ubuntu16|mongodb4.0.8|sharde31，sharde32,sharde33，configure3,mongos3
192.168.178.129 |node2|ubuntu16|mongodb4.0.8|sharde21，sharde22,sharde23，configure2,mongos2
192.168.178.130 |node1|ubuntu16|mongodb4.0.8|sharde11，sharde12,sharde13，configure1,mongos1

!!! note "详细参数"
    ```python
    主机   端口信息
    node1 mongo shard1:27018(replicat set1)
          mongo shard2:27019(replicat set2)
          mongo shard3:27020(replicat set3)
          mongo config:20000
          mongos: 27017
         
    node2 mongo shard1:27018(replicat set1)
          mongo shard2:27019(replicat set2)
          mongo shard3:27020(replicat set3)
          mongo config:20000
          mongos: 27017
          
    node3 mongo shard1:27018(replicat set1)
          mongo shard2:27019(replicat set2)
          mongo shard3:27020(replicat set3)
          mongo config:20000
          mongos: 27017
    ```
一定要认真看完，以下操作，虽然有点烦。我尽量写的非常详细。

![集群图](../../../pictures/linux/nosql/mongo/集群图.png)

## 3. 部署

以下脚本运行，会自动创建副本集，shard集，config server，mongo这一整套集群[看脚本内容配置]。
> 前提是需要安装好mongdb4.x 在运行下面这个脚本。

==三台基本都使用这一个脚本==

??? note "脚本"
    ```python
    # 角色      端口
    # shard1    27018
    # shard2    27019
    # shard3    27020
    # configsvr 20000
    # mongos    27107
    pkill mongo
    pkill mongo
    pkill mongo
    mkdir /app/mongo/services/{shard1/db,shard2/db,shard3/db,configsvr/db,mongos} -p
    
    # 1. shard1的配置文件
    # shard1 mongod.conf
    cat >/app/mongo/services/shard1/mongod.conf<<EOF
    storage:
        dbPath: /app/mongo/services/shard1/db
        journal:
            enabled: true
    systemLog:
        destination: file
        logAppend: true
        path: /app/mongo/services/shard1/mongod.log
    net:
        port: 27018
        bindIp: 0.0.0.0
    processManagement: 
        fork: true 
        pidFilePath: /app/mongo/services/shard1/pid 
    replication: 
        replSetName: shard1 
    sharding: 
        clusterRole: shardsvr
    EOF
    
    # 2. shard 2的配置文件
    # shard2 mongod.conf
    cat >/app/mongo/services/shard2/mongod.conf<<EOF
    storage:
        dbPath: /app/mongo/services/shard2/db
        journal:
            enabled: true
    systemLog:
        destination: file
        logAppend: true
        path: /app/mongo/services/shard2/mongod.log
    net:
        port: 27019
        bindIp: 0.0.0.0
    processManagement:
        fork: true
        pidFilePath: /app/mongo/services/shard2/pid
    replication:
        replSetName: shard2
    sharding:
        clusterRole: shardsvr
    EOF
    
    # 3. shard 3的配置文件
    #shard2 mongod.conf
    
    cat >/app/mongo/services/shard3/mongod.conf<<EOF
    storage:
        dbPath: /app/mongo/services/shard3/db
        journal:
            enabled: true
    systemLog:
        destination: file
        logAppend: true
        path: /app/mongo/services/shard3/mongod.log
    net:
        port: 27020
        bindIp: 0.0.0.0
    processManagement:
        fork: true
        pidFilePath: /app/mongo/services/shard3/pid
    replication:
        replSetName: shard3
    sharding:
        clusterRole: shardsvr
    EOF
    
    # 4. configsvr 的配置文件
    
    cat>/app/mongo/services/configsvr/cfg.conf<<EOF
    #configsvr cfg.conf
    storage:
        dbPath: /app/mongo/services/configsvr/db
        journal:
            enabled: true
    systemLog:
        destination: file
        logAppend: true
        path: /app/mongo/services/configsvr/mongod.log
    net:
        port: 20000
        bindIp: 0.0.0.0
    processManagement:
        fork: true
        pidFilePath: /app/mongo/services/configsvr/pid
    replication:
        replSetName: cfg
    sharding:
        clusterRole: configsvr
    EOF
    
    #mongos mongos.conf
    cat >/app/mongo/services/mongos/mongos.conf<<EOF
    systemLog:
        destination: file
        logAppend: true
        path: /app/mongo/services/mongos/mongos.log
    net:
        port: 27017
        bindIp: 0.0.0.0
    processManagement:
        fork: true
        pidFilePath: /app/mongo/services/mongos/pid
    sharding:
        configDB: cfg/node1:20000,node2:20000,node3:20000
    EOF
    
    # 2. start 启动服务
    mongod -f /app/mongo/services/shard1/mongod.conf 
    mongod -f /app/mongo/services/shard2/mongod.conf 
    mongod -f /app/mongo/services/shard3/mongod.conf 
    mongod -f /app/mongo/services/configsvr/cfg.conf
    
    
    # 3. check
    ps axf|grep -v grep | egrep 'mongod|configsvr'
    netstat -lnp|egrep '27018|27019|27020|20000'
    
    # 4. set replicat 设置副本集
    mongo --port 27018 --quiet<<EOF
    rs.initiate({
        "_id":"shard1",
        "members":[
            {
                "_id":0,
                "host":"node1:27018"
            },
            {
                "_id":1,
                "host":"node2:27018"
            },
            {
                "_id":2,
                "host":"node3:27018"
            }
        ]
    })
    EOF
    mongo --port 27019 --quiet<<EOF
    rs.initiate({
        "_id":"shard2",
        "members":[
            {
                "_id":0,
                "host":"node1:27019"
            },
            {
                "_id":1,
                "host":"node2:27019"
            },
            {
                "_id":2,
                "host":"node3:27019"
            }
        ]
    })
    EOF
    
    mongo --port 27020 --quiet<<EOF
    rs.initiate({
        "_id":"shard3",
        "members":[
            {
                "_id":0,
                "host":"node1:27020"
            },
            {
                "_id":1,
                "host":"node2:27020"
            },
            {
                "_id":2,
                "host":"node3:27020"
            }
        ]
    })
    EOF
    # 5. init  replicat 初始化副本集[告诉configure server它的副本集有哪些]
    mongo --port 20000 --quiet<<EOF
    rs.initiate({
        "_id":"cfg",
        "members":[
            {
                "_id":0,
                "host":"node1:20000"
            },
            {
                "_id":1,
                "host":"node2:20000"
            },
            {
                "_id":2,
                "host":"node3:20000"
            }
        ]
    })
    EOF
    mongos -f /app/mongo/services/mongos/mongos.conf
    
    # 6. set shard  
    # 为mongo configsvr 添加shard节点
    mongo --port 27017 --quiet<<EOF
    sh.addShard("shard1/node1:27018,node2:27018,node3:27018")
    sh.addShard("shard2/node1:27019,node2:27019,node3:27019")
    sh.addShard("shard3/node1:27020,node2:27020,node3:27020")
    sh.status()
    EOF
    
    # 7. check process
    ps axf|grep -v grep | grep "mongo"
    netstat -lnp|egrep '27018|27019|27020|20000'
    ```

## 4. 测试
### 4.1 进程和端口
先检查上面脚本的运行情况是否正常。

```
root@node1:~# ps axf|grep -v grep | grep "mongo"
 11840 pts/0    Sl+    0:00  |       \_ mongo --port 27018
 12098 pts/1    Sl+    1:28  |       \_ mongo
  9867 ?        Sl     3:28 mongod -f /app/mongo/services/shard1/mongod.conf
  9899 ?        Sl     3:03 mongod -f /app/mongo/services/shard2/mongod.conf
  9931 ?        Sl     7:16 mongod -f /app/mongo/services/shard3/mongod.conf
  9963 ?        Sl     2:12 mongod -f /app/mongo/services/configsvr/cfg.conf
 10221 ?        Sl     5:09 mongos -f /app/mongo/services/mongos/mongos.conf

root@node1:~# netstat -lnp|egrep '27018|27019|27020|20000|27017'
tcp        0      0 0.0.0.0:27017           0.0.0.0:*               LISTEN      10221/mongos    
tcp        0      0 0.0.0.0:27018           0.0.0.0:*               LISTEN      9867/mongod     
tcp        0      0 0.0.0.0:27019           0.0.0.0:*               LISTEN      9899/mongod     
tcp        0      0 0.0.0.0:27020           0.0.0.0:*               LISTEN      9931/mongod     
tcp        0      0 0.0.0.0:20000           0.0.0.0:*               LISTEN      9963/mongod     
unix  2      [ ACC ]     STREAM     LISTENING     67939    9867/mongod         /tmp/mongodb-27018.sock
unix  2      [ ACC ]     STREAM     LISTENING     67941    9899/mongod         /tmp/mongodb-27019.sock
unix  2      [ ACC ]     STREAM     LISTENING     69099    9931/mongod         /tmp/mongodb-27020.sock
unix  2      [ ACC ]     STREAM     LISTENING     69101    9963/mongod         /tmp/mongodb-20000.sock
unix  2      [ ACC ]     STREAM     LISTENING     68122    10221/mongos        /tmp/mongodb-27017.sock
```
必须有以上5个进程，5个端口，这是node1上的，其他所有三台机器都是这样。

### 4.2 测试
我们开始测试复制集和分片集，我们使用预先分片,手动预先分片是为了防止未来chunk的移动，减少IO。

```
# 8. 定义分片规则，添加分片的库
# Field是collection的一个字段，系统将会利用filed的值来计算应该分片到哪个片上，
# 这个filed是片键，shard key
# 修改chunkserver 
# db.settings.save({'_id':'chunksize','value':1});
# db.settings.find()

sh.enableSharding("caimengzhi");
sh.shardCollection('caimengzhi.goods',{'goods_id':1});
for (var i=1;i<=30000;i++){
    db.goods.insert({goods_id:i,good_name:'summer'});
}

# 9. 手动预先分片
sh.shardCollection('caimengzhi.cmz',{'userid':1});
# 先分块,先分40个块，预先在1K,2K,...40K这样的界限切好chunk（虽然chunk还是空的）
# 但是chunk会均匀的移动到各片上
for(var i=1;i<=40;i++){
    sh.splitAt('caimengzhi.cmz',{userid:i*1000})
}
# 插入数据
for(var i=1;i<=10000;i++){
    db.cmz.insert({userid:i,name:'cmz'+i})
}

sh.shardCollection("caimengzhi.users",{"userId": 1 })
for(var i=1; i<=30; i++){ sh.splitAt("caimengzhi.users", {userId: i*1000}) }
for(var i=1; i<30000; i++){ db.users.insert({userId: i,name: 'hello'}) }
```


```
use shop;
sh.enableSharding("shop");
sh.shardCollection("shop.users",{"userId": 1 });
for(var i=1; i<=30; i++){ sh.splitAt("shop.users", {userId: i*1000}) };
for(var i=1; i<30000; i++){ db.users.insert({userId: i,name: 'cmz'})};
```

详细过程

```
root@node1:~# mongo --port 27017 --quiet
mongos> show dbs;
admin   0.000GB
config  0.002GB

mongos> use shop;
switched to db shop
mongos> sh.enableSharding("shop");
{
	"ok" : 1,
	"operationTime" : Timestamp(1554373413, 6),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1554373413, 6),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	}
}


```
查看
```
mongos> sh.status()
--- Sharding Status --- 
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
  	"clusterId" : ObjectId("5ca5b83091d62b328099a7b5")
  }
  shards:
        {  "_id" : "shard1",  "host" : "shard1/node1:27018,node2:27018,node3:27018",  "state" : 1 }
        {  "_id" : "shard2",  "host" : "shard2/node1:27019,node2:27019,node3:27019",  "state" : 1 }
        {  "_id" : "shard3",  "host" : "shard3/node1:27020,node2:27020,node3:27020",  "state" : 1 }
  active mongoses:
        "4.0.8" : 3
  autosplit:
        Currently enabled: yes
  balancer:
        Currently enabled:  yes
        Currently running:  no
        Failed balancer rounds in last 5 attempts:  0
        Migration Results for the last 24 hours: 
                172 : Success
  databases:
        {  "_id" : "config",  "primary" : "config",  "partitioned" : true }
                config.system.sessions
                        shard key: { "_id" : 1 }
                        unique: false
                        balancing: true
                        chunks:
                                shard1	1
                        { "_id" : { "$minKey" : 1 } } -->> { "_id" : { "$maxKey" : 1 } } on : shard1 Timestamp(1, 0) 
        {  "_id" : "shop",  "primary" : "shard2",  "partitioned" : true,  "version" : {  "uuid" : UUID("69b0fc8c-4332-489c-bf20-5a2e6ae774a7"),  "lastMod" : 1 } }

```
从上面可以看出数据默认是在shard1上的。接下来我们要设置shop库是要分片的。[也就是partitioned=true]

#### 4.2.1 使能库
让shop库，开始分片。
```
mongos> sh.enableSharding("shop");
{
	"ok" : 1,
	"operationTime" : Timestamp(1554373497, 2),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1554373497, 2),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	}
}
```
#### 4.2.2 设置片键

```
mongos> sh.shardCollection("shop.users",{"userId": 1 });
{
	"collectionsharded" : "shop.users",
	"collectionUUID" : UUID("867fb471-f2e9-4fb0-a4ac-6a8a6eac7687"),
	"ok" : 1,
	"operationTime" : Timestamp(1554373542, 9),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1554373542, 9),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	}
}

mongos> sh.status()
--- Sharding Status --- 
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
  	"clusterId" : ObjectId("5ca5b83091d62b328099a7b5")
  }
  shards:
        {  "_id" : "shard1",  "host" : "shard1/node1:27018,node2:27018,node3:27018",  "state" : 1 }
        {  "_id" : "shard2",  "host" : "shard2/node1:27019,node2:27019,node3:27019",  "state" : 1 }
        {  "_id" : "shard3",  "host" : "shard3/node1:27020,node2:27020,node3:27020",  "state" : 1 }
  active mongoses:
        "4.0.8" : 3
  autosplit:
        Currently enabled: yes
  balancer:
        Currently enabled:  yes
        Currently running:  no
        Failed balancer rounds in last 5 attempts:  0
        Migration Results for the last 24 hours: 
                172 : Success
  databases:
        {  "_id" : "config",  "primary" : "config",  "partitioned" : true }
                config.system.sessions
                        shard key: { "_id" : 1 }
                        unique: false
                        balancing: true
                        chunks:
                                shard1	1
                        { "_id" : { "$minKey" : 1 } } -->> { "_id" : { "$maxKey" : 1 } } on : shard1 Timestamp(1, 0) 
        {  "_id" : "shop",  "primary" : "shard2",  "partitioned" : true,  "version" : {  "uuid" : UUID("69b0fc8c-4332-489c-bf20-5a2e6ae774a7"),  "lastMod" : 1 } }
                shop.users
                        shard key: { "userId" : 1 }
                        unique: false
                        balancing: true
                        chunks:
                                shard2	1
                        { "userId" : { "$minKey" : 1 } } -->> { "userId" : { "$maxKey" : 1 } } on : shard2 Timestamp(1, 0) 
```

> shard key: { "userId" : 1 } 可以看出就是我设置的片键

#### 4.2.3 设置块
```
mongos> for(var i=1; i<=30; i++){ sh.splitAt("shop.users", {userId: i*1000})};
{
	"ok" : 1,
	"operationTime" : Timestamp(1554373605, 1),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1554373613, 56),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	}
}
```
开始手动分块

```
mongos> sh.shardCollection("shop.users",{"userId": 1 });
{
	"collectionsharded" : "shop.users",
	"collectionUUID" : UUID("867fb471-f2e9-4fb0-a4ac-6a8a6eac7687"),
	"ok" : 1,
	"operationTime" : Timestamp(1554373542, 9),
	"$clusterTime" : {
		"clusterTime" : Timestamp(1554373542, 9),
		"signature" : {
			"hash" : BinData(0,"AAAAAAAAAAAAAAAAAAAAAAAAAAA="),
			"keyId" : NumberLong(0)
		}
	}
}
```
此时看出状态

```
mongos> sh.status()
。。。。。
{  "_id" : "shop",  "primary" : "shard2",  "partitioned" : true,  "version" : {  "uuid" : UUID("69b0fc8c-4332-489c-bf20-5a2e6ae774a7"),  "lastMod" : 1 } }
                shop.users
                        shard key: { "userId" : 1 }
                        unique: false
                        balancing: true
                        chunks:
                                shard1	1      # 这三个块开始在跳整，一直到均衡为止
                                shard2	28
                                shard3	2
                        too many chunks to print, use verbose if you want to force print

```

调整好的情况

```
   {  "_id" : "shop",  "primary" : "shard2",  "partitioned" : true,  "version" : {  "uuid" : UUID("69b0fc8c-4332-489c-bf20-5a2e6ae774a7"),  "lastMod" : 1 } }
                shop.users
                        shard key: { "userId" : 1 }
                        unique: false
                        balancing: true
                        chunks:
                                shard1	10
                                shard2	11
                                shard3	10
                        too many chunks to print, use verbose if you want to force print
```

#### 4.2.3 插入数据

```
mongos> for(var i=1; i<30000; i++){ db.users.insert({userId: i,name: 'cmz'})};
WriteResult({ "nInserted" : 1 })
mongos> show dbs;
admin   0.000GB
config  0.002GB
shop    0.001GB
mongos> use shop;
switched to db shop
mongos> show tables;
users
mongos> db.users.count()
29999
```
查看

```

root@node1:/etc# mongo --port 27018 --quiet
shard1:PRIMARY> rs.slaveOk()
shard1:PRIMARY> show dbs;
admin   0.000GB
config  0.000GB
local   0.006GB
shop    0.000GB
shard1:PRIMARY> use shop;
switched to db shop
shard1:PRIMARY> show tables;
users
shard1:PRIMARY> db.users.count()
9999

shard2:SECONDARY> rs.slaveOk()
shard2:SECONDARY> use shop;
switched to db shop
shard2:SECONDARY> show tables;
users
shard2:SECONDARY> db.users.count()
10000

root@node3:/app/mongo/services/mongos# mongo --port 27020 --quiet
shard3:SECONDARY> rs.slaveOk()
shard3:SECONDARY> use 
bad use parameter
shard3:SECONDARY> use shop
switched to db shop
shard3:SECONDARY> db.users.count();
10000
```
查看每个shard，分片了，均衡的分布。

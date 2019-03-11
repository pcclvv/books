<center><h1> Redis 发布订阅 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; Redis 发布订阅(pub/sub)是一种消息通信模式：发送者(pub)发送消息，订阅者(sub)接收消息。

&#160; &#160; &#160; &#160; Redis 客户端可以订阅任意数量的频道。

&#160; &#160; &#160; &#160; 下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的关系：

![link](../../../pictures/linux/nosql/redis/p1.png)

当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户端

![link](../../../pictures/linux/nosql/redis/p2.png)

## 2. 发布订阅命令

序号|命令|描述
---|---|---
1|PSUBSCRIBE pattern [pattern ...] |订阅一个或多个符合给定模式的频道。
2|PUBSUB subcommand [argument [argument ...]] |查看订阅与发布系统状态。
3|PUBLISH channel message |将信息发送到指定的频道。
4|PUNSUBSCRIBE [pattern [pattern ...]] |退订所有给定模式的频道。
5|SUBSCRIBE channel [channel ...] |订阅给定的一个或多个频道的信息。
6|UNSUBSCRIBE [channel [channel ...]] |指退订给定的频道。

## 3. 实例

以下实例演示了发布订阅是如何工作的。在我们实例中我们创建了订阅频道名为 chat:

```
root@manage01:/home/loocha# redis-cli
127.0.0.1:6379> AUTH cmz
OK
127.0.0.1:6379> SUBSCRIBE chat
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "chat"
3) (integer) 1
```
现在，我们先重新开启个 redis 客户端，然后在同一个频道 chat 发布两次消息，订阅者就能接收到消息。
```
127.0.0.1:6379> PUBLISH chat  'my name is caimengzhi'
(integer) 1
127.0.0.1:6379> PUBLISH chat  'my age 20'
(integer) 1
127.0.0.1:6379> PUBLISH chat  'my hobby python'
(integer) 1
127.0.0.1:6379>
```

订阅者的客户端会显示如下消息

```
127.0.0.1:6379> SUBSCRIBE chat
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "chat"
3) (integer) 1



1) "message"
2) "chat"
3) "my name is caimengzhi"
1) "message"
2) "chat"
3) "my age 20"
1) "message"
2) "chat"
3) "my hobby python"
```

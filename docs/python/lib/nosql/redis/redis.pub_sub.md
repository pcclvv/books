
## 1. 介绍
Redis 发布订阅(pub/sub)是一种消息通信模式：发送者(pub)发送消息，订阅者(sub)接收消息。

Redis 客户端可以订阅任意数量的频道。

下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的关系：
下图展示了频道 channel1 ， 以及订阅这个频道的三个客户端 —— client2 、 client5 和 client1 之间的关系：

```
graph TB
client1-->channel1
client2-->channel1
client3-->channel1
```
当有新消息通过 PUBLISH 命令发送给频道 channel1 时， 这个消息就会被发送给订阅它的三个客户端：

```
graph TB
publish_channel1_message --> channel1
channel1-->client1
channel1-->client2
channel1-->client3
```

## 2. 实例
在我们实例中我们创建了订阅频道名为 redisChat
### 2.1 发布端

```
root@leco:~/code/redis# redis-cli
127.0.0.1:6379>  PUBLISH redisChat "Redis is a great caching technique"
(integer) 1
127.0.0.1:6379>  PUBLISH redisChat "Learn redis by summer"
(integer) 1
127.0.0.1:6379>
```
发布者发布了两条消息

### 2.2 接收端
```
root@leco:~/code/redis# redis-cli
127.0.0.1:6379>  SUBSCRIBE redisChat
Reading messages... (press Ctrl-C to quit)
1) "subscribe"
2) "redisChat"
3) (integer) 1
1) "message"
2) "redisChat"
3) "Redis is a great caching technique"
1) "message"
2) "redisChat"
3) "Learn redis by summer"
```
接收到收到了两条消息


python 实现

```
root@leco:~/code/redis# cat p.py
import redis
r=redis.Redis(host="localhost",port=6379,decode_responses=True)

#发布使用publish(self, channel, message):Publish ``message`` on ``channel``.
Flag=True
while Flag:
    msg=input("主播请讲话>>:")
    if len(msg)==0:
        continue
    elif msg=='quit':
        break
    else:
        r.publish('cctv0',msg)
root@leco:~/code/redis# cat r.py
import redis
r=redis.Redis(host="localhost",port=6379,decode_responses=True)

#发布使用publish(self, channel, message):Publish ``message`` on ``channel``.
Flag=True
chan=r.pubsub()#返回一个发布/订阅对象
msg_reciver=chan.subscribe('cctv0')#订阅

msg=chan.parse_response()#第一次会返回订阅确认信息
print(msg)
print("订阅成功，开始接收------")
while Flag:
    msg=chan.parse_response()#接收消息
    print(">>:",msg[2])#此处的信息格式['消息类型', '频道', '消息']，所以使用[2]来获取

```
测试

```
发布端
root@leco:~/code/redis# python3 p.py
主播请讲话>>:我是redis的发布平台
主播请讲话>>:


接受端
root@leco:~/code/redis# python3 r.py
['subscribe', 'cctv0', 1]
订阅成功，开始接收------
>>: 我是redis的发布平台

阻塞在这，等待接受数据
```

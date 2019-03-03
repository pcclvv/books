<center><h1> uuid 模块 </h1></center>
## 1. 介绍
&#160; &#160; &#160; &#160;uuid是128位的全局唯一标识符（univeral unique identifier），通常用32位的一个字符串的形式来表现。有时也称guid(global unique identifier)。python中自带了uuid模块来进行uuid的生成和管理工作。

&#160; &#160; &#160; &#160;python中的uuid模块基于信息如MAC地址、时间戳、命名空间、随机数、伪随机数来uuid。具体方法有如下几个。

### 1.1 uuid.uuid1()　　
&#160; &#160; &#160; &#160;基于MAC地址，时间戳，随机数来生成唯一的uuid，可以保证全球范围内的唯一性。

### 1.2 uuid.uuid2()　　
&#160; &#160; &#160; &#160;算法与uuid1相同，不同的是把时间戳的前4位置换为POSIX的UID。不过需要注意的是python中没有基于DCE的算法，所以python的uuid模块中没有uuid2这个方法。

### 1.3 uuid.uuid3(namespace,name)　　
&#160; &#160; &#160; &#160;通过计算一个命名空间和名字的md5散列值来给出一个uuid，所以可以保证命名空间中的不同名字具有不同的uuid，但是相同的名字就是相同的uuid了。namespace并不是一个自己手动指定的字符串或其他量，而是在uuid模块中本身给出的一些值。比如uuid.NAMESPACE_DNS，uuid.NAMESPACE_OID，uuid.NAMESPACE_OID这些值。这些值本身也是UUID对象，根据一定的规则计算得出。
### 1.4 uuid.uuid4()　　
&#160; &#160; &#160; &#160;通过伪随机数得到uuid，是有一定概率重复的
### 1.5 uuid.uuid5(namespace,name)　　
&#160; &#160; &#160; &#160;uuid3基本相同，只不过采用的散列算法是sha1。

&#160; &#160; &#160; &#160;UUID: 通用唯一标识符 ( Universally Unique Identifier ), 对于所有的UUID它可以保证在空间和时间上的唯一性. 它是通过MAC地址, 时间戳, 命名空间, 随机数, 伪随机数来保证生成ID的唯一性, 有着固定的大小( 128 bit ).  它的唯一性和一致性特点使得可以无需注册过程就能够产生一个新的UUID. UUID可以被用作多种用途, 既可以用来短时间内标记一个对象, 也可以可靠的辨别网络中的持久性对象. 

&#160; &#160; &#160; &#160;为什么要使用UUID?

&#160; &#160; &#160; &#160;很多应用场景需要一个id, 但是又不要求这个id 有具体的意义, 仅仅用来标识一个对象. 常见的例子有数据库表的id 字段. 另一个例子是前端的各种UI库, 因为它们通常需要动态创建各种UI元素, 这些元素需要唯一的id , 这时候就需要使用UUID了. 


## 2. Python的uuid模块
 
&#160; &#160; &#160; &#160;python的uuid模块提供UUID类和函数uuid1(), uuid3(), uuid4(), uuid5() 来生成1, 3, 4, 5各个版本的UUID ( 需要注意的是: python中没有uuid2()这个函数). 对uuid模块中最常用的几个函数总结如下: 

### 2.1 uuid.uuid1([node[, clock_seq]])
基于时间戳

&#160; &#160; &#160; &#160;使用主机ID, 序列号, 和当前时间来生成UUID, 可保证全球范围的唯一性. 但由于使用该方法生成的UUID中包含有主机的网络地址, 因此可能危及隐私. 该函数有两个参数, 如果 node 参数未指定, 系统将会自动调用 getnode() 函数来获取主机的硬件地址. 如果 clock_seq  参数未指定系统会使用一个随机产生的14位序列号来代替. 

### 2.2 uuid.uuid3(namespace, name)
基于名字的MD5散列值

&#160; &#160; &#160; &#160;通过计算命名空间和名字的MD5散列值来生成UUID, 可以保证同一命名空间中不同名字的唯一性和不同命名空间的唯一性, 但同一命名空间的同一名字生成的UUID相同.

### 2.3 uuid.uuid4()
基于随机数

&#160; &#160; &#160; &#160;通过随机数来生成UUID. 使用的是伪随机数有一定的重复概率. 

### 2.4 uuid.uuid5(namespace, name)
基于名字的SHA-1散列值

&#160; &#160; &#160; &#160;通过计算命名空间和名字的SHA-1散列值来生成UUID, 算法与 uuid.uuid3() 相同.


```
In [1]: import uuid

# make a UUID based on the host ID and current time
In [4]: uuid.uuid1()
Out[4]: UUID('4894dae8-35ad-11e9-a653-7427eab0aa2c')

# make a UUID using an MD5 hash of a namespace UUID and a name
In [5]: uuid.uuid3(uuid.NAMESPACE_DNS, 'python.org')
Out[5]: UUID('6fa459ea-ee8a-3ca4-894e-db77e160355e')

# make a random UUID
In [6]: uuid.uuid4()
Out[6]: UUID('c86ad986-498f-4caf-901e-198076f335d6')

# make a UUID using a SHA-1 hash of a namespace UUID and a name
In [7]: uuid.uuid5(uuid.NAMESPACE_DNS, 'python.org')
Out[7]: UUID('886313e1-3b8a-5372-9b90-0c9aee199e5d')

# make a UUID from a string of hex digits (braces and hyphens ignored)
In [8]: x = uuid.UUID('{00010203-0405-0607-0809-0a0b0c0d0e0f}')

# convert a UUID to a string of hex digits in standard form
In [9]: str(x)
Out[9]: '00010203-0405-0607-0809-0a0b0c0d0e0f'

# get the raw 16 bytes of the UUID
In [10]: x.bytes
Out[10]: b'\x00\x01\x02\x03\x04\x05\x06\x07\x08\t\n\x0b\x0c\r\x0e\x0f'

# make a UUID from a 16-byte string
In [11]: uuid.UUID(bytes=x.bytes)
Out[11]: UUID('00010203-0405-0607-0809-0a0b0c0d0e0f')
```

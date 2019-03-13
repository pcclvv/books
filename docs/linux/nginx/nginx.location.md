<center><h1>Nginx location</h1></center>

## 1. 作用
&#160; &#160; &#160; &#160;location指令的作用是可以根据用户请求的URI来执行不同的应用，其实就是根据用户请求的
网站地址URL匹配，匹配成功即进行相关的操作。

## 2. 语法
location使用的语法例子：

```
location [=|~|~*|^~] uri{
	        …
}
```

!!! note "解释"
    ```python
    location	[=|~|~*|^~|@]	uri	               {…}
    指令	    匹配标识	   匹配的网站网址	匹配URI后要执行的配置段
    ```

&#160; &#160; &#160; &#160;上述语法中的URI部分是关键，这个URI可以是普通的字符串地址路径或者是正则表达式，当匹配成功则执行后面大括号里面的相关指令。正则表达式的签名还可以有^或~*等特殊的字符。
这两种特殊字符~或~*匹配的区别为：


```
1. ~ 用于区分大小写（大小写敏感）的匹配；
2. ~* 用于不区分大小写的匹配。还可以用逻辑操作符！（叹号）对上面的匹配取反，即!~和!~*
3. ^~ 作用是在常规的字符串匹配检查之后，不做正则表达式的检查，即如果最明确的那个字符串
	    匹配的location匹配中有此前缀，那么不做正则表达式的检查。
```

## 3. 匹配实例
下面是一组典型的location匹配，是官方的例子

```
location = / {
		[configuration A]
}

location / {
		[configuration B]
}

location /documents/ {
		[configuration C]
}

location ^~ /images/ {
		[configuration D]
}

location ~*\.(gif|jpg|jpeg)${
		[configuration E]
}
```
在上述location配置中，用户请求对应匹配如下表：

用户请求的URI|完整的URL地址	|匹配的配置
---|---|---
/	|http://www.linux.ac.cn/	|configuration A
/index.html	|http://www.linux.ac.cn/	|configuration B
/documents/index.html	|http://www.linux.ac.cn/documents/index.html 	|configuration C
/images/1.gif	|http://www.linux.ac.cn/images/1.gif  	|configuration D
/documents/1.jpg	|http://www.linux.ac.cn/documents/1.jpg 	|configuration E


## 4. location实战

Nginx配置文件内容如下：

```
    server {
        listen       80;
        server_name  www.linux.ac.cn;

       location / {
	  return 401;
	  }

	location =/ {
          return 402;
        }

       location /documents/ {
          return 403;
        }

      location ^~/images/ {
          return 404;
        }

       location ~*\.(gif|jpg|jpeg)$ {
          return 500;
        }

    access_log  logs/www_access.log main;

    }
```
然后以linux客户端为例对上述location匹配进行真实测试，配置hosts文件如下。

```
[root@web01 web]# tail -1 /etc/hosts
192.168.1.10 www.linux.ac.cn
```
实验结果如下

```
[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn
402

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/
402

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/index.html
401

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/documents/index.html
403

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/documents/1.jpg
500

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/images/1.gif
404

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/kkk/1.gif
500

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/index.html
401

[root@web01 web]# curl -s -o /dev/null -I -w "%{http_code}\n" http://www.linux.ac.cn/kkk
401
```

用户请求说明：

![image](../../pictures/linux/nginx/p2.png)

上述不用URI及特殊字符组合匹配的顺序说明

不用URI及特殊字符组合的匹配顺序|匹配说明
---|---
第一名：location =/ {	|精确匹配/
第二名：location ^~/images/ {	|匹配常规字符串，不做正则匹配检查。
第三名：location ~*\.(gif|jpg|jpeg)$ {	|正则匹配
第四名：location /documents/ {	|匹配常规字符串，如果有正则则优先匹配正则
第五名：location / {	所|有location都不能匹配的时候默认匹配它

<center><h1>Django 中间件</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;什么是中间件？
request和respone之间的处理程序，settings.py中MIDDLEWARE数组中存储的就是中间件

```
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'app01.my_middlewares.AuthMiddleware',
    'app01.my_middlewares.IpLimitMiddleware',
]
```
中间件流程

```
客户端-》wsgiref模块-》中间件-》urls路由控制-》数据库MODEL,HTML模板
```

## 2. 自定义中间件
&#160; &#160; &#160; &#160;创建一个存放中间件的文件夹，如`my_middlewares.py`。

### 2.1 导入模块

```
from django.utils.deprecation import MiddlewareMixin
```
### 2.2 继承
创建相应的类（必须继承MiddlewareMixin）

```
class CustomerMiddleware(MiddlewareMixin)
    def process_request(self,request):
        print("Customer")
```
> 必须有request参数；不用返回值，让其默认返回none

### 2.3 注册自定义中间件
settings.py
```
MIDDLEWARE = [
...
...
...
"app01.my_middlewares.CustomerMiddleware",
```

### 2.4 中间件作用
&#160; &#160; &#160; &#160;只要浏览器访问服务器，就会访问中间件
&#160; &#160; &#160; &#160;作用：大部分视图函数要使用的代码就可以放到中间件中
&#160; &#160; &#160; &#160;比如，将登陆函数放到中间件中，访问服务器就会调用中间件，验证是否登录，使用中间件限制用户访问的频率

### 2.5 方法
在该类中，主要可以定义一下几个方法

方法|定义
---|:---
process_request	|def process_request(self,request):
process_response|	def process_response(self,request,response):
process_view	|process_view(self, request, callback, callback_args, callback_kwargs)
process_exception|	def process_exception(self,request,exception):


### 2.6 执行顺序
#### 2.6.1 正常

```
process_request-》url控制器-》process_view-》视图函数-》process_response
```

#### 2.6.2 异常
视图函数出错时候

```
process_request-》url控制器-》process_view-》视图函数出错-》process_exception-》process_response
```
setting.py中MIDDLEWARE列表执行顺序

&#160; &#160; &#160; &#160;当有多个中间件时，服务器发过来的数据依次从上向下执行函数，视图函数返回顺序时，从下向上执行

&#160; &#160; &#160; &#160;每个`process_request`将传过来的客户端的请求依次传给下一个process_request

&#160; &#160; &#160; &#160;每个`process_response`将传过来的响应体依次传给上一个process_response

ex:

```
process_request1-》process_request2-》url控制器-》process_view1-》》process_view2-》视图函数出错-》process_exception2-》process_exception1-》process_response2-》process_response1
```

## 3 实例
### 3.1 用户验证
&#160; &#160; &#160; &#160;如果我们想让一些页面在用户登录后才显示，我们除了可以使用用户认证装饰器装饰器以外，还可以使用中间件

```
from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import redirect
from authDemo import settings
class AuthMiddleware(MiddlewareMixin):
    def process_request(self,request):
        if request.path in settings.WHITE_LIST:
            return None
        #  用户登录验证
        if  not request.user.is_authenticated:
            return redirect("/login/")！
```

!!! note "注意"
    ```python
    1. settings.py里面创建一个WHITE_LIST列表，用来存放不需要加用户认证的url，比如登录，注册，注销url
    2. 如果用户没有登录，我们将其页面重定向到/login/
    ```

### 3.2 IP访问评率限制
如果我们想限制客户端ip的访问频率，我们可以使用中间件

```
from django.utils.deprecation import MiddlewareMixin
from django.shortcuts import redirect,HttpResponse
from authDemo import settings
import datetime

class IpLimitMiddleware(MiddlewareMixin):
    def process_request(self,request):
    if request.META.get("HTTP_X_FORWARDED_FOR"):
        ip = request.META["HTTP_X_FORWARDED_FOR"]
    else:
        ip = request.META["REMOTE_ADDR"]
    now_min = datetime.datetime.now().minute
    if ip in settings.BLACK_LIST:  # 查询ip是否在黑名单内
        return HttpResponse("你已经被加入黑名单")
    elif ip in settings.IP_LIST:
        if settings.IP_LIST[ip]["min"] == now_min:
            settings.IP_LIST[ip]["times"] += 1
            if settings.IP_LIST[ip]["times"] >= settings.LIMIT_VISIT_TIMES:  #判断用户访问次数是否太快，返回提醒用户
                if settings.IP_LIST[ip]["times"] >= settings.MAX_VISIT_TIMES: #如果用户访问次数非常多，加入黑名单
                    settings.BLACK_LIST.append(ip)
                return HttpResponse("访问频率过快")
        else:
            settings.IP_LIST[ip]["times"] = 0
            settings.IP_LIST[ip]["min"] = now_min
    else:
        settings.IP_LIST[ip] = {"times":1,"min":now_min}
```

!!! note "解释"
    ```python
    1. settings.py里创建一个IP_LIST字典，用来存储客户端ip和其他信息（其实可以单独放入数据库一个表中，不过从数据库中读取没有内存中读取快，访问速度会受到影响）
    2. 如果用户使用代理request.META["REMOTE_ADDR"]抓不到真实地址，所以我们首先使用request.META["HTTP_X_FORWARDED_FOR"]来获取用户真实地址
    3. 我们将其用户ip和访问次数储存，在settings.py中设置一个常量LIMIT_VISIT_TIMES，超过这个次数不让用户访问网页;MAX_VISIT_TIMES超过这个次数，将这个ip加入黑名单
    ```


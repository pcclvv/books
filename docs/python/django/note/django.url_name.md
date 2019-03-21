<center><h1>URL name</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;django重点之url别名[参数名必须是name,格式是name="XXX]，我们称url的别名。

```
1. 不论后台路径如何进行修改路径，前台访问的路径不变，永远是alias, 这样方便开发
2. 前台根据 {{ url "alias"}} 去views.py中查看name="alias"的url
```


## 2. 实例
### 2.1 url

```
urlpatterns = [
    path('admin/', admin.site.urls),
    path('hello1/', views.hello1, name='hello1'),
    path('hello2/', views.hello2, name='hello2'),
]

```
URL第四个参数别名操作，name="hello1",name='hello2',name里面的值代表的是我们的URL路径
### 2.2 views

```
def hello1(request):
    return render(request,'hello1.html')

def hello2(request):
    return render(request,'hello2.html')

```
### 2.3 html
hello1.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

<h1>hello1</h1>
<a href="{% url 'hello2' %}">hello2</a>
</body>
</html>
```
hello2.html

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>hello2</h1>
<a href="{% url 'hello1' %}">hello1</a>
</body>
</html>
```

!!! note "注意"
    ```python
    <a href="{% url 'hello2' %}">hello2</a>
    正常我们若是使用以下表示
    <a href="/hello2/">hello2</a>,若是路由url中变更的话。那么此时html中的标签也的跟着改。很麻烦。所以使用{% url 'hello2' %}。
    
    ```


## 3 测试
### 3.1 测试
我们在范围127.0.0.1:8000/hello1

```
hello1和一个a标签hello2，
```
当我们点击hello2的时候会跳转到hello2页面也就是http://127.0.0.1:8000/hello2/,


!!! note "注意"
    ```python
    name的作用就是url和后面的视图函数绑定，不论前面rul后面怎么修改
    ```

### 3.2 总结
当我们修改

```
path('hello2/', views.hello2, name='hello2'),
```
变更为

```
path('test/', views.hello2, name='hello2'),
```
那么后面的们的视图函数在hello2.html和hello.html 中的a标签就不需要了修改了，会自动关联前面修改后的url地址。


<center><h1>Jinja2 模板</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;Jinja2是Python最常用的模板引擎之一。它的灵感来自Django的模板系统，但它用一种富有表现力的语言扩展它，为模板作者提供了一套更强大的工具。最重要的是，它为安全性很重要的应用程序添加了沙盒执行和可选的自动转义。先来一个漂亮的例子

```
{％extends "layout.html"％}
{％block body％}
  <UL>
  {％for user in users％}
    <li> <a href="{{ user.url }}"> {{user.username}} </a> </ li>
  {％endfor％}
  </ UL>
{％endblock％}
```

!!! note "解释"
    ```python
    1. extends 是该页面继承了layout.html
    2. block body 是重写了 layout.html中的body这个部分
    3. for user in users 是后端的穿过来的users进行遍历
    4. {{ user.url }}是取值
    5. 下面会一一详解
    ```
    
[参考链接](http://docs.jinkan.org/docs/jinja2/)
   
&#160; &#160; &#160; &#160; 在前面的例子中，视图函数的主要作用是生成请求的响应，主要是简单的请求，实际上， 视图函数有两个作用，处理业务逻辑和返回响应内容，在大型应用中，把业务逻辑和表现内容放在一起，会增加代码的复杂度和维护成本，模板，它的作用，即返回响应的内容。

- 模板其实就是一个包含响应文本的文件，期中站位符(变量)表示动态部分。告诉模板引擎其具体的值需要从使用的数据中获取。
- 使用真实值替换变量，在返回最终得到的字符串，这个过程称为渲染。
- Flask是使用Jinja2这个模板引擎来渲染模板。

使用模板的好处:

- 视图函数只负责业务逻辑和数据处理(业务逻辑方面)
- 模板则取到视图函数的数据结果进行展示。视图展示方面
- 代码结构清晰，耦合度低


## 2. 返回模板
### 2.1 render_template 无参
&#160; &#160; &#160; &#160;我们之前写的都是返回hello 这样简单的字符串之类的。如何返回一个html呢，首先我们在templates文件夹内建立一个html文件。
然后return的时候调用`render_template('login.html')`,这样就可以吧login.html内容返回, `render_template`函数会自动在templates文件夹中找到对应的h。代码如下：

```
root@leco:~/code/flask/code# ls
app.py  templates
root@leco:~/code/flask/code# tree .
.
├── app.py
└── templates
    └── login.html

1 directory, 2 files
root@leco:~/code/flask/code# cat app.py
#!/usr/bin/python
# _*_ coding: utf-8 _*_
"""
@Time    : 2019/3/5 13:41
@File    : app.py
@Software: PyCharm
"""

from flask import Flask, render_template, redirect,request

app = Flask(__name__)


@app.route('/')
def hello_world():

    return 'Hello World!'


@app.route('/hello')
def hello():

    return 'Hello!'


@app.route('/login', methods=['GET', 'POST'])
def login():
    return render_template('login.html')


@app.route('/home')
def home():
    return redirect('/login')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9527, debug=True)


root@leco:~/code/flask/code# cat templates/login.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>登录页面</h1>
</form>
</body>
</html>

```
运行测试

```
root@leco:~/code/flask/code# python app.py
 * Running on http://0.0.0.0:9527/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 231-067-023
```
此时我们访问

```
root@leco:~/book/books/docs/python/flask# curl 127.0.0.1:9527/login
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>登录页面</h1>
</form>
</body>
```
此时返回了`login.html`的页面内容。但是页面是固定内容，怎么做到后端的内容传递给前端页面呢。请继续。



### 2.2 render_template 有参
&#160; &#160; &#160; &#160;上一小章节，我们可以通过`render_template` 返回html内容，但是没传递参数给前端，其实我们在`render_template`的时候是可以传递参数的，代码修改如下：
app.py 修改的部分
```

@app.route('/login', methods=['GET', 'POST'])
def login():
    name = "cmz"  #
    age = 10
    return render_template('login.html',name=name,age=age)  # 传递两个参数
```
login.html

```
root@leco:~/code/flask/code# cat templates/login.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<h1>登录页面</h1>
{{ name }} - {{ age }}
</form>
</body>
</html>
```

!!! tip "注意"

```python
1. {{ name }} - {{ age }} 接受从父亲传递过来的参数
2. return render_template('login.html',name=name,age=age)
    name=name ------> 等号前面的name就是要在login.html上调用的，等号后面的name是服务器这边传入的也就是'cmz'
    age 和name一样
3. 要是服务器传入的参数比较多的情况下。我们直接可以使用如下方法:
    return render_template('login.html',locals()) ------> 在前面的页面调用的也正是该视图函数传递过来的参数,其实`locals()`
    就是把视图函数传递过来的参数组成k-v一样的的字典传到前端
```




## 3. 具体用法
### 3.1 环境准备
和django的jinja语法一致
 
```
#!/usr/bin/python
# _*_ coding: utf-8 _*_
"""
@Time    : 2019/2/18 13:03
@File    : 1.py.py
@Software: PyCharm
"""
from flask import Flask, render_template, redirect, request

app = Flask(__name__)

STUDENT = {'name': '张三', 'age': 38, 'gender': '中'},

STUDENT_LIST = [
    {'name': '张三', 'age': 38, 'gender': '中'},
    {'name': '李四', 'age': 73, 'gender': '男'},
    {'name': '王五', 'age': 84, 'gender': '女'}
]

STUDENT_DICT = {
    1: {'name': '张三', 'age': 38, 'gender': '中'},
    2: {'name': '李四', 'age': 73, 'gender': '男'},
    3: {'name': '王五', 'age': 84, 'gender': '女'},
}


@app.route('/')
def hello_world():

    return 'Hello World!'


@app.route('/hello')
def hello():

    return 'Hello!'


@app.route('/login',methods=['GET', 'POST'])
def login():
    # print('你访问了login函数')
    # print(request.method)
    # print(request.path)
    # print(request.headers)
    # print(request.host)
    # print(request.host_url)
    # print(request.full_path)
    met = request.method
    if met == 'GET':
        return render_template('login.html')

    if met == 'POST':
        print("request.args = ", request.args)
        print("request.data = ", request.data)
        print("request.form = ", request.form)
        # print("request.values = ", request.values)
        username = request.form.get("username")
        pwd = request.form.get('pwd')
        if username=='cc' and pwd=='cc':
            return '登录成功'
        else:
            return render_template('login.html', msg='你丫写错了')


@app.route('/home')
def home():
    return redirect('/login')


@app.route('/detail')
def detail():
    return render_template('detail.html', stu=STUDENT)


@app.route('/detail_list')
def detail_list():
    return render_template('detail_list.html', stu_list=STUDENT_LIST)


@app.route('/detail_dict')
def detail_dict():
    return render_template('detail_dict.html', stu_dict=STUDENT_DICT)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=9527, debug=True)
    # app.run(host='0.0.0.0', debug=True)

# wsgi 应用程序网关接口，把你的请求处理后发送给对于的app中
# werkzeug Flask使用的

```

### 3.2 jina2 - 句点号
&#160; &#160; &#160; &#160;在前端展示取值的时候，后端传递过来的参数，我们都可以使用句点号，来取值。不管后端传递过来的是字典，列表，还是对象，都可以通过句点号取值，
语法

```
列表.数值
字典.数值
对象.数值

list1 = [1,2,3]
dict1 = {1:2,3:4}

```


detail.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>detail</title>
</head>
<body>
<!--{{ stu }}-->
{{ stu[0] }}
<table border="1px">
    <tr>
        <td>name</td>
        <td>age</td>
        <td>gender</td>
    </tr>
    <tr>
        <td>{{ stu[0].name }}</td>
        <td>{{ stu[0].age }}</td>
        <td>{{ stu[0]['gender'] }}</td>
    </tr>
</table>
</body>
</html>
```

测试结果
{'name'：'张三'，'年龄'：38，'性别'：'中'}

名称 | 年龄 | 性别  
---|---|---
张三|38|中

---

### 3.3 jina2 - for
&#160; &#160; &#160; &#160;后端传递过来的参数，我们可以通过遍历输出。
语法

```
{% for stu in stu_list %}
    代码块
{% endfor %}
```

detail_list.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>detail</title>
</head>
<body>
{{ stu_list }}
<table border="1px">
    <tr>
        <td>name</td>
        <td>age</td>
        <td>gender</td>
    </tr>
    {% for stu in stu_list %}
        <tr>
            <td>{{ stu.name }}</td>
            <td>{{ stu.age }}</td>
            <td>{{ stu.gender }}</td>
        </tr>
    {% endfor %}
</table>
<p>测试if</p>
<table border="1px">
     {% for stu in  stu_list %}
        {% if stu.name != '张三' %}
            <tr>
                <td>{{ stu.get("name") }}</td>
                <td>{{ stu.get("age") }}</td>
                <td>{{ stu.get("gender") }}</td>
            </tr>
        {% endif %}
    {% endfor %}
</table>
</body>
</html>
```
测试结果
[{'name'：'张三'，'年龄'：38，'性别'：'中'}，{'名称'：'李四'，'年龄'：73，'性别'：'男'} ，{'name'：'王五'，'年龄'：84，'性别'：'女'}]


名称 | 年龄 | 性别  
---|---|---
张三|38|中
李四|73|男
王五|84|女

测试如果

名称 | 年龄 | 性别  
---|---|---
李四|73|男
王五|84|女

以上使用了if判断，判断非张三就显示


---

detail_dict.html
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>detail</title>
</head>
<body>
{{ stu_dict }}
<table border="1px">
    <tr>
        <td>id</td>
        <td>name</td>
        <td>age</td>
        <td>gender</td>
    </tr>
    {% for id in  stu_dict %}
        <tr>
            <td>{{ id }}</td>
            <td>{{ stu_dict.get(id).get("name") }}</td>
            <td>{{ stu_dict.get(id).get("age") }}</td>
            <td>{{ stu_dict.get(id).get("gender") }}</td>
        </tr>
    {% endfor %}
</table>
测试 dict item
<table border="1px">
    <tr>
        <td>id</td>
        <td>name</td>
        <td>age</td>
        <td>gender</td>
    </tr>
    {% for id,stu in  stu_dict.items() %}
        <tr>
            <td>{{ id }}</td>
            <td>{{ stu.get("name") }}</td>
            <td>{{ stu.get("age") }}</td>
            <td>{{ stu.get("gender") }}</td>
        </tr>
    {% endfor %}
</table>
</body>
</html>
```
测试结果

{1：{'name'：'张三'，'年龄'：38，'性别'：'中'}，2：{'name'：'李四'，'年龄'：73，'性别'： '男'}，3：{'name'：'王五'，'年龄'：84，'性别'：'女'}}

ID|名称 | 年龄 | 性别  
---|---|---|---
1|张三|38|中
2|李四|73|男
3|王五|84|女

测试dict项目

ID|名称 | 年龄 | 性别  
---|---|---|---
1|张三|38|中
2|李四|73|男
3|王五|84|女

### 3.4 jina2 - if

```
<table border="1px">
     {% for stu in  stu_list %}
        {% if stu.name != '张三' %}
            <tr>
                <td>{{ stu.get("name") }}</td>
                <td>{{ stu.get("age") }}</td>
                <td>{{ stu.get("gender") }}</td>
            </tr>
        {% endif %}
    {% endfor %}
</table>
```


### 3.5 jina2 - extends
语法

```
{% extends 'hehe.html' %}
```
> 该页面继承于hehe.html

hehe.html

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>

<p>你好 123</p>
{% block a123 %}

{% endblock %}
<p>你好 456</p>
{% block a456 %}

{% endblock %}
<p>你好 789</p>
{% block a789 %}

{% endblock %}
</body>
</html>
```
测试结果
```
你好123

一二三
你好456

四五六
你好789

七八九
我是哈哈模板
```

### 3.6 jina2 - include
语法

```
{% include 'haha.html' %}
```
该处调用的haha.html的内容

haha.html

```
<h1>我是哈哈模板</h1>
```
测试结果
```
你好123

一二三
你好456

四五六
你好789

七八九
我是哈哈模板    <------------------- include 显示的部分
```
### 3.7 jina2 - 函数
后端渲染的函数传递给前端，这个是局部的，要是全局的话（也就是前端什么页面都可以调用）就是有template_global

```
def add_sum(*args):
    return sum(args)
```

前端使用

```
<p>{{ sum(1,2,3,4,5)}}</p>
```
测试结果
```
15
```


### 3.8 jina2 - safe
```
@app.route('/login',methods=['GET', 'POST'])
def login():
    # print('你访问了login函数')
    # print(request.method)
    # print(request.path)
    # print(request.headers)
    # print(request.host)
    # print(request.host_url)
    # print(request.full_path)
    met = request.method
    if met == 'GET':
        text_tag = '<p>你大爷的:  <input type="password" name="pwd"></p>'
        text_tag = Markup(text_tag)
        return render_template('login.html', msg=text_tag, sum=add_sum)

    if met == 'POST':
        print("request.args = ", request.args)
        print("request.data = ", request.data)
        print("request.form = ", request.form)
        # print("request.values = ", request.values)
        username = request.form.get("username")
        pwd = request.form.get('pwd')
        if username=='cc' and pwd=='cc':
            return '登录成功'
        else:
            return render_template('login.html', msg='你丫写错了')
```
前端展示的时候调用text_tag，我们在django的时候是使用safe如下

```
{{ text_tag| safe }}
```
这样就在前端的时候显示input标签了，在flask中可以后端做处理也就是有Markup。
前端直接使用即可，就直接渲染出input标签了
```
{{ text_tag}}
```
### 3.9 jina2 - template_global
后端
```
@app.template_global()
def add_add(*args):
    return sum(args)
```

前端调用，随便哪个页面调用，调用如下

```
<p>{{ add_add(1,2,3,4,5)}} </p>
```

### 3.10 jina2 - template_filter 
俗称过滤器

```
# 过滤器
@app.template_filter()
def oushu(sum):
    if not sum %2:
        return "偶数"
    else:
        return "奇数"
```
前端调用

```
<p> {{ sum(124,4) | oushu }}</p>
```
将前面sum(124,4)的值传递给oushu过滤器，结果是
```
偶数
```

### 3.11 jina2 - macro 
宏，使用的不多。

直接在前端页面上使用
```
{#    意义不大。宏指令#}
{% macro create_tag(na,ty) %}
    <input type="{{ ty }}" name="{{ na }}" value="{{ na }}">
{% endmacro %}
<h1>你向下看</h1>
{{ create_tag("按钮","submit") }}
```
这样就可以在前端页面上创建了一个按钮了。


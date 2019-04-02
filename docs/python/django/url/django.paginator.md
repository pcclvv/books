<center><h1> Django 分页器 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;分页器在页面中非常常见，当数据库条数数据过多时，页面一次性显示不好看时，我们可以使用分页器，将数据分几次显示。

### 1.2 造数据

```
Booklist=[]
for i in range(100):
    Booklist.append(Book(title="book"+str(i),price=30+i*i))
Book.objects.bulk_create(Booklist)
```
> 使用对象下面的bulk_create()，可以实现批量插入

### 1.3 导入模块

```
from django.core.paginator import Paginator
```

### 1.4 实例化

```
paginator = Paginator(book_list,10) 第一个为数据列表，第二个为每一页数据
```

### 1.5 方法
分页器对象相关的方法如下：

方法 | 作用
---|---
paginator.count()|	数据总数
paginator.num_pages()|	总页数
paginator.page_range()|	页码的迭代器

获取第n页数据

```
current_page = paginator.page(1)获取第一页的列表
```
方法|作用
---|---
current\_page.object\_list|	获取第n页对象列表
current\_page.has\_next()|	是否有下一页
current\_page.next\_page\_number()|	下一页的页码
current\_page.has\_previous()|	是否有上一页
current\_page.previous\_page\_number()|上一页的页码

> 注意： 如果在paginator.page(1)输入的页码数小于1或者大于最大页数，会报EmptyPage错误。
捕捉EmptyPage错误方法

## 2. 例子
views.py

```
def books(request):
    book_list = Book.objects.all()
    from django.core.paginator import  Paginator,EmptyPage
    paginator = Paginator(book_list,3)
    num_pages = paginator.num_pages
    current_page_num = int(request.GET.get("page",1))
    if num_pages > 11:
        if current_page_num < 5:
            page_range = range(1,11)
        elif current_page_num+5 > num_pages:
            page_range = range(num_pages-10,num_pages+1)
        else:
            page_range = range(current_page_num-5,current_page_num+5)
    else:
        page_range = paginator.page_range
    try:
        current_page = paginator.page(current_page_num)
    except EmptyPage as e:
        current_page = paginator.page(1)
    return render(request,"book.html",locals())
```

```
from django.core.paginator import EmptyPage
引入错误，使用try捕捉错误
try:
   内容
except EmptyPage as e:
    current_page=paginator.page(1)
```

book.html


```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>分页练习</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
    <script
            src="https://code.jquery.com/jquery-3.3.1.js"
            integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60="
            crossorigin="anonymous"></script>
</head>
<body>
<p>OK</p>
<table class="table table-striped">
    <tbody>
{#显示当前页面#}
    {% for book in current_page %}
        <tr>
            <td>{{ book.nid }}</td>
            <td>{{ book.title  }}</td>
            <td>{{ book.price}}</td>
        </tr>
    {% endfor %}
    </tbody>
</table>
{#显示页码#}
<ul class="pagination">
    {% if current_page.has_previous %}
        <li>
            <a href="?page={{ current_page.previous_page_number }}" aria-label="Previous">
                <span aria-hidden="true">&laquo;</span>
            </a>
        </li>
    {% else %}
        <li class="disabled">
            <a href="" aria-label="Previous">
                <span aria-hidden="true">&laquo;</span>
            </a>
        </li>
    {% endif %}

    {% for item in page_range %}
        {% if item == current_page_num %}
            <li class="active"><a href="?page={{ item }}">{{ item }}</a></li>
        {% else %}
            <li><a href="?page={{ item }}">{{ item }}</a></li>
        {% endif %}
    {% endfor %}

    {% if current_page.has_next %}
    <li>
        <a href="?page={{ current_page.next_page_number }}" aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
        </a>
    </li>
    {% else %}
    <li class="disabled">
        <a href="" aria-label="Next">
            <span aria-hidden="true">&raquo;</span>
        </a>
    </li>
    {% endif %}
</ul>

</body>
{#<script>#}
{#    $(".pagination li a").click(function () {#}
{#        $(this).parent().addClass("active").siblings("li").removeClass("active")#}
{#    })#}
{#</script>#}
</html>
```

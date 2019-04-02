<center><h1>表单有关空设置</h1></center>

## 1. 介绍
建立一个简易Model

```
class Person(models.Model):
    GENDER_CHOICES=(
        (1,'Male'),
        (2,'Female'),
        )
    name=models.CharField(max_length=30,unique=True,verbose_name='姓 名')   
    birthday=models.DateField(blank=True,null=True)
    gender=models.IntegerField(choices=GENDER_CHOICES)
    account=models.IntegerField(default=0)
```

## 2. blank
&#160; &#160; &#160; &#160;设置为True时，字段可以为空。设置为False时，字段是必须填写的。字符型字段CharField和TextField是用空字符串来存储空值的。如果为True，字段允许为空，默认不允许。

## 3. null
&#160; &#160; &#160; &#160;设置为True时，django用Null来存储空值。日期型、时间型和数字型字段不接受空字符串。所以设置IntegerField，DateTimeField型字段可以为空时，需要将blank，null均设为True。

&#160; &#160; &#160; &#160;如果为True，空值将会被存储为NULL，默认为False。

&#160; &#160; &#160; &#160;如果想设置BooleanField为空时可以选用NullBooleanField型字段。

## 4. 总结
&#160; &#160; &#160; &#160;null 是针对数据库而言，如果 null=True, 表示数据库的该字段可以为空。

&#160; &#160; &#160; &#160;blank 是针对表单的，如果 blank=True，表示你的表单填写该字段的时候可以不填，比如 admin 界面下增加 model 一条记录的时候。

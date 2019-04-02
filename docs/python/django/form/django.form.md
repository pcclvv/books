<center><h1> Django 表单 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;forms组件主要功能是检验字段的功能，校验表单中的键值对的功能

## 2. 功能
### 2.1 导入forms组件
```
from django import forms
```

### 2.2 建类

```
class UserForm(forms.Form):
    name = forms.CharField(min_length=4)
    email=forms.EmailField()
```

!!! note "注意"
    ```python
    1. name字段最小不得小于4个字节，email字段必须邮箱格式
    2. 该类必须继承forms.Form
    3. 只校验UserForm中的字段，传入的其他字段会被忽视，不会校验。
    4. forms存在该字段，校验时该字段就不能为空
    ```
一些常用的校验函数及其参数

校验函数 | 解释
---|:---
CharField|	校验字符串，可以设置max_length最大长度或最小长度min_length
DecimalField|	校验验证数字，前后空格会被忽略，max_value和min_value控制总长度，并应作为decimal.Decimal值给出。max_digits允许的小数+整数总位数;decimal_places允许的最大小数位数。
EmailField|	是否为有效的电子邮件地址,可选参数max_length和min_length
FileField|	非空文件数据是否已绑定到表单,max_length文件最大大小和allow_empty_file文件是否可以为空
FloatField|	验证给定值是否为float,可选max_value并且min_value
IntegerField|	验证给定值是否为整数。可选max_value和min_value

### 2.3 实例化

将需要验证的表单值传入，检验是否合法

```
form=UserForm({"name":"caimegzhi","email":"610658552@qq.com"})
```

也可以直接传入POST字典（但是前段键值必须与form一一对应）

```
form = UserForm(request.POST)
```

### 2.4 校验

相关API	|功能
---|:---
form.is_valid()	|校验全部通过返回True,否则返回False
form.cleaned_data|	返回字典，可以查看校验成功的字段（键值都放入）
form.errors|	可以查看校验失败的字段（键为校验错误的键，值为错误信息的列表）

### 2.5 渲染标签
&#160; &#160; &#160; &#160;forms组件还可以自动为我们在form表单中渲染校验字段的表单。

### 2.6 实例化
首先实例化一个forms类

```
form=UserForm() 不用传值
```

### 2.7 调用
#### 2.7.1 方式1
&#160; &#160; &#160; &#160;使用标签`{{ form.字段 }}`可以渲染出相应的input标签,在HTML中

```
<form action="" method="post">
    {% csrf_token %}
    <p>用户名：{{ form.name }}</p>
    <p>密码：{{ form.pwd }}</p>
    <p>再次确认密码：{{ form.re_pwd }}</p>
    <p>邮箱：{{ form.email }}</p>
    <p>电话：{{ form.tel }}</p>
    <input type="submit" value="注册">
</form>
```
视图函数

```
form=UserForm()
```
forms组件将自动将生成标签name属性变成相应的字段名

```
比如说<p>用户名：{{ form.name }}</p>
等同于<p>用户名：<input type="text" name="name"></p>
```

#### 2.7.2 方式2 推荐
使用for循环标签

```
<form action="" method="post">
    {% csrf_token %}
    {% for field in form %}
        <p>
            <label>{{ field.label }}</label>
            {{ field }} <span>{{ field.errors.0 }}</span>
        </p>
    {% endfor %}
    <input type="submit" value="注册">
</form>
```
使用`{{ form.字段.label }}`可以渲染出相应的label标签
> 注意：label标签默认显示的是字段名，如果想修改label标签显示的内容，可以在创建forms类时指定


```
class UserForm(forms.Form):
    name = forms.CharField(min_length=4,label="用户名")
    email=forms.EmailField(label="邮箱")
```
使用label参数进行指定，用这个UserForm渲染出的效果相当于

```
<p>用户名：{{ form.name }}</p>  
<p>邮箱：{{ form.email }}</p>
```

#### 2.7.3 方式3 不推荐

```
<form action="" method="post">
    {% csrf_token %}
    {{ form.as_ul }}
    <input type="submit" value="注册">
</form>
```

使用`{{ form.as_ul }}`可以自动渲染所有字段，每个字段使用label和input渲染，并且用ul包裹还可以选择用`as_p()`,`as_table()`分别是用`p`，`table`标签包裹


### 2.8 重置页面
&#160; &#160; &#160; &#160;当用户表单输入错误时，我们可能自己传入参数，设置各个input的value值，来渲染出一个重置页面，使用forms组件，可以快速渲染出一个重置界面，只需简单设置几步即可

```
def register(request):
    if request.method =="POST":
        form = UserForm(request.POST)
        if form.is_valid():
            return HttpResponse("ok")
        else:
            return render(request,"register.html",locals())
    else:
        form = UserForm()
        return render(request,"register.html",locals())
```

&#160; &#160; &#160; &#160;简单说，如果用户使用浏览器访问页面时，发送的是get请求，我们使用form = UserForm()传入一个没有参数的forms对象，在浏览器中，将自动渲染出各个字段的空白标签

&#160; &#160; &#160; &#160;如果用户提交表单时，我们实例化一个form = UserForm(request.POST)带有参数的forms对象，同样的，浏览器中会渲染出提交表单传入的参数内容。也就是说，输入错误时，返回的表单中用户输入的内容不会为空，会是用户上次输入错误的内容

## 2.9 错误显示
&#160; &#160; &#160; &#160;如果我们想在校验数据之后，将错误信息输入到HTML页面上，我们可以这样做。

### 2.9.1 实例化
&#160; &#160; &#160; &#160;首先将实例化的forms对象传入HTML。这样直接将局部变量全部当映射到HTML模板中（包括form）
```
form = UserForm()
return render(request,"register.html",locals())
```

### 2.9.2 调用
在HTML模板中调用相应的对象。

```
<form action="" method="post">
    {% csrf_token %}
    <p>用户名：{{ form.name }}<span>{{ form.name.errors.0 }}</span></p>
    <p>密码：{{ form.pwd }}<span>{{ form.pwd.errors.0 }}</span></p>
    <p>再次确认密码：{{ form.re_pwd }}<span>{{ form.re_pwd.errors.0 }}</span></p>
    <p>邮箱：{{ form.email }}<span>{{ form.email.errors.0 }}</span></p>
    <p>电话：{{ form.tel }}<span>{{ form.tel.errors.0 }}</span></p>
    <input type="submit" value="注册">
</form>
```

&#160; &#160; &#160; &#160;使用`{{ form.字段.errors.0 }}`标签 如果相应字段错误，可以渲染出相应的错误信息`{{form.字段.errors}}`是一个错误列表，我们使用`{{ form.字段.errors.0 }}`只取出第一个错误信息）

## 2.10 参数配置
&#160; &#160; &#160; &#160;使用widgets模块，我们可以给forms类中的字段设置相应的参数
### 2.10.1 导入

```
form django.forms import widgets
```

### 2.10.2 配置
&#160; &#160; &#160; &#160;设置forms组件在模板中生成的元素类型，如果我们设置一个校验字段为CharField类型，那么在HTML模板中生成的标签即为<input type='text'>类型
如果我们想修改生成的标签类型，怎么办？

```
pwd =forms.CharField(min_length=4,widget=widgets.PasswordInput())
```
使用widget参数可以设置标签类型，`PasswordInput()`代表将自动生成```类型标签

### 2.10.3 元素生成
&#160; &#160; &#160; &#160;设置forms组件在模板中生成元素的属性，如果我们想给每一个生成的元素中默认添加某些属性，我们可以在元素类型函数中使用attrs参数


```
name = forms.CharField(min_length=4,widget=widgets.TextInput(attrs={"class":"form-control"}))
```
在每个默认生成的元素中添加class属性，值为form-control通过attrs中存放需要设置键值对，这样bootstrap就会对其响应渲染。


## 3. 局部钩子
&#160; &#160; &#160; &#160;如果上述对字段的校验条件太少，不能满足我们的需要，我们可以对每个字段自定义校验的内容，就要使用局部钩子
使用方法

### 3.1 原理
&#160; &#160; &#160; &#160;当我们调用forms对象下的`s_valid()`函数时，将会进行字段校验；校验成功放入`clean_data`字典中，校验失败抛出异常，然后异常处理函数将校验失败的字段和错误信息存入errors字典中。而在django校验成功时，特意留下一个钩子，用来给用户自定义函数

```
if hasattr(self, 'clean_%s' % name):
    value = getattr(self, 'clean_%s' % name)()
    self.cleaned_data[name] = value
```

### 3.2 导入错误类型

```
from django.core.exceptions import ValidationError
```

ValidationError是用来抛出异常时的错误类型

### 3.3 建函数
然后在forms类中创建一个`clean_字段`的函数。

```
def clean_name(self)
```

### 3.4 取值
使用cleaned_data获取校验成功的值。

```
val = self.cleaned_data.get("name")
```

使用cleaned_data可以获取的校验成功的字典

### 3.5 示例
验证手机号码字段是否是十一位。

```
def clean_tel(self):
    val = self.cleaned_data.get("tel")
    if len(val)==11:
        return val
    else:
        raise ValidationError("手机号位数错误")
```
&#160; &#160; &#160; &#160;取出由forms校验成功的电话号码，对其进行校验，如果满足条件，将原来取出的字段原样返回，否则抛出异常


## 4. 全局钩子
&#160; &#160; &#160; &#160;如果我们想对多个字段之间的关系进行校验，比如说确认密码和密码需要相同，但用局部钩子只能对单个字段的值进行校验。这是候我们需要全局钩子。
第一步，同样导入ValidationError类型的错误。
```
from django.core.exceptions import ValidationError
```
### 4.1 原理
&#160; &#160; &#160; &#160;django同时也留一个clean函数，当用户想要对多个字段之间的关系进行校验时，直接覆盖掉这个函数，在函数中写出自己想校验的内容即可。

```
def clean(self):
    """
    Hook for doing any extra form-wide cleaning after Field.clean() has been
    called on every field. Any ValidationError raised by this method will
    not be associated with a particular field; it will have a special-case
    association with the field named '__all__'.
    """
    return self.cleaned_data
```

### 4.2 建函数[密码校准]
在forms类中创建一个clean函数

```
def clean(self):
    pwd = self.cleaned_data.get("pwd")
    re_pwd = self.cleaned_data.get("re_pwd")
    if pwd and re_pwd:
        if pwd == re_pwd:
            return self.cleaned_data
        else:
            raise ValidationError("两次密码不一致")
    return self.cleaned_data
```
如果校验成功，返回原来的clean_data字段，校验失败抛出异常ValidationError

!!! note "注意"
    ```python
    1. 在模板中，单个字段校验失败的错误信息我们可以使用{{form.字段.errors}}
    而全局钩子抛出的异常会被存入全局错误中，我们需要在python使用clean_errors = form.errors.get("__all__")获取全局错误信息，在模板中使用{{ clean_errors.0 }}获取错误信息
    
    2. 我们在校验时，还要判断if pwd and re_pwd:,代表如果单个字段校验失败，就不执行全局钩子。这样如果密码或者是确认密码格式不对，密码和确认密码也不相同时，只报一个密码或者是确认密码格式错误。
    ```


<center><h1>extend append</h1></center>


## 1. 介绍

```
list.append(object) 向列表中添加一个对象object
list.extend(sequence) 把一个序列seq的内容添加到列表中
```

## 2. 例子

```
In [6]: a=[1]

In [7]: a1=[2,3]

In [8]: a.append(a1)

In [9]: a
Out[9]: [1, [2, 3]]

In [10]: b=[1]

In [11]: b1=[2,3]

In [12]: b.extend(b1)

In [13]: b
Out[13]: [1, 2, 3]

```


!!! note "区别"
    使用append的时候，是将a1看作一个对象，整体打包添加到a对象中。
    使用extend的时候，是将b1看作一个序列，将这个序列和b序列合并，并放在其后面。

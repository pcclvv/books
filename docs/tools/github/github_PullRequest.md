<center><h1>github pull request</h1></center>

## 1. 概念

### 1.1 pull request

> 俗称: pr, 即将别人的项目克隆到本地，然后修改。最后希望作者能接受意见合并代码

## 2. 操作

1. fork这个操作的一系列细节;
2. 与两个远程仓库分别建立链接;
3. 将修改提交到自己的远程仓库;
4. Compare需要注意。

### 2.1 fork clone

1. 在github上找到对应的项目，对应项目右上角点击fork按钮
2. 在自己的github项目上找到fork的项目，然后clone到本地

### 2.2 增加远程项目

查看远程repository地址

```
my@MacBook ~/File/books git remote -v
origin	https://github.com/sona201/books.git (fetch)
origin	https://github.com/sona201/books.git (push)
```

### 2.3 关联原作者的repository
```
my@MacBook ~/File/books git remote add upstream https://github.com/caimengzhi/books.git
my@MacBook ~/File/books git remote -v
origin	https://github.com/sona201/books.git (fetch)
origin	https://github.com/sona201/books.git (push)
upstream	https://github.com/caimengzhi/books.git (fetch)
upstream	https://github.com/caimengzhi/books.git (push)
```

### 2.4 新建分支

建议新建分支，在新分支上修改代码，避免代码混乱
```
git checkout -b test-branch
```
如果不新建，默认是在master分支上修改代码

### 2.5 修改提交

修改代码，然后提交 推送到远程

```
git status
git add .
git push origin test-branch
```

### 2.6 创建pr

到这里看下就是在自己的github仓库上有了新提交

点击工具栏的`pull request`


## 3. 总结

1. fork
2. clone
3. git remote add upstream https://githua.com/xxxxxx.git
4. git checkout -b new-branch
5. "change code"
6. git push origin new-branch
7. pull request

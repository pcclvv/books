## 1. 标签的使用

前面回滚的是一串字符，又长又难记。
## 2. 简单实用
```
root@k8s4:~/git_test# git log --oneline --decorat
495c011 (HEAD -> master) meger testing to master both modify a
65b3dce modify a on testing branch
41d0dd3 modify a on master
a369899 Merge branch 'testing'
21af5cc commit master in branch master
81cec5e commit test on branch testing
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
```

## 3. 基本命令
```
git tag v1.0                                  # 当前提交内容打一个标签，方便回滚，每次提交都会打个tag
git tag                                       # 查看当前所有标签
git show v1.0                                 # 查看当前1.0版本的详细信息
git tag v1.2 -m 'version 1.2 release is test' # 创建带有说明的标签，
  -a 是指定标签名
  -m 是指定说明文字
git tag -d v1.0                               # 我们为同一个提交版本设置了两次标签，删除之前的v.10
```
 
## 4. 打标签
### 4.1 没指定特定的版本
```
root@k8s4:~/git_test# git log --oneline --decorat
495c011 (HEAD -> master) meger testing to master both modify a
65b3dce modify a on testing branch
41d0dd3 modify a on master
a369899 Merge branch 'testing'
21af5cc commit master in branch master
81cec5e commit test on branch testing
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
root@k8s4:~/git_test# git tag -a v1.0
然后新开的窗口记录tag的信息，我记录为
This is my v1.0 version 
```
#### 4.1.1 查看打的标签

```
root@k8s4:~/git_test# git tag
v1.0
```

### 4.2 指定特定的版本

```
root@k8s4:~/git_test# git log --oneline --decorat
495c011 (HEAD -> master, tag: v1.0) meger testing to master both modify a
65b3dce modify a on testing branch
41d0dd3 modify a on master
a369899 Merge branch 'testing'
21af5cc commit master in branch master
81cec5e commit test on branch testing
1afadfd modify a second   # 指定这个版本打标签
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
root@k8s4:~/git_test# git tag
v1.0
root@k8s4:~/git_test# git tag -a v2.0 1afadfd
root@k8s4:~/git_test# git tag
v1.0
v2.0
```
#### 4.2.1 查看打的标签

```
root@k8s4:~/git_test# git show v1.0
tag v1.0
Tagger: leco <leco@leco.com>
Date:   Tue Jan 15 14:56:45 2019 +0800

This is my v1.0 version

commit 495c011cd59214a3d8de425203162e6af50f41be
Merge: 41d0dd3 65b3dce
Author: leco <leco@leco.com>
Date:   Tue Jan 15 14:38:27 2019 +0800

    meger testing to master both modify a

diff --cc a
index 3bf17cd,a2b2d32..db90531
--- a/a
+++ b/a
@@@ -1,3 -1,3 +1,4 @@@
  1
  bbb
 +master
+ testing
```

## 5. tag操作
### 5.1 通过tag 恢复版本
以下是恢复到2.0版本

```
root@k8s4:~/git_test# touch b
root@k8s4:~/git_test# ls
a  b  master  test
root@k8s4:~/git_test# git reset --hard v2.0
HEAD is now at 1afadfd modify a second
root@k8s4:~/git_test# ls
a  b
```

### 5.2 删除tag

```
root@k8s4:~/git_test# git tag
v1.0
v2.0
root@k8s4:~/git_test# git tag -d v2.0
Deleted tag 'v2.0' (was 65b1d62)
root@k8s4:~/git_test# git tag
v1.0
```


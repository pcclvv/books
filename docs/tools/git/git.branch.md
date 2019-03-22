<center><h1>Git 分支</h1></center>
#### 介绍
git分支，从本质上来讲仅仅是指向提交对象的可变指针，在这一点上与SVN是有本质区别，SVN的分支实际上就是一个目录。

git的默认分支名字是master。在多次提交操作之后，你其实已经有一个指向最后那个提交对象的master分支，它会在每次的提交操作中自动向前移动。

- 查看分支
    - git branch
- 创建分支
    - git branch testing
- 切换分支
    - git checkout testing
- 合并分支
    - 在谁上合并谁的分支要注意，比如在master的分支上合并testing分支，就先切换到master分支上
    - 切换到master分支上在执行 git merge testing
- 删除分支
    - git branch -d testing

```
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# git log --oneline --decorate
1afadfd (HEAD -> master) modify a second  # 最后指向
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
```
> 解释
- HEAD 指向谁，当前就是哪个分支
- 操作之后，最后指向那个提交的分支


```
graph LR
A[HEAD]-->B[master]
B-->C[f30ab]
E[V1.0]-->C
C-->D[Snapshot C]
F[34ac2]-->C
F-->G[Snapshot B]
H[98ca9]-->F
H-->I[Snapshot A]

```
在实际项目开发中，尽量保证master分支稳定，仅用于发布新颁布，平时不要随便直接修改里面的数据文件

干活都在dev分支上，每人从dev分支创建自己的个人分支，开发完合并到dev分支，最后dev分支合并到master分支上

- 创建分支
```
root@k8s4:~/git_test# git branch testing
```
- 查看分支

```
root@k8s4:~/git_test# git branch
* master   # 当前在master分支（看*号位置）
  testing
```
此时master分支和testing分支都指向最后提交的那个commit

```
1afadfd (HEAD -> master, testing) modify a second  # 看地方就指向了哪个commit
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
```
- 切换分支

```
root@k8s4:~/git_test# git checkout testing
Switched to branch 'testing'
root@k8s4:~/git_test# git branch
  master
* testing
root@k8s4:~/git_test# cat a
1
bbb
```

- 在testing分支下操作

```
root@k8s4:~/git_test# git branch
* master
  testing
root@k8s4:~/git_test# git checkout testing
Switched to branch 'testing'
root@k8s4:~/git_test# git branch
  master
* testing
root@k8s4:~/git_test# cat a
1
bbb
root@k8s4:~/git_test# git log --oneline --decorate
1afadfd (HEAD -> testing, master) modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
root@k8s4:~/git_test# touch test
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git commit -m 'commit test on branch testing '
[testing 81cec5e] commit test on branch testing
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 test
root@k8s4:~/git_test# git status
On branch testing
nothing to commit, working directory clean
root@k8s4:~/git_test# ls
a  test
root@k8s4:~/git_test# git log --oneline --decorate
81cec5e (HEAD -> testing) commit test on branch testing
1afadfd (master) modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
root@k8s4:~/git_test# git branch
  master
* testing
root@k8s4:~/git_test# git checkout master
Switched to branch 'master'
root@k8s4:~/git_test# git branch
* master
  testing
root@k8s4:~/git_test# ls
a
```
> 此时看到在testing分支上的操作，在master上没有(需要合并)，因为master和head的HEAD指向不同的commit。这样就可以多人协作。

- 在master分支下操作

```
root@k8s4:~/git_test# git branch
* master
  testing
root@k8s4:~/git_test# touch master
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git commit -m 'commit master in branch master'
[master 21af5cc] commit master in branch master
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 master
root@k8s4:~/git_test# git log --oneline --decorate
21af5cc (HEAD -> master) commit master in branch master
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
```

- 合并分支
    - testing分支合并到master分支上

首先在master分支上执行

```
root@k8s4:~/git_test# git branch
* master
  testing
root@k8s4:~/git_test# git merge testing
```
此时会弹出一个界面，记录此次操作

```
GNU nano 2.5.3      File: /root/git_test/.git/MERGE_MSG           Modified

Merge branch 'testing'

# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
merge testing to master  # 新增内容 记录合并了什么信息
merge test to master

此时按下ctrl + X 后再按下Y 保存退出
Merge made by the 'recursive' strategy.
 test | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 test
 
# 此时可以看到testing分支下的数据已经合并过来了
root@k8s4:~/git_test# ls
a  master  test
root@k8s4:~/git_test# git branch
* master

此时可以看到testing分支合并过来的数据 
root@k8s4:~/git_test# git log --oneline --decorat
a369899 (HEAD -> master) Merge branch 'testing'
21af5cc commit master in branch master
81cec5e (testing, mster) commit test on branch testing
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a

# 切换到testing分支查看信息
root@k8s4:~/git_test# git checkout testing
Switched to branch 'testing'
root@k8s4:~/git_test# ls
a  test
root@k8s4:~/git_test# git log --oneline --decorat
81cec5e (HEAD -> testing, mster) commit test on branch testing
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
```

---
- 不同分支修改同一个文件后合并

```
root@k8s4:~/git_test# git branch         # 查看当前分支
* master
  testing
root@k8s4:~/git_test# ls 
a  master  test
root@k8s4:~/git_test# cat a
1
bbb
root@k8s4:~/git_test# echo 'master'>>a  # 在master分支上修改提交数据
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git commit -m 'modify a on master'
[master 41d0dd3] modify a on master
 1 file changed, 1 insertion(+)
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# git log --oneline --decorat  # 查看master分支上日志
41d0dd3 (HEAD -> master) modify a on master
a369899 Merge branch 'testing'
21af5cc commit master in branch master
81cec5e (testing, mster) commit test on branch testing
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a


root@k8s4:~/git_test# git checkout testing   # 切换到testing分支上操作数据
Switched to branch 'testing'
root@k8s4:~/git_test# ls
a  test
root@k8s4:~/git_test# cat a
1
bbb
root@k8s4:~/git_test# echo 'testing'>>a     # testing分支上修改提交数据
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git commit -m 'modify a on testing branch'
[testing 65b3dce] modify a on testing branch
 1 file changed, 1 insertion(+)
 

root@k8s4:~/git_test# git checkout master    # 切换到master分支上 合并testing分支
Switched to branch 'master'
root@k8s4:~/git_test# git merge testing
Auto-merging a
CONFLICT (content): Merge conflict in a
Automatic merge failed; fix conflicts and then commit the result.
root@k8s4:~/git_test# git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   a

no changes added to commit (use "git add" and/or "git commit -a")

# 出现这种情况就是master分支和testing分支都同时修改了同一个文件a,这样的情况必须手动修改
root@k8s4:~/git_test# cat a  # 查看同一个文件在两个分支下的差异
1
bbb
<<<<<<< HEAD
master    # 在master下的修改
=======
testing   # 在testing下修改
>>>>>>> testing
```
- 如何解决冲突
    - 就是在master分支上修改成你认为对
```
root@k8s4:~/git_test# git branch
* master
  testing

root@k8s4:~/git_test# vim a
root@k8s4:~/git_test# cat a    # 认为正确的
1
bbb
master
testing
root@k8s4:~/git_test# git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git add .    # 重新提交
root@k8s4:~/git_test# git commit -m 'meger testing to master both modify a'
[master 495c011] meger testing to master both modify a
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean

root@k8s4:~/git_test# git log --oneline --decorat  # 查看日志
495c011 (HEAD -> master) meger testing to master both modify a
65b3dce (testing) modify a on testing branch
41d0dd3 modify a on master
a369899 Merge branch 'testing'
21af5cc commit master in branch master
81cec5e (mster) commit test on branch testing
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a
```

---
- 删除分支

```
root@k8s4:~/git_test# git branch
* master
  testing
root@k8s4:~/git_test# git branch -d testing
Deleted branch testing (was 65b3dce).
root@k8s4:~/git_test# git branch
* master
```



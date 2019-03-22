<center><h1>Git 安装</h1></center>
#### 在线安装
- ubuntu 在线安装
    - apt-get install git -y
- centos 在线安装
    - yum install -y git

1. ubuntu
```
root@k8s4:/home/leco# apt-get install git
Reading package lists... Done
Building dependency tree
Reading state information... Done
git is already the newest version (1:2.7.4-0ubuntu1.4).
0 upgraded, 0 newly installed, 0 to remove and 4 not upgraded.
```

2. centos
```
[root@leco ~]# yum install git
Loaded plugins: fastestmirror
Setting up Install Process
Loading mirror speeds from cached hostfile
base                                                                                                                         | 3.7 kB     00:00
epel                                                                                                                         | 4.7 kB     00:00
epel/primary_db                                                                                                              | 6.0 MB     00:00
extras                                                                                                                       | 3.4 kB     00:00
mysql-connectors-community                                                                                                   | 2.5 kB     00:00
mysql-tools-community                                                                                                        | 2.5 kB     00:00
mysql56-community                                                                                                            | 2.5 kB     00:00
saltstack                                                                                                                    | 2.9 kB     00:00
updates                                                                                                                      | 3.4 kB     00:00
Package git-1.7.1-9.el6_9.x86_64 already installed and latest version
Nothing to do
```

##### 初始化本地
```
root@k8s4:~/git_test# git init
Initialized empty Git repository in /root/git_test/.git/
root@k8s4:~/git_test# ll -a
total 12
drwxr-xr-x 3 root root 4096 Jan 15 11:25 ./
drwx------ 9 root root 4096 Jan 15 11:25 ../
drwxr-xr-x 7 root root 4096 Jan 15 11:25 .git/
```

##### 2.基本配置
```
root@k8s4:/home/leco# git config
usage: git config [<options>]

Config file location
    --global              use global config file
    --system              use system config file
    --local               use repository config file
    -f, --file <file>     use given config file
    --blob <blob-id>      read config from given blob object

Action
    --get                 get value: name [value-regex]
    --get-all             get all values: key [value-regex]
    --get-regexp          get values for regexp: name-regex [value-regex]
    --get-urlmatch        get value specific for the URL: section[.var] URL
    --replace-all         replace all matching variables: name value [value_regex]
    --add                 add a new variable: name value
    --unset               remove a variable: name [value-regex]
    --unset-all           remove all matches: name [value-regex]
    --rename-section      rename section: old-name new-name
    --remove-section      remove a section: name
    -l, --list            list all
    -e, --edit            open an editor
    --get-color           find the color configured: slot [default]
    --get-colorbool       find the color setting: slot [stdout-is-tty]

Type
    --bool                value is "true" or "false"
    --int                 value is decimal number
    --bool-or-int         value is --bool or --int
    --path                value is a path (file or directory name)

Other
    -z, --null            terminate values with NUL byte
    --name-only           show variable names only
    --includes            respect include directives on lookup
```

##### 3.人员信息配置
```

root@k8s4:/home/leco# git config --global user.name leco
root@k8s4:/home/leco# git config --global user.email leco@leco.com
root@k8s4:/home/leco# cd
root@k8s4:~# ll .gitconfig
-rw-r--r-- 1 root root 43 Jan 15 11:22 .gitconfig
root@k8s4:~# cat .gitconfig
[user]
	name = leco
	email = leco@leco.com
	
root@k8s4:~# git config --list
user.name=leco
user.email=leco@leco.com
```

```
root@k8s4:~# mkdir git_test
root@k8s4:~# cd git_test/
root@k8s4:~/git_test# git init
Initialized empty Git repository in /root/git_test/.git/
root@k8s4:~/git_test# ll -a
total 12
drwxr-xr-x 3 root root 4096 Jan 15 11:25 ./
drwx------ 9 root root 4096 Jan 15 11:25 ../
drwxr-xr-x 7 root root 4096 Jan 15 11:25 .git/   # git 仓库
```

##### 流程图
```
graph TD
A[远程仓库]-->B[本地仓库]
B -->A
B-->C[暂存区域]
C-->B
C-->D[工作目录]
D-->C

```

- Workspace： 工作区
- Index/Stage/Cached : 缓存区
- Respository： 本地仓库
- Remote: 远程仓库

Git 命令就是用于将文件改动切换到不同空间来记录

##### 状态
```
root@k8s4:~/git_test# git status
On branch master  # 在master分支上

Initial commit

nothing to commit (create/copy files and use "git add" to track)
# 仓库没有任务
```
##### 新建后查看
```
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	a
	b
	c

nothing added to commit but untracked files present (use "git add" to track)
root@k8s4:~/git_test#
```

##### 提交文件后
```
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   a
	new file:   b
	new file:   c
```

> 解释
- untracked files就是缓存区
- git add filename 或者git add .(提交所有) 到缓存区
- git rm --cached <file> 是将之前提交的文件（也就是提交到缓存的文件）删除，返回到本地

##### 删除缓存c的文件

```
root@k8s4:~/git_test# git rm --cached c
rm 'c'
root@k8s4:~/git_test# ls
a  b  c
root@k8s4:~/git_test# git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   a
	new file:   b
```
> 解释，可以看到缓存文件只有a，b两个文件了，c文件被从缓存区中删除了，
- 要是完全删除c的话，就直接再本地继续把c文件删除即可

```
root@k8s4:~/git_test# rm c
```

- 直接删除的话（同时删除缓存区文件和本地文件）
```
root@k8s4:~/git_test# git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   a
	new file:   b

root@k8s4:~/git_test# git rm -f b
rm 'b'
root@k8s4:~/git_test# git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

	new file:   a
```

##### 提交
```
root@k8s4:~/git_test# git commit -m 'commit a'
[master (root-commit) e73cff4] commit a
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 a
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
```
> 注释
- git commit -m "后面是注释"，这样就将工作区文件提交到本地仓库
- commit之前一定要add也就是先将本地文件add到缓存区，然后commit后会提交到本地仓库

##### 改名 
- 方法1
    - 现将本地文件a 改为a.txt
    - 删除缓存区a文件
    - 提交a.txt文件
- 方法2
    - git mv oldfile newfile
    - git commit -m 'newfile'

```
# 方法1
root@k8s4:~/git_test# ls
a
root@k8s4:~/git_test# mv a a.txt
root@k8s4:~/git_test# ls
a.txt
root@k8s4:~/git_test# git status
On branch master
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    a

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	a.txt

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git rm --cached a
rm 'a'
root@k8s4:~/git_test# git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	deleted:    a

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	a.txt

root@k8s4:~/git_test# git add a.txt
root@k8s4:~/git_test# git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	renamed:    a -> a.txt

root@k8s4:~/git_test# git commit -m 'commit a.txt'
[master da4a5dd] commit a.txt
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename a => a.txt (100%)
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
```
```
# 方法2
root@k8s4:~/git_test# git mv a.txt a
root@k8s4:~/git_test# git commit -m 'rename a.txt to a'
[master 26e567b] rename a.txt to a
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename a.txt => a (100%)
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
```

##### 对比查看，修改了什么
1. git diff file 
    - 对比文件在本地和缓存区的差异
2. git diff --cached file
    - 对比文件在缓存区和本地仓库的差异
    
- git diff file
    - 就是查看本地和缓存区文件的对比
```
root@k8s4:~/git_test# echo '1'>>a
root@k8s4:~/git_test# git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git diff a
diff --git a/a b/a
index e69de29..d00491f 100644
--- a/a
+++ b/a
@@ -0,0 +1 @@  
+1            # 新加内容
```
- 修改后再提交到缓存区（git add），在比对
    - 这样缓存区文件和本地文件就一样了，所以对比后啥都没有

```
root@k8s4:~/git_test# git add a
root@k8s4:~/git_test# git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   a

root@k8s4:~/git_test# git diff a
```
- 再次对此，缓存区和本地仓库的差异
    - git diff --cached file 就是对比文件在缓存区和本地仓库的差异
```
root@k8s4:~/git_test# git diff --cached a
diff --git a/a b/a
index e69de29..d00491f 100644
--- a/a
+++ b/a
@@ -0,0 +1 @@
+1

```
- 继续将缓存区的文件提交到本地仓库后再对比

```
root@k8s4:~/git_test# git commit -m 'modify a'
[master ccf4d94] modify a
 1 file changed, 1 insertion(+)
root@k8s4:~/git_test# git diff --cached a  # 因为文件都提交到本地仓库了，所以对比后都一样了，
```

##### 查看提交的日志

```
root@k8s4:~/git_test# git log
commit ccf4d94ce795364ec9157fbdee829cbf2c0108b1
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:43:28 2019 +0800

    modify a

commit 26e567b47ad85ba7ea48e030e8d259bddf3d9b69
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:35:04 2019 +0800

    rename a.txt to a

commit da4a5ddc2a9795ba231e0e8a86dc501b93a63dc9
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:31:36 2019 +0800

    commit a.txt

commit e73cff4891f06c86c59f0fe316902cf829ae17e4
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:24:57 2019 +0800

    commit a
```
- 简写

```
root@k8s4:~/git_test# git log --oneline
1afadfd modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a

root@k8s4:~/git_test# git log --oneline --decorate
1afadfd (HEAD -> master) modify a second
ccf4d94 modify a
26e567b rename a.txt to a
da4a5dd commit a.txt
e73cff4 commit a

```
- 详细日志

```
root@k8s4:~/git_test# git log -p
commit 1afadfd79ce4a2676650401e9334b60b36550372
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:53:33 2019 +0800

    modify a second

diff --git a/a b/a
index d00491f..68fac01 100644
--- a/a
+++ b/a
@@ -1 +1,2 @@
 1
+bbb

commit ccf4d94ce795364ec9157fbdee829cbf2c0108b1
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:43:28 2019 +0800

    modify a

diff --git a/a b/a
index e69de29..d00491f 100644
--- a/a
+++ b/a
@@ -0,0 +1 @@
+1

commit 26e567b47ad85ba7ea48e030e8d259bddf3d9b69
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:35:04 2019 +0800

    rename a.txt to a

diff --git a/a b/a
new file mode 100644
index 0000000..e69de29
diff --git a/a.txt b/a.txt
deleted file mode 100644
index e69de29..0000000

commit da4a5ddc2a9795ba231e0e8a86dc501b93a63dc9
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:31:36 2019 +0800

    commit a.txt

diff --git a/a b/a
deleted file mode 100644
index e69de29..0000000
diff --git a/a.txt b/a.txt
new file mode 100644
index 0000000..e69de29

commit e73cff4891f06c86c59f0fe316902cf829ae17e4
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:24:57 2019 +0800

    commit a

diff --git a/a b/a
new file mode 100644
index 0000000..e69de29
```
- 查看历史几条记录
    - git log -n n表示显示最后修改的几条记录
```
root@k8s4:~/git_test# git log -2
commit 1afadfd79ce4a2676650401e9334b60b36550372
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:53:33 2019 +0800

    modify a second

commit ccf4d94ce795364ec9157fbdee829cbf2c0108b1
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:43:28 2019 +0800

    modify a

```



<center><h1>Git 版本恢复</h1></center>
### 版本恢复
- 1.本地修改后错误恢复
    - 用本地缓存区覆盖本地文件
    - git checkout -- file
- 2.本地修改后提交到缓存区后恢复
    - 用仓库覆盖缓存区文件
        - git reset HEAD file
        - git checkout -- file
    - 用缓存区文件覆盖本地文件
- 3.本地修改后提交到缓存区后然后再提交到本地仓库后恢复
    - git log     查历史版本号
    - git reflog  查看所有历史版本号
    - git reset --hard 版本号


#####  1. 本地修改后错误恢复

```
root@k8s4:~/git_test# echo 'ccc'>>a
root@k8s4:~/git_test# cat a
1
bbb
ccc
root@k8s4:~/git_test# git diff a
diff --git a/a b/a
index 68fac01..cc63771 100644
--- a/a
+++ b/a
@@ -1,2 +1,3 @@
 1
 bbb
+ccc
root@k8s4:~/git_test# git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git checkout -- a
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# cat a
1
bbb
```

##### 2.本地修改后提交到缓存区后恢复
```
root@k8s4:~/git_test# echo 'ccc'>>a   # 修改本地文件
root@k8s4:~/git_test# cat a           # 查看本地文本
1
bbb
ccc
root@k8s4:~/git_test# git status      # 查看缓存区状态
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git add .       # 提交文件到缓存区
root@k8s4:~/git_test# git status      # 查看缓存区状态
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   a

root@k8s4:~/git_test# git diff --cached  # 对比文件在缓存区和本地仓库的差异
diff --git a/a b/a
index 68fac01..cc63771 100644
--- a/a
+++ b/a
@@ -1,2 +1,3 @@
 1
 bbb
+ccc
root@k8s4:~/git_test# git reset HEAD a   # 本地仓库文件覆盖缓存区文件
Unstaged changes after reset:
M	a
root@k8s4:~/git_test# cat a              # 查看本地文件（没变。因为只用本地仓库覆盖了缓存区文件）
1
bbb
ccc
root@k8s4:~/git_test# git diff a         # 对比缓存区和本地文件差异
diff --git a/a b/a
index 68fac01..cc63771 100644
--- a/a
+++ b/a
@@ -1,2 +1,3 @@
 1
 bbb
+ccc
root@k8s4:~/git_test# git diff --cached a   # 对比仓库和缓存区文件差异
root@k8s4:~/git_test# git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git checkout -- a   # 缓存区文件覆盖本地文件
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# cat a               # 查看文件
1
bbb
```

##### 3.本地修改后提交到缓存区后然后再提交到本地仓库后恢复

```
root@k8s4:~/git_test# cat a                    # 查看本文件
1
bbb
root@k8s4:~/git_test# echo 'ccc'>>a            # 修改本地文件
root@k8s4:~/git_test# cat a
1
bbb
ccc
root@k8s4:~/git_test# git add .                # 提交到缓存区
root@k8s4:~/git_test# git status               # 查看状态
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   a

root@k8s4:~/git_test# git log                  # 查看历史日志
commit 1afadfd79ce4a2676650401e9334b60b36550372
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:53:33 2019 +0800

    modify a second

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

root@k8s4:~/git_test# git reset --hard ccf4d94ce  # 回退到某个版本也就是上面commit后面的值（可以取部分）
HEAD is now at ccf4d94 modify a
root@k8s4:~/git_test# cat a                       # 查看本地文件，已经回退到某一个版本文件了
1  
root@k8s4:~/git_test# git status                  # 查看状态
On branch master    
nothing to commit, working directory clean

# 恢复某个版本后，在这个版本之后的log也看不到，使用 git reflog是查看所有历史记录
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
root@k8s4:~/git_test# git reflog
ccf4d94 HEAD@{0}: reset: moving to ccf4d94ce
1afadfd HEAD@{1}: commit: modify a second
ccf4d94 HEAD@{2}: commit: modify a
26e567b HEAD@{3}: commit: rename a.txt to a
da4a5dd HEAD@{4}: commit: commit a.txt
e73cff4 HEAD@{5}: commit (initial): commit a
root@k8s4:~/git_test# git reset --hard 1afadfd  # 回退到某个版本
HEAD is now at 1afadfd modify a second
root@k8s4:~/git_test# cat a
1
bbb
```
t checkout -- file
- 2.本地修改后提交到缓存区后恢复
    - 用仓库覆盖缓存区文件
        - git reset HEAD file
        - git checkout -- file
    - 用缓存区文件覆盖本地文件
- 3.本地修改后提交到缓存区后然后再提交到本地仓库后恢复
    - git log     查历史版本号
    - git reflog  查看所有历史版本号
    - git reset --hard 版本号


#####  1. 本地修改后错误恢复

```
root@k8s4:~/git_test# echo 'ccc'>>a
root@k8s4:~/git_test# cat a
1
bbb
ccc
root@k8s4:~/git_test# git diff a
diff --git a/a b/a
index 68fac01..cc63771 100644
--- a/a
+++ b/a
@@ -1,2 +1,3 @@
 1
 bbb
+ccc
root@k8s4:~/git_test# git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git checkout -- a
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# cat a
1
bbb
```

##### 2.本地修改后提交到缓存区后恢复
```
root@k8s4:~/git_test# echo 'ccc'>>a   # 修改本地文件
root@k8s4:~/git_test# cat a           # 查看本地文本
1
bbb
ccc
root@k8s4:~/git_test# git status      # 查看缓存区状态
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git add .       # 提交文件到缓存区
root@k8s4:~/git_test# git status      # 查看缓存区状态
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   a

root@k8s4:~/git_test# git diff --cached  # 对比文件在缓存区和本地仓库的差异
diff --git a/a b/a
index 68fac01..cc63771 100644
--- a/a
+++ b/a
@@ -1,2 +1,3 @@
 1
 bbb
+ccc
root@k8s4:~/git_test# git reset HEAD a   # 本地仓库文件覆盖缓存区文件
Unstaged changes after reset:
M	a
root@k8s4:~/git_test# cat a              # 查看本地文件（没变。因为只用本地仓库覆盖了缓存区文件）
1
bbb
ccc
root@k8s4:~/git_test# git diff a         # 对比缓存区和本地文件差异
diff --git a/a b/a
index 68fac01..cc63771 100644
--- a/a
+++ b/a
@@ -1,2 +1,3 @@
 1
 bbb
+ccc
root@k8s4:~/git_test# git diff --cached a   # 对比仓库和缓存区文件差异
root@k8s4:~/git_test# git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   a

no changes added to commit (use "git add" and/or "git commit -a")
root@k8s4:~/git_test# git checkout -- a   # 缓存区文件覆盖本地文件
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# cat a               # 查看文件
1
bbb
```

##### 3.本地修改后提交到缓存区后然后再提交到本地仓库后恢复

```
root@k8s4:~/git_test# cat a                    # 查看本文件
1
bbb
root@k8s4:~/git_test# echo 'ccc'>>a            # 修改本地文件
root@k8s4:~/git_test# cat a
1
bbb
ccc
root@k8s4:~/git_test# git add .                # 提交到缓存区
root@k8s4:~/git_test# git status               # 查看状态
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

	modified:   a

root@k8s4:~/git_test# git log                  # 查看历史日志
commit 1afadfd79ce4a2676650401e9334b60b36550372
Author: leco <leco@leco.com>
Date:   Tue Jan 15 12:53:33 2019 +0800

    modify a second

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

root@k8s4:~/git_test# git reset --hard ccf4d94ce  # 回退到某个版本也就是上面commit后面的值（可以取部分）
HEAD is now at ccf4d94 modify a
root@k8s4:~/git_test# cat a                       # 查看本地文件，已经回退到某一个版本文件了
1  
root@k8s4:~/git_test# git status                  # 查看状态
On branch master    
nothing to commit, working directory clean

# 恢复某个版本后，在这个版本之后的log也看不到，使用 git reflog是查看所有历史记录
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
root@k8s4:~/git_test# git reflog
ccf4d94 HEAD@{0}: reset: moving to ccf4d94ce
1afadfd HEAD@{1}: commit: modify a second
ccf4d94 HEAD@{2}: commit: modify a
26e567b HEAD@{3}: commit: rename a.txt to a
da4a5dd HEAD@{4}: commit: commit a.txt
e73cff4 HEAD@{5}: commit (initial): commit a
root@k8s4:~/git_test# git reset --hard 1afadfd  # 回退到某个版本
HEAD is now at 1afadfd modify a second
root@k8s4:~/git_test# cat a
1
bbb
```


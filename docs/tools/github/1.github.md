Hub是一个面向开源及私有软件项目的托管平台，因为只支持git 作为唯一的版本库格式进行托管，故名gitHub。

gitHub于2008年4月10日正式上线，除了git代码仓库托管及基本的 Web管理界面以外，还提供了订阅、讨论组、文本渲染、在线文件编辑器、协作图谱（报表）、代码片段分享（Gist）等功能。目前，其注册用户已经超过350万，托管版本数量也是非常之多，其中不乏知名开源项目 Ruby on Rails、jQuery、python 等。
2018年6月4日，微软宣布，通过75亿美元的股票交易收购代码托管平台GitHub。

[git使用](https://blog.oldboyedu.com/git/)

github使用 [Github官网](https://github.com/)
- 注册用户
- 配置ssh-key
- 创建项目
- 克隆项目到本地
- 推送修改到远程

- 本地仓库关联远程（github）仓库，并把本地仓库内容推送到远程仓库上
    - 详细方法
    - 本地新创建仓库
    - 本地已经存在仓库
    
    ```
    …or create a new repository on the command line
    echo "# git" >> README.md
    git init
    git add README.md
    git commit -m "first commit"
    git remote add origin git@github.com:caimengzhi/git.git
    git push -u origin master
    …or push an existing repository from the command line
    git remote add origin git@github.com:caimengzhi/git.git
    git push -u origin master
    ```

只演示本地存在的仓库推到到github
```
root@k8s4:~/git_test# git status
On branch master
nothing to commit, working directory clean
root@k8s4:~/git_test# ls
a  b  master  test
```
关联本地仓库和远程仓库

```
root@k8s4:~/git_test# git remote add origin git@github.com:caimengzhi/git.git
                                     |           |______________________________ 远程仓库地址(github)
                                     |__________________________________________ 远程仓库名字
root@k8s4:~/git_test# git remote
origin

把自己的公约绑定到github
root@k8s4:~/git_test# ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
/root/.ssh/id_rsa already exists.
Overwrite (y/n)? y
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:Q/ctxUTf8bzz8VhNNpdIFV8vS1R2yAZ+9z1iUvLXczw root@k8s4
The key's randomart image is:
+---[RSA 2048]----+
|            .==**|
|           ..+=+X|
|        . ...+*o%|
|       . . .+= BO|
|        S  .o+oEO|
|         .  o.ooX|
|              . o|
|                 |
|                 |
+----[SHA256]-----+
root@k8s4:~/git_test# ls /root/.ssh/id_rsa
/root/.ssh/id_rsa
root@k8s4:~/git_test# cat /root/.ssh//id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdW9wXBlVkMGVjoBPK+TKC8+k8XDmzaZA1lHEGTv2T2NgmETIGLXsj2JzFcT600k8isLcwuPBTE1Sntm0829sbMtBaPjseFO7LAN64vWyXxEVyoRx1l4wM3zHMvBLlgb2Og5YzEhBd3rRPEAZlTq6vKeiJghkngDAHKA/0fk4oOiIHBB9p39EsBioi4EhIhvinie6LI0iGOZPQbrbGMnKOCIDzkN8WXtkIWS9VCwN88BGdgROYrJxcZFO7S5her6sjgBNvILw3uBhfGDwVtARtaFRwXG4TmK1n1OIoTE1LCEjNZwTq6bVkJvxDLQco2WcM9R4qcVrCrmokqVXaeYGn root@k8s4
```
推送

```
root@k8s4:~/git_test# git push -u origin master
Counting objects: 29, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (19/19), done.
Writing objects: 100% (29/29), 2.38 KiB | 0 bytes/s, done.
Total 29 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), done.
To git@github.com:caimengzhi/git.git
 * [new branch]      master -> master
Branch master set up to track remote branch master from origin.
```
产看github仓库上是否有数据


---
克隆远程仓库数据

```
root@k8s4:~/git_test# cd /opt/
root@k8s4:/opt# ls
root@k8s4:/opt# git clone https://github.com/caimengzhi/git.git
Cloning into 'git'...
#  因为是私有仓库所以要输入github的账号和密码，才能clone下来，
Username for 'https://github.com': xxx           # 这个地方输入github账号
Password for 'https://caimengzhi@github.com':    # github密码
remote: Enumerating objects: 29, done.
remote: Counting objects: 100% (29/29), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 29 (delta 3), reused 29 (delta 3), pack-reused 0
Unpacking objects: 100% (29/29), done.
Checking connectivity... done.
root@k8s4:/opt# ls
git
root@k8s4:/opt# cd git/
root@k8s4:/opt/git# ls
a  b  master  test

```
别的其他clone
- 要加账号
```
[root@leco git]# git clone https://caimengzhi@github.com/caimengzhi/git.git
Initialized empty Git repository in /opt/git/git/.git/
Password:   # 此地方要输入密码
remote: Enumerating objects: 29, done.
remote: Counting objects: 100% (29/29), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 29 (delta 3), reused 29 (delta 3), pack-reused 0
Unpacking objects: 100% (29/29), done.
[root@leco git]# pwd
/opt/git
[root@leco git]# ls
git
[root@leco git]# tree
.
└── git
    ├── a
    ├── b
    ├── master
    └── test

1 directory, 4 files
[root@leco git]# git remote
origin
```
本地修改后推送

```
root@k8s4:/opt/git# touch c
root@k8s4:/opt/git# git add .
root@k8s4:/opt/git# git commit -m 'commit c'
[master d381f99] commit c
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 c
root@k8s4:/opt/git# git push origin master
Username for 'https://github.com':  # 输入github账号
Password for 'https://caimengzhi@github.com': # 输入github密码
Counting objects: 2, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 207 bytes | 0 bytes/s, done.
Total 2 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To https://github.com/caimengzhi/git.git
   d504270..d381f99  master -> master
```
此时在会到之前的项目下创建文件后提交

```
root@k8s4:/opt/git# cd
root@k8s4:~# cd git_test/
root@k8s4:~/git_test# touch d
root@k8s4:~/git_test# git add .
root@k8s4:~/git_test# git commit -m 'commit -d'
[master 28d37c5] commit -d
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 d
root@k8s4:~/git_test# git push origin master
To git@github.com:caimengzhi/git.git
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to 'git@github.com:caimengzhi/git.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
竟然报错了，因为别的地方已经提交了数据，此时本地仓库和远程github仓库不一致。解决办法就是
- 把远程github仓库拉下来，合并后再退


```
# 1. 先从github上拉下来
root@k8s4:~/git_test# git fetch   
Warning: Permanently added the RSA host key for IP address '13.250.177.223' to the list of known hosts.
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (1/1), done.
remote: Total 2 (delta 1), reused 2 (delta 1), pack-reused 0
Unpacking objects: 100% (2/2), done.
From github.com:caimengzhi/git
   d504270..d381f99  master     -> origin/master
root@k8s4:~/git_test# ls
a  b  d  master  test

# 2. 然后本地仓库和之前拉下来的合并
root@k8s4:~/git_test# git merge origin/master
Merge made by the 'recursive' strategy.
 c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 c
 记录合并的内容

root@k8s4:~/git_test# ll
total 16
drwxr-xr-x 3 root root 4096 Jan 15 15:53 ./
drwx------ 9 root root 4096 Jan 15 14:37 ../
drwxr-xr-x 8 root root 4096 Jan 15 15:53 .git/
-rw-r--r-- 1 root root   21 Jan 15 15:24 a
-rw-r--r-- 1 root root    0 Jan 15 15:02 b
-rw-r--r-- 1 root root    0 Jan 15 15:53 c
-rw-r--r-- 1 root root    0 Jan 15 15:50 d
-rw-r--r-- 1 root root    0 Jan 15 15:24 master
-rw-r--r-- 1 root root    0 Jan 15 15:24 test

# 3. 然后再推送到远程
root@k8s4:~/git_test# git push -u origin master
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 426 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 1 local object.
To git@github.com:caimengzhi/git.git
   d381f99..752ef29  master -> master
Branch master set up to track remote branch master from origin.
root@k8s4:~/git_test#
```
> 注意
- 每次推送的时候，都要拉一下远程仓库的数据然后合并，保证本地仓库和远程仓库的数据一致
- 然后再修改本地数据后，再次推送到远程



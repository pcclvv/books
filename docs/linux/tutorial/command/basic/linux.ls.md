<center><h1>命令 - ls </h1></center>


## 1. 命令参数
命令`ls`或许跟写代码开始打印`hello world`一样，入门级别

## 2. 语法

```
ls（选项）（参数）

-a：显示所有档案及目录（ls内定将档案名或目录名称为“.”的视为影藏，不会列出）；
-A：显示除影藏文件“.”和“..”以外的所有文件列表；
-C：多列显示输出结果。这是默认选项；
-l：与“-C”选项功能相反，所有输出信息用单列格式输出，不输出为多列；
-F：在每个输出项后追加文件的类型标识符，具体含义：“*”表示具有可执行权限的普通文件，“/”表示目录，“@”表示符号链接，“|”表示命令管道FIFO，“=”表示sockets套接字。当文件为普通文件时，不输出任何标识符；
-b：将文件中的不可输出的字符以反斜线“”加字符编码的方式输出；
-c：与“-lt”选项连用时，按照文件状态时间排序输出目录内容，排序的依据是文件的索引节点中的ctime字段。与“-l”选项连用时，则排序的一句是文件的状态改变时间；
-d：仅显示目录名，而不显示目录下的内容列表。显示符号链接文件本身，而不显示其所指向的目录列表；
-f：此参数的效果和同时指定“aU”参数相同，并关闭“lst”参数的效果；
-i：显示文件索引节点号（inode）。一个索引节点代表一个文件；
--file-type：与“-F”选项的功能相同，但是不显示“*”；
-k：以KB（千字节）为单位显示文件大小；
-l：以长格式显示目录下的内容列表。输出的信息从左到右依次包括文件名，文件类型、权限模式、硬连接数、所有者、组、文件大小和文件的最后修改时间等；
-m：用“,”号区隔每个文件和目录的名称；
-n：以用户识别码和群组识别码替代其名称；
-r：以文件名反序排列并输出目录内容列表；
-s：显示文件和目录的大小，以区块为单位；
-t：用文件和目录的更改时间排序；
-L：如果遇到性质为符号链接的文件或目录，直接列出该链接所指向的原始文件或目录；
-R：递归处理，将指定目录下的所有文件及子目录一并处理；
--full-time：列出完整的日期与时间；
--color[=WHEN]：使用不同的颜色高亮显示不同类型的。
```

## 3. 实例

```
[root@localhost ~]# ls
anaconda-ks.cfg
[root@localhost ~]# ls -a 
.   anaconda-ks.cfg  .bash_profile  .cshrc  .tcshrc
..  .bash_logout     .bashrc        .pki    .viminfo
[root@localhost ~]# ls -A
anaconda-ks.cfg  .bash_profile  .cshrc  .tcshrc
.bash_logout     .bashrc        .pki    .viminfo
[root@localhost ~]# ls -C 
anaconda-ks.cfg
[root@localhost ~]# ls -l
total 4
-rw-------. 1 root root 1260 Apr 13  2019 anaconda-ks.cfg

# 水平输出文件列表
[root@localhost /]# ls -m
bin, boot, dev, etc, home, lib, lib64, media, mnt, opt, proc, root, run, sbin,
srv, sys, tmp, usr, var

# 修改最后一次编辑的文件，最近修改的文件显示在最上面。
[root@localhost /]# ls -t
dev  sys   usr    sbin  bin   run  etc   home   mnt  srv
var  proc  lib64  lib   root  tmp  boot  media  opt

# 显示递归文件
[root@localhost ~]# mkdir a/b/{c1,c2} -p
[root@localhost ~]# ls -R .
.:
a  anaconda-ks.cfg

./a:
b

./a/b:
c1  c2

./a/b/c1:

./a/b/c2:

# 打印文件的UID和GID
[root@localhost ~]# ls -n
total 4
drwxr-xr-x. 3 0 0   15 Apr 13 05:43 a
-rw-------. 1 0 0 1260 Apr 13  2019 anaconda-ks.cfg

# 列出文件和文件夹的详细信息
[root@localhost ~]# ls -l 
total 4
drwxr-xr-x. 3 root root   15 Apr 13 05:43 a
-rw-------. 1 root root 1260 Apr 13  2019 anaconda-ks.cfg

# 列出可读文件和文件夹详细信息
[root@localhost ~]# ls -lh
total 4.0K
drwxr-xr-x. 3 root root   15 Apr 13 05:43 a
-rw-------. 1 root root 1.3K Apr 13  2019 anaconda-ks.cfg

# 显示文件夹信息
[root@localhost ~]# ls -ld /etc/
drwxr-xr-x. 76 root root 8192 Apr 13 05:22 /etc/

# 按时间列出文件和文件夹详细信息
[root@localhost ~]# ls -lt
total 4
-rw-------. 1 root root 1260 Apr 13  2019 anaconda-ks.cfg
drwxr-xr-x. 3 root root   15 Apr 13 05:43 a

# 按修改时间列出文件和文件夹详细信息
[root@localhost ~]# ls -ltr /
total 20
drwxr-xr-x.   2 root root    6 Apr 11  2018 srv
drwxr-xr-x.   2 root root    6 Apr 11  2018 opt
drwxr-xr-x.   2 root root    6 Apr 11  2018 mnt
drwxr-xr-x.   2 root root    6 Apr 11  2018 media
drwxr-xr-x.   2 root root    6 Apr 11  2018 home
dr-xr-xr-x.   5 root root 4096 Apr 13 02:19 boot
drwxr-xr-x.  76 root root 8192 Apr 13 05:22 etc
drwxrwxrwt.   8 root root 4096 Apr 13 05:24 tmp
drwxr-xr-x.  26 root root  780 Apr 13 05:26 run
dr-xr-x---.   4 root root  151 Apr 13 05:43 root
lrwxrwxrwx.   1 root root    7 Apr 13  2019 bin -> usr/bin
lrwxrwxrwx.   1 root root    7 Apr 13  2019 lib -> usr/lib
lrwxrwxrwx.   1 root root    8 Apr 13  2019 sbin -> usr/sbin
lrwxrwxrwx.   1 root root    9 Apr 13  2019 lib64 -> usr/lib64
drwxr-xr-x.  13 root root  155 Apr 13  2019 usr
dr-xr-xr-x. 149 root root    0 Apr 13  2019 proc
dr-xr-xr-x.  13 root root    0 Apr 13  2019 sys
drwxr-xr-x.  19 root root  267 Apr 13  2019 var
drwxr-xr-x.  20 root root 3200 Apr 13  2019 dev

# 按照特殊字符对文件进行分类
[root@localhost nginx-1.2.1]# ls -F

auto/  CHANGES  CHANGES.ru  conf/  configure*  contrib/  html/  LICENSE  Makefile  man/  objs/  README  src/

# 列出文件并标记颜色分类
[root@localhost ~]# ls --color=auto
a  anaconda-ks.cfg
```
其他具体的参数详见

```
[root@localhost ~]# man ls
LS(1)                            User Commands                           LS(1)

NAME
       ls - list directory contents

SYNOPSIS
       ls [OPTION]... [FILE]...

DESCRIPTION
       List  information  about  the FILEs (the current directory by default).
       Sort entries alphabetically if none of -cftuvSUX nor --sort  is  speci‐
       fied.

       Mandatory  arguments  to  long  options are mandatory for short options
 Manual page ls(1) line 1 (press h for help or q to quit)
其他省略
```


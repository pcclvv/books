<center><h1>Linux命令</h1></center>
> 作者: caimengzhi
## 1. Linux命令行简介

### 1.1 Linux命令行概述

&#160;&#160;&#160; 众所周知，我们在使用windows系统很多时候，都是通过鼠标去选择，操作等。微软提供了一套很友善的图形桌面系统，我们通过鼠标很容易去复制，粘贴，新建，删除，等等操作，比如我们把`D`盘中的`cmz.txt` 文件复制到`E`盘,一般我们是先到`D`盘中找到`cmz.txt`文件，然后鼠标放在`cmz.txt`文件上，鼠标右击向下选择复制功能，然后通过鼠标选择到`E`盘指定位置后右击粘贴，此时文件`cmz.txt`就拷贝一份到此时`E`盘这个地方了，其实你感觉这样拷贝很快是吧，NO，NO，NO你有没有想过，你是从`D`盘拷贝文件到`E`盘的时间大部分都消耗在哪里了呢，其实就是找到你要选择的文件和你要粘贴的文件路径，若是文件曾经很多层的话，文件夹又很多，还是需要你一定时间的，毕竟你是一个人非机器，不能一下子找不到你的文件夹内的文件，尤其在海量文件的时候，你文件内找，毕竟费劲的，不信的话，你终究会有体会的。接下来让你感受一下`Linux`系统下是如何拷贝文件。

```
[root@cmz ~]# mkdir -p {D,E}
You have new mail in /var/spool/mail/root
[root@cmz ~]# echo 'data from D dir'>D/cmz.txt
[root@cmz ~]# ls D E
D:
cmz.txt

E:
[root@cmz ~]# cp D/cmz.txt E/
[root@cmz ~]# ls D E
D:
cmz.txt

E:
cmz.txt
```

&#160; &#160; &#160;上面就是把`D`文件夹下的`cmz.txt`拷贝到`E`文件夹内,通过以下操作实现

```linux
cp D/cmz.txt E/
```

&#160; &#160; &#160;其实这个是`Linux`系统的命令行操作，`Windows`系统也有类似的命令行，它叫`DOS`,`Linux`的命令行远不止这点。

### 1.2 超级用户

 &#160; &#160;不知道你使用`windows`操作系统的时候，注意账号[登录系统的用户]`administration`，其实这用户就是超级管理员，什么叫超级管理员呢，就是能对这个操作系统任何更改操作的人，也就有至高无上的权限，你有没有想到古代的皇帝呢，中央集权的唯一最高领袖，手里掌握着生杀大权，可谓是无所不能，这个超级管理员类似古代的皇帝，拥有最广泛的权限，你在使用windows的时候经常会有提示要是管理员方式运行什么什么的，就是这个道理，因为管理员权限很大，可以操作所有一切，`Linux`的系统上也有这样超级管理员，模式是`root`用户，也就是用户名是`root`，账号需要你配置。至于密码嘛，和`windows`一样，你在安装`windows`操作系统的时候,会让你输入一个密码，那个就是超级管理员的密码，你会说我虽然设置了密码，但是我开机的时候并没有让我输入账号啊，直接让我输入密码的啊，密码对了就进入系统了啊。对，你想的没错，其实是`windows`系统开机后会默认选择一个账号，`Linux`系统也类似，只不过开机后不会默认选择[除非你安装的图形系统]，需要你输入账号和密码。

 &#160; 数据无价，请谨慎操作，使用`root`用户的时候，你把你自己看成皇帝。生杀大权都在你手里，你杀掉大臣[系统中的文件]，很难再让大臣起死回生了。

### 1.2 查看帮助

 &#160; 接下来我们一整套教程都是在学习`Linux的`详细命令，我们拿到一个命令不知道如何使用，我们一定要先看帮助文档，那些顶层的大牛也就是写操作系统的人都想到我们这样的小白的迷茫了。大牛给我们写了命令去查看如何使用系统中的命令的帮助文档了，好比很多开发软件都会有附带`README.md`类似这样的文档，主要就是告诉你怎么使用这软件，或者说你买什么产品都有说明书吧，其实你或许都没在意过，那说明书就是告诉你这产品的使用规则。`Linux`系统也这样，都是人写的肯定符合人类的思维。

#### 1.2.1 man

 &#160; 功能说明

```
man 命令  【用于查询命令的帮助信息】
```

例子

```
[root@cmz ~]# man cp 
CP(1)                                                              User Commands                                                              CP(1)

NAME
       cp - copy files and directories

SYNOPSIS
       cp [OPTION]... [-T] SOURCE DEST
       cp [OPTION]... SOURCE... DIRECTORY
       cp [OPTION]... -t DIRECTORY SOURCE...

DESCRIPTION
       Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.

       Mandatory arguments to long options are mandatory for short options too.

       -a, --archive
              same as -dR --preserve=all

       --attributes-only
              don't copy the file data, just the attributes

       --backup[=CONTROL]
              make a backup of each existing destination file

       -b     like --backup but does not accept an argument

       --copy-contents
              copy contents of special files when recursive

       -d     same as --no-dereference --preserve=links

       -f, --force
              if an existing destination file cannot be opened, remove it and try again (this option is ignored when the -n option is also used)

       -i, --interactive
              prompt before overwrite (overrides a previous -n option)

       -H     follow command-line symbolic links in SOURCE

       -l, --link
              hard link files instead of copying

       -L, --dereference
              always follow symbolic links in SOURCE

       -n, --no-clobber
              do not overwrite an existing file (overrides a previous -i option)

       -P, --no-dereference
              never follow symbolic links in SOURCE

       -p     same as --preserve=mode,ownership,timestamps

       --preserve[=ATTR_LIST]
              preserve the specified attributes (default: mode,ownership,timestamps), if possible additional attributes: context, links, xattr, all

       -c     deprecated, same as --preserve=context

       --no-preserve=ATTR_LIST
              don't preserve the specified attributes

       --parents
              use full source file name under DIRECTORY

       -R, -r, --recursive
              copy directories recursively

       --reflink[=WHEN]
              control clone/CoW copies. See below

       --remove-destination
              remove each existing destination file before attempting to open it (contrast with --force)

       --sparse=WHEN
              control creation of sparse files. See below

       --strip-trailing-slashes
              remove any trailing slashes from each SOURCE argument

       -s, --symbolic-link
              make symbolic links instead of copying

       -S, --suffix=SUFFIX
              override the usual backup suffix

       -t, --target-directory=DIRECTORY
              copy all SOURCE arguments into DIRECTORY

       -T, --no-target-directory
              treat DEST as a normal file

       -u, --update
              copy only when the SOURCE file is newer than the destination file or when the destination file is missing

       -v, --verbose
              explain what is being done

       -x, --one-file-system
              stay on this file system

       -Z     set SELinux security context of destination file to default type

       --context[=CTX]
              like -Z, or if CTX is specified then set the SELinux or SMACK security context to CTX

       --help display this help and exit

       --version
              output version information and exit

       By  default,  sparse  SOURCE  files  are  detected by a crude heuristic and the corresponding DEST file is made sparse as well.  That is the
       behavior selected by --sparse=auto.  Specify --sparse=always to create a sparse DEST file whenever the SOURCE file contains  a  long  enough
       sequence of zero bytes.  Use --sparse=never to inhibit creation of sparse files.

       When  --reflink[=always] is specified, perform a lightweight copy, where the data blocks are copied only when modified.  If this is not pos‐
       sible the copy fails, or if --reflink=auto is specified, fall back to a standard copy.

       The backup suffix is '~', unless set with --suffix or SIMPLE_BACKUP_SUFFIX.  The version control method may be  selected  via  the  --backup
       option or through the VERSION_CONTROL environment variable.  Here are the values:

       none, off
              never make backups (even if --backup is given)

       numbered, t
              make numbered backups

       existing, nil
              numbered if numbered backups exist, simple otherwise

       simple, never
              always make simple backups

       As  a  special  case,  cp  makes a backup of SOURCE when the force and backup options are given and SOURCE and DEST are the same name for an
       existing, regular file.

       GNU coreutils online help: <http://www.gnu.org/software/coreutils/> Report cp translation bugs to <http://translationproject.org/team/>

AUTHOR
       Written by Torbjorn Granlund, David MacKenzie, and Jim Meyering.

COPYRIGHT
       Copyright © 2013 Free Software Foundation, Inc.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
       This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.

SEE ALSO
       The full documentation for cp is maintained as a Texinfo manual.  If the info and cp programs are properly installed at your site, the  com‐
       mand

              info coreutils 'cp invocation'

       should give you access to the complete manual.

GNU coreutils 8.22                              
```

#### 1.2.2 help

 &#160; 对于man，查询的命令的帮助是最全的。类似man的查询方式，还有一个help也可以查询，只不过更实用。

 &#160; 功能说明

```
命令 --help / 命令 --h 【用于查询命令的帮助信息】
```

  例子 

```
[root@cmz ~]# cp --help
Usage: cp [OPTION]... [-T] SOURCE DEST
  or:  cp [OPTION]... SOURCE... DIRECTORY
  or:  cp [OPTION]... -t DIRECTORY SOURCE...
Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY.

Mandatory arguments to long options are mandatory for short options too.
  -a, --archive                same as -dR --preserve=all
      --attributes-only        don't copy the file data, just the attributes
      --backup[=CONTROL]       make a backup of each existing destination file
  -b                           like --backup but does not accept an argument
      --copy-contents          copy contents of special files when recursive
  -d                           same as --no-dereference --preserve=links
  -f, --force                  if an existing destination file cannot be
                                 opened, remove it and try again (this option
                                 is ignored when the -n option is also used)
  -i, --interactive            prompt before overwrite (overrides a previous -n
                                  option)
  -H                           follow command-line symbolic links in SOURCE
  -l, --link                   hard link files instead of copying
  -L, --dereference            always follow symbolic links in SOURCE
  -n, --no-clobber             do not overwrite an existing file (overrides
                                 a previous -i option)
  -P, --no-dereference         never follow symbolic links in SOURCE
  -p                           same as --preserve=mode,ownership,timestamps
      --preserve[=ATTR_LIST]   preserve the specified attributes (default:
                                 mode,ownership,timestamps), if possible
                                 additional attributes: context, links, xattr,
                                 all
  -c                           deprecated, same as --preserve=context
      --no-preserve=ATTR_LIST  don't preserve the specified attributes
      --parents                use full source file name under DIRECTORY
  -R, -r, --recursive          copy directories recursively
      --reflink[=WHEN]         control clone/CoW copies. See below
      --remove-destination     remove each existing destination file before
                                 attempting to open it (contrast with --force)
      --sparse=WHEN            control creation of sparse files. See below
      --strip-trailing-slashes  remove any trailing slashes from each SOURCE
                                 argument
  -s, --symbolic-link          make symbolic links instead of copying
  -S, --suffix=SUFFIX          override the usual backup suffix
  -t, --target-directory=DIRECTORY  copy all SOURCE arguments into DIRECTORY
  -T, --no-target-directory    treat DEST as a normal file
  -u, --update                 copy only when the SOURCE file is newer
                                 than the destination file or when the
                                 destination file is missing
  -v, --verbose                explain what is being done
  -x, --one-file-system        stay on this file system
  -Z                           set SELinux security context of destination
                                 file to default type
      --context[=CTX]          like -Z, or if CTX is specified then set the
                                 SELinux or SMACK security context to CTX
      --help     display this help and exit
      --version  output version information and exit

By default, sparse SOURCE files are detected by a crude heuristic and the
corresponding DEST file is made sparse as well.  That is the behavior
selected by --sparse=auto.  Specify --sparse=always to create a sparse DEST
file whenever the SOURCE file contains a long enough sequence of zero bytes.
Use --sparse=never to inhibit creation of sparse files.

When --reflink[=always] is specified, perform a lightweight copy, where the
data blocks are copied only when modified.  If this is not possible the copy
fails, or if --reflink=auto is specified, fall back to a standard copy.

The backup suffix is '~', unless set with --suffix or SIMPLE_BACKUP_SUFFIX.
The version control method may be selected via the --backup option or through
the VERSION_CONTROL environment variable.  Here are the values:

  none, off       never make backups (even if --backup is given)
  numbered, t     make numbered backups
  existing, nil   numbered if numbered backups exist, simple otherwise
  simple, never   always make simple backups

As a special case, cp makes a backup of SOURCE when the force and backup
options are given and SOURCE and DEST are the same name for an existing,
regular file.

GNU coreutils online help: <http://www.gnu.org/software/coreutils/>
For complete documentation, run: info coreutils 'cp invocation'
```

平时我们该实用谁呢，请结合使用。man是能查询更详细的信息，而help一般查询你需要的一些

### 1.3 开关机注销

&#160;&#160;&#160; 我们使windows电脑的时候，晚上下班的时候鼠标点击关机，然后早上上班的时候，按下开机按键，启动系统，开启一天的工作生活。使用Linux方式也类似，不过Linux系统一般用于服务器比较多，一般服务器是很少关机的，一工作就是很多年不关机的。windows很难做到一直工作很多年不死机，不出问题，这就是为什么Linux的用于服务器的重要原因之一。

开机

```
和windows一样，按下开机按键，稍等片刻就可以进入系统啦
```

关机

```
shutdown [选项]
shutdown [-t seconds] [-rkhncfF] time [message]
```

> 说明 shutdown和[选项之间必须至少有一个空格，一般一个空格即可

**参数说明**：

```
-t seconds : 设定在几秒钟之后进行关机程序。
-k : 并不会真的关机，只是将警告讯息传送给所有使用者。
-r : 关机后重新开机。
-h : 关机后停机。
-n : 不采用正常程序来关机，用强迫的方式杀掉所有执行中的程序后自行关机。
-c : 取消目前已经进行中的关机动作。
-f : 关机时，不做 fcsk 动作(检查 Linux 档系统)。
-F : 关机时，强迫进行 fsck 动作。
time : 设定关机的时间。
message : 传送给所有使用者的警告讯息。
```

例子

```
[root@cmz ~]# shutdown -h now            # <-- 立刻关机
[root@cmz ~]# shutdown +5 “System will shutdown after 5 minutes” # <-- 5分钟够关机并显示警告信息
[root@cmz ~]# shutdown -r 12:00  # <-- 12点关机
Shutdown scheduled for Mon 2019-04-29 12:00:00 CST, use 'shutdown -c' to cancel.
You have new mail in /var/spool/mail/root
[root@cmz ~]# shutdown -c   # <-- 取消上面关机命令

Broadcast message from root@k8s-master01 (Mon 2019-04-29 10:02:39 CST):

The system shutdown has been cancelled at Mon 2019-04-29 10:03:39 CST!
```

类似系统操作开关机还有如下命令

```
halt
reboot
poweroff
```



### 1.4 感想

&#160;基础不牢地动山摇，正所谓万丈高楼平地起，一定要造好地基，否则总有一天风崩瓦解的时候。



## 2. 文件和目录

### 2.1 pwd

&#160;&#160;&#160;**&ensp;** 执行pwd指令可立刻得知您目前所在的工作目录的绝对路径名称。

```
[root@cmz ~]# cd /opt/
You have new mail in /var/spool/mail/root
[root@cmz opt]# ls
containerd  etcd  kubernetes
[root@cmz opt]# cd kubernetes/
[root@cmz kubernetes]# ls
bin  cfg  logs  ssl
[root@cmz kubernetes]# pwd
/opt/kubernetes
[root@cmz kubernetes]# cd /tmp/
[root@cmz tmp]# pwd
/tmp
```



### 2.2 cd

&emsp;Linux cd命令用于切换当前工作目录至 dirName(目录参数)。

&emsp;其中 dirName 表示法可为绝对路径或相对路径。若目录名称省略，则变换至使用者的 home 目录 (也就是刚 login 时所在的目录)。

&emsp;另外，"~" 也表示为 home 目录 的意思，"." 则是表示目前所在的目录，".." 则表示目前目录位置的上一层目录。

```
[root@cmz opt]# cd kubernetes/
[root@cmz kubernetes]# ls
bin  cfg  logs  ssl
[root@cmz kubernetes]# pwd
/opt/kubernetes
[root@cmz kubernetes]# cd cfg/
[root@cmz cfg]# ls
kube-apiserver  kube-controller-manager  kube-scheduler  token.csv
[root@cmz cfg]# pwd
/opt/kubernetes/cfg
[root@cmz cfg]# cd ..
[root@cmz kubernetes]# pwd
/opt/kubernetes
[root@cmz kubernetes]# cd ..
[root@cmz opt]# ls
containerd  etcd  kubernetes
[root@cmz opt]# pwd
/opt
[root@cmz opt]# cd .
[root@cmz opt]# pwd
/opt
```



### 2.3 tree

&emsp;Linux tree命令用于以树状图列出目录的内容。

&emsp;执行tree指令，它会列出指定目录下的所有文件，包括子目录里的文件。

语法

```
tree [-aACdDfFgilnNpqstux][-I <范本样式>][-P <范本样式>][目录...]
```

- -a 显示所有文件和目录。
- -A 使用ASNI绘图字符显示树状图而非以ASCII字符组合。
- -C 在文件和目录清单加上色彩，便于区分各种类型。
- -d 显示目录名称而非内容。
- -D 列出文件或目录的更改时间。
- -f 在每个文件或目录之前，显示完整的相对路径名称。
- -F 在执行文件，目录，Socket，符号连接，管道名称名称，各自加上"*","/","=","@","|"号。
- -g 列出文件或目录的所属群组名称，没有对应的名称时，则显示群组识别码。
- -i 不以阶梯状列出文件或目录名称。
- -I<范本样式> 不显示符合范本样式的文件或目录名称。
- -l 如遇到性质为符号连接的目录，直接列出该连接所指向的原始目录。
- -n 不在文件和目录清单加上色彩。
- -N 直接列出文件和目录名称，包括控制字符。
- -p 列出权限标示。
- -P<范本样式> 只显示符合范本样式的文件或目录名称。
- -q 用"?"号取代控制字符，列出文件和目录名称。
- -s 列出文件或目录大小。
- -t 用文件和目录的更改时间排序。
- -u 列出文件或目录的拥有者名称，没有对应的名称时，则显示用户识别码。
- -x 将范围局限在现行的文件系统中，若指定目录下的某些子目录，其存放于另一个文件系统上，则将该子目录予以排除在寻找范围外。

```
[root@cmz opt]# cd etcd/
[root@cmz etcd]# ls
bin  cfg  ssl
[root@cmz etcd]# tree .
.
├── bin
│   ├── etcd
│   └── etcdctl
├── cfg
│   └── etcd
└── ssl
    ├── ca.pem
    ├── server-key.pem
    └── server.pem

3 directories, 6 files
[root@cmz etcd]# tree -L 1
.
├── bin
├── cfg
└── ssl

3 directories, 0 files
[root@cmz etcd]# tree -L 2
.
├── bin
│   ├── etcd
│   └── etcdctl
├── cfg
│   └── etcd
└── ssl
    ├── ca.pem
    ├── server-key.pem
    └── server.pem

3 directories, 6 files

只显示目录
[root@cmz etcd]# tree -d .
.
├── bin
├── cfg
└── ssl

显示绝对路径
[root@cmz etcd]# tree -f .
.
├── ./bin
│   ├── ./bin/etcd
│   └── ./bin/etcdctl
├── ./cfg
│   └── ./cfg/etcd
└── ./ssl
    ├── ./ssl/ca.pem
    ├── ./ssl/server-key.pem
    └── ./ssl/server.pem

3 directories, 6 files

不显示树杈，显示绝对路径
[root@cmz etcd]# tree -if .
.
./bin
./bin/etcd
./bin/etcdctl
./cfg
./cfg/etcd
./ssl
./ssl/ca.pem
./ssl/server-key.pem
./ssl/server.pem

3 directories, 6 files

显示所有包括隐藏文件
[root@cmz cmz]# tree -a
.
├── .bash_history
├── .bash_logout
├── .bash_profile
└── .bashrc

0 directories, 4 files

显示详细信息
[root@cmz etcd]# tree -F .
.
├── bin/
│   ├── etcd*
│   └── etcdctl*
├── cfg/
│   └── etcd
└── ssl/
    ├── ca.pem
    ├── server-key.pem
    └── server.pem

3 directories, 6 files
过滤文件夹
[root@cmz etcd]# tree -F .|grep '/$'
├── bin/
├── cfg/
└── ssl/
```





### 2.4 mkdir

&emsp;Linux mkdir命令用于建立名称为 dirName 之子目录。

```
mkdir [-pv] dirName
```

- -p 确保目录名称存在，不存在的就建一个。
- -v 显示创建过程

```
[root@cmz cmz]# tree -d .
.

0 directories
[root@cmz cmz]# mkdir folder1 
[root@cmz cmz]# tree -d .
.
└── folder1

1 directory
---------------------------------------------
[root@cmz cmz]# mkdir folder2 -v
mkdir: created directory ‘folder2’
[root@cmz cmz]# tree -d .
.
├── folder1
└── folder2

2 directories
---------------------------------------------
[root@cmz cmz]# mkdir folder3/cmz
mkdir: cannot create directory ‘folder3/cmz’: No such file or directory
[root@cmz cmz]# mkdir folder3/cmz -p
[root@cmz cmz]# tree .
.
├── folder1
├── folder2
└── folder3
    └── cmz

4 directories, 0 files
---------------------------------------------
[root@cmz cmz]# mkdir -p folder4/{cmz1,cmz2,cmz3/cmz.txt} -pv
mkdir: created directory ‘folder4’
mkdir: created directory ‘folder4/cmz1’
mkdir: created directory ‘folder4/cmz2’
mkdir: created directory ‘folder4/cmz3’
mkdir: created directory ‘folder4/cmz3/cmz.txt’
[root@cmz cmz]# tree folder4
folder4
├── cmz1
├── cmz2
└── cmz3
    └── cmz.txt

4 directories, 0 files
期中加{}是可以连续创建，况且{}内是分层级
---------------------------------------------
[root@cmz cmz]# mkdir -p folder5/file_{1..5} -pv
mkdir: created directory ‘folder5’
mkdir: created directory ‘folder5/file_1’
mkdir: created directory ‘folder5/file_2’
mkdir: created directory ‘folder5/file_3’
mkdir: created directory ‘folder5/file_4’
mkdir: created directory ‘folder5/file_5’
[root@cmz cmz]# tree folder5
folder5
├── file_1
├── file_2
├── file_3
├── file_4
└── file_5

5 directories, 0 files
file_{1..5}表示序列
```



### 2.5 touch

&emsp;Linux touch命令用于修改文件或者目录的时间属性，包括存取时间和更改时间。若文件不存在，系统会建立一个新的文件。`ls -l` 可以显示档案的时间记录。

```
touch [-acfm][-d<日期时间>][-r<参考文件或目录>] [-t<日期时间>][--help][--version][文件或目录…]
```

- **参数说明**：
- a 改变档案的读取时间记录。
- m 改变档案的修改时间记录。
- c 假如目的档案不存在，不会建立新的档案。与 --no-create 的效果一样。
- f 不使用，是为了与其他 unix 系统的相容性而保留。
- r 使用参考档的时间记录，与 --file 的效果一样。
- d 设定时间与日期，可以使用各种不同的格式。
- t 设定档案的时间记录，格式与 date 指令相同。
- --no-create 不会建立新档案。
- --help 列出指令格式。
- --version 列出版本讯息。

```
普通，且常见的创建文件，文件事先不存在
[root@cmz cmz]# mkdir test
[root@cmz cmz]# cd test/
[root@cmz test]# touch cmz.txt
[root@cmz test]# tree .
.
└── cmz.txt

0 directories, 1 file
---------------------------------------------
更改文件时间戳
[root@cmz test]# stat cmz.txt 
  File: ‘cmz.txt’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 40717269    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-04-29 11:09:19.062368602 +0800
Modify: 2019-04-29 11:09:19.062368602 +0800
Change: 2019-04-29 11:09:19.062368602 +0800
 Birth: -
[root@cmz test]# touch -a cmz.txt
[root@cmz test]# stat cmz.txt 
  File: ‘cmz.txt’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 40717269    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-04-29 11:10:08.871161128 +0800
Modify: 2019-04-29 11:09:19.062368602 +0800
Change: 2019-04-29 11:10:08.871161128 +0800
 Birth: -
---------------------------------------------
指定时间戳
[root@cmz test]# touch -d 20200612 cmz2.txt
You have new mail in /var/spool/mail/root
[root@cmz test]# stat cmz2.txt 
  File: ‘cmz2.txt’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 40717270    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2020-06-12 00:00:00.000000000 +0800
Modify: 2020-06-12 00:00:00.000000000 +0800
Change: 2019-04-29 11:11:02.802815445 +0800
 Birth: -
---------------------------------------------
指定和某文件一样时间戳
[root@cmz test]# touch -r cmz2.txt cmz3.txt
[root@cmz test]# stat cmz3.txt 
  File: ‘cmz3.txt’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 40717271    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2020-06-12 00:00:00.000000000 +0800
Modify: 2020-06-12 00:00:00.000000000 +0800
Change: 2019-04-29 11:12:31.164498402 +0800
 Birth: -
---------------------------------------------
指定详细时间戳
[root@cmz test]# touch -t 202007082020.50 cmz4.txt
[root@cmz test]# stat cmz4.txt 
  File: ‘cmz4.txt’
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d	Inode: 40717274    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2020-07-08 20:20:50.000000000 +0800
Modify: 2020-07-08 20:20:50.000000000 +0800
Change: 2019-04-29 11:15:19.004999126 +0800
 Birth: -
---------------------------------------------
Access: 2020-07-08 20:20:50.000000000 +0800  <--- 最后访问时间
Modify: 2020-07-08 20:20:50.000000000 +0800  <--- 最后修改时间
Change: 2019-04-29 11:15:19.004999126 +0800  <--- 最后文件改变时间
```



### 2.6 ls

&emsp;Linux ls命令用于显示指定工作目录下之内容（列出目前工作目录所含之文件及子目录)。

```
 ls [-alrtAFR] [name...]
```

**参数** :

- -a 显示所有文件及目录 (ls内定将文件名或目录名称开头为"."的视为隐藏档，不会列出)
- -l 除文件名称外，亦将文件型态、权限、拥有者、文件大小等资讯详细列出
- -r 将文件以相反次序显示(原定依英文字母次序)
- -t 将文件依建立时间之先后次序列出
- -A 同 -a ，但不列出 "." (目前目录) 及 ".." (父目录)
- -F 在列出的文件名称后加一符号；例如可执行档则加 "*", 目录则加 "/"
- -R 若目录下有文件，则以下之文件亦皆依序列出
- -d 显示目录信息

```
[root@cmz cmz]# ls
folder1  folder2  folder3  folder4  folder5  test
---------------------------------------------
[root@cmz cmz]# ls -a
.  ..  folder1  folder2  folder3  folder4  folder5  test
---------------------------------------------
[root@cmz cmz]# ls -alhi
total 8.0K
  1136591 drwxr-xr-x   8 root root  125 Apr 29 11:29 .
100663361 dr-xr-x---. 18 root root 4.0K Apr 29 10:57 ..
  1136606 -rw-r--r--   1 root root    6 Apr 29 11:29 cmz1.txt
  1136607 lrwxrwxrwx   1 root root    7 Apr 29 11:29 cmz2.txt -> cmz2.ln
 67261863 drwxr-xr-x   2 root root    6 Apr 29 10:59 folder1
109570865 drwxr-xr-x   2 root root    6 Apr 29 10:59 folder2
  1136593 drwxr-xr-x   3 root root   17 Apr 29 11:00 folder3
 68388486 drwxr-xr-x   5 root root   42 Apr 29 11:03 folder4
109570869 drwxr-xr-x   7 root root   76 Apr 29 11:04 folder5
 40717268 drwxr-xr-x   2 root root  114 Apr 29 11:15 test
     |      |          |  |    |     |   |   |   |    |_____ 文件夹/文件
     |      |          |  |    |     |   |   |   |__________ 时间 -\
     |      |          |  |    |     |   |   |______________ 日     \ 文件最后修改时间
     |      |          |  |    |     |   |__________________ 月   -/
     |      |          |  |    |     |______________________ 文件/文件夹大小
     |      |          |  |    |____________________________ 所属组
     |      |          |  |_________________________________ 所属主
     |      |          |____________________________________ 硬链接数
     |      |_______________________________________________ 文件件类型和权限 
     |______________________________________________________ inode 节点号
文件类型
-	普通文件
d	目录
l  	符号链接
s（伪文件）	套接字
b（伪文件）	块设备
c（伪文件）	字符设备
p（伪文件）	管道

文件权限
   |------------------- 所属组
   /\    |------------- 所属组
  /   \  /\    |------- 其他人
  |   | /   \  /\
  |   | |   | /  \
d r w x r - x r - x
| | | | | | | | | |__ 执行权限
| | | | | | | | |____ 空
| | | | | | | |______ 如权限
| | | | | | |________ 读权限
| | | | | |__________ 执行权限
| | | | | |__________ 空
| | | | |____________ 读权限
| | | |______________ 执行权限
| | |________________ 写权限
| |__________________ 读权限
|____________________ 文件类似-d是目录

---------------------------------------------
[root@cmz cmz]# ls -alt
total 4
drwxr-xr-x   2 root root  114 Apr 29 11:15 test
drwxr-xr-x   8 root root   93 Apr 29 11:08 .
drwxr-xr-x   7 root root   76 Apr 29 11:04 folder5
drwxr-xr-x   5 root root   42 Apr 29 11:03 folder4
drwxr-xr-x   3 root root   17 Apr 29 11:00 folder3
drwxr-xr-x   2 root root    6 Apr 29 10:59 folder2
drwxr-xr-x   2 root root    6 Apr 29 10:59 folder1
dr-xr-x---. 18 root root 4096 Apr 29 10:57 ..
---------------------------------------------
folder1/  folder2/  folder3/  folder4/  folder5/  test/
[root@cmz cmz]# ls -l
total 0
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5
drwxr-xr-x 2 root root 114 Apr 29 11:15 test
[root@cmz cmz]# echo 'hello'>cmz1.txt
[root@cmz cmz]# echo 'hello'>cmz2.txt
[root@cmz cmz]# ll
total 8
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz1.txt
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz2.txt
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5
drwxr-xr-x 2 root root 114 Apr 29 11:15 test
[root@cmz cmz]# ll -F
total 8
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz1.txt
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz2.txt
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1/
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2/
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3/
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4/
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5/
drwxr-xr-x 2 root root 114 Apr 29 11:15 test/
[root@cmz cmz]# ln -sf cmz2.ln cmz2.txt 
[root@cmz cmz]# ls -lF
total 4
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz1.txt
lrwxrwxrwx 1 root root   7 Apr 29 11:29 cmz2.txt -> cmz2.ln
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1/
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2/
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3/
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4/
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5/
drwxr-xr-x 2 root root 114 Apr 29 11:15 test/
---------------------------------------------
倒序显示
[root@cmz cmz]# ls -l
total 4
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz1.txt
lrwxrwxrwx 1 root root   7 Apr 29 11:29 cmz2.txt -> cmz2.ln
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5
drwxr-xr-x 2 root root 114 Apr 29 11:15 test
[root@cmz cmz]# ls -lr
total 4
drwxr-xr-x 2 root root 114 Apr 29 11:15 test
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1
lrwxrwxrwx 1 root root   7 Apr 29 11:29 cmz2.txt -> cmz2.ln
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz1.txt
---------------------------------------------
只显示目录信息
[root@cmz cmz]# ls -dl test/
drwxr-xr-x 2 root root 114 Apr 29 11:15 test/
```

### 2.7 cp

&emsp;Linux cp命令主要用于复制文件或目录。

```
cp [options] source dest
```

或

```
cp [options] source... directory
```

**参数说明**：

- -a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
- -d：复制时保留链接。这里所说的链接相当于Windows系统中的快捷方式。
- -f：覆盖已经存在的目标文件而不给出提示。
- -i：与-f选项相反，在覆盖目标文件之前给出提示，要求用户确认是否覆盖，回答"y"时目标文件将被覆盖。
- -p：除复制文件的内容外，还把修改时间和访问权限也复制到新文件中。
- -r：若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件。
- -l：不复制文件，只是生成链接文件。

### 2.8 mv

&emsp;Linux mv命令用来为文件或目录改名、或将文件或目录移入其它位置。

```
mv [options] source dest
mv [options] source... directory
```

**参数说明**：

- -i: 若指定目录已有同名文件，则先询问是否覆盖旧文件;
- -f: 在mv操作要覆盖某已有的目标文件时不给任何指示;
- -n:不覆盖已经存在的文件
- -u:源文件比目标文件新，或者目标文件不存在的时候在移动
- -t:指定mv的目标目录，适合移动多个源文件到一个目录情况

```
询问
[root@cmz cmz]# ll
total 4
-rw-r--r-- 1 root root   6 Apr 29 11:29 cmz1.txt
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder1
drwxr-xr-x 2 root root   6 Apr 29 10:59 folder2
drwxr-xr-x 3 root root  17 Apr 29 11:00 folder3
drwxr-xr-x 5 root root  42 Apr 29 11:03 folder4
drwxr-xr-x 7 root root  76 Apr 29 11:04 folder5
drwxr-xr-x 2 root root 114 Apr 29 11:15 test
[root@cmz cmz]# ls test/
20207082020.50  202907082020.50  cmz2.txt  cmz3.txt  cmz4.txt  cmz.txt
[root@cmz cmz]# echo 'hello caimengzhi'> test/cmz1.txt
[root@cmz cmz]# ls test/
20207082020.50  202907082020.50  cmz1.txt  cmz2.txt  cmz3.txt  cmz4.txt  cmz.txt
[root@cmz cmz]# mv -i cmz1.txt test/
mv: overwrite ‘test/cmz1.txt’? y
[root@cmz cmz]# ls
folder1  folder2  folder3  folder4  folder5  test
---------------------------------------------
覆盖已有文件
[root@cmz cmz]# echo 'keke'>cmz1.txt
[root@cmz cmz]# cat test/cmz1.txt 
hello
[root@cmz cmz]# mv -f cmz1.txt test/
[root@cmz cmz]# cat test/cmz1.txt 
keke
---------------------------------------------
不覆盖已经存在的文件
[root@cmz cmz]# echo 'keke123'>cmz1.txt
[root@cmz cmz]# ls
cmz1.txt  folder1  folder2  folder3  folder4  folder5  test
[root@cmz cmz]# cat test/cmz1.txt 
keke
[root@cmz cmz]# mv -n cmz1.txt test/
[root@cmz cmz]# cat test/cmz1.txt 
keke
---------------------------------------------
[root@cmz cmz]# ls
cmz1.txt  folder1  folder2  folder3  folder4  folder5  test
[root@cmz cmz]# mv -t cmz1.txt folder1 folder2 test
mv: target ‘cmz1.txt’ is not a directory
[root@cmz cmz]# mv -t folder1 folder2 test
[root@cmz cmz]# ls
cmz1.txt  folder1  folder3  folder4  folder5
[root@cmz cmz]# ls folder1/
folder2  test
```



| 原文件                     | 目标文件  | 描述                                                         |
| -------------------------- | --------- | ------------------------------------------------------------ |
| 一个普通文件a              | 目录A     | 将普通文件a移动到目录A下                                     |
| 多个普通文件A1,A2,A3...... | 目录A     | 将多文件移动到目录A下                                        |
| 一个普通文件a              | 普通文件A | 将普通文件a，重命名为A,如若是文件A存在就提示是否覆盖         |
| 多个普通文件A1,A2,A3...... | 普通文件A | 会提示普通文件A不是目录                                      |
| 一个目录B                  | 目录A     | 若目录A不存在，目录B改名为A存在，就将目录A移动到目录B下      |
| 多个目录A1,A2,A3......     | 目录A     | 若是目录A不存在就报错，若是存在就将前面多个目录移动到目录A下 |
| 一个目录A                  | 普通文件A | 报错，说不是目录                                             |
| 多个目录A1,A2,A3......     | 普通文件A | 报错，说不是目录                                             |

### 2.9 rm

&emsp;Linux rm命令用于删除一个文件或者目录

```
rm [options] name...
```

**参数**：

- -i 删除前逐一询问确认。
- -f 即使原档案属性设为唯读，亦直接删除，无需逐一确认。
- -r 将目录及以下之档案亦逐一删除。

```
询问删除方式
[root@cmz cmz]# ls
folder1  folder3  folder4  folder5  ls
[root@cmz cmz]# rm ls -rf
[root@cmz cmz]# ls
folder1  folder3  folder4  folder5
[root@cmz cmz]# echo '123' > cmz1.txt
[root@cmz cmz]# ls
cmz1.txt  folder1  folder3  folder4  folder5
[root@cmz cmz]# rm -i cmz1.txt 
rm: remove regular file ‘cmz1.txt’? n
[root@cmz cmz]# ls
cmz1.txt  folder1  folder3  folder4  folder5
[root@cmz cmz]# rm -i cmz1.txt 
rm: remove regular file ‘cmz1.txt’? y
[root@cmz cmz]# ls
folder1  folder3  folder4  folder5
---------------------------------------------
强制删除文件
[root@cmz cmz]# echo '123' > cmz1.txt
[root@cmz cmz]# ls
cmz1.txt  folder1  folder3  folder4  folder5
[root@cmz cmz]# ls
cmz1.txt  folder1  folder3  folder4  folder5
[root@cmz cmz]# rm -f cmz1.txt 
[root@cmz cmz]# ls
folder1  folder3  folder4  folder5
---------------------------------------------
rm -r 询问删除目录下所有文件
[root@cmz cmz]# mkdir test
[root@cmz cmz]# echo '123' > test/cmz1.txt
[root@cmz cmz]# echo '123' > test/cmz2.txt
[root@cmz cmz]# echo '123' > test/cmz3.txt
You have new mail in /var/spool/mail/root
[root@cmz cmz]# tree .
.
└── test
    ├── cmz1.txt
    ├── cmz2.txt
    └── cmz3.txt

1 directory, 3 files
[root@cmz cmz]# rm -r test/
rm: descend into directory ‘test/’? y
rm: remove regular file ‘test/cmz1.txt’? y
rm: remove regular file ‘test/cmz2.txt’? y
rm: remove regular file ‘test/cmz3.txt’? y
rm: remove directory ‘test/’? y
[root@cmz cmz]# ls
---------------------------------------------
强制删除所有，rm 删除的时候不需要询问就加-f
[root@cmz cmz]# mkdir test
[root@cmz cmz]# echo '123' > test/cmz1.txt
[root@cmz cmz]# echo '123' > test/cmz2.txt
[root@cmz cmz]# echo '123' > test/cmz3.txt
[root@cmz cmz]# rm -rf ^C
[root@cmz cmz]# ls
test
[root@cmz cmz]# ls test/
cmz1.txt  cmz2.txt  cmz3.txt
[root@cmz cmz]# rm -rf test/
[root@cmz cmz]# ls

数据价更高，删除需谨慎。有时候你要是root的身份，删除某个文件，若是删除的错，你可能就把一个公司删掉了[重要数据，基本等于公司倒闭]。
```

### 2.10 rmdir

&emsp;Linux rmdir命令删除空的目录。

```
rmdir [-p] dirName
```

**参数**：

- -p 是当子目录被删除后使它也成为空目录的话，则顺便一并删除。
- -v 显示执行过程

```
默认不能删除非空目录
[root@cmz cmz]# ls
[root@cmz cmz]# mkdir a/b/c -p
[root@cmz cmz]# ls
a
[root@cmz cmz]# tree .
.
└── a
    └── b
        └── c

3 directories, 0 files
[root@cmz cmz]# rmdir a
rmdir: failed to remove ‘a’: Directory not empty

[root@cmz cmz]# rmdir -p -v a/b/c
rmdir: removing directory, ‘a/b/c’
rmdir: removing directory, ‘a/b’
rmdir: removing directory, ‘a’
[root@cmz cmz]# ls
```



> 工作中极少使用，基本都是使用rm替代rmdir。

### 2.11 ln

&emsp;Linux ln命令是一个非常重要命令，它的功能是为某一个文件在另外一个位置建立一个同步的链接。

&emsp;当我们需要在不同的目录，用到相同的文件时，我们不需要在每一个需要的目录下都放一个必须相同的文件，我们只要在某个固定的目录，放上该文件，然后在 其它的目录下用ln命令链接（link）它就可以，不必重复的占用磁盘空间。

```
 ln [参数]  [源文件或目录]  [目标文件或目录]
```

**参数**：

- 无参数 创建硬链接
- -s 创建软连接
- -f 强制覆盖

```
创建硬链接【看成双胞胎】
[root@cmz cmz]# echo 'cmz'>cmz.txt
[root@cmz cmz]# ls
cmz.txt
[root@cmz cmz]# ln cmz.txt cmz.hln
[root@cmz cmz]# ll
total 8
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.hln
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.txt
---------------------------------------------
创建软链接 【类似windows的快捷方式】
[root@cmz cmz]# ln -s cmz.txt cmz.ln 
[root@cmz cmz]# ll
total 8
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.hln
lrwxrwxrwx 1 root root 7 Apr 29 13:42 cmz.ln -> cmz.txt
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.txt
---------------------------------------------
[root@cmz cmz]# ll
total 8
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.hln
lrwxrwxrwx 1 root root 7 Apr 29 13:42 cmz.ln -> cmz.txt
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.txt
[root@cmz cmz]# ln -s cmz.txt cmz.ln2
[root@cmz cmz]# ln -s cmz.txt cmz.ln2
ln: failed to create symbolic link ‘cmz.ln2’: File exists
[root@cmz cmz]# ln -sf cmz.txt cmz.ln2
[root@cmz cmz]# ll
total 8
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.hln
lrwxrwxrwx 1 root root 7 Apr 29 13:42 cmz.ln -> cmz.txt
lrwxrwxrwx 1 root root 7 Apr 29 13:45 cmz.ln2 -> cmz.txt
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.txt
```

> 后面会有单独讲述软链接和硬链接区别

### 2.12 readlink

&emsp;查看链接文件详细信息。

```
readlink [参数] 链接
```

**参数**：

- -f 一直跟随符号链接，直到非符号链接的文件位置。要保证最后必须存在一个非符号链接文件

```
[root@cmz cmz]# ll
total 8
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.hln
lrwxrwxrwx 1 root root 7 Apr 29 13:42 cmz.ln -> cmz.txt
lrwxrwxrwx 1 root root 7 Apr 29 13:45 cmz.ln2 -> cmz.txt
-rw-r--r-- 2 root root 4 Apr 29 13:41 cmz.txt
[root@cmz cmz]# cat cmz.ln
cmz
[root@cmz cmz]# readlink cmz.ln
cmz.txt
[root@cmz cmz]# readlink -f cmz.ln
/root/cmz/cmz.txt
[root@cmz cmz]# ll -h /usr/bin/awk
lrwxrwxrwx. 1 root root 4 Apr 13 21:51 /usr/bin/awk -> gawk
[root@cmz cmz]# readlink /usr/bin/awk 
gawk
[root@cmz cmz]# readlink -f /usr/bin/awk 
/usr/bin/gawk

```

### 2.13 find

&emsp;Linux find命令用来在指定目录下查找文件。任何位于参数之前的字符串都将被视为欲查找的目录名。如果使用该命令时，不设置任何参数，则find命令将在当前目录下查找子目录与文件。并且将查找到的子目录和文件全部进行显示。

```
find   path   -option   [   -print ]   [ -exec   -ok   command ]   {} \;
```

**参数说明** :

find 根据下列规则判断 path 和 expression，在命令列上第一个 - ( ) , ! 之前的部份为 path，之后的是 expression。如果 path 是空字串则使用目前路径，如果 expression 是空字串则使用 -print 为预设 expression。

expression 中可使用的选项有二三十个之多，在此只介绍最常用的部份。

- -mount, -xdev : 只检查和指定目录在同一个文件系统下的文件，避免列出其它文件系统中的文件

- -amin n : 在过去 n 分钟内被读取过

- -anewer file : 比文件 file 更晚被读取过的文件

- -atime n : 在过去n天内被读取过的文件

- -cmin n : 在过去 n 分钟内被修改过

- -cnewer file :比文件 file 更新的文件

- -ctime n : 在过去n天内被修改过的文件

- -empty : 空的文件-gid n or -group name : gid 是 n 或是 group 名称是 name

- -ipath p, -path p : 路径名称符合 p 的文件，ipath 会忽略大小写

- -name name, -iname name : 文件名称符合 name 的文件。iname 会忽略大小写

- -size n : 文件大小 是 n 单位，b 代表 512 位元组的区块，c 表示字元数，k 表示 kilo bytes，w 是二个位元组。

- -type 

  - c : 文件类型是 c 的文件。
  - b：块设备
  - c：字符设备
  - d：目录
  - p：管道文件
  - l：符号链接文件
  - f：普通文件
  - s：socket文件

- -delete : 将找到的文件删除

- -exec：对匹配的文件执行该参数所给出的shell命令

- -ok：和-exec作用相同，但是在执行每个命令之前，都会让用户先确定是否执行

- -prune: 使用这个选项可以使find不在当前指定的目录中查找

- -print: 将匹配的文件输出到标准输出，默认功能，使用中可以省略

- OPERATORS: find支持逻辑运算符

- !: 取反

- -a: 取交集

- -o: 取并集

  

### 2.14 xargs

### 2.15 rename

### 2.16 basename

### 2.17 dirname

### 2.18 chattr

### 2.19 lsattr

### 2.20 file

### 2.21 md5sum

### 2.22 chown

### 2.23 chmod

### 2.24 chgrp

### 2.25 umask

## 3. 文件操作

### 3.1 cat

&emsp;cat 命令用于连接文件并打印到标准输出设备上。

```
cat [-AbeEnstTuv] [--help] [--version] fileName
```

参数说明

- -n 或 --number：由 1 开始对所有输出的行数编号
- -b 或 --number-nonblank：和 -n 相似，只不过对于空白行不编号。
- -s 或 --squeeze-blank：当遇到有连续两行以上的空白行，就代换为一行的空白行。
- -v 或 --show-nonprinting：使用 ^ 和 M- 符号，除了 LFD 和 TAB 之外。
- -E 或 --show-ends : 在每行结束处显示 $。
- -T 或 --show-tabs: 将 TAB 字符显示为 ^I。
- -A, --show-all：等价于 -vET。
- -e：等价于"-vE"选项；
- -t：等价于"-vT"选项；

```
[root@cmz cmz]# cat -n hosts 
     1	127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
     2	::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
     3	
     4	
     5	192.168.186.139 k8s-master01 
     6	192.168.186.141 k8s-node01
     7	192.168.186.142 k8s-node02
---------------------------------------------
[root@cmz cmz]# cat -b hosts 
     1	127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
     2	::1         localhost localhost.localdomain localhost6 localhost6.localdomain6


     3	192.168.186.139 k8s-master01 
     4	192.168.186.141 k8s-node01
     5	192.168.186.142 k8s-node02
---------------------------------------------
[root@cmz cmz]# cat -s hosts 
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.186.139 k8s-master01 
192.168.186.141 k8s-node01
192.168.186.142 k8s-node02
[root@cmz cmz]# cat -sn hosts 
     1	127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
     2	::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
     3	
     4	192.168.186.139 k8s-master01 
     5	192.168.186.141 k8s-node01
     6	192.168.186.142 k8s-node02
 ---------------------------------------------
[root@cmz cmz]# cat -E hosts 
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4$
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6$
$
$
192.168.186.139 k8s-master01 $
192.168.186.141 k8s-node01$
192.168.186.142 k8s-node02$
 ---------------------------------------------
[root@cmz cmz]# cat -T hosts 
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6


192.168.186.139 k8s-master01 
192.168.186.141 k8s-node01
192.168.186.142 k8s-node02
^I
```

### 3.2 tac

&emsp;倒着输出所有内容

```
[root@cmz cmz]# tac hosts 
	
192.168.186.142 k8s-node02
192.168.186.141 k8s-node01
192.168.186.139 k8s-master01 


::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
```



### 3.3 more

&emsp;Linux more 命令类似 cat ，不过会以一页一页的形式显示，更方便使用者逐页阅读，而最基本的指令就是按空白键（space）就往下一页显示，按 b 键就会往回（back）一页显示，而且还有搜寻字串的功能（与 vi 相似），使用中的说明文件，请按 h 。

```
more [-dlfpcsu] [-num] [+/pattern] [+linenum] [fileNames..]
```

**参数**：

- -num 一次显示的行数
- -d 提示使用者，在画面下方显示 [Press space to continue, 'q' to quit.] ，如果使用者按错键，则会显示 [Press 'h' for instructions.] 而不是 '哔' 声
- -l 取消遇见特殊字元 ^L（送纸字元）时会暂停的功能
- -f 计算行数时，以实际上的行数，而非自动换行过后的行数（有些单行字数太长的会被扩展为两行或两行以上）
- -p 不以卷动的方式显示每一页，而是先清除萤幕后再显示内容
- -c 跟 -p 相似，不同的是先显示内容再清除其他旧资料
- -s 当遇到有连续两行以上的空白行，就代换为一行的空白行
- -u 不显示下引号 （根据环境变数 TERM 指定的 terminal 而有所不同）
- +/pattern 在每个文档显示前搜寻该字串（pattern），然后从该字串之后开始显示
- +num 从第 num 行开始显示
- fileNames 欲显示内容的文档，可为复数个数

- Enter 向下n行，需要定义。默认为1行
- Ctrl+F 向下滚动一屏
- 空格键 向下滚动一屏
- Ctrl+B 返回上一屏
- = 输出当前行的行号
- ：f 输出文件名和当前行的行号
- V 调用vi编辑器
- !命令 调用Shell，并执行命令
- q 退出more

```
[root@master01 tmp]# more hosts 
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```

### 3.4 less

&emsp;less 与 more 类似，但使用 less 可以随意浏览文件，而 more 仅能向前移动，却不能向后移动，而且 less 在查看之前不会加载整个文件。

```
less [参数] 文件 
```

**参数说明**：

- -b <缓冲区大小> 设置缓冲区的大小
- -e 当文件显示结束后，自动离开
- -f 强迫打开特殊文件，例如外围设备代号、目录和二进制文件
- -g 只标志最后搜索的关键词
- -i 忽略搜索时的大小写
- -m 显示类似more命令的百分比
- -N 显示每行的行号
- -o <文件名> 将less 输出的内容在指定文件中保存起来
- -Q 不使用警告音
- -s 显示连续空行为一行
- -S 行过长时间将超出部分舍弃
- -x <数字> 将"tab"键显示为规定的数字空格
- /字符串：向下搜索"字符串"的功能
- ?字符串：向上搜索"字符串"的功能
- n：重复前一个搜索（与 / 或 ? 有关）
- N：反向重复前一个搜索（与 / 或 ? 有关）
- b 向后翻一页
- d 向后翻半页
- h 显示帮助界面
- Q 退出less 命令
- u 向前滚动半页
- y 向前滚动一行
- 空格键 滚动一页
- 回车键 滚动一行
- [pagedown]： 向下翻动一页
- [pageup]： 向上翻动一页

```
[root@master01 ~]# history | less
    1  yum install
    2  yum install net-tools
    3  sed -i 's@SELINUX=enforcing@SELINUX=disabled@g' /etc/selinux/config 
    4  setenforce 0
    5  systemctl disable firewalld  # 开机不自启防火墙
    1  yum install
```

### 3.5 head

&emsp;head 与 tail 就像它的名字一样的浅显易懂，它是用来显示开头或结尾某个数量的文字区块，head 用来显示档案的开头至标准输出中，而 tail 想当然尔就是看档案的结尾。 head 用来显示档案的开头至标准输出中，默认head命令打印其相应文件的开头10行。 

 ```
head [参数]... [文件]...
 ```

**参数说明**：

- -q 隐藏文件名
- -v 显示文件名
- -c<字节> 显示字节数
- -n<行数> 显示的行数

```
显示指定行数
[root@master01 ~]# head -n 5 anaconda-ks.cfg 
#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
---------------------------------------------
显示指定字节数
[root@master01 ~]# head -c 8 anaconda-ks.cfg 
#version[root@master01 ~]#
---------------------------------------------
显示文件名
[root@master01 ~]# head -v anaconda-ks.cfg 
==> anaconda-ks.cfg <==
#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
---------------------------------------------
隐藏文件名，默认模式
[root@master01 ~]# head -q anaconda-ks.cfg 
#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# Use CDROM installation media
cdrom
# Use graphical install
graphical
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
```

### 3.6 tail

&emsp;tail 命令可用于查看文件的内容，有一个常用的参数 **-f** 常用于查阅正在改变的日志文件。`tail -f filename` 会把 filename 文件里的最尾部的内容显示在屏幕上，并且不断刷新，只要 filename 更新就可以看到最新的文件内容。

**命令格式：**

```
tail [参数] [文件]  
```

**参数：**

- -f 循环读取

- -q 不显示处理信息

- -v 显示详细的处理信息

- -c<数目> 显示的字节数

- -n<行数> 显示文件的尾部 n 行内容

- --pid=PID 与-f合用,表示在进程ID,PID死掉之后结束

- -q, --quiet, --silent 从不输出给出文件名的首部

- -s, --sleep-interval=S 与-f合用,表示在每次反复的间隔休眠S秒

  

```
动态加载文件内容
[root@master01 src]# tail -f file 
line1
line2
---------------------------------------------
显示详细处理信息
[root@master01 src]# tail -v file 
==> file <==
line1
line2
---------------------------------------------
显示末尾3行
[root@master01 src]# tail -3f passwd 
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
saslauth:x:997:76:Saslauthd user:/run/saslauthd:/sbin/nologin
---------------------------------------------
显示文件 file 的最后 10 个字符
[root@master01 src]# cat file 
line1
line2
[root@master01 src]# tail -c 4 file 
ne2

```



### 3.7 tailf

&emsp;等价于`tail -f`,与`tail -f`不同的事，如果文件不增长，那么它不会访问磁盘文件，也不会更改文件的访问时间。

### 3.8 cut

&emsp;Linux cut命令用于显示每行从开头算起 num1 到 num2 的文字。

命令格式：

```
cut  [-bn] [file]
cut [-c] [file]
cut [-df] [file]
```

**使用说明:**

cut 命令从文件的每一行剪切字节、字符和字段并将这些字节、字符和字段写至标准输出。

如果不指定 File 参数，cut 命令将读取标准输入。必须指定 -b、-c 或 -f 标志之一。

**参数:**

- -b ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 -n 标志。
- -c ：以字符为单位进行分割。
- -d ：自定义分隔符，默认为制表符。
- -f ：与-d一起使用，指定显示哪个区域。
- -n ：取消分割多字节字符。仅和 -b 标志一起使用。如果字符的最后一个字节落在由 -b 标志的 List 参数指示的
  范围之内，该字符将被写出；否则，该字符将被排除

```
[root@master01 src]# cat info 
my name is caimengzhi.
my age is 32.
my hobby hadoop.
---------------------------------------------
按照字节为单位分割，
[root@master01 src]# cat info | cut -b 1
m
m
m
[root@master01 src]# cat info | cut -b 1,2
my
my
my
[root@master01 src]# cat info | cut -b 1,2,3
my 
my 
my 
[root@master01 src]# cat info | cut -b 1,2,3,4
my n
my a
my h
[root@master01 src]# cat info | cut -b 1-4
my n
my a
my h
```

> -c后面接取单个字节，取多个字节使用英文逗号[,]隔开，也支持连续选择，使用英文横岗[-]表示。

```
以字符为分割单位
[root@master01 src]# cat info | cut -c 1
m
m
m
[root@master01 src]# cat info | cut -c 1,2,3
my 
my 
my 
[root@master01 src]# cat info | cut -c 1,2,3,4
my n
my a
my h
[root@master01 src]# cat info | cut -c 1,2,3,4,5
my na
my ag
my ho
[root@master01 src]# cat info | cut -c 1-5
my na
my ag
my ho
本选项使用-c 和-d结果没有区别，是因为字母是单个字节字符，要是提前非字母就明显了
[root@master01 src]# cat cmz.txt |cut -b 1-2

i 
[root@master01 src]# cat cmz.txt 
我爱中国.
i love china.
[root@master01 src]# cat cmz.txt |cut -b 1-2

i 
[root@master01 src]# cat cmz.txt |cut -c 1-2
我爱
i 
---------------------------------------------
自定义分隔符，通常-d，-f搭配使用
[root@master01 src]# cat info 
my name is caimengzhi.
my age is 32.
my hobby hadoop.
[root@master01 src]# cat info | cut -d " " -f 1 
my
my
my
[root@master01 src]# cat info | cut -d " " -f 2 
name
age
hobby
[root@master01 src]# cat info | cut -d " " -f 3
is
is
hadoop.
```



### 3.9 split

&emsp;Linux split命令用于将一个文件分割成数个。该指令将大文件分割成较小的文件，在默认情况下将按照每1000行切割成一个小文件。

命令格式：

```bash
split [--help][--version][-<行数>][-b <字节>][-C <字节>][-l <行数>][要切割的文件][输出文件名]
```

**参数说明**：

- -<行数> : 指定每多少行切成一个小文件
- -b<字节> : 指定每多少字节切成一个小文件
- -d: 使用数字后缀
- -a: 指定后缀长度，默认为2位字母
- -l：指定分割后最大行数
- --help : 在线帮助
- --version : 显示版本信息
- -C<字节> : 与参数"-b"相似，但是在切 割时将尽量维持每行的完整性
- [输出文件名] : 设置切割后文件的前置文件名， split会自动在前置文件名后再加上编号

```
[root@master01 test]# cat ori.txt 
1
2
3
4
5
6
7
8
9
10
[root@master01 test]# split -2 ori.txt 
[root@master01 test]# ll
total 24
-rw-r--r-- 1 root root 21 Apr 30 02:22 ori.txt
-rw-r--r-- 1 root root  4 Apr 30 02:22 xaa
-rw-r--r-- 1 root root  4 Apr 30 02:22 xab
-rw-r--r-- 1 root root  4 Apr 30 02:22 xac
-rw-r--r-- 1 root root  4 Apr 30 02:22 xad
-rw-r--r-- 1 root root  5 Apr 30 02:22 xae
[root@master01 test]# cat xaa 
1
2
[root@master01 test]# cat xab
3
4
[root@master01 test]# cat xac
5
6
[root@master01 test]# cat xad
7
8
[root@master01 test]# cat xae
9
10
也可以指定名字
[root@master01 test]# split -2 ori.txt  cmz_
[root@master01 test]# ll
total 24
-rw-r--r-- 1 root root  4 Apr 30 02:24 cmz_aa
-rw-r--r-- 1 root root  4 Apr 30 02:24 cmz_ab
-rw-r--r-- 1 root root  4 Apr 30 02:24 cmz_ac
-rw-r--r-- 1 root root  4 Apr 30 02:24 cmz_ad
-rw-r--r-- 1 root root  5 Apr 30 02:24 cmz_ae
-rw-r--r-- 1 root root 21 Apr 30 02:22 ori.txt
---------------------------------------------
指定分割最大行数[每个文件]
[root@master01 test]# split -l 3 ori.txt c_
[root@master01 test]# ll
total 20
-rw-r--r-- 1 root root  6 Apr 30 02:25 c_aa
-rw-r--r-- 1 root root  6 Apr 30 02:25 c_ab
-rw-r--r-- 1 root root  6 Apr 30 02:25 c_ac
-rw-r--r-- 1 root root  3 Apr 30 02:25 c_ad
-rw-r--r-- 1 root root 21 Apr 30 02:22 ori.txt
[root@master01 test]# cat c_aa 
1
2
3
--------------------------------------------
指定分割大小分割。
[root@master01 test]# cp /sbin/lvm .
[root@master01 test]# du -sh lvm 
2.2M	lvm
[root@master01 test]# split -b 500K -d lvm  lvm_
[root@master01 test]# ll
total 4344
-r-xr-xr-x 1 root root 2220496 Apr 30 02:27 lvm
-rw-r--r-- 1 root root  512000 Apr 30 02:27 lvm_00
-rw-r--r-- 1 root root  512000 Apr 30 02:27 lvm_01
-rw-r--r-- 1 root root  512000 Apr 30 02:27 lvm_02
-rw-r--r-- 1 root root  512000 Apr 30 02:27 lvm_03
-rw-r--r-- 1 root root  172496 Apr 30 02:27 lvm_04
[root@master01 test]# du -sh *
2.2M	lvm
500K	lvm_00
500K	lvm_01
500K	lvm_02
500K	lvm_03
172K	lvm_04
---------------------------------------------
指定输出文件后缀长度
[root@master01 test]# split -b 500K -d lvm  lvm_ -a 1
[root@master01 test]# ll
total 4344
-r-xr-xr-x 1 root root 2220496 Apr 30 02:27 lvm
-rw-r--r-- 1 root root  512000 Apr 30 02:29 lvm_0
-rw-r--r-- 1 root root  512000 Apr 30 02:29 lvm_1
-rw-r--r-- 1 root root  512000 Apr 30 02:29 lvm_2
-rw-r--r-- 1 root root  512000 Apr 30 02:29 lvm_3
-rw-r--r-- 1 root root  172496 Apr 30 02:29 lvm_4

```

### 3.10 paste

&emsp;Linux paste命令用于合并文件的列。paste指令会把每个文件以列对列的方式，一列列地加以合并。

命令格式：

```
paste [-s][-d <间隔字符>][--help][--version][文件...]
```

**参数**：

- -d<间隔字符>或--delimiters=<间隔字符> 　用指定的间隔字符取代跳格字符。
- -s或--serial 　串列进行而非平行处理。
- --help 　在线帮助。
- --version 　显示帮助信息。
- [文件…] 指定操作的文件路径

```
[root@master01 test]# cat t1
111
222
333
444

666
[root@master01 test]# cat t2
aaa
bbb

ddd
eee
fff
ggg
[root@master01 test]# paste t1 t2
111		aaa
222		bbb
333	
444		ddd
		eee
666		fff
		ggg
---------------------------------------------
指定链接符号
[root@master01 test]# paste t1 t2 -d :
111:aaa
222:bbb
333:
444:ddd
:eee
666:fff
:ggg
---------------------------------------------
将行转为列
[root@master01 test]# paste -s t1
111	222	333	444		666
[root@master01 test]# paste -s t2
aaa	bbb		ddd	eee	fff	ggg
[root@master01 test]# paste -s t1 t2
111	222	333	444		666
aaa	bbb		ddd	eee	fff	ggg
[root@master01 test]# paste -s t1 t2 -d:
111:222:333:444::666
aaa:bbb::ddd:eee:fff:ggg
```

### 3.11 sort

&emsp;Linux sort命令用于将文本文件内容加以排序。sort可针对文本文件的内容，以行为单位来排序。

命令格式：

```
sort [-bcdfimMnr][-o<输出文件>][-t<分隔字符>][+<起始栏位>-<结束栏位>][--help][--verison][文件]
```

**参数说明**：

- -b 忽略每行前面开始出的空格字符。*
- -c 检查文件是否已经按照顺序排序。
- -d 排序时，处理英文字母、数字及空格字符外，忽略其他的字符。
- -f 排序时，将小写字母视为大写字母。
- -i 排序时，除了040至176之间的ASCII字符外，忽略其他的字符。
- -m 将几个排序好的文件进行合并。
- -M 将前面3个字母依照月份的缩写进行排序。
- -n 依照数值的大小排序。*
- -o<输出文件> 将排序后的结果存入指定的文件。
- -r 以相反的顺序来排序。*
- -t<分隔字符> 指定排序时所用的栏位分隔字符。
- +<起始栏位>-<结束栏位> 以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。
- --help 显示帮助。
- --version 显示版本信息。

> 星号是重点要掌握的

```
[root@master01 src]# cat info 
2
4
3
4
4
1
3
8
-----------------------------------------------------------------------------------------
按照ASCII码中顺序排序
[root@master01 src]# sort info 
1
2
3
3
4
4
4
8
-----------------------------------------------------------------------------------------
按照数字从小到大排序
[root@master01 src]# sort -n info 
1
2
3
3
4
4
4
8
-----------------------------------------------------------------------------------------
按照数字从大到小排序
[root@master01 src]# sort -nr info 
8
4
4
4
3
3
2
1
-----------------------------------------------------------------------------------------
去重-u
[root@master01 src]# sort -u info 
1
2
3
4
8
-----------------------------------------------------------------------------------------
[root@master01 src]# cat info1.txt 
2 4
4 3
3 4
4 5
4 5
1 1
3 2
8 9
默认是对第一列排序
[root@master01 src]# sort info1.txt 
1 1
2 4
3 2
3 4
4 3
4 5
4 5
8 9
-----------------------------------------------------------------------------------------
指定列排序
[root@master01 src]# cat info1.txt 
2 4
4 3
3 4
4 5
4 5
1 1
3 2
8 9
指定第二列排序
[root@master01 src]# sort -t " " -k2 info1.txt 
1 1
3 2
4 3
2 4
3 4
4 5
4 5
8 9
第二列排序，同时去重
[root@master01 src]# sort -t " " -k2 -u info1.txt 
1 1
3 2
4 3
2 4
4 5
8 9
第二列排序，同时去重，倒序
[root@master01 src]# sort -t " " -k2 -ur info1.txt 
8 9
4 5
2 4
4 3
3 2
1 1
```

### 3.12 join

&emsp;Linux join命令用于合并文件的列。join指令会把每个文件以列对列的方式，一列列地加以合并。

命令格式：

```
join [option] [file1] [file2]
```

**参数**：

- -a 输出文件中不匹配的行
- -i 忽视大小写
- -1 字段 以第1个文件的指定字段为基础进行合并。
- -2 字段 以第2个文件的指定字段为基础进行合并。

```
[root@master01 src]# cat a.txt 
1 China
2 America
3 Russia
[root@master01 src]# cat b.txt 
1 Beijing
2 Washington
3 Mosco
[root@master01 src]# join a.txt  b.txt 
1 China Beijing
2 America Washington
3 Russia Mosco
```

### 3.13 uniq

&emsp;Linux uniq 命令用于检查及删除文本文件中重复出现的行列，一般与 sort 命令结合使用。uniq 可检查文本文件中重复出现的行列。

命令格式：

```
uniq [-cdu][-f<栏位>][-s<字符位置>][-w<字符位置>][--help][--version][输入文件][输出文件]
```

**参数**：

- -c或--count 在每列旁边显示该行重复出现的次数。
- -d或--repeated 仅显示重复出现的行列。
- -f<栏位>或--skip-fields=<栏位> 忽略比较指定的栏位。
- -s<字符位置>或--skip-chars=<字符位置> 忽略比较指定的字符。
- -u或--unique 仅显示出一次的行列。
- -w<字符位置>或--check-chars=<字符位置> 指定要比较的字符。
- --help 显示帮助。
- --version 显示版本信息。
- [输入文件] 指定已排序好的文本文件。如果不指定此项，则从标准读取数据；
- [输出文件] 指定输出的文件。如果不指定此选项，则将内容显示到标准输出设备（显示终端）。

```
[root@master01 src]# cat cmz.txt 
cmz 30  
cmz 30  
cmz 30  
Hello 95  
Hello 95  
Hello 95  
Hello 95  
Linux 85  
Linux 85 
name cmz
-----------------------------------------------------------------------------------------
去重
[root@master01 src]# uniq cmz.txt 
cmz 30  
Hello 95  
Linux 85 
name cmz

> 去重后，排序
排序
[root@master01 src]# uniq cmz.txt | sort -t ' ' -k2
cmz 30  
Linux 85 
Hello 95  
name cmz
-----------------------------------------------------------------------------------------
去重且显示重复次数
[root@master01 src]# uniq -c cmz.txt 
      3 cmz 30  
      4 Hello 95  
      2 Linux 85 
      1 name cmz
-----------------------------------------------------------------------------------------
只显示重复行
[root@master01 src]# uniq -d cmz.txt 
cmz 30  
Hello 95  
Linux 85 
-----------------------------------------------------------------------------------------
显示没有重复的行
[root@master01 src]# uniq -u cmz.txt 
name cmz
```



### 3.14 wc

&emsp;Linux wc命令用于计算字数。利用wc指令我们可以计算文件的Byte数、字数、或是列数，若不指定文件名称、或是所给予的文件名为"-"，则wc指令会从标准输入设备读取数据。

```
wc [-clw][--help][--version][文件...]
```

**参数**：

- -c或--bytes或--chars 只显示Bytes数。
- -l或--lines 只显示行数。
- -w或--words 只显示字数。
- --help 在线帮助。
- --version 显示版本信息

```
[root@master01 src]# cat cmz.txt 
cmz 30  
cmz 30  
cmz 30  
Hello 95  
Hello 95  
Hello 95  
Hello 95  
Linux 85 
Linux 85 
name cmz
[root@master01 src]# wc cmz.txt 
 10  20 100 cmz.txt
 |   |   |__________ 字节数
 |   |______________ 单词数
 |__________________ 行数
[root@master01 src]# wc -l cmz.txt  # 行数
10 cmz.txt 
[root@master01 src]# wc -w cmz.txt  # 单词数
20 cmz.txt
[root@master01 src]# wc -c cmz.txt  # 字节数
100 cmz.txt

[root@master01 src]# wc cmz.txt cmz1.txt  # 统计两个文件的信息
 10  20 100 cmz.txt                       # 第一个文件行数为10，单词数为20，字节数为100
 10  20 100 cmz1.txt                      # 第二个文件行数为10，单词数为20，字节数为100
 20  40 200 total                         # 两个文件总行数为20，单词总数为40个，字节总数为200个
```



### 3.15 iconv

&emsp;linux系统默认编码是utf-8,而windows系统默认是GB2312【国人电脑系统哈】，在windows上编辑的文传到Linux上就有乱码，需要编码转化。很少用。

```
iconv -f [编码1] -t [编码2] 源文件
```

**参数**：

- -f 指定源文件的编码格式
- -t 指定输出文件夹的编码方式

```
[root@master01 src]# iconv -f gb2312 -t utf-8 cmz.txt 
cmz 30  
cmz 30  
cmz 30  
Hello 95  
Hello 95  
Hello 95  
Hello 95  
Linux 85 
Linux 85 
name cmz
```

### 3.16 dos2unix

&emsp;dos2unix就是把windows文件"\r\n"转成"\n",`unix2dos`就是反过来把linux上的文件"\n"转成"\r\n"

```
[root@master01 src]# dos2unix c1.log 
dos2unix: converting file c1.log to Unix format ...
```

### 3.17 diff

&emsp;Linux diff命令用于比较文件的差异。diff以逐行的方式，比较文本文件的异同处。如果指定要比较目录，则diff会比较目录中相同文件名的文件，但不会比较其中子目录。

```
[root@master01 src]# cat c1.log 
1
2
3
[root@master01 src]# cat c2.log 
1
3
3

[root@master01 src]# diff c1.log c2.log 
2c2
< 2
---
> 3
显示第二行不同，横向上面是第一个文件内容，横向下面是第二个文件内容
```



### 3.18 vimdiff

&emsp;Linux vimdiff命令也是用于比较文件的差异，只是会diff更加高级，图形化高亮显示差异。

```
[root@master01 src]# vimdiff c1.log c2.log 
2 files to edit
1                             |                          1
2                             |                          3  《--------这行会高亮显示
3                             |                          3
```



### 3.19 rev

### 3.20 tr

### 3.21 od

### 3.22 tee

### 3.23 vi vim

## 4. 三剑客

### 4.1 grep

### 4.2 sed

### 4.3 awk

## 5. 系统显示

###  5.1 uname

&emsp;Linux uname命令用于显示系统信息。`uname`可显示电脑以及操作系统的相关信息。

```
uname [-amnrsv][--help][--version]
```

**参数**：

- 从从hine 　显示电脑类型。
- -n或-nodename 　显示在网络上的主机名称。
- -r或--release 　显示操作系统的发行编号。
- -s或--sysname 　显示操作系统名称。
- -v 　显示操作系统的版本。
- --help 　显示帮助。
- --version 　显示版本信息。

```
显示系统信息
[root@master01 ~]# uname -a
Linux master01 3.10.0-957.10.1.el7.x86_64 #1 SMP Mon Mar 18 15:06:45 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

显示计算机类型
[root@master01 ~]# uname -m
x86_64

显示计算名
[root@master01 ~]# uname -n
master01
[root@master01 ~]# hostname
master01

显示操作系统发行编号
[root@master01 ~]# uname -r
3.10.0-957.10.1.el7.x86_64

显示操作系统名称
[root@master01 ~]# uname -s
Linux

显示系统时间
[root@master01 ~]# uname -v
#1 SMP Mon Mar 18 15:06:45 UTC 2019
[root@master01 ~]# date
Tue May  7 03:17:36 EDT 2019
```

### 5.2 hostname

&emsp;显示和设置系统的主机名

**语法**

```
hostname [选项]
```

**参数**：

- -a  如果设置了主机名，则可以使用-a来显示主机别名
- -i 显示主机IP地址，这个参数需要DNS解析
- -I 显示主机IP地址，不依赖DNS解析
- -s 显示短格式主机名

```
显示主机名
[root@master01 ~]# hostname # 不接受参数，就表示显示主机名
master01

设置主机名,临时生效，重启机器后失效
[root@master01 ~]# hostname caimengzhi
[root@master01 ~]# bash
[root@caimengzhi ~]# hostname
caimengzhi
永久生效的话，需要在/etc/hostname 中编辑
[root@master01 ~]# cat /etc/hostname
master01

显示主机ip地址
[root@master01 ~]# hostname -i
192.168.5.100
[root@master01 ~]# hostname -I # 有多少块网卡[有IP地址]就显示多少个IP地址 
192.168.5.100 172.17.7.1 172.17.7.0 
```

### 5.3 dmesg

&emsp;Linux dmesg命令用于显示开机信息。kernel会将开机信息存储在ring buffer中。您若是开机时来不及查看信息，可利用dmesg来查看。开机信息亦保存在/var/log目录中，名称为dmesg的文件里。

**语法**

```
dmesg [-cn][-s <缓冲区大小>]
```

**参数说明**：

- -c 　显示信息后，清除ring buffer中的内容。
- -s<缓冲区大小> 　预设置为8196，刚好等于ring buffer的大小。
- -n 　设置记录信息的层级。

```
[root@master01 ~]# dmesg|less
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-957.10.1.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) ) #1 SMP Mon Mar 18 15:06:45 UTC 2019
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.0-957.10.1.el7.x86_64 root=/dev/mapper/centos-root ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet LANG=en_U
S.UTF-8[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009d914fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d915000-0x000000009dc09fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009dc0a000-0x000000009e822fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e823000-0x000000009eed4fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009eed5000-0x000000009eed5fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009eed6000-0x000000009f0dbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009f0dc000-0x000000009f50ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f510000-0x000000009f7f2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009f7f3000-0x000000009f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000013effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Acer Shangqi N6120/AAHD3-VF, BIOS MAP23SB 09/02/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
以下省略
```

### 5.4 stat

&emsp;Linux stat命令用于显示inode内容。stat以文字的格式来显示inode的内容。

**语法**

```
stat [文件或目录]
```

```
[root@master01 etcd]# stat etcd.sh 
  File: ‘etcd.sh’
  Size: 1773      	Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 100909135   Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-05-04 22:33:49.742966577 -0400
Modify: 2019-05-04 22:31:50.597254997 -0400
Change: 2019-05-04 22:33:38.758177561 -0400
 Birth: -
```



### 5.5 du

&emsp;Linux du命令用于显示目录或文件的大小。`du`会显示指定的目录或文件所占用的磁盘空间。

**语法**

```
du [-abcDhHklmsSx][-L <符号连接>][-X <文件>][--block-size][--exclude=<目录或文件>][--max-depth=<目录层数>][--help][--version][目录或文件]
```

**参数说明**：

- -a或-all 显示目录中个别文件的大小。
- -b或-bytes 显示目录或文件大小时，以byte为单位。
- -c或--total 除了显示个别目录或文件的大小外，同时也显示所有目录或文件的总和。
- -D或--dereference-args 显示指定符号连接的源文件大小。
- -h或--human-readable 以K，M，G为单位，提高信息的可读性。
- -H或--si 与-h参数相同，但是K，M，G是以1000为换算单位。
- -k或--kilobytes 以1024 bytes为单位。
- -l或--count-links 重复计算硬件连接的文件。
- -L<符号连接>或--dereference<符号连接> 显示选项中所指定符号连接的源文件大小。
- -m或--megabytes 以1MB为单位。
- -s或--summarize 仅显示总计。
- -S或--separate-dirs 显示个别目录的大小时，并不含其子目录的大小。
- -x或--one-file-xystem 以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过。
- -X<文件>或--exclude-from=<文件> 在<文件>指定目录或文件。
- --exclude=<目录或文件> 略过指定的目录或文件。
- --max-depth=<目录层数> 超过指定层数的目录后，予以忽略。
- --help 显示帮助。
- --version 显示版本信息。

显示目录或者文件所占空间

```
[root@master01 ~]# cd /opt/
[root@master01 opt]# du -s  # 显示当前目录总大小
525876	.
[root@master01 opt]# du -h  # h参数会自动换算成K，M,G这样容易理解和阅读
0	./containerd/bin
0	./containerd/lib
0	./containerd
12K	./etcd/ssl
4.0K	./etcd/cfg
34M	./etcd/bin
34M	./etcd
481M	./kubernetes/bin
48K	./kubernetes/cfg
28K	./kubernetes/ssl
481M	./kubernetes
514M	.
[root@master01 opt]# du -sh . # 推荐使用，显示指定目录总大小
514M	.


[root@master01 opt]# du 
0	./containerd/bin
0	./containerd/lib
0	./containerd
12	./etcd/ssl
4	./etcd/cfg
34236	./etcd/bin
34252	./etcd
491548	./kubernetes/bin
48	./kubernetes/cfg
28	./kubernetes/ssl
491624	./kubernetes
525876	.
```

> 只显示当前目录下面的子目录的目录大小和当前目录的总的大小，最下面的525876为当前目录的总大小

显示指定文件所占空间

```
[root@master01 opt]# du etcd/cfg/etcd 
4	etcd/cfg/etcd
默认是kb
```

方便阅读的格式显示/opt目录所占空间情况：

```
[root@master01 opt]# du -h /opt/
0	/opt/containerd/bin
0	/opt/containerd/lib
0	/opt/containerd
12K	/opt/etcd/ssl
4.0K	/opt/etcd/cfg
34M	/opt/etcd/bin
34M	/opt/etcd
481M	/opt/kubernetes/bin
48K	/opt/kubernetes/cfg
28K	/opt/kubernetes/ssl
481M	/opt/kubernetes
514M	/opt/
```

```
只显示第一层目录大小
[root@master01 opt]# du -h --max-depth=1 /usr/local/  
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
0	/usr/local/share
8.0K	/usr/local/src
19M	/usr/local/

只显示第一层和第二层目录大小
[root@master01 opt]# du -h --max-depth=2 /usr/local/
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
0	/usr/local/share/applications
0	/usr/local/share/info
0	/usr/local/share/man
0	/usr/local/share
8.0K	/usr/local/src
19M	/usr/local/

排除指定目录
[root@master01 opt]# du -h --max-depth=2 /usr/local/ --exclude=/usr/local/share
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
8.0K	/usr/local/src
19M	/usr/local/
```

> 排除指定目录，要排除的目录，最后不能有/结尾。

错误写法

```
[root@master01 opt]# du -h --max-depth=2 /usr/local/ --exclude=/usr/local/share/  # 最后/share后面多了一个/
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
0	/usr/local/share/applications
0	/usr/local/share/info
0	/usr/local/share/man
0	/usr/local/share
8.0K	/usr/local/src
19M	/usr/local/
```

### 5.6 date

### 5.7 echo

&emsp;Linux echo命令用于显示输出

**语法**

```
echo [选项] 输出字符
```

**参数说明**：

- -n    不自动换行
- -E    不解析转意字符(默认参数)
- -e    若字符串中出现以下字符，则需要特别处理，而不是将它当做一般字符处理，也就是需要转意。
  - \a    发出警告声音
  - \b    删除前一个字符
  - \c    最后不加上换行符号
  - \f    换行单光标依然停留在原来的位置
  - \n    换行且光标移动至行首
  - \r     光标移动到行首，但是不换行
  - \t    插入tab
  - \v    与\f相反
  - \\\\    插入\字符
  - \\'    插入单引号
  - \\"   插入双引号
  - \\nnn    插入nnn[八进制]所代表的ASCII字符  

```
直接输出要输出的文字
[root@master01 ~]# echo hello caimenzhi! 
hello caimenzhi!

可以将要输出的单引号括起来
[root@master01 ~]# echo 'hello caimenzhi!' 
hello caimenzhi!

！特殊性
[root@master01 ~]# echo "hello caimenzhi!" 
bash: !": event not found
[root@master01 ~]# echo "hello caimenzhi"!
hello caimenzhi!

重定向到文件[保存到文件]
> 每次都会情况文件
>> 追加到文件

[root@master01 ~]# echo 'hello caimengzhi'>info
[root@master01 ~]# cat info
hello caimengzhi
[root@master01 ~]# echo 'hello caimengzhi'>info
[root@master01 ~]# cat info
hello caimengzhi
[root@master01 ~]# echo 'hello caimengzhi'>>info
[root@master01 ~]# echo 'hello caimengzhi'>>info
[root@master01 ~]# cat info
hello caimengzhi
hello caimengzhi
hello caimengzhi

输出不换行[-n]
[root@master01 ~]# echo 'caimengzhi';echo 'caimengzhi'
caimengzhi
caimengzhi
[root@master01 ~]# echo -n 'caimengzhi';echo 'caimengzhi'
caimengzhicaimengzhi
```

### 5.8 watch

&emsp;主要监控命令输出结果，或者程序执行情况.

**语法**

```
watch [选项] [命令]
```

**参数说明**：

- -n    命令执行间隔时间，默认2秒
- -d    高亮显示命令结果的变动之处
- -t     关闭watch命令在顶部显示的时间间隔，命令以及当前时间的输出

```
每隔1秒显示网络链接数的变化情况
[root@master01 ~]# watch  -n 1 -d netstat -ant
Every 1.0s: netstat -ant                                                                                                                                             Tue May  7 04:09:05 2019

Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0	  0 127.0.0.1:10248         0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:10249         0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:10250     0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:6443      0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:2379      0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:2379          0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:10252         0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:2380      0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:10255     0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:8080          0.0.0.0:*               LISTEN
tcp        0	  0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:25            0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:33503         0.0.0.0:*               LISTEN

监控文件
[root@master01 ~]# echo 'line 1'>cmz.txt
[root@master01 ~]# watch cat cmz.txt 
Every 2.0s: cat cmz.txt                                                                                                                                              Tue May  7 04:11:04 2019

line 1
line 2
line 3

新开一个界面终端往cmz.txt文件中输入数据
[root@master01 ~]# echo 'line 2'>>cmz.txt
[root@master01 ~]# echo 'line 3'>>cmz.txt
上面 watch cat cmz.txt 就会动态显示类似 tail -f cmz.txt | tailf cmz.txt

不显示标题
[root@master01 ~]# watch -t cat cmz.txt 
line 1
line 2
line 3
```

### 5.9 which

&emsp;Linux which命令用于查找文件。which指令会在环境变量$PATH设置的目录里查找符合条件的文件。

**语法**

```
which [文件...]
```

**参数**：

- -n<文件名长度> 　指定文件名长度，指定的长度必须大于或等于所有文件中最长的文件名。
- -p<文件名长度> 　与-n参数相同，但此处的<文件名长度>包括了文件的路径。
- -w 　指定输出时栏位的宽度。
- -V 　显示版本信息。

```
[root@master01 ~]# which sh
/usr/bin/sh
```

### 5.10 whereis

&emsp;Linux whereis命令用于查找文件。该指令会在特定目录中查找符合条件的文件。这些文件应属于原始代码、二进制文件，或是帮助文件。该指令只能用于查找二进制文件、源代码文件和man手册页，一般文件的定位需使用locate命令。

```
whereis [-bfmsu][-B <目录>...][-M <目录>...][-S <目录>...][文件...]
```

**参数**：

- -b 　只查找二进制文件。
- -B<目录> 　只在设置的目录下查找二进制文件。
- -f 　不显示文件名前的路径名称。
- -m 　只查找说明文件。
- -M<目录> 　只在设置的目录下查找说明文件。
- -s 　只查找原始代码文件。
- -S<目录> 　只在设置的目录下查找原始代码文件。
- -u 　查找不包含指定类型的文件。

```
[root@master01 ~]# whereis bash 
bash: /usr/bin/bash /usr/share/man/man1/bash.1.gz
```

注意：以上输出信息从左至右分别为查询的程序名、bash路径、bash的man 手册页路径。

如果用户需要单独查询二进制文件或帮助文件，可使用如下命令：

```
[root@master01 ~]# whereis -b bash   # 显示bash 命令的二进制程序
bash: /usr/bin/bash                  # bash命令的二进制程序的地址
[root@master01 ~]# whereis -m bash   # 显示bash 命令的帮助文件
bash: /usr/share/man/man1/bash.1.gz  # bash命令的帮助文件地址
```

### 5.11 locate

&emsp;Linux locate命令用于查找符合条件的文档，他会去保存文档和目录名称的数据库内，查找合乎范本样式条件的文档或目录。一般情况我们只需要输入 **locate your_file_name** 即可查找指定文件。

**语法**

```
locate [-d ][--help][--version][范本样式...]
```

**参数：**

- -d或--database= 配置locate指令使用的数据库。locate指令预设的数据库位于/var/lib/slocate目录里，文档名为slocate.db，您可使用 这个参数另行指定。
- --help 　在线帮助。
- --version 　显示版本信息。

```
root@leco:~/book# locate book.conf
/etc/nginx/sites-enabled/book.conf
/var/lib/dpkg/info/account-plugin-facebook.conffiles

只显示匹配到的行数
root@leco:~/book# locate book.conf -c
2
```

&emsp;locate与find 不同: find 是去硬盘找，locate 只在/var/lib/slocate资料库中找。

&emsp;locate的速度比find快，它并不是真的查找，而是查数据库，一般文件数据库在/var/lib/slocate/slocate.db中，所以locate的查找并不是实时的，而是以数据库的更新为准，一般是系统自己维护。

### 5.12 updatedb

&emsp;创建或者修改数据库，

```
root@leco:~# ls /var/lib/mlocate/mlocate.db 
/var/lib/mlocate/mlocate.db

root@leco:~# locate cmz -c
1951
root@leco:~# touch cmz12.txt
root@leco:~# locate cmz -c  # 没有变
1951
root@leco:~# updatedb -vU /root/  # 更新数据库
root@leco:~# ll /var/lib/mlocate/mlocate.db  # 数据库时间也变了
-rw-r----- 1 root mlocate 3694627 5月   7 17:54 /var/lib/mlocate/mlocate.db 
root@leco:~# locate cmz -c  # 出现了
1952
```

##  6. 文件压缩和解压

### 6.1 tar

&emsp;Linux tar命令用于备份文件。tar是用来建立，还原备份文件的工具程序，它可以加入，解开备份文件内的文件。

**语法**

```
tar [-ABcdgGhiklmMoOpPrRsStuUvwWxzZ][-b <区块数目>][-C <目的目录>][-f <备份文件>][-F <Script文件>][-K <文件>][-L <媒体容量>][-N <日期时间>][-T <范本文件>][-V <卷册名称>][-X <范本文件>][-<设备编号><存储密度>][--after-date=<日期时间>][--atime-preserve][--backuup=<备份方式>][--checkpoint][--concatenate][--confirmation][--delete][--exclude=<范本样式>][--force-local][--group=<群组名称>][--help][--ignore-failed-read][--new-volume-script=<Script文件>][--newer-mtime][--no-recursion][--null][--numeric-owner][--owner=<用户名称>][--posix][--erve][--preserve-order][--preserve-permissions][--record-size=<区块数目>][--recursive-unlink][--remove-files][--rsh-command=<执行指令>][--same-owner][--suffix=<备份字尾字符串>][--totals][--use-compress-program=<执行指令>][--version][--volno-file=<编号文件>][文件或目录...]
```

**参数**：

- -A或--catenate 新增文件到已存在的备份文件。
- -b<区块数目>或--blocking-factor=<区块数目> 设置每笔记录的区块数目，每个区块大小为12Bytes。
- -B或--read-full-records 读取数据时重设区块大小。
- -c或--create 建立新的备份文件。
- -C<目的目录>或--directory=<目的目录> 切换到指定的目录。
- -d或--diff或--compare 对比备份文件内和文件系统上的文件的差异。
- -f<备份文件>或--file=<备份文件> 指定备份文件。
- -F<Script文件>或--info-script=<Script文件> 每次更换磁带时，就执行指定的Script文件。
- -g或--listed-incremental 处理GNU格式的大量备份。
- -G或--incremental 处理旧的GNU格式的大量备份。
- -h或--dereference 不建立符号连接，直接复制该连接所指向的原始文件。
- -i或--ignore-zeros 忽略备份文件中的0 Byte区块，也就是EOF。
- -k或--keep-old-files 解开备份文件时，不覆盖已有的文件。
- -K<文件>或--starting-file=<文件> 从指定的文件开始还原。
- -l或--one-file-system 复制的文件或目录存放的文件系统，必须与tar指令执行时所处的文件系统相同，否则不予复制。
- -L<媒体容量>或-tape-length=<媒体容量> 设置存放每体的容量，单位以1024 Bytes计算。
- -m或--modification-time 还原文件时，不变更文件的更改时间。
- -M或--multi-volume 在建立，还原备份文件或列出其中的内容时，采用多卷册模式。
- -N<日期格式>或--newer=<日期时间> 只将较指定日期更新的文件保存到备份文件里。
- -o或--old-archive或--portability 将资料写入备份文件时使用V7格式。
- -O或--stdout 把从备份文件里还原的文件输出到标准输出设备。
- -p或--same-permissions 用原来的文件权限还原文件。
- -P或--absolute-names 文件名使用绝对名称，不移除文件名称前的"/"号。
- -r或--append 新增文件到已存在的备份文件的结尾部分。
- -R或--block-number 列出每个信息在备份文件中的区块编号。
- -s或--same-order 还原文件的顺序和备份文件内的存放顺序相同。
- -S或--sparse 倘若一个文件内含大量的连续0字节，则将此文件存成稀疏文件。
- -t或--list 列出备份文件的内容。
- -T<范本文件>或--files-from=<范本文件> 指定范本文件，其内含有一个或多个范本样式，让tar解开或建立符合设置条件的文件。
- -u或--update 仅置换较备份文件内的文件更新的文件。
- -U或--unlink-first 解开压缩文件还原文件之前，先解除文件的连接。
- -v或--verbose 显示指令执行过程。
- -V<卷册名称>或--label=<卷册名称> 建立使用指定的卷册名称的备份文件。
- -w或--interactive 遭遇问题时先询问用户。
- -W或--verify 写入备份文件后，确认文件正确无误。
- -x或--extract或--get 从备份文件中还原文件。
- -X<范本文件>或--exclude-from=<范本文件> 指定范本文件，其内含有一个或多个范本样式，让ar排除符合设置条件的文件。
- -z或--gzip或--ungzip 通过gzip指令处理备份文件。
- -Z或--compress或--uncompress 通过compress指令处理备份文件。
- -<设备编号><存储密度> 设置备份用的外围设备编号及存放数据的密度。
- --after-date=<日期时间> 此参数的效果和指定"-N"参数相同。
- --atime-preserve 不变更文件的存取时间。
- --backup=<备份方式>或--backup 移除文件前先进行备份。
- --checkpoint 读取备份文件时列出目录名称。
- --concatenate 此参数的效果和指定"-A"参数相同。
- --confirmation 此参数的效果和指定"-w"参数相同。
- --delete 从备份文件中删除指定的文件。
- --exclude=<范本样式> 排除符合范本样式的问家。
- --group=<群组名称> 把加入设备文件中的文件的所属群组设成指定的群组。
- --help 在线帮助。
- --ignore-failed-read 忽略数据读取错误，不中断程序的执行。
- --new-volume-script=<Script文件> 此参数的效果和指定"-F"参数相同。
- --newer-mtime 只保存更改过的文件。
- --no-recursion 不做递归处理，也就是指定目录下的所有文件及子目录不予处理。
- --null 从null设备读取文件名称。
- --numeric-owner 以用户识别码及群组识别码取代用户名称和群组名称。
- --owner=<用户名称> 把加入备份文件中的文件的拥有者设成指定的用户。
- --posix 将数据写入备份文件时使用POSIX格式。
- --preserve 此参数的效果和指定"-ps"参数相同。
- --preserve-order 此参数的效果和指定"-A"参数相同。
- --preserve-permissions 此参数的效果和指定"-p"参数相同。
- --record-size=<区块数目> 此参数的效果和指定"-b"参数相同。
- --recursive-unlink 解开压缩文件还原目录之前，先解除整个目录下所有文件的连接。
- --remove-files 文件加入备份文件后，就将其删除。
- --rsh-command=<执行指令> 设置要在远端主机上执行的指令，以取代rsh指令。
- --same-owner 尝试以相同的文件拥有者还原文件。
- --suffix=<备份字尾字符串> 移除文件前先行备份。
- --totals 备份文件建立后，列出文件大小。
- --use-compress-program=<执行指令> 通过指定的指令处理备份文件。
- --version 显示版本信息。
- --volno-file=<编号文件> 使用指定文件内的编号取代预设的卷册编号。

```
压缩文件
[root@master01 cmz]# touch {1..10}.txt
[root@master01 cmz]# ls
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt
[root@master01 cmz]# tar zcvf all.tgz ./*  # -v 显示过程
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
-----------------------------------------------------------------------------------------
[root@master01 cmz]# tar tvfz all.tgz  # 查看压缩包详细内容，-t不解压意思，-v显示属性
-rw-r--r-- root/root         0 2019-05-07 07:36 ./10.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./1.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./2.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./3.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./4.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./5.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./6.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./7.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./8.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./9.txt
-----------------------------------------------------------------------------------------
[root@master01 cmz]# tar tfz all.tgz # 查看包内容
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
-----------------------------------------------------------------------------------------
[root@master01 cmz]# tar tf all.tgz # 若不指定-z，那么tar会自动判断压缩包类型，自动调用gzip命令
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
-----------------------------------------------------------------------------------------
解压
[root@master01 cmz]# ls
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt  all.tgz
[root@master01 cmz]# mkdir cc
[root@master01 cmz]# tar zxvf all.tgz -C cc/ # -C 指定解压后的目录，若不加-C，解压到当前的目录下
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
[root@master01 cmz]# ls cc/
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt
-----------------------------------------------------------------------------------------
精简输出。不输出相关信息，脚本建议使用这样模式
[root@master01 cmz]# rm cc/* -rf
[root@master01 cmz]# tar xf all.tgz -C cc/
[root@master01 cmz]# ls cc/
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt
-----------------------------------------------------------------------------------------
打包的时候排除某个目录
[root@master01 cmz]# tree .
.
├── 1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── aa
│   ├── aa_1.txt
│   ├── aa_2.txt
│   ├── aa_3.txt
│   └── aa_4.txt
└── bb
    ├── bb_1.txt
    ├── bb_2.txt
    ├── bb_3.txt
    └── bb_4.txt

2 directories, 12 files
[root@master01 cmz]# tar zcvf all.tgz * --exclude=aa    # 文件后不能加/.否则失败
1.txt
2.txt
3.txt
4.txt
bb/
bb/bb_1.txt
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
[root@master01 cmz]# tar tvf all.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 1.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 2.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  all.tgz  bb

排除多个目录
[root@master01 cmz]# rm all.tgz 
rm: remove regular file ‘all.tgz’? y
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  bb
排除多个目录就是有多个 --exclude
[root@master01 cmz]# tar zcvf all.tgz * --exclude=aa --exclude=bb  
1.txt
2.txt
3.txt
4.txt
[root@master01 cmz]# tar tvf all.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 1.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 2.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
-----------------------------------------------------------------------------------------
排除某个文件
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  bb
[root@master01 cmz]# tar zcvf paichu1.tgz * --exclude=1.txt
2.txt
3.txt
4.txt
aa/
aa/aa_1.txt
aa/aa_2.txt
aa/aa_3.txt
aa/aa_4.txt
bb/
bb/bb_1.txt
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
[root@master01 cmz]# tar tvf paichu1.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 2.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:47 aa/
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt
[root@master01 cmz]# 
排除多个文件,和排除文件夹一样
[root@master01 cmz]# tar zcvf paichu2.tgz * --exclude=1.txt --exclude=2.txt
3.txt
4.txt
aa/
aa/aa_1.txt
aa/aa_2.txt
aa/aa_3.txt
aa/aa_4.txt
bb/
bb/bb_1.txt
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
[root@master01 cmz]# tar tvf paichu2.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:47 aa/
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt

排除多个文件，使用文件
[root@master01 cmz]# cat list.txt  # 指定一个目当前目录下文件，里面记录不需要的打包的文件
2.txt
bb/bb_1.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  bb  list.txt
[root@master01 cmz]# ll
total 4
-rw-r--r-- 1 root root  0 May  7 07:46 1.txt
-rw-r--r-- 1 root root  0 May  7 07:46 2.txt
-rw-r--r-- 1 root root  0 May  7 07:46 3.txt
-rw-r--r-- 1 root root  0 May  7 07:46 4.txt
drwxr-xr-x 2 root root 70 May  7 07:47 aa
drwxr-xr-x 2 root root 70 May  7 07:48 bb
-rw-r--r-- 1 root root 18 May  7 07:53 list.txt
[root@master01 cmz]# tar zcvfX paichu.tgz list.txt *
1.txt
3.txt
4.txt
aa/
aa/aa_1.txt
aa/aa_2.txt
aa/aa_3.txt
aa/aa_4.txt
bb/
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
list.txt
[root@master01 cmz]# tar tvf paichu.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 1.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:47 aa/
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt
-rw-r--r-- root/root        18 2019-05-07 07:53 list.txt
```

### 6.2 gzip

&emsp;Linux gzip命令用于压缩文件。gzip是个使用广泛的压缩程序，文件经它压缩过后，其名称后面会多出".gz"的扩展名。

**语法**

```
gzip [-acdfhlLnNqrtvV][-S &lt;压缩字尾字符串&gt;][-&lt;压缩效率&gt;][--best/fast][文件...] 或 gzip [-acdfhlLnNqrtvV][-S &lt;压缩字尾字符串&gt;][-&lt;压缩效率&gt;][--best/fast][目录]
```

**参数**：

- -a或--ascii 　使用ASCII文字模式。
- -c或--stdout或--to-stdout 　把压缩后的文件输出到标准输出设备，不去更动原始文件。
- -d或--decompress或----uncompress 　解开压缩文件。 **
- -f或--force 　强行压缩文件。不理会文件名称或硬连接是否存在以及该文件是否为符号连接。
- -h或--help 　在线帮助。
- -l或--list 　列出压缩文件的相关信息。
- -L或--license 　显示版本与版权信息。
- -n或--no-name 　压缩文件时，不保存原来的文件名称及时间戳记。
- -N或--name 　压缩文件时，保存原来的文件名称及时间戳记。
- -q或--quiet 　不显示警告信息。
- -r或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
- -S<压缩字尾字符串>或----suffix<压缩字尾字符串> 　更改压缩字尾字符串。
- -t或--test 　测试压缩文件是否正确无误。
- -v或--verbose 　显示指令执行过程。
- -V或--version 　显示版本信息。
- -<压缩效率> 　压缩效率是一个介于1－9的数值，预设值为"6"，指定愈大的数值，压缩效率就会愈高。
- --best 　此参数的效果和指定"-9"参数相同。
- --fast 　此参数的效果和指定"-1"参数相同。

```
[root@master01 cmz]# touch {1..5}.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  5.txt
[root@master01 cmz]# gzip *   # 直接压缩当前每个文件，源文件消失
[root@master01 cmz]# ls
1.txt.gz  2.txt.gz  3.txt.gz  4.txt.gz  5.txt.gz

不解压查看压缩包信息
[root@master01 cmz]# gzip -l *
         compressed        uncompressed  ratio uncompressed_name
                 26                   0   0.0% 1.txt
                 26                   0   0.0% 2.txt
                 26                   0   0.0% 3.txt
                 26                   0   0.0% 4.txt
                 26                   0   0.0% 5.txt
解压
[root@master01 cmz]# ls
1.txt.gz  2.txt.gz  3.txt.gz  4.txt.gz  5.txt.gz
[root@master01 cmz]# gzip -dv *.gz  # -d解压，-v显示解压过程，解压后压缩包消失
1.txt.gz:	  0.0% -- replaced with 1.txt
2.txt.gz:	  0.0% -- replaced with 2.txt
3.txt.gz:	  0.0% -- replaced with 3.txt
4.txt.gz:	  0.0% -- replaced with 4.txt
5.txt.gz:	  0.0% -- replaced with 5.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  5.txt
```

### 6.3 zip

&emsp;Linux zip命令用于压缩文件。zip是个使用广泛的压缩程序，文件经它压缩后会另外产生具有".zip"扩展名的压缩文件。

**语法**

```
zip [-AcdDfFghjJKlLmoqrSTuvVwXyz$][-b <工作目录>][-ll][-n <字尾字符串>][-t <日期时间>][-<压缩效率>][压缩文件][文件...][-i <范本样式>][-x <范本样式>]
```

**参数**：

- -A 调整可执行的自动解压缩文件。
- -b<工作目录> 指定暂时存放文件的目录。
- -c 替每个被压缩的文件加上注释。
- -d 从压缩文件内删除指定的文件。
- -D 压缩文件内不建立目录名称。
- -f 此参数的效果和指定"-u"参数类似，但不仅更新既有文件，如果某些文件原本不存在于压缩文件内，使用本参数会一并将其加入压缩文件中。
- -F 尝试修复已损坏的压缩文件。
- -g 将文件压缩后附加在既有的压缩文件之后，而非另行建立新的压缩文件。
- -h 在线帮助。
- -i<范本样式> 只压缩符合条件的文件。
- -j 只保存文件名称及其内容，而不存放任何目录名称。
- -J 删除压缩文件前面不必要的数据。
- -k 使用MS-DOS兼容格式的文件名称。
- -l 压缩文件时，把LF字符置换成LF+CR字符。
- -ll 压缩文件时，把LF+CR字符置换成LF字符。
- -L 显示版权信息。
- -m 将文件压缩并加入压缩文件后，删除原始文件，即把文件移到压缩文件中。
- -n<字尾字符串> 不压缩具有特定字尾字符串的文件。
- -o 以压缩文件内拥有最新更改时间的文件为准，将压缩文件的更改时间设成和该文件相同。
- -q 不显示指令执行过程。
- -r 递归处理，将指定目录下的所有文件和子目录一并处理。
- -S 包含系统和隐藏文件。
- -t<日期时间> 把压缩文件的日期设成指定的日期。
- -T 检查备份文件内的每个文件是否正确无误。
- -u 更换较新的文件到压缩文件内。
- -v 显示指令执行过程或显示版本信息。
- -V 保存VMS操作系统的文件属性。
- -w 在文件名称里假如版本编号，本参数仅在VMS操作系统下有效。
- -x<范本样式> 压缩时排除符合条件的文件。
- -X 不保存额外的文件属性。
- -y 直接保存符号连接，而非该连接所指向的文件，本参数仅在UNIX之类的系统下有效。
- -z 替压缩文件加上注释。
- -$ 保存第一个被压缩文件所在磁盘的卷册名称。
- -<压缩效率> 压缩效率是一个介于1-9的数值。

```
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt
[root@master01 cmz]# zip all.zip *
  adding: 2.txt (stored 0%)
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip
-----------------------------------------------------------------------------------------
递归压缩
[root@master01 cmz]# tree .
.
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── cc
    ├── 2.txt
    ├── 3.txt
    ├── 4.txt
    └── 5.txt

1 directory, 8 files
[root@master01 cmz]# zip all.zip *
  adding: 2.txt (stored 0%)
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%) # 没有压缩cc下面文件
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip  cc

[root@master01 cmz]# zip -r all.zip * # 递归压缩
  adding: 2.txt (stored 0%)
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%)
  adding: cc/2.txt (stored 0%)
  adding: cc/3.txt (stored 0%)
  adding: cc/4.txt (stored 0%)
  adding: cc/5.txt (stored 0%)
  
排除某个文件不压缩
[root@master01 cmz]# zip -r all.zip * -x 2.txt  # -x 指定某个文件不压缩
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%)
  adding: cc/2.txt (stored 0%)
  adding: cc/3.txt (stored 0%)
  adding: cc/4.txt (stored 0%)
  adding: cc/5.txt (stored 0%)
[root@master01 cmz]# zip -r all.zip * -x 2.txt 3.txt # -x后面可以接多个文件，表示都不参与压缩
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%)
  adding: cc/2.txt (stored 0%)
  adding: cc/3.txt (stored 0%)
  adding: cc/4.txt (stored 0%)
  adding: cc/5.txt (stored 0%)

删除压缩包内某个文件
[root@master01 cmz]# zip -dv all.zip 4.txt
1>1: updating: 4.txt (stored 0%)

不显示执行过程 -q
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  cc
[root@master01 cmz]# zip -qr all.zip *
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip  cc
```

### 6.4 unzip

&emsp;Linux unzip命令用于解压缩zip文件,unzip为.zip压缩文件的解压缩程序。

**语法**

```
unzip [-cflptuvz][-agCjLMnoqsVX][-P <密码>][.zip文件][文件][-d <目录>][-x <文件>] 或 unzip [-Z]
```

**参数**：

- -c 将解压缩的结果显示到屏幕上，并对字符做适当的转换。
- -f 更新现有的文件。
- -l 显示压缩文件内所包含的文件。**
- -p 与-c参数类似，会将解压缩的结果显示到屏幕上，但不会执行任何的转换。
- -t 检查压缩文件是否正确。
- -u 与-f参数类似，但是除了更新现有的文件外，也会将压缩文件中的其他文件解压缩到目录中。
- -v 执行是时显示详细的信息。 **
- -z 仅显示压缩文件的备注文字。
- -a 对文本文件进行必要的字符转换。
- -b 不要对文本文件进行字符转换。
- -C 压缩文件中的文件名称区分大小写。
- -j 不处理压缩文件中原有的目录路径。
- -L 将压缩文件中的全部文件名改为小写。
- -M 将输出结果送到more程序处理。
- -n 解压缩时不要覆盖原有的文件。
- -o 不必先询问用户，unzip执行后覆盖原有文件。**
- -P<密码> 使用zip的密码选项。
- -q 执行时不显示任何信息。
- -s 将文件名中的空白字符转换为底线字符。
- -V 保留VMS的文件版本信息。
- -X 解压缩时同时回存文件原来的UID/GID。
- [.zip文件] 指定.zip压缩文件。
- [文件] 指定要处理.zip压缩文件中的哪些文件。
- -d<目录> 指定文件解压缩后所要存储的目录。 **
- -x<文件> 指定不要处理.zip压缩文件中的哪些文件。
- -Z unzip -Z等于执行zipinfo指令。

```
查看zip包中文件列表
[root@master01 cmz]# unzip -l all.zip 
Archive:  all.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  05-07-2019 08:02   2.txt
        0  05-07-2019 08:02   3.txt
        0  05-07-2019 08:02   4.txt
        0  05-07-2019 08:02   5.txt
        0  05-07-2019 08:12   cc/
        0  05-07-2019 08:12   cc/2.txt
        0  05-07-2019 08:12   cc/3.txt
        0  05-07-2019 08:12   cc/4.txt
        0  05-07-2019 08:12   cc/5.txt
---------                     -------
        0                     9 files
        
[root@master01 cmz]# unzip -v all.zip  # -v 参数用于查看压缩文件目录信息，但是不解压该文件。
Archive:  all.zip
 Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
--------  ------  ------- ---- ---------- ----- --------  ----
       0  Stored        0   0% 05-07-2019 08:02 00000000  2.txt
       0  Stored        0   0% 05-07-2019 08:02 00000000  3.txt
       0  Stored        0   0% 05-07-2019 08:02 00000000  4.txt
       0  Stored        0   0% 05-07-2019 08:02 00000000  5.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/2.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/3.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/4.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/5.txt
--------          -------  ---                            -------
       0                0   0%                            9 files
[root@master01 cmz]# 
----------------------------------------------------------------------------
解压，-d指定解压到该后面文件夹内，不指定就解压到当前目录下
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip  cc
[root@master01 cmz]# unzip all.zip 
Archive:  all.zip
replace 2.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: n         
replace 3.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: n
replace 4.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: N

[root@master01 cmz]# mkdir caimz
[root@master01 cmz]# unzip all.zip -d caimz/
Archive:  all.zip
 extracting: caimz/2.txt             
 extracting: caimz/3.txt             
 extracting: caimz/4.txt             
 extracting: caimz/5.txt             
   creating: caimz/cc/
 extracting: caimz/cc/2.txt          
 extracting: caimz/cc/3.txt          
 extracting: caimz/cc/4.txt          
 extracting: caimz/cc/5.txt          
[root@master01 cmz]# ls caimz/
2.txt  3.txt  4.txt  5.txt  cc

解压不提示文件是否覆盖
[root@master01 cmz]# unzip -o all.zip 
Archive:  all.zip
 extracting: 2.txt                   
 extracting: 3.txt                   
 extracting: 4.txt                   
 extracting: 5.txt                   
 extracting: cc/2.txt                
 extracting: cc/3.txt                
 extracting: cc/4.txt                
 extracting: cc/5.txt   
```

### 6.5 scp

&emsp;Linux scp命令用于Linux之间复制文件和目录。scp是 secure copy的缩写, scp是linux系统下基于ssh登陆进行安全的远程文件拷贝命令。

**语法**

```
scp [-1246BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
[-l limit] [-o ssh_option] [-P port] [-S program]
[[user@]host1:]file1 [...] [[user@]host2:]file2
```

简易写法:

```
scp [可选参数] file_source file_target 
```

**参数说明：**

- -1： 强制scp命令使用协议ssh1
- -2： 强制scp命令使用协议ssh2
- -4： 强制scp命令只使用IPv4寻址
- -6： 强制scp命令只使用IPv6寻址
- -B： 使用批处理模式（传输过程中不询问传输口令或短语）
- -C： 允许压缩。（将-C标志传递给ssh，从而打开压缩功能）**
- -p：保留原文件的修改时间，访问时间和访问权限。
- -q： 不显示传输进度条。
- -r： 递归复制整个目录。**
- -v：详细方式显示输出。scp和ssh(1)会显示出整个过程的调试信息。这些信息用于调试连接，验证和配置问题。
- -c cipher： 以cipher将数据传输进行加密，这个选项将直接传递给ssh。
- -F ssh_config： 指定一个替代的ssh配置文件，此参数直接传递给ssh。
- -i identity_file： 从指定文件中读取传输时使用的密钥文件，此参数直接传递给ssh。
- -l limit： 限定用户所能使用的带宽，以Kbit/s为单位。**
- -o ssh_option： 如果习惯于使用ssh_config(5)中的参数传递方式，
- -P port：注意是大写的P, port是指定数据传输用到的端口号 **
- -p:  不显示传输进度条 **
- -S program： 指定加密传输时所使用的程序。此程序必须能够理解ssh(1)的选项。

````
scp local_file remote_username@remote_ip:remote_folder 
或者 
scp local_file remote_username@remote_ip:remote_file 
或者 
scp local_file remote_ip:remote_folder 
或者 
scp local_file remote_ip:remote_file 

第1,2个指定了用户名，命令执行后需要再输入密码，第1个仅指定了远程的目录，文件名字不变，第2个指定了文件名；
第3,4个没有指定用户名，命令执行后需要输入用户名和密码，第3个仅指定了远程的目录，文件名字不变，第4个指定了文件名；
````



````
推送[本地文件/文件夹推送到远端]
1. 文件发送
root@master01 cmz]# ls
master.txt
[root@master01 cmz]# scp master.txt root@192.168.5.110:/tmp/
root@192.168.5.110's password: 
master.txt       100%    9    13.4KB/s   00:00 
2. 文件夹发送
[root@master01 cmz]# scp -r caimengzhi root@192.168.5.110:/tmp
root@192.168.5.110's password: 
hosts            100%  266   359.6KB/s   00:00  
----------------------------------------------------------------------------
拉取[远端文件/文件夹拉取到本地]
1. 拉取文件
[root@master01 cmz]# scp 192.168.5.110:/tmp/master.txt .
root@192.168.5.110's password: 
master.txt    100%    9     7.7KB/s   00:00    
[root@master01 cmz]# ls
master.txt

2. 拉取文件夹
[root@master01 cmz]# scp -r 192.168.5.110:/tmp/caimengzhi .
root@192.168.5.110's password: 
hosts          100%  266   174.7KB/s   00:00    
[root@master01 cmz]# ls
caimengzhi  master.txt
[root@master01 cmz]# ls caimengzhi/
hosts
````

> scp是全量复制，本地有也会再起拉取

### 6.6 rsync

&emsp;`rsync`是一款开源的，多功能的，快速的，可以实现全量和增量的本地或者远程的数据同步工具。`rsync` 命令一般有三种常见模式

```
1. 本地模式
	rsync	[选项]	[源文件]	[目标文件]
2. shell访问模式
	1. 拉取
		rsync	[选项]	[用户@主机:源文件]	   [目标文件]
	2. 推送
		rsync	[选项]	[目标文件]            [用户@主机:源文件]
3. rsync守护进程模式
	1. 拉取
		rsync	[选项]	[用户名@主机::源文件]  [目标文件]
		rsync	[选项]	rsync://用户@主机:端口/源文件	[目标文件]
	2. 推送
		rsync	[选项]	[源文件]	用户@主机::目标文件
		rsync	[选项]	[源文件]	rsync://用户@主机:端口/目标文件
```

> 命令之间，至少要有一个空格。

**参数说明：**

- -v, --verbose 详细模式输出
- -q, --quiet 精简输出模式
- -c, --checksum 打开校验开关，强制对文件传输进行校验
- -a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
- -r, --recursive 对子目录以递归模式处理
- -R, --relative 使用相对路径信息
- -b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
- --backup-dir 将备份文件(如~filename)存放在在目录下。
- -suffix=SUFFIX 定义备份文件前缀
- -u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
- -l, --links 保留软链结
- -L, --copy-links 想对待常规文件一样处理软链结
- --copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结
- --safe-links 忽略指向SRC路径目录树以外的链结
- -H, --hard-links 保留硬链结
- -p, --perms 保持文件权限
- -o, --owner 保持文件属主信息
- -g, --group 保持文件属组信息
- -D, --devices 保持设备文件信息
- -t, --times 保持文件时间信息
- -S, --sparse 对稀疏文件进行特殊处理以节省DST的空间
- -n, --dry-run现实哪些文件将被传输
- -W, --whole-file 拷贝文件，不进行增量检测
- -x, --one-file-system 不要跨越文件系统边界
- -B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节
- -e, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步
- --rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息
- -C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件
- --existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件
- --delete 删除那些DST中SRC没有的文件
- --delete-excluded 同样删除接收端那些被该选项指定排除的文件
- --delete-after 传输结束以后再删除
- --ignore-errors 及时出现IO错误也进行删除
- --max-delete=NUM 最多删除NUM个文件
- --partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输
- --force 强制删除目录，即使不为空
- --numeric-ids 不将数字的用户和组ID匹配为用户名和组名
- --timeout=TIME IP超时时间，单位为秒
- -I, --ignore-times 不跳过那些有同样的时间和长度的文件
- --size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间
- --modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0
- -T --temp-dir=DIR 在DIR中创建临时文件
- --compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份
- -P 等同于 --partial
- --progress 显示备份过程
- -z, --compress 对备份的文件在传输时进行压缩处理
- --exclude=PATTERN 指定排除不需要传输的文件模式
- --include=PATTERN 指定不排除而需要传输的文件模式
- --exclude-from=FILE 排除FILE中指定模式的文件
- --include-from=FILE 不排除FILE指定模式匹配的文件
- --version 打印版本信息
- --address 绑定到特定的地址
- --config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件
- --port=PORT 指定其他的rsync服务端口
- --blocking-io 对远程shell使用阻塞IO
- -stats 给出某些文件的传输状态
- --progress 在传输时现实传输过程
- --log-format=formAT 指定日志文件格式
- --password-file=FILE 从FILE中得到密码
- --bwlimit=KBPS 限制I/O带宽，KBytes per second
- -h, --help 显示帮助信息

```
[root@master01 cmz]# ls
caimengzhi  master.txt
[root@master01 cmz]# mkdir aa bb
[root@master01 cmz]# tree .
.
├── aa
├── bb
├── caimengzhi
│   └── hosts
└── master.txt

3 directories, 2 files
[root@master01 cmz]# rsync -avz caimengzhi/ aa/  # 源文件后加/，就复制源文件里面文件到目标文件下
sending incremental file list
./
hosts

sent 210 bytes  received 38 bytes  496.00 bytes/sec
total size is 266  speedup is 1.07
[root@master01 cmz]# rsync -avz caimengzhi bb/ # 源文件后不加/，就复制源文件和源文件下文件到目标文件下
sending incremental file list
caimengzhi/
caimengzhi/hosts

sent 229 bytes  received 39 bytes  536.00 bytes/sec
total size is 266  speedup is 0.99
[root@master01 cmz]# tree .
.
├── aa
│   └── hosts
├── bb
│   └── caimengzhi
│       └── hosts
├── caimengzhi
│   └── hosts
└── master.txt

4 directories, 4 files
```

> 目标文件后面有没有/都没有影响，主要是源文件后面的/

```
目标文件和源文件都在一个机器上，也就是同机器上的文件拷贝.
[root@master01 cmz]# rsync -avz caimengzhi /tmp/
sending incremental file list
caimengzhi/
caimengzhi/hosts

sent 229 bytes  received 39 bytes  536.00 bytes/sec
total size is 266  speedup is 0.99
[root@master01 cmz]# ls /tmp/caimengzhi/
hosts
```

> 类似`cp`，只不过能增量复制。	

````
删除文件的特殊例子 --delete，怎么能快速删除海量文件，
[root@master01 cmz]# mkdir null aa
[root@master01 cmz]# touch aa/{1..100000}.txt
[root@master01 cmz]# ls
aa  null
[root@master01 cmz]# ll aa|wc -l
100001
[root@master01 cmz]# rsync -abz --delete null/ aa/
--delete 使aa目录下内容要和控目录null保持一致，不同的文件及目录将会呗删除，即null里面有什么内容，aa里面就有什么内容，null里面没有的，aa里面必须要删除，因为null目录为空，因此会删除aa目录下所有内容。


对比删除时间
[root@master01 cmz]# touch aa/{1..100000}.txt
[root@master01 cmz]# time rsync -abz --delete null/ aa/

real	0m6.731s
user	0m0.242s
sys	0m5.141s
[root@master01 cmz]# touch aa/{1..100000}.txt
[root@master01 cmz]# time rm -rf aa/

real	0m6.647s
user	0m0.178s
sys	0m6.276s
因为文件比较少，差异不是那么明显
````

```
远程推送
	1. 文件推送
	[root@master01 cmz]# rsync -avz 1.txt 2.txt 3.txt  root@192.168.5.110:/tmp/
    root@192.168.5.110's password: 
    sending incremental file list
    1.txt
    2.txt
    3.txt

    sent 188 bytes  received 73 bytes  104.40 bytes/sec
    total size is 0  speedup is 0.00
	
	2. 文件夹推送
	[root@master01 cmz]# rsync -avz aa  root@192.168.5.110:/tmp/
    root@192.168.5.110's password: 
    sending incremental file list
    aa/
    aa/1.txt
    aa/2.txt
    aa/3.txt

    sent 216 bytes  received 77 bytes  83.71 bytes/sec
    total size is 0  speedup is 0.00
	
	源目录后面没有/，就是推送目录。源目录后面有/，就是推送目录下文件及目录

远程拉取
	1. 拉取文件
	[root@master01 cmz]# ls
    1.txt  2.txt  3.txt  aa
    [root@master01 cmz]# rm -rf *  # 删除文件
    [root@master01 cmz]# ls
    [root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/{1,2,3}.txt .
    root@192.168.5.110's password: 
    receiving incremental file list
    1.txt
    2.txt
    3.txt

    sent 81 bytes  received 185 bytes  106.40 bytes/sec
    total size is 0  speedup is 0.00
	[root@master01 cmz]# ls 
	1.txt  2.txt  3.txt   # 可见文件已经被拉取过来了
	
	2. 拉取目录
	[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa .
    root@192.168.5.110's password: 
    receiving incremental file list
    aa/
    aa/1.txt
    aa/2.txt
    aa/3.txt

    sent 85 bytes  received 216 bytes  120.40 bytes/sec
    total size is 0  speedup is 0.00
    [root@master01 cmz]# ll
    total 0
    -rw-r--r-- 1 root root  0 May  7 22:41 1.txt
    -rw-r--r-- 1 root root  0 May  7 22:41 2.txt
    -rw-r--r-- 1 root root  0 May  7 22:41 3.txt
    drwxr-xr-x 2 root root 45 May  7 22:41 aa
    [root@master01 cmz]# tree a
    a [error opening dir]

    0 directories, 0 files
    [root@master01 cmz]# tree aa
    aa
    ├── 1.txt
    ├── 2.txt
    └── 3.txt

    0 directories, 3 files
	
	效果一样，源目录下后加/，就同步源目录下文件及目录
	[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
    root@192.168.5.110's password: 
    receiving incremental file list
    ./
    1.txt
    2.txt
    3.txt

    sent 84 bytes  received 203 bytes  114.80 bytes/sec
    total size is 0  speedup is 0.00
    [root@master01 cmz]# ls
    1.txt  2.txt  3.txt
```

> `rsync`和`scp`都可以远程同步数据，scp是全量拷贝。而rsync可以是增量拷贝。

```
[root@master01 cmz]# rm -rf *
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list
./
1.txt
2.txt
3.txt

sent 84 bytes  received 203 bytes  114.80 bytes/sec
total size is 0  speedup is 0.00
[root@master01 cmz]# ls
1.txt  2.txt  3.txt
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list

sent 20 bytes  received 88 bytes  43.20 bytes/sec
total size is 0  speedup is 0.00
和本地一样就不拷贝了。
去远程机器上，增加一个文件。再次拷贝一下，
root@leco:/tmp# cd aa/
root@leco:/tmp/aa# cp /etc/hosts .
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list
./
hosts

sent 46 bytes  received 373 bytes  167.60 bytes/sec
total size is 387  speedup is 0.92

改变源文件数据
root@leco:/tmp/aa# ls
1.txt  2.txt  3.txt  hosts
root@leco:/tmp/aa# echo "1111">1.txt 
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list
1.txt

sent 43 bytes  received 167 bytes  84.00 bytes/sec
total size is 392  speedup is 1.87
可见只同步有差异的数据，
---------------------------------------------------------------------------------------------------
[root@master01 cmz]# scp -r  root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
1.txt                           100%    5     4.3KB/s   00:00    
hosts                           100%  387   237.5KB/s   00:00    
3.txt                           100%    0     0.0KB/s   00:00    
2.txt                           100%    0     0.0KB/s   00:00    
[root@master01 cmz]# scp -r  root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
1.txt                           100%    5     6.4KB/s   00:00    
hosts                           100%  387   322.5KB/s   00:00    
3.txt                           100%    0     0.0KB/s   00:00    
2.txt                           100%    0     0.0KB/s   00:00   
可见scp复制数据，都是全量的。不管你本地有没有，都给你再拷贝一遍过来。
```

> 不管是`rsync`还是`scp`都是基于ssh通道，所有输入的密码就是ssh对应的账号密码。

## 7. 用户管理

### 7.1 useradd

### 7.2 usermod

### 7.3 userdel

### 7.4 groupadd

### 7.5 groupdel

### 7.6 passwd

### 7.7 chage

### 7.8 chapsswd

### 7.9 su 

### 7.10 visudo

### 7.11 sudo 

### 7.12 id

### 7.13 w

### 7.14 who

### 7.15 users

### 7.16 whoami

### 7.17 last

### 7.18 lastb

### 7.19 lastlog

## 8. 磁盘，文件管理

### 8.1 fdisk

### 8.2 partprobe

### 8.3 tune2fs

### 8.4 parted

### 8.5 mkfs

### 8.6 dumpe2fs

### 8.7 resize2fs

### 8.8 fsck

### 8.9 dd

### 8.10 mount

### 8.11 umount

### 8.12 df

### 8.13 mkswap

### 8.14 swapon

### 8.15 swapoff

### 8.16 sync

## 9. Linux 进程管理

### 9.1 ps

### 9.2 pstree

### 9.3 pgrep

### 9.4 kill

### 9.5 killall

### 9.6 pkill

### 9.7 top

### 9.8 nice

### 9.9 renice

### 9.10 nohup

### 9.11 strace

### 9.12 ltrace

### 9.13 runlevel

### 9.14 init

### 9.15 service

## 10. 网络管理

### 10.1 ifconfig

&emsp;Linux ifconfig命令用于显示或设置网络设备。ifconfig可设置网络设备的状态，或是显示目前的设置。


````
ifconfig [网络设备][down up -allmulti -arp -promisc][add<地址>][del<地址>][<hw<网络设备类型><硬件地址>][io_addr<I/O地址>][irq<IRQ地址>][media<网络媒介类型>][mem_start<内存地址>][metric<数目>][mtu<字节>][netmask<子网掩码>][tunnel<地址>][-broadcast<地址>][-pointopoint<地址>][IP地址]
````

- add<地址> 设置网络设备IPv6的IP地址。
- del<地址> 删除网络设备IPv6的IP地址。
- down 关闭指定的网络设备。
- hw<网络设备类型><硬件地址> 设置网络设备的类型与硬件地址。
- io_addr<I/O地址> 设置网络设备的I/O地址。
- irq<IRQ地址> 设置网络设备的IRQ。
- media<网络媒介类型> 设置网络设备的媒介类型。
- mem_start<内存地址> 设置网络设备在主内存所占用的起始地址。
- metric<数目> 指定在计算数据包的转送次数时，所要加上的数目。
- mtu<字节> 设置网络设备的MTU。
- netmask<子网掩码> 设置网络设备的子网掩码。
- tunnel<地址> 建立IPv4与IPv6之间的隧道通信地址。
- up 启动指定的网络设备。
- broadcast<地址> 将要送往指定地址的数据包当成广播数据包来处理。
- pointopoint<地址> 与指定地址的网络设备建立直接连线，此模式具有保密功能。
- promisc 关闭或启动指定网络设备的promiscuous模式。
- [IP地址] 指定网络设备的IP地址。
- [网络设备] 指定网络设备的名称。

```
显示所有网卡信息
[root@master01 ~]# ifconfig
docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet 172.17.7.1  netmask 255.255.255.0  broadcast 172.17.7.255
        inet6 fe80::42:eeff:fe6d:570b  prefixlen 64  scopeid 0x20<link>
        ether 02:42:ee:6d:57:0b  txqueuelen 0  (Ethernet)
        RX packets 45  bytes 4919 (4.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 62  bytes 4736 (4.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.5.100  netmask 255.255.255.0  broadcast 192.168.5.255
        inet6 fe80::56d2:664e:e6f6:82db  prefixlen 64  scopeid 0x20<link>
        ether 0c:54:a5:01:7c:5b  txqueuelen 1000  (Ethernet)
        RX packets 15724030  bytes 3085207447 (2.8 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 16417165  bytes 3228395397 (3.0 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

flannel.1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet 172.17.7.0  netmask 255.255.255.255  broadcast 0.0.0.0
        inet6 fe80::ec2e:1dff:fea3:e33e  prefixlen 64  scopeid 0x20<link>
        ether ee:2e:1d:a3:e3:3e  txqueuelen 0  (Ethernet)
        RX packets 60  bytes 7875 (7.6 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 68  bytes 5195 (5.0 KiB)
        TX errors 0  dropped 8 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 14094691  bytes 3311043347 (3.0 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 14094691  bytes 3311043347 (3.0 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

veth5db34eb: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet6 fe80::e88d:90ff:fe4d:4cd6  prefixlen 64  scopeid 0x20<link>
        ether ea:8d:90:4d:4c:d6  txqueuelen 0  (Ethernet)
        RX packets 26  bytes 4079 (3.9 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 44  bytes 3364 (3.2 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0



显示指定网卡信息
root@leco:~# ifconfig enp3s0
enp3s0    Link encap:以太网  硬件地址 74:27:ea:b0:aa:2c  
          inet 地址:192.168.5.110  广播:192.168.5.255  掩码:255.255.255.0
          inet6 地址: fe80::7627:eaff:feb0:aa2c/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
          接收数据包:318562 错误:0 丢弃:0 过载:0 帧数:0
          发送数据包:219695 错误:0 丢弃:0 过载:0 载波:0
          碰撞:0 发送队列长度:1000 
          接收字节:23933588 (23.9 MB)  发送字节:243692185 (243.6 MB)

网卡开启和关闭
# ifconfig eth0 down
# ifconfig eth0 up

用ifconfig修改MAC地址
# ifconfig eth0 down //关闭网卡
# ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE //修改MAC地址
# ifconfig eth0 up //启动网卡
# ifconfig eth1 hw ether 00:1D:1C:1D:1E //关闭网卡并修改MAC地址 
# ifconfig eth1 up //启动网卡

配置IP地址
# ifconfig eth0 192.168.1.56 
//给eth0网卡配置IP地址
# ifconfig eth0 192.168.1.56 netmask 255.255.255.0 
// 给eth0网卡配置IP地址,并加上子掩码
# ifconfig eth0 192.168.1.56 netmask 255.255.255.0 broadcast 192.168.1.255
// 给eth0网卡配置IP地址,加上子掩码,加上个广播地址

开启和关闭arp
# ifconfig eth0 arp  //开启
# ifconfig eth0 -arp  //关闭

设置最大的传输单元
# ifconfig eth0 mtu 1500 
//设置能通过的最大数据包大小为 1500 bytes
```



### 10.2 ifup

### 10.3 ifdown

### 10.4 route 

### 10.5 arp

### 10.6 ip

### 10.7 netstat 

### 10.8 ss

### 10.9 ping

### 10.10 traceroute

### 10.11 arpinp

### 10.12 telnet

### 10.13 nc

### 10.14 ssh

### 10.15 wget

### 10.16 mailq

### 10.17 mail

### 10.18 nslookup

### 10.19 dig

### 10.20 nmap

### 10.21 tcpdump

## 11.系统管理

### 11.1 lsof

&emsp;Linux 查看端口占用情况可以使用 **lsof** 和 **netstat** 命令。lsof 查看端口占用语法格式：

```
lsof -i:端口号
```

```
root@leco:~# lsof -i:22
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
sshd    1401 root    3u  IPv4  39679      0t0  TCP *:ssh (LISTEN)
sshd    1401 root    4u  IPv6  39681      0t0  TCP *:ssh (LISTEN)
sshd    3518 root    3u  IPv4  34543      0t0  TCP 192.168.5.110:ssh->192.168.5.1:7644 (ESTABLISHED)
sshd    3589 leco    3u  IPv4  34543      0t0  TCP 192.168.5.110:ssh->192.168.5.1:7644 (ESTABLISHED)
root@leco:~# lsof -i:6000
COMMAND  PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nginx   1443     root    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx   1444 www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx   1445 www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx   1446 www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx   1447 www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
```

可以看到 `6000` 端口已经被轻 `nginx`服务占用。



```
# 使用root用户来执行lsof -i 命令
root@leco:~# lsof -i
COMMAND     PID            USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
cupsd       795            root   10u  IPv6  19840      0t0  TCP ip6-localhost:ipp (LISTEN)
cupsd       795            root   11u  IPv4  19841      0t0  TCP localhost:ipp (LISTEN)
mongod      811         mongodb   10u  IPv4  25119      0t0  TCP localhost:27017 (LISTEN)
avahi-dae   871           avahi   12u  IPv4  20687      0t0  UDP *:mdns 
avahi-dae   871           avahi   13u  IPv6  20688      0t0  UDP *:mdns 
avahi-dae   871           avahi   14u  IPv4  20689      0t0  UDP *:51183 
avahi-dae   871           avahi   15u  IPv6  20690      0t0  UDP *:41768 
cups-brow   954            root    8u  IPv4  20845      0t0  UDP *:ipp 
proxysql   1074            root   19u  IPv4  20827      0t0  TCP *:6033 (LISTEN)
proxysql   1074            root   20u  IPv4  20828      0t0  TCP *:6033 (LISTEN)
proxysql   1074            root   21u  IPv4  20829      0t0  TCP *:6033 (LISTEN)
proxysql   1074            root   22u  IPv4  20830      0t0  TCP *:6033 (LISTEN)
proxysql   1074            root   23u  IPv4  25711      0t0  TCP *:6032 (LISTEN)
sshd       1401            root    3u  IPv4  39679      0t0  TCP *:ssh (LISTEN)
sshd       1401            root    4u  IPv6  39681      0t0  TCP *:ssh (LISTEN)
mysqld     1421           mysql   24u  IPv6  31901      0t0  TCP *:mysql (LISTEN)
mysqld     1421           mysql   51u  IPv4  31943      0t0  TCP 192.168.5.110:53860->192.168.2.146:mysql (ESTABLISHED)
nginx      1443            root    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx      1443            root    7u  IPv4  21121      0t0  TCP *:90 (LISTEN)
nginx      1443            root    8u  IPv4  21122      0t0  TCP *:afs3-fileserver (LISTEN)
nginx      1443            root    9u  IPv4  21123      0t0  TCP *:kerberos (LISTEN)
nginx      1444        www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx      1444        www-data    7u  IPv4  21121      0t0  TCP *:90 (LISTEN)
nginx      1444        www-data    8u  IPv4  21122      0t0  TCP *:afs3-fileserver (LISTEN)
nginx      1444        www-data    9u  IPv4  21123      0t0  TCP *:kerberos (LISTEN)
nginx      1445        www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx      1445        www-data    7u  IPv4  21121      0t0  TCP *:90 (LISTEN)
nginx      1445        www-data    8u  IPv4  21122      0t0  TCP *:afs3-fileserver (LISTEN)
nginx      1445        www-data    9u  IPv4  21123      0t0  TCP *:kerberos (LISTEN)
nginx      1446        www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx      1446        www-data    7u  IPv4  21121      0t0  TCP *:90 (LISTEN)
nginx      1446        www-data    8u  IPv4  21122      0t0  TCP *:afs3-fileserver (LISTEN)
nginx      1446        www-data    9u  IPv4  21123      0t0  TCP *:kerberos (LISTEN)
nginx      1447        www-data    6u  IPv4  21120      0t0  TCP *:x11 (LISTEN)
nginx      1447        www-data    7u  IPv4  21121      0t0  TCP *:90 (LISTEN)
nginx      1447        www-data    8u  IPv4  21122      0t0  TCP *:afs3-fileserver (LISTEN)
nginx      1447        www-data    9u  IPv4  21123      0t0  TCP *:kerberos (LISTEN)
chronogra  1477      chronograf    5u  IPv6  27287      0t0  TCP *:8888 (LISTEN)
rwhod      1600           rwhod    3u  IPv4  28701      0t0  UDP *:who 
rwhod      1604           rwhod    3u  IPv4  28701      0t0  UDP *:who 
redis-sen  1629           redis    4u  IPv4  29195      0t0  TCP localhost:26379 (LISTEN)
redis-sen  1629           redis    5u  IPv4  29198      0t0  TCP localhost:49615->localhost:6379 (ESTABLISHED)
redis-sen  1629           redis    6u  IPv4  29199      0t0  TCP localhost:45091->localhost:6379 (ESTABLISHED)
redis-ser  1630           redis    4u  IPv4  27754      0t0  TCP *:6379 (LISTEN)
redis-ser  1630           redis    5u  IPv4  27218      0t0  TCP localhost:6379->localhost:49615 (ESTABLISHED)
redis-ser  1630           redis    6u  IPv4  27219      0t0  TCP localhost:6379->localhost:45091 (ESTABLISHED)
ntpd       1661             ntp   16u  IPv6  25007      0t0  UDP *:ntp 
ntpd       1661             ntp   17u  IPv4  25010      0t0  UDP *:ntp 
ntpd       1661             ntp   18u  IPv4  25014      0t0  UDP localhost:ntp 
ntpd       1661             ntp   19u  IPv6  25016      0t0  UDP ip6-localhost:ntp 
ntpd       1661             ntp   23u  IPv4  28496      0t0  UDP 192.168.5.110:ntp 
ntpd       1661             ntp   24u  IPv6  28499      0t0  UDP [fe80::7627:eaff:feb0:aa2c]:ntp 
ntpd       1661             ntp   25u  IPv4  32965      0t0  UDP 172.16.1.1:ntp 
ntpd       1661             ntp   26u  IPv4  32967      0t0  UDP 172.16.97.1:ntp 
ntpd       1661             ntp   27u  IPv6  37238      0t0  UDP [fe80::250:56ff:fec0:1]:ntp 
ntpd       1661             ntp   28u  IPv6  37240      0t0  UDP [fe80::250:56ff:fec0:8]:ntp 
tp_core    1688            root    4u  IPv4  27214      0t0  UDP localhost:56899->localhost:42396 
tp_core    1688            root    5u  IPv4  27215      0t0  UDP localhost:42396->localhost:56899 
tp_core    1688            root    6u  IPv4  27216      0t0  TCP localhost:52080 (LISTEN)
tp_core    1688            root   14u  IPv4  29269      0t0  TCP *:52189 (LISTEN)
tp_core    1688            root   15u  IPv4  27896      0t0  TCP *:52089 (LISTEN)
tp_core    1688            root   22u  IPv4  27307      0t0  TCP *:52389 (LISTEN)
tp_web     1775            root    6u  IPv4  30834      0t0  TCP *:7190 (LISTEN)
teamviewe  1820            root   13u  IPv4  27559      0t0  TCP localhost:5939 (LISTEN)
teamviewe  1820            root   15u  IPv4 654847      0t0  TCP 192.168.5.110:50896->CA-VAN-ANX-R004.teamviewer.com:5938 (ESTABLISHED)
shellinab  2145     shellinabox    4u  IPv4  25421      0t0  TCP *:4200 (LISTEN)
apache2    2217            root    4u  IPv6  31746      0t0  TCP *:http (LISTEN)
apache2    2219        www-data    4u  IPv6  31746      0t0  TCP *:http (LISTEN)
apache2    2220        www-data    4u  IPv6  31746      0t0  TCP *:http (LISTEN)
ntop       2320            ntop    1u  IPv4  28413      0t0  TCP *:3000 (LISTEN)
vmware-au  2551            root    8u  IPv6  32242      0t0  TCP *:902 (LISTEN)
vmware-au  2551            root    9u  IPv4  32243      0t0  TCP *:902 (LISTEN)
vmware-ho  2629            root   14u  IPv4  34056      0t0  TCP *:https (LISTEN)
vmware-ho  2629            root   15u  IPv6  34057      0t0  TCP *:https (LISTEN)
vmware-ho  2629            root   18u  IPv4  34059      0t0  TCP localhost:8307 (LISTEN)
nmbd       2696            root   16u  IPv4  31252      0t0  UDP *:netbios-ns 
nmbd       2696            root   17u  IPv4  31253      0t0  UDP *:netbios-dgm 
nmbd       2696            root   18u  IPv4  31255      0t0  UDP 192.168.5.110:netbios-ns 
nmbd       2696            root   19u  IPv4  31256      0t0  UDP 192.168.5.255:netbios-ns 
nmbd       2696            root   20u  IPv4  31257      0t0  UDP 192.168.5.110:netbios-dgm 
nmbd       2696            root   21u  IPv4  31258      0t0  UDP 192.168.5.255:netbios-dgm 
nmbd       2696            root   22u  IPv4  31259      0t0  UDP 172.16.97.1:netbios-ns 
nmbd       2696            root   23u  IPv4  31260      0t0  UDP 172.16.97.255:netbios-ns 
nmbd       2696            root   24u  IPv4  31261      0t0  UDP 172.16.97.1:netbios-dgm 
nmbd       2696            root   25u  IPv4  31262      0t0  UDP 172.16.97.255:netbios-dgm 
nmbd       2696            root   26u  IPv4  31263      0t0  UDP 172.16.1.1:netbios-ns 
nmbd       2696            root   27u  IPv4  31264      0t0  UDP 172.16.1.255:netbios-ns 
nmbd       2696            root   28u  IPv4  31265      0t0  UDP 172.16.1.1:netbios-dgm 
nmbd       2696            root   29u  IPv4  31266      0t0  UDP 172.16.1.255:netbios-dgm 
nmbd       2696            root   31u  IPv4  56357      0t0  UDP 172.17.0.1:netbios-ns 
nmbd       2696            root   32u  IPv4  56358      0t0  UDP 172.17.255.255:netbios-ns 
nmbd       2696            root   33u  IPv4  56359      0t0  UDP 172.17.0.1:netbios-dgm 
nmbd       2696            root   34u  IPv4  56360      0t0  UDP 172.17.255.255:netbios-dgm 
nmbd       2696            root   35u  IPv4  56361      0t0  UDP 172.18.0.1:netbios-ns 
nmbd       2696            root   36u  IPv4  56362      0t0  UDP 172.18.255.255:netbios-ns 
nmbd       2696            root   37u  IPv4  56363      0t0  UDP 172.18.0.1:netbios-dgm 
nmbd       2696            root   38u  IPv4  56364      0t0  UDP 172.18.255.255:netbios-dgm 
nmbd       2696            root   39u  IPv4  56365      0t0  UDP 172.19.0.1:netbios-ns 
nmbd       2696            root   40u  IPv4  56366      0t0  UDP 172.19.255.255:netbios-ns 
nmbd       2696            root   41u  IPv4  56367      0t0  UDP 172.19.0.1:netbios-dgm 
nmbd       2696            root   42u  IPv4  56368      0t0  UDP 172.19.255.255:netbios-dgm 
nmbd       2696            root   43u  IPv4  56369      0t0  UDP 172.20.0.1:netbios-ns 
nmbd       2696            root   44u  IPv4  56370      0t0  UDP 172.20.255.255:netbios-ns 
nmbd       2696            root   45u  IPv4  56371      0t0  UDP 172.20.0.1:netbios-dgm 
nmbd       2696            root   46u  IPv4  56372      0t0  UDP 172.20.255.255:netbios-dgm 
nmbd       2696            root   47u  IPv4  56373      0t0  UDP 192.168.122.1:netbios-ns 
nmbd       2696            root   48u  IPv4  56374      0t0  UDP 192.168.122.255:netbios-ns 
nmbd       2696            root   49u  IPv4  56375      0t0  UDP 192.168.122.1:netbios-dgm 
nmbd       2696            root   50u  IPv4  56376      0t0  UDP 192.168.122.255:netbios-dgm 
smbd       2767            root   34u  IPv6  34828      0t0  TCP *:microsoft-ds (LISTEN)
smbd       2767            root   35u  IPv6  34829      0t0  TCP *:netbios-ssn (LISTEN)
smbd       2767            root   36u  IPv4  34830      0t0  TCP *:microsoft-ds (LISTEN)
smbd       2767            root   37u  IPv4  34831      0t0  TCP *:netbios-ssn (LISTEN)
sshd       3518            root    3u  IPv4  34543      0t0  TCP 192.168.5.110:ssh->192.168.5.1:7644 (ESTABLISHED)
sshd       3589            leco    3u  IPv4  34543      0t0  TCP 192.168.5.110:ssh->192.168.5.1:7644 (ESTABLISHED)
dnsmasq    3858 libvirt-dnsmasq    3u  IPv4  39695      0t0  UDP *:bootps 
dnsmasq    3858 libvirt-dnsmasq    5u  IPv4  39698      0t0  UDP 192.168.122.1:domain 
dnsmasq    3858 libvirt-dnsmasq    6u  IPv4  39699      0t0  TCP 192.168.122.1:domain (LISTEN)
smbd      27361            root   38u  IPv4 522400      0t0  TCP 192.168.5.110:microsoft-ds->192.168.5.1:52759 (ESTABLISHED)

字段详解
COMMAND: 进程的名称
PID：进程的标识符
USER：进程所有者
FD：文件描述符，应用程序通过文件描述符识别该文件，如cwd，txt等
TYPE：文件类型，如DIR,REG等
DEVICE：指定磁盘的名称
SIZE: 文件的大小
NODE: 索引节点(文件在磁盘上的标识)
NAME：打开文件的确切名称
```

更多`lsof`用法

```
lsof -i:8080：查看8080端口占用
lsof abc.txt：显示开启文件abc.txt的进程
lsof -c abc：显示abc进程现在打开的文件
lsof -c -p 1234：列出进程号为1234的进程所打开的文件
lsof -g gid：显示归属gid的进程情况
lsof +d /usr/local/：显示目录下被进程开启的文件
lsof +D /usr/local/：同上，但是会搜索目录下的目录，时间较长
lsof -d 4：显示使用fd为4的进程
lsof -i -U：显示所有打开的端口和UNIX domain文件
```

### 11.2 uptime

```
root@leco:~# uptime
 14:35:59 up  4:17,  1 user,  load average: 0.10, 0.04, 0.01
   |       |   |     |            |          |     |     |_ 15分钟负载
   |       |   |     |            |          |     |_  5分钟负载
   |       |   |     |            |          |__ 1分钟负载
   |       |   |     |            |__ 负载[后面表示1,5,15分钟系统负载的值，越大表示负载越高]
   |       |   |     |___ 登录当前系统yoghurt
   |       |   |
   |       |___|__  开机状态UP，开机到现在时间4h17m
   |___  目前系统当前时间
```

### 11.3 free

&emsp;Linux free命令用于显示内存状态。free指令会显示内存的使用情况，包括实体内存，虚拟的交换文件内存，共享内存区段，以及系统核心使用的缓冲区等。

用法

```
free [-bkmotV][-s <间隔秒数>]
```

**参数说明**：

- -b 　以Byte为单位显示内存使用情况。
- -k 　以KB为单位显示内存使用情况。
- -m 　以MB为单位显示内存使用情况。
- -o 　不显示缓冲区调节列。
- -s<间隔秒数> 　持续观察内存使用状况。
- -t 　显示内存总和列。
- -V 　显示版本信息。

显示内存使用情况

```
[root@master01 ~]# free //显示内存使用信息
              total        used        free      shared  buff/cache   available
Mem:        3312584      676996      138616      174628     2496972     2166080
Swap:       3538940        5384     3533556
```

以上不好读[按照字节]，不友好，一般不推荐使用。

以总和的形式显示内存的使用信息

```
[root@master01 ~]# free -g  # 显示单位是GB
              total        used        free      shared  buff/cache   available
Mem:              3           0           0           0           2           2
Swap:             3           0           3
[root@master01 ~]# free -m  # 显示单位是MB
              total        used        free      shared  buff/cache   available
Mem:           3234         661         126         178        2446        2107
Swap:          3455           5        3450
[root@master01 ~]# free -k  # 显示单位是KB
              total        used        free      shared  buff/cache   available
Mem:        3312584      677092      129836      182820     2505656     2157784
Swap:       3538940        5384     3533556

# 显示单位是MB,且每隔2秒，执行一次
[root@master01 ~]# free -m -s 2
              total        used        free      shared  buff/cache   available
Mem:           3234         662         125         178        2447        2106
Swap:          3455           5        3450

              total        used        free      shared  buff/cache   available
Mem:           3234         662         125         178        2447        2106
```



### 11.4 iftop

### 11.5 vmstat

### 11.6 mpstat

### 11.7 iostat

### 11.8  iotop

### 11.9 sar

### 11.10 chkconfig

&emsp;Linux chkconfig命令用于检查，设置系统的各种服务。这是Red Hat公司遵循GPL规则所开发的程序，它可查询操作系统在每一个执行等级中会执行哪些系统服务，其中包括各类常驻服务。

> 该命令在centos7上即将废除了。在centos6用的很多。

**语法**

```
chkconfig [--add][--del][--list][系统服务] 或 chkconfig [--level <等级代号>][系统服务][on/off/reset]
```

**参数**：

- --add 　增加所指定的系统服务，让chkconfig指令得以管理它，并同时在系统启动的叙述文件内增加相关数据。
- --del 　删除所指定的系统服务，不再由chkconfig指令管理，并同时在系统启动的叙述文件内删除相关数据。
- --level<等级代号> 　指定读系统服务要在哪一个执行等级中开启或关毕。

```
[root@iZwz9e73kbnnm5ufk088lnZ ~]# chkconfig --list
aegis          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
agentwatch     	0:off	1:off	2:on	3:on	4:on	5:on	6:off
auditd         	0:off	1:off	2:on	3:on	4:on	5:on	6:off
blk-availability	0:off	1:on	2:on	3:on	4:on	5:on	6:off
cgconfig       	0:off	1:off	2:off	3:off	4:off	5:off	6:off
cgred          	0:off	1:off	2:off	3:off	4:off	5:off	6:off
cloud-config   	0:off	1:off	2:on	3:on	4:on	5:on	6:off
cloud-final    	0:off	1:off	2:on	3:on	4:on	5:on	6:off
cloud-init     	0:off	1:off	2:on	3:on	4:on	5:on	6:off
cloud-init-local	0:off	1:off	2:on	3:on	4:on	5:on	6:off
crond          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
ecs_mq-service 	0:off	1:off	2:on	3:on	4:on	5:on	6:off
eni-service    	0:off	1:off	2:on	3:on	4:on	5:on	6:off
htcacheclean   	0:off	1:off	2:off	3:off	4:off	5:off	6:off
httpd          	0:off	1:off	2:off	3:off	4:off	5:off	6:off
ip6tables      	0:off	1:off	2:on	3:on	4:on	5:on	6:off
iptables       	0:off	1:off	2:on	3:on	4:on	5:on	6:off
irqbalance     	0:off	1:off	2:off	3:on	4:on	5:on	6:off
iscsi          	0:off	1:off	2:off	3:on	4:on	5:on	6:off
iscsid         	0:off	1:off	2:off	3:on	4:on	5:on	6:off
lvm2-monitor   	0:off	1:on	2:on	3:on	4:on	5:on	6:off
mdmonitor      	0:off	1:off	2:on	3:on	4:on	5:on	6:off
messagebus     	0:off	1:off	2:on	3:on	4:on	5:on	6:off
multipathd     	0:off	1:off	2:off	3:off	4:off	5:off	6:off
netconsole     	0:off	1:off	2:off	3:off	4:off	5:off	6:off
netfs          	0:off	1:off	2:off	3:on	4:on	5:on	6:off
network        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
nginx          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
nscd           	0:off	1:off	2:off	3:off	4:off	5:off	6:off
ntpd           	0:off	1:off	2:on	3:on	4:on	5:on	6:off
ntpdate        	0:off	1:off	2:off	3:off	4:off	5:off	6:off
rdisc          	0:off	1:off	2:off	3:off	4:off	5:off	6:off
redis          	0:off	1:off	2:off	3:off	4:off	5:off	6:off
redis-sentinel 	0:off	1:off	2:off	3:off	4:off	5:off	6:off
restorecond    	0:off	1:off	2:off	3:off	4:off	5:off	6:off
rsyslog        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
salt-master    	0:off	1:off	2:on	3:on	4:on	5:on	6:off
salt-minion    	0:off	1:off	2:on	3:on	4:on	5:on	6:off
saslauthd      	0:off	1:off	2:off	3:off	4:off	5:off	6:off
smartd         	0:off	1:off	2:off	3:off	4:off	5:off	6:off
sshd           	0:off	1:off	2:on	3:on	4:on	5:on	6:off
udev-post      	0:off	1:on	2:on	3:on	4:on	5:on	6:off
vsftpd         	0:off	1:off	2:off	3:off	4:off	5:off	6:off

[root@iZwz9e73kbnnm5ufk088lnZ ~]# chkconfig --list nginx
nginx          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
[root@iZwz9e73kbnnm5ufk088lnZ ~]# chkconfig nginx off  # 开机不自启动
[root@iZwz9e73kbnnm5ufk088lnZ ~]# chkconfig --list nginx
nginx          	0:off	1:off	2:off	3:off	4:off	5:off	6:off
[root@iZwz9e73kbnnm5ufk088lnZ ~]# chkconfig nginx on   # 开机自启动
[root@iZwz9e73kbnnm5ufk088lnZ ~]# chkconfig --list nginx
nginx          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
```

&emsp;Linux运行等级。

**参数**：

- 0:     关机
- 1:     单用户模式
- 2：  没有网络的多用户模式
- 3：  完全的多用户模式
- 4：  预留
- 5：  图形界面多用户模式
- 6：  重启

```
[root@iZwz9e73kbnnm5ufk088lnZ ~]# cat /etc/inittab 
# inittab is only used by upstart for the default runlevel.
#
# ADDING OTHER CONFIGURATION HERE WILL HAVE NO EFFECT ON YOUR SYSTEM.
#
# System initialization is started by /etc/init/rcS.conf
#
# Individual runlevels are started by /etc/init/rc.conf
#
# Ctrl-Alt-Delete is handled by /etc/init/control-alt-delete.conf
#
# Terminal gettys are handled by /etc/init/tty.conf and /etc/init/serial.conf,
# with configuration in /etc/sysconfig/init.
#
# For information on how to write upstart event handlers, or how
# upstart works, see init(5), init(8), and initctl(8).
#
# Default runlevel. The runlevels used are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode
#   4 - unused
#   5 - X11
#   6 - reboot (Do NOT set initdefault to this)
# 
id:3:initdefault:
```

centos7

````
查看当前模式
[root@master01 tmp]# systemctl get-default
multi-user.target
````



### 11.11 ntsysv

&emsp;Linux ntsysv命令用于设置系统的各种服务。这是Red Hat公司遵循GPL规则所开发的程序，它具有互动式操作界面，您可以轻易地利用方向键和空格键等，开启，关闭操作系统在每个执行等级中，所要执行的系统服务。

**语法**

```
ntsysv [--back][--level <等级代号>]
```

**参数**：

- --back 　在互动式界面里，显示Back钮，而非Cancel钮。
- --level <等级代号> 　在指定的执行等级中，决定要开启或关闭哪些系统服务。

```
[root@iZwz9e73kbnnm5ufk088lnZ ~]# ntsysv
ntsysv 1.3.49.5 - (C) 2000-2001 Red Hat, Inc. 

┌──────────────────┤ Services ├──────────────────┐
│                                                │ 
│ What services should be automatically started? │ 
│                                                │ 
│            [*] aegis             ↑             │ 
│            [*] agentwatch        ▮             │ 
│            [*] auditd            ▒             │ 
│            [*] blk-availability  ▒             │ 
│            [ ] cgconfig          ▒             │ 
│            [ ] cgred             ▒             │ 
│            [*] cloud-config      ▒             │ 
│            [*] cloud-final       ▒             │ 
│            [*] cloud-init        ▒             │ 
│            [*] cloud-init-local  ▒             │ 
│            [*] crond             ▒             │ 
│            [*] ecs_mq-service    ▒             │ 
│            [*] eni-service       ▒             │ 
│            [ ] htcacheclean      ▒             │ 
│            [ ] httpd             ▒             │ 
│            [*] ip6tables         ▒             │ 
│            [*] iptables          ▒             │ 
│            [*] irqbalance        ▒             │ 
│            [*] iscsi             ▒             │ 
│            [*] iscsid            ▒             │ 
│            [*] lvm2-monitor      ▒             │ 
│            [*] mdmonitor         ▒             │ 
│            [*] messagebus        ↓             │ 
│                                                │ 
│        ┌────┐               ┌────────┐         │ 
│        │ Ok │               │ Cancel │         │ 
│        └────┘               └────────┘         │ 
│                                                │ 
│                                                │ 
└────────────────────────────────────────────────┘ 
Press <F1> for more information on a service.
```

> 以上就可以图形化操作，配置开机自启动那些服务了

### 11.12 setup

> 没有命令就安装包 yum install setuptool

图形配置

```
[root@iZwz9e73kbnnm5ufk088lnZ ~]# setup
Text Mode Setup Utility 1.19.9  (c) 1999-2006 Red Hat, Inc.

 ┌────────┤ Choose a Tool ├─────────┐
 │                                  │ 
 │   Authentication configuration   │ 
 │   System services                │ 
 │                                  │ 
 │      ┌──────────┐  ┌──────┐      │ 
 │      │ Run Tool │  │ Quit │      │ 
 │      └──────────┘  └──────┘      │ 
 │                                  │ 
 │                                  │ 
 └──────────────────────────────────┘ 
                                                                     
authconfig-tui - (c) 1999-2005 Red Hat, Inc.

 ┌────────────────┤ Authentication Configuration ├─────────────────┐
 │                                                                 │ 
 │  User Information        Authentication                         │ 
 │  [ ] Cache Information   [ ] Use MD5 Passwords                  │ 
 │  [ ] Use LDAP            [*] Use Shadow Passwords               │ 
 │  [ ] Use NIS             [ ] Use LDAP Authentication            │ 
 │  [ ] Use IPAv2           [ ] Use Kerberos                       │ 
 │  [ ] Use Winbind         [ ] Use Fingerprint reader             │ 
 │                          [ ] Use Winbind Authentication         │ 
 │                          [*] Local authorization is sufficient  │ 
 │                                                                 │ 
 │            ┌────────┐                      ┌──────┐             │ 
 │            │ Cancel │                      │ Next │             │ 
 │            └────────┘                      └──────┘             │ 
 │                                                                 │ 
 │                                                                 │ 
 └─────────────────────────────────────────────────────────────────┘ 
 <Tab>/<Alt-Tab> between elements   |   <Space> selects   |  <F12> next screen
```



### 11.13 ethool

&emsp;ethtool 是用于查询及设置网卡参数的命令。

语法

```
ethool [网卡名] 参数列表[-h|-i|-d|-r|-s|-S]
```

**参数说明**：

- 网卡名 查询网卡基本信息
- -h    显示帮助信息
- -i     查询后面网卡信息
- -d    查询后面网卡的注册信息
- -r     重置后面网卡到自适应模式
- -S    查询后面网卡收发包统计
- -s    设置网卡速率

```
[root@master01 ~]# ethtool eno1
Settings for eno1:
	Supported ports: [ TP MII ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Supported pause frame use: No
	Supports auto-negotiation: Yes
	Supported FEC modes: Not reported
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Advertised FEC modes: Not reported
	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
	                                     100baseT/Half 100baseT/Full 
	                                     1000baseT/Full 
	Link partner advertised pause frame use: Symmetric Receive-only
	Link partner advertised auto-negotiation: Yes
	Link partner advertised FEC modes: Not reported
	Speed: 1000Mb/s
	Duplex: Full
	Port: MII
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: pumbg
	Wake-on: d
	Current message level: 0x00000033 (51)
			       drv probe ifdown ifup
	Link detected: yes

[root@master01 ~]# ethtool -i eno1
driver: r8169
version: 2.3LK-NAPI
firmware-version: rtl_nic/rtl8168e-2.fw
expansion-rom-version: 
bus-info: 0000:01:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no

[root@master01 ~]# ethtool -d eno1
RealTek RTL8168e/8111e registers:
--------------------------------------------------------
0x00: MAC Address                      0c:54:a5:01:7c:5b
0x08: Multicast Address Filter     0x00000050 0x00000080
0x10: Dump Tally Counter Command   0x34c12000 0x00000001
0x20: Tx Normal Priority Ring Addr 0x96bf4000 0x00000000
0x28: Tx High Priority Ring Addr   0x30c67800 0x11866c14
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x00
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x803f
      SERR LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x2f200700
0x44: Rx Configuration                        0x0002874e
0x48: Timer count                             0x5b91711f
0x4C: Missed packet counter                     0x8ef7bb
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x00
0x52: Config 1                                      0x0f
0x53: Config 2                                      0x5d
0x54: Config 3                                      0xc0
0x55: Config 4                                      0x54
0x56: Config 5                                      0x80
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x8005cde1
0x64: TBI control and status                  0x27ffff01
0x68: TBI Autonegotiation advertisement (ANAR)    0xf70c
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0xf3
0x84: PM wakeup frame 0            0x00000000 0x5b91783f
0x8C: PM wakeup frame 1            0x00000000 0x14c67c06
0x94: PM wakeup frame 2 (low)      0x14e46914 0x12c47894
0x9C: PM wakeup frame 2 (high)     0x34c67914 0x34c66816
0xA4: PM wakeup frame 3 (low)      0x68c67d16 0x30c47906
0xAC: PM wakeup frame 3 (high)     0x30447d16 0x00000000
0xB4: PM wakeup frame 4 (low)      0x00000000 0x00000000
0xBC: PM wakeup frame 4 (high)     0x00000000 0x00000000
0xC4: Wakeup frame 0 CRC                          0x0000
0xC6: Wakeup frame 1 CRC                          0x0000
0xC8: Wakeup frame 2 CRC                          0x0000
0xCA: Wakeup frame 3 CRC                          0x0000
0xCC: Wakeup frame 4 CRC                          0x0000
0xDA: RX packet maximum size                      0x4000
0xE0: C+ Command                                  0x21e1
      Home LAN enable
      VLAN de-tagging
      RX checksumming
0xE2: Interrupt Mitigation                        0x5151
      TxTimer:       5
      TxPackets:     1
      RxTimer:       5
      RxPackets:     1
0xE4: Rx Ring Addr                 0x96953000 0x00000000
0xEC: Early Tx threshold                            0x3f
0xF0: Func Event                              0x00000030
0xF4: Func Event Mask                         0x00000000
0xF8: Func Preset State                       0x0003ffff
0xFC: Func Force Event                        0x00000000

[root@master01 ~]# ethtool -S eno1
NIC statistics:
     tx_packets: 15463169
     rx_packets: 14713138
     tx_errors: 0
     rx_errors: 0
     rx_missed: 0
     align_errors: 0
     tx_single_collisions: 0
     tx_multi_collisions: 0
     unicast: 14388193
     broadcast: 315968
     multicast: 8977
     tx_aborted: 0
     tx_underrun: 0

[root@master01 ~]#  ethtool -s eno1 autoneg off speed 100 duplex full
```

### 11.15 mii-tool

&emsp;查看物理网卡的网线是否在线

```
[root@master01 ~]# mii-tool eno1
eno1: negotiated 1000baseT-FD flow-control, link ok
```

### 11.16 dmidecode

&emsp;查看内存详细信息,比如内存大小，型号，主板型号等等.

语法

```
dmidecode [选项]
```

**参数说明**：

- -t  只显示指定条目
- -s 只显示指定DMI字符串信息
- -q 精简输出

??? note "详细"
    ```
    [root@master01 ~]# dmidecode 
    # dmidecode 3.1
    Getting SMBIOS data from sysfs.
    SMBIOS 2.7 present.
    58 structures occupying 2363 bytes.
    Table at 0x000E9BF0.

    Handle 0x0000, DMI type 0, 24 bytes
    BIOS Information
        Vendor: Acer   
        Version: MAP23SB
        Release Date: 09/02/2013
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 4096 kB
        Characteristics:
            PCI is supported
            APM is supported
            BIOS is upgradeable
            BIOS shadowing is allowed
            Boot from CD is supported
            Selectable boot is supported
            BIOS ROM is socketed
            EDD is supported
            5.25"/1.2 MB floppy services are supported (int 13h)
            3.5"/720 kB floppy services are supported (int 13h)
            3.5"/2.88 MB floppy services are supported (int 13h)
            Print screen service is supported (int 5h)
            Serial services are supported (int 14h)
            Printer services are supported (int 17h)
            ACPI is supported
            USB legacy is supported
            BIOS boot specification is supported
            Targeted content distribution is supported
            UEFI is supported
        BIOS Revision: 4.6
    
    Handle 0x0001, DMI type 1, 27 bytes
    System Information
        Manufacturer: Acer
        Product Name: Shangqi N6120
        Version:         
        Serial Number: DTA0CCN010346043DC9600
        UUID: 906e720a-4cf8-11e3-a582-cd6b93fb380d
        Wake-up Type: Power Switch
        SKU Number:                       
        Family: Acer Desktop
    
    Handle 0x0002, DMI type 2, 15 bytes
    Base Board Information
        Manufacturer: Acer
        Product Name: AAHD3-VF
        Version: 1.02
        Serial Number: DBA0CC1001345002916311
        Asset Tag:                       
        Features:
            Board is a hosting board
            Board is replaceable
        Location In Chassis:                                 
        Chassis Handle: 0x0003
        Type: Motherboard
        Contained Object Handles: 0
    
    Handle 0x0003, DMI type 3, 22 bytes
    Chassis Information
        Manufacturer: Acer
        Type: Desktop
        Lock: Not Present
        Version:         
        Serial Number:                       
        Asset Tag:                       
        Boot-up State: Safe
        Power Supply State: Safe
        Thermal State: Safe
        Security Status: None
        OEM Information: 0x00000000
        Height: Unspecified
        Number Of Power Cords: 1
        Contained Elements: 0
        SKU Number:                       
    
    Handle 0x0004, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J1A1
        Internal Connector Type: None
        External Reference Designator: PS2Mouse
        External Connector Type: PS/2
        Port Type: Mouse Port
    
    Handle 0x0005, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J1A1
        Internal Connector Type: None
        External Reference Designator: Keyboard
        External Connector Type: PS/2
        Port Type: Keyboard Port
    
    Handle 0x0006, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J2A1
        Internal Connector Type: None
        External Reference Designator: TV Out
        External Connector Type: Mini Centronics Type-14
        Port Type: Other
    
    Handle 0x0007, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J2A2A
        Internal Connector Type: None
        External Reference Designator: COM A
        External Connector Type: DB-9 male
        Port Type: Serial Port 16550A Compatible
    
    Handle 0x0008, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J2A2B
        Internal Connector Type: None
        External Reference Designator: Video
        External Connector Type: DB-15 female
        Port Type: Video Port
    
    Handle 0x0009, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J3A1
        Internal Connector Type: None
        External Reference Designator: USB1
        External Connector Type: Access Bus (USB)
        Port Type: USB
    
    Handle 0x000A, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J3A1
        Internal Connector Type: None
        External Reference Designator: USB2
        External Connector Type: Access Bus (USB)
        Port Type: USB
    
    Handle 0x000B, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J3A1
        Internal Connector Type: None
        External Reference Designator: USB3
        External Connector Type: Access Bus (USB)
        Port Type: USB
    
    Handle 0x000C, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9A1 - TPM HDR
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x000D, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9C1 - PCIE DOCKING CONN
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x000E, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J2B3 - CPU FAN
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x000F, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J6C2 - EXT HDMI
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0010, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J3C1 - GMCH FAN
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0011, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J1D1 - ITP
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0012, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9E2 - MDC INTPSR
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0013, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9E4 - MDC INTPSR
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0014, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9E3 - LPC HOT DOCKING
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0015, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9E1 - SCAN MATRIX
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0016, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J9G1 - LPC SIDE BAND
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0017, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J8F1 - UNIFIED
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0018, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J6F1 - LVDS
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x0019, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J2F1 - LAI FAN
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x001A, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J2G1 - GFX VID
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x001B, DMI type 8, 9 bytes
    Port Connector Information
        Internal Reference Designator: J1G6 - AC JACK
        Internal Connector Type: Other
        External Reference Designator: Not Specified
        External Connector Type: None
        Port Type: Other
    
    Handle 0x001C, DMI type 9, 17 bytes
    System Slot Information
        Designation: PCIEx16
        Type: x16 PCI Express 2 x16
        Current Usage: Available
        Length: Long
        ID: 1
        Characteristics:
            3.3 V is provided
            Opening is shared
            PME signal is supported
        Bus Address: 0000:ff:02.0
    
    Handle 0x001D, DMI type 9, 17 bytes
    System Slot Information
        Designation: PCIE_X1_1
        Type: x1 PCI Express 2 x1
        Current Usage: Available
        Length: Short
        ID: 33
        Characteristics:
            3.3 V is provided
            Opening is shared
            PME signal is supported
        Bus Address: 0000:ff:15.0
    
    Handle 0x001E, DMI type 9, 17 bytes
    System Slot Information
        Designation: PCIE_X1_2
        Type: x1 PCI Express 2 x1
        Current Usage: Available
        Length: Short
        ID: 34
        Characteristics:
            3.3 V is provided
            Opening is shared
            PME signal is supported
        Bus Address: 0000:ff:15.1
    
    Handle 0x001F, DMI type 9, 17 bytes
    System Slot Information
        Designation: MINI_CARD1
        Type: x1 PCI Express 2 x1
        Current Usage: Available
        Length: Short
        ID: 4
        Characteristics:
            3.3 V is provided
            Opening is shared
            PME signal is supported
        Bus Address: 0000:ff:15.2
    
    Handle 0x0020, DMI type 9, 17 bytes
    System Slot Information
        Designation: PCI_1
        Type: 32-bit PCI
        Current Usage: Available
        Length: Long
        ID: 6
        Characteristics:
            3.3 V is provided
            Opening is shared
            PME signal is supported
        Bus Address: 0000:ff:14.4
    
    Handle 0x0021, DMI type 10, 12 bytes
    On Board Device 1 Information
        Type: Video
        Status: Enabled
        Description:  Onboard AMD Graphics
    On Board Device 2 Information
        Type: Ethernet
        Status: Enabled
        Description:  Realtek Gigabit Network Connection
    On Board Device 3 Information
        Type: Sound
        Status: Enabled
        Description:  Realtek Audio
    On Board Device 4 Information
        Type: SATA Controller
        Status: Enabled
        Description:  Onboard SATA
    
    Handle 0x0022, DMI type 11, 5 bytes
    OEM Strings
        String 1: AMD FM2 APU + AMD Hudson D3
    
    Handle 0x0023, DMI type 12, 5 bytes
    System Configuration Options
        Option 1: To Be Filled By O.E.M.
    
    Handle 0x0024, DMI type 16, 23 bytes
    Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: None
        Maximum Capacity: 16 GB
        Error Information Handle: Not Provided
        Number Of Devices: 4
    
    Handle 0x0025, DMI type 19, 31 bytes
    Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 4 GB
        Physical Array Handle: 0x0024
        Partition Width: 255
    
    Handle 0x0026, DMI type 17, 34 bytes
    Memory Device
        Array Handle: 0x0024
        Error Information Handle: Not Provided
        Total Width: 64 bits
        Data Width: 64 bits
        Size: 4096 MB
        Form Factor: DIMM
        Set: None
        Locator: DIMM1
        Bank Locator: BANK1
        Type: DDR3
        Type Detail: Synchronous
        Speed: 1600 MT/s
        Manufacturer: Kingston        
        Serial Number: BE222EA4  
        Asset Tag:                       
        Part Number: ACR16D3LU1NGG/4G      
        Rank: 2
        Configured Clock Speed: 1600 MT/s
    
    Handle 0x0027, DMI type 20, 35 bytes
    Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 4 GB
        Physical Device Handle: 0x0026
        Memory Array Mapped Address Handle: 0x0025
        Partition Row Position: 1
    
    Handle 0x0028, DMI type 17, 34 bytes
    Memory Device
        Array Handle: 0x0024
        Error Information Handle: Not Provided
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: DIMM
        Set: None
        Locator: DIMM2
        Bank Locator: BANK2
        Type: Other
        Type Detail: None
        Speed: Unknown
        Manufacturer:                 
        Serial Number:           
        Asset Tag:                       
        Part Number:                       
        Rank: Unknown
        Configured Clock Speed: Unknown
    
    Handle 0x0029, DMI type 126, 35 bytes
    Inactive
    
    Handle 0x002A, DMI type 17, 34 bytes
    Memory Device
        Array Handle: 0x0024
        Error Information Handle: Not Provided
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: DIMM
        Set: None
        Locator: DIMM3
        Bank Locator: BANK3
        Type: Other
        Type Detail: None
        Speed: Unknown
        Manufacturer:                 
        Serial Number:           
        Asset Tag:                       
        Part Number:                       
        Rank: Unknown
        Configured Clock Speed: Unknown
    
    Handle 0x002B, DMI type 126, 35 bytes
    Inactive
    
    Handle 0x002C, DMI type 17, 34 bytes
    Memory Device
        Array Handle: 0x0024
        Error Information Handle: Not Provided
        Total Width: Unknown
        Data Width: Unknown
        Size: No Module Installed
        Form Factor: DIMM
        Set: None
        Locator: DIMM4
        Bank Locator: BANK4
        Type: Other
        Type Detail: None
        Speed: Unknown
        Manufacturer:                 
        Serial Number:           
        Asset Tag:                       
        Part Number:                       
        Rank: Unknown
        Configured Clock Speed: Unknown
    
    Handle 0x002D, DMI type 126, 35 bytes
    Inactive
    
    Handle 0x002E, DMI type 24, 5 bytes
    Hardware Security
        Power-On Password Status: Disabled
        Keyboard Password Status: Not Implemented
        Administrator Password Status: Disabled
        Front Panel Reset Status: Not Implemented
    
    Handle 0x002F, DMI type 32, 20 bytes
    System Boot Information
        Status: No errors detected
    
    Handle 0x0030, DMI type 41, 11 bytes
    Onboard Device
        Reference Designation:  Onboard AMD Graphics
        Type: Video
        Status: Enabled
        Type Instance: 1
        Bus Address: f000:00:01.0
    
    Handle 0x0031, DMI type 41, 11 bytes
    Onboard Device
        Reference Designation:  Realtek Gigabit Network Connection
        Type: Ethernet
        Status: Enabled
        Type Instance: 1
        Bus Address: f000:01:00.0
    
    Handle 0x0032, DMI type 41, 11 bytes
    Onboard Device
        Reference Designation:  Realtek Audio
        Type: Sound
        Status: Enabled
        Type Instance: 1
        Bus Address: f000:00:01.1
    
    Handle 0x0033, DMI type 41, 11 bytes
    Onboard Device
        Reference Designation:  Onboard SATA
        Type: SATA Controller
        Status: Enabled
        Type Instance: 1
        Bus Address: f000:00:11.0
    
    Handle 0x0034, DMI type 7, 19 bytes
    Cache Information
        Socket Designation: L2 CACHE
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 4096 kB
        Maximum Size: 4096 kB
        Supported SRAM Types:
            Pipeline Burst
        Installed SRAM Type: Pipeline Burst
        Speed: 1 ns
        Error Correction Type: Multi-bit ECC
        System Type: Unified
        Associativity: 16-way Set-associative
    
    Handle 0x0035, DMI type 7, 19 bytes
    Cache Information
        Socket Designation: L1 CACHE
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 192 kB
        Maximum Size: 192 kB
        Supported SRAM Types:
            Pipeline Burst
        Installed SRAM Type: Pipeline Burst
        Speed: 1 ns
        Error Correction Type: Multi-bit ECC
        System Type: Unified
        Associativity: 2-way Set-associative
    
    Handle 0x0037, DMI type 4, 42 bytes
    Processor Information
        Socket Designation: P0
        Type: Central Processor
        Family: Other
        Manufacturer: AMD
        ID: FF FB 8B 17 01 0F 61 00
        Version: AMD A8-5500 APU with Radeon(tm) HD Graphics    
        Voltage: 1.3 V
        External Clock: 100 MHz
        Max Speed: 3200 MHz
        Current Speed: 3200 MHz
        Status: Populated, Enabled
        Upgrade: Other
        L1 Cache Handle: 0x0035
        L2 Cache Handle: 0x0034
        L3 Cache Handle: Not Provided
        Serial Number: Not Specified
        Asset Tag: Not Specified
        Part Number: Not Specified
        Core Count: 4
        Core Enabled: 4
        Thread Count: 4
        Characteristics:
            64-bit capable
    
    Handle 0x0038, DMI type 172, 18 bytes
    OEM-specific Type
        Header and Data:
            AC 12 38 00 03 02 FF FF FF 02 02 00 FF FF FF 04
            03 00
    
    Handle 0x0039, DMI type 13, 22 bytes
    BIOS Language Information
        Language Description Format: Long
        Installable Languages: 1
            en|US|iso8859-1
        Currently Installed Language: en|US|iso8859-1
    
    Handle 0x003A, DMI type 127, 4 
    ```

内存信息

```
[root@master01 ~]# dmidecode -t memory
# dmidecode 3.1
Getting SMBIOS data from sysfs.
SMBIOS 2.7 present.

Handle 0x0024, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 16 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0026, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0024
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK1
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MT/s
	Manufacturer: Kingston        
	Serial Number: BE222EA4  
	Asset Tag:                       
	Part Number: ACR16D3LU1NGG/4G      
	Rank: 2
	Configured Clock Speed: 1600 MT/s

Handle 0x0028, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0024
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM2
	Bank Locator: BANK2
	Type: Other
	Type Detail: None
	Speed: Unknown
	Manufacturer:                 
	Serial Number:           
	Asset Tag:                       
	Part Number:                       
	Rank: Unknown
	Configured Clock Speed: Unknown

Handle 0x002A, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0024
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK3
	Type: Other
	Type Detail: None
	Speed: Unknown
	Manufacturer:                 
	Serial Number:           
	Asset Tag:                       
	Part Number:                       
	Rank: Unknown
	Configured Clock Speed: Unknown

Handle 0x002C, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0024
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM4
	Bank Locator: BANK4
	Type: Other
	Type Detail: None
	Speed: Unknown
	Manufacturer:                 
	Serial Number:           
	Asset Tag:                       
	Part Number:                       
	Rank: Unknown
	Configured Clock Speed: Unknown
```

查看服务器型号

```
[root@master01 ~]# dmidecode -s system-product-name
Shangqi N6120
```

查查系统序列号

```
[root@master01 ~]# dmidecode -s system-serial-number
DTA0CCN010346043DC9600
```

### 11.17 rpm

&emsp;Linux rpm 命令用于管理套件。rpm(redhat package manager) 原本是 Red Hat Linux 发行版专门用来管理 Linux 各项套件的程序，由于它遵循 GPL 规则且功能强大方便，因而广受欢迎。逐渐受到其他发行版的采用。RPM 套件管理方式的出现，让 Linux 易于安装，升级，间接提升了 Linux 的适用度。

**语法**

```
rpm [-acdhilqRsv][-b<完成阶段><套间档>+][-e<套件挡>][-f<文件>+][-i<套件档>][-p<套件档>＋][-U<套件档>][-vv][--addsign<套件档>+][--allfiles][--allmatches][--badreloc][--buildroot<根目录>][--changelog][--checksig<套件档>+][--clean][--dbpath<数据库目录>][--dump][--excludedocs][--excludepath<排除目录>][--force][--ftpproxy<主机名称或IP地址>][--ftpport<通信端口>][--help][--httpproxy<主机名称或IP地址>][--httpport<通信端口>][--ignorearch][--ignoreos][--ignoresize][--includedocs][--initdb][justdb][--nobulid][--nodeps][--nofiles][--nogpg][--nomd5][--nopgp][--noorder][--noscripts][--notriggers][--oldpackage][--percent][--pipe<执行指令>][--prefix<目的目录>][--provides][--queryformat<档头格式>][--querytags][--rcfile<配置档>][--rebulid<套件档>][--rebuliddb][--recompile<套件档>][--relocate<原目录>=<新目录>][--replacefiles][--replacepkgs][--requires][--resign<套件档>+][--rmsource][--rmsource<文件>][--root<根目录>][--scripts][--setperms][--setugids][--short-circuit][--sign][--target=<安装平台>+][--test][--timecheck<检查秒数>][--triggeredby<套件档>][--triggers][--verify][--version][--whatprovides<功能特性>][--whatrequires<功能特性>]
```

**参数说明**：

- -a 　查询所有套件。
- -b<完成阶段><套件档>+或-t <完成阶段><套件档>+ 　设置包装套件的完成阶段，并指定套件档的文件名称。
- -c 　只列出组态配置文件，本参数需配合"-l"参数使用。
- -d 　只列出文本文件，本参数需配合"-l"参数使用。
- -e<套件档>或--erase<套件档> 　删除指定的套件。
- -f<文件>+ 　查询拥有指定文件的套件。
- -h或--hash 　套件安装时列出标记。
- -i 　显示套件的相关信息。
- -i<套件档>或--install<套件档> 　安装指定的套件档。
- -l 　显示套件的文件列表。
- -p<套件档>+ 　查询指定的RPM套件档。
- -q 　使用询问模式，当遇到任何问题时，rpm指令会先询问用户。
- -R 　显示套件的关联性信息。
- -s 　显示文件状态，本参数需配合"-l"参数使用。
- -U<套件档>或--upgrade<套件档> 升级指定的套件档。
- -v 　显示指令执行过程。
- -vv 　详细显示指令执行过程，便于排错。
- -addsign<套件档>+ 　在指定的套件里加上新的签名认证。
- --allfiles 　安装所有文件。
- --allmatches 　删除符合指定的套件所包含的文件。
- --badreloc 　发生错误时，重新配置文件。
- --buildroot<根目录> 　设置产生套件时，欲当作根目录的目录。
- --changelog 　显示套件的更改记录。
- --checksig<套件档>+ 　检验该套件的签名认证。
- --clean 　完成套件的包装后，删除包装过程中所建立的目录。
- --dbpath<数据库目录> 　设置欲存放RPM数据库的目录。
- --dump 　显示每个文件的验证信息。本参数需配合"-l"参数使用。
- --excludedocs 　安装套件时，不要安装文件。
- --excludepath<排除目录> 　忽略在指定目录里的所有文件。
- --force 　强行置换套件或文件。
- --ftpproxy<主机名称或IP地址> 　指定FTP代理服务器。
- --ftpport<通信端口> 　设置FTP服务器或代理服务器使用的通信端口。
- --help 　在线帮助。
- --httpproxy<主机名称或IP地址> 　指定HTTP代理服务器。
- --httpport<通信端口> 　设置HTTP服务器或代理服务器使用的通信端口。
- --ignorearch 　不验证套件档的结构正确性。
- --ignoreos 　不验证套件档的结构正确性。
- --ignoresize 　安装前不检查磁盘空间是否足够。
- --includedocs 　安装套件时，一并安装文件。
- --initdb 　确认有正确的数据库可以使用。
- --justdb 　更新数据库，当不变动任何文件。
- --nobulid 　不执行任何完成阶段。
- --nodeps 　不验证套件档的相互关联性。
- --nofiles 　不验证文件的属性。
- --nogpg 　略过所有GPG的签名认证。
- --nomd5 　不使用MD5编码演算确认文件的大小与正确性。
- --nopgp 　略过所有PGP的签名认证。
- --noorder 　不重新编排套件的安装顺序，以便满足其彼此间的关联性。
- --noscripts 　不执行任何安装Script文件。
- --notriggers 　不执行该套件包装内的任何Script文件。
- --oldpackage 　升级成旧版本的套件。
- --percent 　安装套件时显示完成度百分比。
- --pipe<执行指令> 　建立管道，把输出结果转为该执行指令的输入数据。
- --prefix<目的目录> 　若重新配置文件，就把文件放到指定的目录下。
- --provides 　查询该套件所提供的兼容度。
- --queryformat<档头格式> 　设置档头的表示方式。
- --querytags 　列出可用于档头格式的标签。
- --rcfile<配置文件> 　使用指定的配置文件。
- --rebulid<套件档> 　安装原始代码套件，重新产生二进制文件的套件。
- --rebuliddb 　以现有的数据库为主，重建一份数据库。
- --recompile<套件档> 　此参数的效果和指定"--rebulid"参数类似，当不产生套件档。
- --relocate<原目录>=<新目录> 　把本来会放到原目录下的文件改放到新目录。
- --replacefiles 　强行置换文件。
- --replacepkgs 　强行置换套件。
- --requires 　查询该套件所需要的兼容度。
- --resing<套件档>+ 　删除现有认证，重新产生签名认证。
- --rmsource 　完成套件的包装后，删除原始代码。
- --rmsource<文件> 　删除原始代码和指定的文件。
- --root<根目录> 　设置欲当作根目录的目录。
- --scripts 　列出安装套件的Script的变量。
- --setperms 　设置文件的权限。
- --setugids 　设置文件的拥有者和所属群组。
- --short-circuit 　直接略过指定完成阶段的步骤。
- --sign 　产生PGP或GPG的签名认证。
- --target=<安装平台>+ 　设置产生的套件的安装平台。
- --test 　仅作测试，并不真的安装套件。
- --timecheck<检查秒数> 　设置检查时间的计时秒数。
- --triggeredby<套件档> 　查询该套件的包装者。
- --triggers 　展示套件档内的包装Script。
- --verify 　此参数的效果和指定"-q"参数相同。
- --version 　显示版本信息。
- --whatprovides<功能特性> 　查询该套件对指定的功能特性所提供的兼容度。
- --whatrequires<功能特性> 　查询该套件对指定的功能特性所需要的兼容度。

```
[root@master01 tmp]# wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
--2019-05-07 06:55:46--  https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
Resolving dl.fedoraproject.org (dl.fedoraproject.org)... 209.132.181.25, 209.132.181.23, 209.132.181.24
Connecting to dl.fedoraproject.org (dl.fedoraproject.org)|209.132.181.25|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 15080 (15K) [application/x-rpm]
Saving to: ‘epel-release-latest-7.noarch.rpm’

100%[===================================================================================================================================================>] 15,080      71.3KB/s   in 0.2s   

2019-05-07 06:55:52 (71.3 KB/s) - ‘epel-release-latest-7.noarch.rpm’ saved [15080/15080]

[root@master01 tmp]# rpm -ivh epel-release-latest-7.noarch.rpm 
warning: epel-release-latest-7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Preparing...                          ################################# [100%]
	package epel-release-7-11.noarch is already installed


查看rpm包信息
[root@master01 tmp]# rpm -qpi epel-release-latest-7.noarch.rpm 
warning: epel-release-latest-7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
Name        : epel-release
Version     : 7
Release     : 11
Architecture: noarch
Install Date: (not installed)
Group       : System Environment/Base
Size        : 24834
License     : GPLv2
Signature   : RSA/SHA256, Mon 02 Oct 2017 01:52:02 PM EDT, Key ID 6a2faea2352c64e5
Source RPM  : epel-release-7-11.src.rpm
Build Date  : Mon 02 Oct 2017 01:45:58 PM EDT
Build Host  : buildvm-ppc64le-05.ppc.fedoraproject.org
Relocations : (not relocatable)
Packager    : Fedora Project
Vendor      : Fedora Project
URL         : http://download.fedoraproject.org/pub/epel
Summary     : Extra Packages for Enterprise Linux repository configuration
Description :
This package contains the Extra Packages for Enterprise Linux (EPEL) repository
GPG key as well as configuration for yum.

查看rpm包内容
[root@master01 tmp]# rpm -qpl epel-release-latest-7.noarch.rpm 
warning: epel-release-latest-7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
/etc/yum.repos.d/epel-testing.repo
/etc/yum.repos.d/epel.repo
/usr/lib/systemd/system-preset/90-epel.preset
/usr/share/doc/epel-release-7
/usr/share/doc/epel-release-7/GPL

插卡rpm包依赖
[root@master01 tmp]# rpm -qpR epel-release-latest-7.noarch.rpm 
warning: epel-release-latest-7.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID 352c64e5: NOKEY
config(epel-release) = 7-11
redhat-release >= 7
rpmlib(CompressedFileNames) <= 3.0.4-1
rpmlib(FileDigests) <= 4.6.0-1
rpmlib(PayloadFilesHavePrefix) <= 4.0-1
rpmlib(PayloadIsXz) <= 5.2-1

查看系统是否安装指定rpm包
[root@master01 tmp]# rpm -qa lrzsz
lrzsz-0.12.20-36.el7.x86_64

卸载指定rpm包
[root@master01 tmp]# rpm -e lrzsz # 卸载
[root@master01 tmp]# rpm -qa lrzsz # 查看
[root@master01 tmp]# rz
-bash: rz: command not found

查看文件属于哪个rpm 包
[root@master01 tmp]# rpm -qf $(which ifconfig)
net-tools-2.0-0.24.20131004git.el7.x86_64

```



### 11.18 yum

&emsp;yum（ Yellow dog Updater, Modified）是一个在Fedora和RedHat以及SUSE中的Shell前端软件包管理器。基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装。

**语法**

```
yum [options] [command] [package ...]
```

- **options：**可选选项包括-h[帮助]，-y[当安装过程提示选择全部为"yes"]，-q[不显示安装的过程]等等。
- **command：**要进行的操作。
- **package**操作的对象。

**常用命令**

- 1.列出所有可更新的软件清单命令：yum check-update
- 2.更新所有软件命令：yum update
- 3.仅安装指定的软件命令：yum install <package_name>
- 4.仅更新指定的软件命令：yum update <package_name>
- 5.列出所有可安裝的软件清单命令：yum list
- 6.删除软件包命令：yum remove <package_name>
- 7.查找软件包 命令：yum search <keyword>
- 8.安装本地rpm包:  yum localinstall <package.rpm>
- 9.获取软件包信息: yum info <package>
- 10 .清除缓存命令:
  - yum clean packages: 清除缓存目录下的软件包
  - yum clean headers: 清除缓存目录下的 headers
  - yum clean oldheaders: 清除缓存目录下旧的 headers
  - yum clean, yum clean all (= yum clean packages; yum clean oldheaders) :清除缓存目录下的软件包及旧的headers

```
安装
[root@master01 ~]# yum install pam-devel
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.163.com
 * epel: mirrors.yun-idc.com
 * extras: mirrors.cn99.com
 * updates: mirrors.163.com
Resolving Dependencies
--> Running transaction check
---> Package pam-devel.x86_64 0:1.1.8-22.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================================================================================
 Package                                       Arch                                       Version                                             Repository                                Size
=============================================================================================================================================================================================
Installing:
 pam-devel                                     x86_64                                     1.1.8-22.el7                                        base                                     184 k

Transaction Summary
=============================================================================================================================================================================================
Install  1 Package

Total download size: 184 k
Installed size: 528 k
Is this ok [y/d/N]: y
Downloading packages:
pam-devel-1.1.8-22.el7.x86_64.rpm                                                                                                                                     | 184 kB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : pam-devel-1.1.8-22.el7.x86_64                                                                                                                                             1/1 
  Verifying  : pam-devel-1.1.8-22.el7.x86_64                                                                                                                                             1/1 

Installed:
  pam-devel.x86_64 0:1.1.8-22.el7                                                                                                                                                            

Complete!

卸载
[root@master01 ~]# yum remove pam-devel
Loaded plugins: fastestmirror
Resolving Dependencies
--> Running transaction check
---> Package pam-devel.x86_64 0:1.1.8-22.el7 will be erased
--> Finished Dependency Resolution

Dependencies Resolved

=============================================================================================================================================================================================
 Package                                       Arch                                       Version                                            Repository                                 Size
=============================================================================================================================================================================================
Removing:
 pam-devel                                     x86_64                                     1.1.8-22.el7                                       @base                                     528 k

Transaction Summary
=============================================================================================================================================================================================
Remove  1 Package

Installed size: 528 k
Is this ok [y/N]: y
Downloading packages:
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Erasing    : pam-devel-1.1.8-22.el7.x86_64                                                                                                                                             1/1 
  Verifying  : pam-devel-1.1.8-22.el7.x86_64                                                                                                                                             1/1 

Removed:
  pam-devel.x86_64 0:1.1.8-22.el7                                                                                                                                                            

Complete!

找到的文件包含ng
[root@master01 ~]# yum list ng*
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.163.com
 * epel: mirrors.yun-idc.com
 * extras: mirrors.cn99.com
 * updates: mirrors.163.com
Available Packages
nghttp2.x86_64                                                                                1.31.1-1.el7                                                                               epel
nginx.x86_64                                                                                  1:1.12.2-2.el7                                                                             epel
nginx-all-modules.noarch                                                                      1:1.12.2-2.el7                                                                             epel
nginx-filesystem.noarch                                                                       1:1.12.2-2.el7                                                                             epel
nginx-mod-http-geoip.x86_64                                                                   1:1.12.2-2.el7                                                                             epel
nginx-mod-http-image-filter.x86_64                                                            1:1.12.2-2.el7                                                                             epel
nginx-mod-http-perl.x86_64                                                                    1:1.12.2-2.el7                                                                             epel
nginx-mod-http-xslt-filter.x86_64                                                             1:1.12.2-2.el7                                                                             epel
nginx-mod-mail.x86_64                                                                         1:1.12.2-2.el7                                                                             epel
nginx-mod-stream.x86_64                                                                       1:1.12.2-2.el7                                                                             epel
ngircd.x86_64                                                                                 23-1.el7                                                                                   epel
ngrep.x86_64                                                                                  1.47-1.1.20180101git9b59468.el7                                                            epel

查看yum安装某软件的详细信息
[root@master01 ~]# yum info nginx
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.163.com
 * epel: mirrors.yun-idc.com
 * extras: mirrors.cn99.com
 * updates: mirrors.163.com
Available Packages
Name        : nginx
Arch        : x86_64
Epoch       : 1
Version     : 1.12.2
Release     : 2.el7
Size        : 530 k
Repo        : epel/x86_64
Summary     : A high performance web server and reverse proxy server
URL         : http://nginx.org/
License     : BSD
Description : Nginx is a web server and a reverse proxy server for HTTP, SMTP, POP3 and
            : IMAP protocols, with a strong focus on high concurrency, performance and low
            : memory usage.
```

&emsp;更换`yum`源,网易（163）yum源是国内最好的yum源之一 ，无论是速度还是软件版本，都非常的不错。

将yum源设置为163 yum，可以提升软件包安装和更新的速度，同时避免一些常见软件版本无法找到。

```
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS6-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
```

centos5,6,7对应的yum源

```
CentOS5 ：http://mirrors.163.com/.help/CentOS5-Base-163.repo
CentOS6 ：http://mirrors.163.com/.help/CentOS6-Base-163.repo
CentOS7 ：http://mirrors.163.com/.help/CentOS7-Base-163.repo
```

运行以下命令生成缓存

```
yum clean all
yum makecache
```

除了网易之外，国内还有其他不错的 yum 源，比如中科大和搜狐,阿里源。

```
中科大的 yum 源安装方法查看：https://lug.ustc.edu.cn/wiki/mirrors/help/centos
sohu 的 yum 源安装方法查看: http://mirrors.sohu.com/help/centos.html
阿里yum源
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```



### 11.19 lspci

&emsp;查询pci设备详细信息，

语法

```
lspci [选项]
```

**参数说明**：

- -v 显示详细信息
- -vv 显示更详细信息
- -s 显示指定总线信息

```
root@leco:~# lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation H61 Express Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
01:00.0 VGA compatible controller: NVIDIA Corporation GF119 [GeForce GT 620 OEM] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GF119 HDMI Audio Controller (rev a1)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0b)
```



### 11.02 lscpu

&emsp;查看cpu详细信息

```
root@leco:~#  lscpu
Architecture:          x86_64
CPU 运行模式：    32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                4
On-line CPU(s) list:   0-3
每个核的线程数：1
每个座的核数：  4
Socket(s):             1
NUMA 节点：         1
厂商 ID：           GenuineIntel
CPU 系列：          6
型号：              58
Model name:            Intel(R) Core(TM) i5-3350P CPU @ 3.10GHz
步进：              9
CPU MHz：             1647.663
CPU max MHz:           3300.0000
CPU min MHz:           1600.0000
BogoMIPS:              6186.27
虚拟化：           VT-x
L1d 缓存：          32K
L1i 缓存：          32K
L2 缓存：           256K
L3 缓存：           6144K
NUMA node0 CPU(s):     0-3
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant
_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer xsave avx f16c rdrand lahf_lm cpuid_fault epb pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid fsgsbase smep erms xsaveopt dtherm ida arat pln pts flush_l1d
```

```
lspci -v
lspci -vv
```

显示单一信息

```
root@leco:~# lspci 
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation H61 Express Chipset Family LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
01:00.0 VGA compatible controller: NVIDIA Corporation GF119 [GeForce GT 620 OEM] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GF119 HDMI Audio Controller (rev a1)
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0b)
root@leco:~# lspci -s 01:00.1
01:00.1 Audio device: NVIDIA Corporation GF119 HDMI Audio Controller (rev a1)
root@leco:~# lspci -s 00:1f.2  # 设备编号，根据lspci输出，第一列就是设备编号
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller (rev 05)
root@leco:~# lspci -s 00:1f.2 -v
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
	DeviceName:  Onboard Intel SATA Controller
	Subsystem: Acer Incorporated [ALI] 6 Series/C200 Series Chipset Family SATA AHCI Controller
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 28
	I/O ports at f070 [size=8]
	I/O ports at f060 [size=4]
	I/O ports at f050 [size=8]
	I/O ports at f040 [size=4]
	I/O ports at f020 [size=32]
	Memory at f7206000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci
	Kernel modules: ahci
```



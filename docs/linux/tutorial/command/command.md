<center><h1>Linux命令</h1></center>

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

  ```linux
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

  ```
  
  ```

  

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

### 3.4 less

### 3.5 head

### 3.6 tail

### 3.7 tailf

### 3.8 cut

### 3.9 split

### 3.10 paste

### 3.11 sort

### 3.12 join

### 3.13 uniq

### 3.14 wc

### 3.15 iconv

### 3.16 dos2uinx

### 3.17 diff

### 3.18 vimdiff

### 3.19 rev

### 3.20 tr

### 3.21 od

### 3.22 tee

### 3.23 vi vim

### 4. 三剑客

### 4.1 grep

### 4.2 sed

### 4.3 awk

## 5. 系统显示

###  5.1 uname

### 5.2 hostname

### 5.3 dmesg

### 5.4 stat

### 5.5 du

### 5.6 date

### 5.7 echo

### 5.8 watch

### 5.9 which

### 5.10 whereis

### 5.11 locate

### 5.12 updatedb

##  6. 文件压缩和解压

### 6.1 tar

### 6.2 gzip

### 6.3 zip

### 6.4 unzip

### 6.5 scp

### 6.6 rsync

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

### 11.2 uptime

### 11.3 free

### 11.4 iftop

### 11.5 vmstat

### 11.6 mpstat

### 11.7 iostat

### 11.8  iotop

### 11.9 sar

### 11.10 chkconfig

### 11.11 ntsysv

### 11.12 setup

### 11.13 ethool

### 11.14 mill-tool

### 11.15 dmidecode

### 11.16 ipcs

### 11.17 ipcrm

### 11.18 rpm

### 11.19 yum

### 11.20 lspci

### 11.21 lscpu



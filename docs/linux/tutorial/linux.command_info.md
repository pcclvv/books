<center><h1>Linux命令介绍</h1></center>
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


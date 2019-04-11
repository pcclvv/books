<center><h1> sshpass</h1></center>

## 1. 起因
&#160; &#160; &#160; 在某云平台创建云服务器后，生成了巨长、巨复杂的一串密码，在输入几十次密码后，依然是密码错误。这时候就想如果密码是非交互式输入，可以将密码做为参数或从文件输入就太好了。sshpass就是一款密码输入辅助工具，它可以从命令行明文参数、文件或环境变量中指定密码，从而避免交互式密码输入。

## 2. 部署
### 2.1 在线装

```
# ubuntu 
root@leco:~# apt-get install sshpass -y
# centos
root@leco:~# yum install sshpass -y
# mac
brew install sshpass
```

### 2.2 离线安装

​	若是没有网络的机器，可以选择离线安装。`https://sourceforge.net/projects/sshpass/`

下载后解码压，然后进入源码目录：

```
tar -zxvf sshpass-1.06.tar.gz
cd sshpass-1.06
./configure
make &&make install
```

详细操作

```
[root@207_syslog src]# ls
sshpass_1.06.orig.tar.gz
[root@207_syslog src]# tar xf sshpass_1.06.orig.tar.gz
[root@207_syslog src]# ls
sshpass-1.06  sshpass_1.06.orig.tar.gz
[root@207_syslog src]# cd sshpass-1.06/
[root@207_syslog sshpass-1.06]# ls
aclocal.m4  compile      configure.ac  INSTALL     Makefile.am  NEWS
AUTHORS     config.h.in  COPYING       install-sh  Makefile.in  README
ChangeLog   configure    depcomp       main.c      missing      sshpass.1
[root@207_syslog sshpass-1.06]# ./configure
[root@207_syslog sshpass-1.06]# make && make install
```


## 3. 基本参数
 &#160; &#160; sshpass参数

```
root@leco:~# sshpass
Usage: sshpass [-f|-d|-p|-e] [-hV] command parameters
   -f filename   Take password to use from file
   -d number     Use number as file descriptor for getting password
   -p password   Provide password as argument (security unwise)
   -e            Password is passed as env-var "SSHPASS"
   With no parameters - password will be taken from stdin

   -h            Show help (this screen)
   -V            Print version information
At most one of -f, -d, -p or -e should be used
```

 &#160; &#160; 如上所示，command parameters为你要执行的需要交互式输入密码的命令，如：ssh、scp等。当sshpass没有指定参数时会从stdin获取密码，几个密码输入相关参数如下：

```
-f filename：从文件中获取密码
-d number：  使用数字作为获取密码的文件描述符
-p password：指定明文本密码输入（安全性较差）
-e：         从环境变量SSHPASS获取密码
```

## 4. 基本使用

### 4.1 文件方式

```
[root@207_syslog ~]# sshpass echo "cmz" > user.passwd
[root@207_syslog ~]# sshpass -f user.passwd ssh root@172.17.9.200
Last login: Wed Dec  7 10:40:13 2016 from 172.17.9.206
```

### 4.2 环境变量方式

```
[root@207_syslog sshpass-1.06]#  export SSHPASS="cmz"
[root@207_syslog sshpass-1.06]# sshpass -e ssh root@172.17.9.200
Last login: Wed Dec  7 11:02:34 2016 from 172.17.9.207
```

### 4.3 密码方式

```
[root@207_syslog sshpass-1.06]# sshpass -p cmz ssh root@172.17.9.200
Last login: Wed Dec  7 11:00:12 2016 from 172.17.9.206
```

### 4.4 远程执行命令

```shell
[root@207_syslog sshpass-1.06]# sshpass -p cmz ssh root@172.17.9.200 "ifconfig|grep inet"
    inet 172.17.9.200  netmask 255.255.255.192  broadcast 172.17.9.255
    inet6 fe80::250:56ff:feb0:710e  prefixlen 64  scopeid 0x20<link>
    inet 127.0.0.1  netmask 255.0.0.0
    inet6 ::1  prefixlen 128  scopeid 0x10<host>
    inet 172.17.9.208  netmask 255.255.255.255
    inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
```

### 4.5 远程执行脚本

### 4.5.1 远程新建脚本

```
[root@200_tomcat ~]# ll /opt/test.sh
-rw-r--r--. 1 root root 61 Dec  7 11:18 /opt/test.sh
[root@200_tomcat ~]# cat /opt/test.sh
#!/bin/bash
echo "this test for remote"
ifconfig | grep inet
```

### 4.5.2 本地远程执行

```
[root@207_syslog sshpass-1.06]# sshpass -p cmz ssh root@172.17.9.200 "sh /opt/test.sh"
this test for remote
inet 172.17.9.200  netmask 255.255.255.192  broadcast 172.17.9.255
inet6 fe80::250:56ff:feb0:710e  prefixlen 64  scopeid 0x20<link>
inet 127.0.0.1  netmask 255.0.0.0
inet6 ::1  prefixlen 128  scopeid 0x10<host>
inet 172.17.9.208  netmask 255.255.255.255
inet 192.168.122.1  netmask 255.255.255.0  broadcast 192.168.122.255
```

此时说明，已经执行了远端程序。

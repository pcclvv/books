# Sersync数据同步
## 一.rsync介绍
rsync是类unix系统下的数据镜像备份工具——remote sync。一款快速增量备份工具 Remote Sync，远程同步支持本地复制，或者与其他SSH、rsync主机同步。

它的特性如下：
- 可以镜像保存整个目录树和文件系统。
- 可以很容易做到保持原来文件的权限、时间、软硬链接等等。
- 无须特殊权限即可安装。
- 快速：第一次同步时 rsync 会复制全部内容，但在下一次只传输修改过的文件。rsync 在传输数据的过程中可以实行压缩及解压缩操作，因此可以使用更少的带宽。
- 安全：可以使用scp、ssh等方式来传输文件，当然也可以通过直接的socket连接。
- 支持匿名传输，以方便进行网站镜象。


|IP | 角色  |  安装软件 | 目录 | 目的
|---|---|---|---|---
|192.168.91.166 | Rsync 服务端 | rsync |  /data	| 将192.168.91.156 rsync 客户端上的/data下目录实时推送到192.168.91.166 rsync服务器端/data下
|192.168.91.156 | Rsync 客户端 | serync|  /data  | 


## 二.rsync的安装

```
yum install -y rsync
```

## 三.rsync通过ssh认证传输
### 3.1将数据发送到远端

```
rsync -avz -P 本地目录 -e 'ssh -p 端口号'
```
> 远端用户名@远端IP:远端路径

```
root@template /tmp 16:33:07 # cat rsync.txt
我是rsync测试
root@template /tmp 16:34:02 # rsync -avzP /tmp/rsync.txt -e 'ssh -p 22' root@192.168.44.100:/tmp
The authenticity of host '192.168.44.100(192.168.44.100)' can't be established.
RSA key fingerprint is57:22:33:d6:43:40:31:84:88:19:5d:f5:fc:7d:4e:ce.
Are you sure you want to continue connecting(yes/no)? yes
Warning: Permanently added '192.168.44.100' (RSA) tothe list of known hosts.
reverse mapping checking getaddrinfo for bogon[192.168.44.100] failed - POSSIBLE BREAK-IN ATTEMPT!
root@192.168.44.100's password:
sending incremental file list
rsync.txt
          18100%    0.00kB/s    0:00:00 (xfer#1, to-check=0/1)
 
sent 93 bytes received 31 bytes  13.05 bytes/sec
total size is 18 speedup is 0.15
```

> 详细参数：

```
-v, --verbose 详细模式输出
-q, --quiet 精简输出模式
-c, --checksum 打开校验开关，强制对文件传输进行校验
-a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
-r, --recursive 对子目录以递归模式处理
-R, --relative 使用相对路径信息
-b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
--backup-dir 将备份文件(如~filename)存放在在目录下。
-suffix=SUFFIX 定义备份文件前缀
-u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
-l, --links 保留软链结
-L, --copy-links 想对待常规文件一样处理软链结
--copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结
--safe-links 忽略指向SRC路径目录树以外的链结
-H, --hard-links 保留硬链结
-p, --perms 保持文件权限
-o, --owner 保持文件属主信息
-g, --group 保持文件属组信息
-D, --devices 保持设备文件信息
-t, --times 保持文件时间信息
-S, --sparse 对稀疏文件进行特殊处理以节省DST的空间
-n, --dry-run现实哪些文件将被传输
-W, --whole-file 拷贝文件，不进行增量检测
-x, --one-file-system 不要跨越文件系统边界
-B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节
-e, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步
--rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息
-C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件
--existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件
--delete 删除那些DST中SRC没有的文件
--delete-excluded 同样删除接收端那些被该选项指定排除的文件
--delete-after 传输结束以后再删除
--ignore-errors 及时出现IO错误也进行删除
--max-delete=NUM 最多删除NUM个文件
--partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输
--force 强制删除目录，即使不为空
--numeric-ids 不将数字的用户和组ID匹配为用户名和组名
--timeout=TIME IP超时时间，单位为秒
-I, --ignore-times 不跳过那些有同样的时间和长度的文件
--size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间
--modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0
-T --temp-dir=DIR 在DIR中创建临时文件
--compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份
-P 等同于 --partial
--progress 显示备份过程
-z, --compress 对备份的文件在传输时进行压缩处理
--exclude=PATTERN 指定排除不需要传输的文件模式
--include=PATTERN 指定不排除而需要传输的文件模式
--exclude-from=FILE 排除FILE中指定模式的文件
--include-from=FILE 不排除FILE指定模式匹配的文件
--version 打印版本信息
--address 绑定到特定的地址
--config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件
--port=PORT 指定其他的rsync服务端口
--blocking-io 对远程shell使用阻塞IO
-stats 给出某些文件的传输状态
--progress 在传输时现实传输过程
--log-format=formAT 指定日志文件格式
--password-file=FILE 从FILE中得到密码
--bwlimit=KBPS 限制I/O带宽，KBytes per second
-h, --help 显示帮助信息
```

### 3.2从远端拉取数据

```
rsync -avz -P -e 'ssh -p 端口号' 远端用户名@远端IP:远端路径 本地目录
root@template /tmp 16:34:19 # rsync -avzP  -e 'ssh -p 22'root@192.168.44.100:/tmp/rsync.txt /tmp
reverse mapping checking getaddrinfo for bogon[192.168.44.100] failed - POSSIBLE BREAK-IN ATTEMPT!
root@192.168.44.100's password:
receiving incremental file list
rsync.txt
          19100%   18.55kB/s    0:00:00 (xfer#1, to-check=0/1)
 
sent 36 bytes received 99 bytes  30.00 bytes/sec
total size is 19 speedup is 0.14
root@template /tmp 16:39:26 # cat rsync.txt
我是rsync测试2
```

## 四.通过rsync认证传输
### 4.1备份服务器配置
  也就是服务器端192.168.91.166
####  4.1.1创建rsync同步用户

```
[root@salt-master data]# useradd -M -s /sbin/nologin rsync
```

#### 4.1.2修改配置文件
（vim /etc/rsyncd.conf）

```
[root@salt-master data]# cat /etc/rsyncd.conf
#config_______________start
##rsyncd.conf start##
uid = root                      #此时用户可以是别的，但是只要有管理服务端下/data的权限即可,不一定非得要用root
gid = root
use chroot = no                  #内网设置为no
max connections = 200            #最大连接数默认为0无限大，负数为关闭
timeout = 300                   #超时默认为0 notimeout无超时时间 建议200-600（5-10分钟）
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
[data]                                     #新建的模块名
comment = datafile by caimengzhi at 2016-11-10  #注释部分
path = /data/                               #默认上传和下载的路径
ignore errors                               #忽略错误
read only = false                             #禁止只读可写
list = false                                  #禁止列表
hosts allow = 192.168.91.0/24                  #指定可以连接的客户端ip或地址段
hosts deny = 0.0.0.0/32                       #指定不可以连接的ip或地址段
auth users = rsync_body                      #客户端同步的虚拟用户
secrets file = /etc/rsync.password               #客户端同步的虚拟机用户的密码

快速
cat >>/etc/rsyncd.conf<<EOF
#config_______________start
##rsyncd.conf start##
uid = root
gid = root
use chroot = no
max connections = 200
timeout = 300
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
[data]
comment = datafile by caimengzhi at 2016-11-10
path = /data/
ignore errors
read only = false
list = false
hosts allow = 192.168.91.0/24
hosts deny = 0.0.0.0/32
auth users = rsync_body
secrets file = /etc/rsync.password
EOF
```

#### 4.1.3添加密码文件

```
[root@salt-master data]# echo 'rsync_body:admin' >> /etc/rsync.password   #添加账户和密码，前面是同步时候的虚拟账号和密码
[root@salt-master data]# cat /etc/rsync.password
rsync_body:admin
[root@salt-master data]# chmod 600  /etc/rsync.password
4.1.4启动服务
[root@salt-master data]# rsync --daemon       #rsync服务端以守护进程方式启动，且端口是tcp协议的873
[root@salt-master data]#  ps -ef | grep rsync |grep -v grep 
root       7247      1  0 17:21 ?        00:00:00 rsync --daemon
[root@salt-master data]# netstat -lnp| grep  873
tcp        0      0 0.0.0.0:873                 0.0.0.0:*                   LISTEN      7247/rsync
tcp        0      0 :::873                      :::*                        LISTEN      7247/rsync            
[root@salt-master data]# lsof -i:873
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
rsync   7247 root    4u  IPv4  67065      0t0  TCP *:rsync (LISTEN)
rsync   7247 root    5u  IPv6  67066      0t0  TCP *:rsync (LISTEN)
```

### 4.2源数据服务器配置也就是客户端192.168.91.156
#### 4.2.1配置密码文件
```
[root@salt-client01 sersync]# echo "admin">/etc/rsync.password   #客户端只需要配置密码文件即可，因为在同步的时候会指定虚拟同步账号
[root@salt-client01 sersync]# cat /etc/rsync.password
admin
[root@salt-client01 sersync]# chmod 600 /etc/rsync.password
[root@salt-client01 sersync]# ll /etc/rsync.password
-rw------- 1 root root 6 Nov 10 17:26 /etc/rsync.password
```

#### 4.2.2向备份服务器发送数据
> rsync -avz -P 本地目录或文件 rsync_backup@服务端地址::模块名--password-file=/etc/rsync.pwd

```
[root@salt-client01 sersync]# rsync -avz /data rsync_body@192.168.91.166::data --password-file=/etc/rsync.password
sending incremental file list
data/
data/3

sent 88 bytes  received 31 bytes  238.00 bytes/sec
total size is 0  speedup is 0.00
```
> #说明rsync 服务端和客户端是OK的

### 4.2.3从备份服务器拉取

```
rsync -avz -P rsync_backup@服务端地址::模块名 本地目录或文件--password-file=/etc/rsync.pwd
```

## 五.sersync的简单原理
采用inotify来对文件进行监控，当监控到文件有文件发生改变的时候，就会调用rsync实现触发式实时同步！
### 5.1安装sersync
> （注意sersync是工作在rsync的源服务器上，也就是客户端上）

```
[root@salt-client01 ~]# cd /usr/local/src/
[root@salt-client01 src]# tar -zxvf sersync2.5.4_64bit_binary_stable_final.tar.gz  -C /usr/local/
GNU-Linux-x86/
GNU-Linux-x86/sersync2
GNU-Linux-x86/confxml.xml
[root@salt-client01 src]# cd /usr/local/
[root@salt-client01 local]# mv GNU-Linux-x86 sersync
[root@salt-client01 local]# cd sersync/
[root@salt-client01 sersync]# mkdir conf bin log
[root@salt-client01sersync]# mv confxml.xml conf
[root@salt-client01sersync]# mv sersync2 bin/sersync
```

### 5.2修改配置文件

```
***********************************30行开始******************************
   <commonParams params="-artuz"/>  #-artuz为rsync同步时的参数
    <authstart="true" users="rsync的虚拟用户名(rsync_backup)" passwordfile="rsync的密码文件"/>
   <userDefinedPort start="true"port="873"/><!-- port=874 -->
   <timeout start="false" time="100"/><!--timeout=100 -->
    <sshstart="false"/>
       ************************************第36行***********************************
       <failLogpath="自己定义的log文件夹(/usr/local/sersync/log)rsync_fail_log.sh"
       timeToExecute="60"/><!--defaultevery 60mins execute once-->
       *******************************************************************************
       *注：若有多个目录备份可以穿件多个配置文件在启动时的-o参数中添加即可

[root@salt-client01 conf]# diff confxml.xml confxml.xml.bak
24,25c24,25
< 	<localpath watch="/data/">                          #data就是本地需要同步的文件夹到服务器端的目录
< 	    <remote ip="192.168.91.166" name="data"/>       #data (server的模块名)是rsync 服务端的文件夹，也就是推送到服务器端的目标文件夹，可以配置多个，
---
> 	<localpath watch="/opt/tongbu">
> 	    <remote ip="127.0.0.1" name="tongbu1"/>
31c31
< 	    <auth start="true" users="rsync_body" passwordfile="/etc/rsync.password"/>   #true 才能生效，rsync_body同步时候虚拟账号，后面是密码文件
---
> 	    <auth start="false" users="root" passwordfile="/etc/rsync.pas"/>
33c33
< 	    <timeout start="true" time="100"/><!-- timeout=100 -->                    #true 才能生效
---
> 	    <timeout start="false" time="100"/><!-- timeout=100 -->
36c36
< 	<failLog path="/usr/local/sersync/log/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->  #检测rsync进程判断，没有自动启
---
> 	<failLog path="/tmp/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->
```

### 5.3启动sersync

```
[root@salt-client01 src]# echo 'export PATH=$PATH:/usr/local/sersync/bin'>>/etc/profile #声明环境变量
[root@salt-client01 src]# source /etc/profile
[root@salt-client01 src]# sersync2 -r -d -o /usr/local/sersync/conf/confxml.xml  #启动
set the system param
execute：echo 50000000 > /proc/sys/fs/inotify/max_user_watches
execute：echo 327679 > /proc/sys/fs/inotify/max_queued_events
parse the command param
option: -r 	rsync all the local files to the remote servers before the sersync work
option: -d 	run as a daemon
option: -o 	config xml name：  /usr/local/sersync/conf/confxml.xml
daemon thread num: 10
parse xml config file
host ip : localhost	host port: 8008
daemon start，sersync run behind the console
use rsync password-file :
user is	rsync_body
passwordfile is 	/etc/rsync.password
config xml parse success
please set /etc/rsyncd.conf max connections=0 Manually
sersync working thread 12  = 1(primary thread) + 1(fail retry thread) + 10(daemon sub threads)
Max threads numbers is: 22 = 12(Thread pool nums) + 10(Sub threads)
please according your cpu ，use -n param to adjust the cpu rate
------------------------------------------
rsync the directory recursivly to the remote servers once
working please wait...
execute command: cd /data && rsync -artuz -R --delete ./  --timeout=100 rsync_body@192.168.91.166::data --password-file=/etc/rsync.password >/dev/null 2>&1
run the sersync:
watch path is: /data  #此时可以看出sersync已经启动成功了
```

- 检测脚本

```
[root@salt-client01 log]# pwd
/usr/local/sersync/log
[root@salt-client01 log]# vim rsync_fail_log.sh
[root@salt-client01 log]# chmod +x rsync_fail_log.sh
[root@salt-client01 ~]# cat /usr/local/sersync/log/rsync_fail_log.sh
#!/bin/bash
#Purpose: Check sersync whether it is alive
#Author: cai meng zhi
SERSYNC="/usr/local/sersync/bin/sersync2"
CONF_FILE="/usr/local/sersync/conf/confxml.xml"
STATUS=$(ps aux |grep 'sersync2'|grep -v 'grep'|wc -l)
if [ $STATUS -eq 0 ];
then
        $SERSYNC -d -r -o $CONF_FILE &
else
        exit 0;
fi
脚本写好以后，添加到计划任务中去
*/1 * * * * /bin/bash /usr/local/sersync/log/rsync_fail_log.sh  > /dev/null 2>&1
```


- 测试同步：

```
客户端新增文件
[root@salt-client01 data]# cp /etc/passwd 192.168.91.156.passwd
[root@salt-client01 data]# ll
total 4
-rw-r--r-- 1 root root 1928 Nov 10 18:15 192.168.91.156.passwd
-rw-r--r-- 1 root root    0 Nov 10 17:27 3
服务端检测
[root@salt-master data]# cd /data/
[root@salt-master data]# ll
total 8
-rw-r--r-- 1 root root 1928 Nov 10 18:15 192.168.91.156.passwd  #说明已经同步过来了
-rw-r--r-- 1 root root    0 Nov 10 17:27 3
drwxr-xr-x 2 root root 4096 Nov 10 17:27 data
```


- 客户端测试删除

```
[root@salt-client01 data]# rm rf 192.168.91.156.passwd 
rm: cannot remove `rf': No such file or directory
rm: remove regular file `192.168.91.156.passwd'? y
[root@salt-client01 data]# ll
total 0
-rw-r--r-- 1 root root 0 Nov 10 17:27 3
[root@salt-client01 data]#

服务器端：
[root@salt-master data]# ll
total 4
-rw-r--r-- 1 root root    0 Nov 10 17:27 3   #说明已经删除掉了
drwxr-xr-x 2 root root 4096 Nov 10 17:27 data
```

### 5.4常见错误汇总

```
错误一：
@ERROR: auth failed on module xxxxx
rsync: connection unexpectedly closed(90 bytes read so far)
rsync error: error in rsync protocoldata stream (code 12) at io.c(150)
说明：这是因为密码设置错了，无法登入成功，检查一下rsync.pwd，看客服是否匹配。还有服务器端没启动rsync 服务也会出现这种情况。
 
错误二：
password file must not beother-accessible
continuing without password file
Password:
说明：这是因为rsyncd.pwdrsyncd.sec的权限不对，应该设置为600。如：chmod600 rsyncd.pwd
 
错误三：
@ERROR: chroot failed
rsync: connection unexpectedly closed(75 bytes read so far)
rsync error: error in rsync protocoldata stream (code 12) at io.c(150)
说明：这是因为你在 rsync.conf中设置的 path 路径不存在，要新建目录才能开启同步
 
错误四：
rsync: failed to connect to218.107.243.2: No route to host (113)
rsync error: error in socket IO (code10) at clientserver.c(104) [receiver=2.6.9]
说明：防火墙问题导致，这个最好先彻底关闭防火墙，排错的基本法就是这样，无论是S还是C，还有ignore errors选项问题也会导致
 
错误五：
@ERROR: access denied to www fromunknown (192.168.1.123)
rsync: connection unexpectedly closed(0 bytes received so far) [receiver]
rsync error: error in rsync protocoldata stream (code 12) at io.c(359)
说明：此问题很明显，是配置选项hostallow的问题，初学者喜欢一个允许段做成一个配置，然后模块又是同一个，致使导致
 
错误六：
rsync error: received SIGINT,SIGTERM, or SIGHUP (code 20) at rsync.c(244) [generator=2.6.9]
rsync error: received SIGUSR1 (code19) at main.c(1182) [receiver=2.6.9]
说明：导致此问题多半是服务端服务没有被正常启动，到服务器上去查查服务是否有启动，然后查看下 /var/run/rsync.pid 文件是否存在，最干脆的方法是杀死已经启动了服务，然后再次启动服务或者让脚本加入系统启动服务级别然后shutdown -r now服务器

错误七：
rsync: read error: Connection resetby peer (104)
rsync error: error in rsync protocoldata stream (code 12) at io.c(604) [sender=2.6.9]
说明：原数据目录里没有数据存在
```


## 六.资料

[参考资料](https://www.samba.org/ftp/rsync/rsyncd.conf.html)

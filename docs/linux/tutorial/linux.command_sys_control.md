<center><h1>Linux命令 系统管理</h1></center>
> 作者: caimengzhi

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

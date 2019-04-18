<center><h1>Centos7 优化</h1></center>


## 1. 介绍
&#160; &#160; &#160; &#160;为了更好的使用linux。基本的优化我们还是需要做的。
```
sed -i 's@SELINUX=enforcing@SELINUX=disabled@g' /etc/selinux/config 
setenforce 0
systemctl disable firewalld  # 开机不自启防火墙
systemctl stop firewalld     # 关闭防火墙

yum install -y ntp
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "*/5 * * * *  /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root

cat>>/etc/security/limits.conf<<EOF
* soft nofile 65535
* hard nofile 65535
EOF
echo "ulimit -SHn 65535">>/etc/rc.local
ulimit -SHn 65535

# 网卡开机自启动
sed -i 's@ONBOOT=no@ONBOOT=yes@g' /etc/sysconfig/network-scripts/ifcfg-ens33

# 禁止ssh反向解析
sed -i 's@UseDNS yes@UseDNS no@' /etc/ssh/sshd_config /etc/ssh/sshd_config
# # 禁止空密码登录
sed -i 's@PermitEmptyPasswords no@PermitEmptyPasswords no@' /etc/ssh/sshd_config

yum install -y bash-completion 
yum install gcc cmake bzip2-devel curl-devel db4-devel libjpeg-devel libpng-devel freetype-devel libXpm-devel gmp-devel libc-client-devel openldap-devel unixODBC-devel postgresql-devel sqlite-devel aspell-devel net-snmp-devel libxslt-devel libxml2-devel pcre-devel mysql-devel pspell-devel libmemcached libmemcached-devel zlib-devel  vim wget   lrzsz  tree
yum -y install epel-release
sudo systemctl set-default multi-user.target  # 设置非图形模式为默认模式
cat >> /etc/resolv.conf << EOF
nameserver 114.114.114.114
EOF
cat >> /etc/sysctl.conf << EOF
vm.overcommit_memory = 1
net.ipv4.ip_local_port_range = 1024 65536
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_abort_on_overflow = 0
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.ipv4.netfilter.ip_conntrack_max = 2097152
net.nf_conntrack_max = 655360
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
EOF
/sbin/sysctl -p
```
## 2. 优化
### 2.1  禁用SELINUX

```
sed -i 's@SELINUX=enforcing@SELINUX=disabled@g' /etc/selinux/config 
setenforce 0
```
详细操作如下:

```
[root@localhost ~]# sed -i 's@SELINUX=enforcing@SELINUX=disabled@g' /etc/selinux
/config [root@localhost ~]# setenforce 0
[root@localhost ~]# grep -wi ^selinux /etc/selinux/config
SELINUX=disabled
```

### 2.2 关闭防火墙

```
systemctl disable firewalld  # 开机不自启防火墙
systemctl stop firewalld     # 关闭防火墙
```
详细操作如下：

```
[root@localhost ~]# systemctl disable firewalld
[root@localhost ~]# systemctl stop firewalld
[root@localhost ~]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor p
reset: enabled)   Active: inactive (dead)
     Docs: man:firewalld(1)

Apr 13 09:59:26 localhost.localdomain systemd[1]: Starting firewalld - dynami...
Apr 13 09:59:26 localhost.localdomain systemd[1]: Started firewalld - dynamic...
Apr 13 04:45:19 localhost.localdomain systemd[1]: Stopping firewalld - dynami...
Apr 13 04:45:20 localhost.localdomain systemd[1]: Stopped firewalld - dynamic...
Hint: Some lines were ellipsized, use -l to show in full.
```

### 2.3 时间矫正

```
yum install -y ntp
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
crontab -e
// 加入一行
*/5 * * * * /usr/sbin/ntpdate ntp.api.bz

# echo "*/5 * * * *  /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root
```
详细操作

```
[root@localhost ~]# crontab -l
*/5 * * * * /usr/sbin/ntpdate ntp.api.bz
[root@localhost ~]# date
Sat Apr 13 04:48:52 EDT 2019
[root@localhost ~]# /usr/sbin/ntpdate ntp.api.bz
13 Apr 05:06:38 ntpdate[38604]: step time server 114.118.7.163 offset 1056.43580
1 sec[root@localhost ~]# date
Sat Apr 13 05:06:54 EDT 2019
```

### 2.4 limit
&#160; &#160; &#160; &#160;要调整一下 Linux 的最大文件打开数，否则运行 Squid 诅服务的机器在高负载时执行性能将会很差；另外，在 Linux 下部署应用时，有时候会遇上 “Too many open files” 这样的问题，这个值也会影响服务器的最大并发数。其实 Linux 是有文件句柄限制的。但默认值下是很高，一般是1024，生产服务器很容易就会达到这个值，所以需要改动此值。


```
cat>>/etc/security/limits.conf<<EOF
* soft nofile 65535
* hard nofile 65535
EOF
echo "ulimit -SHn 65535">>/etc/rc.local
ulimit -SHn 65535
```


详细操作：
```
[root@localhost ~]# cat>>/etc/security/limits.conf<<EOF
> * soft nofile 65535
> * hard nofile 65535
> EOF
[root@localhost ~]# echo "ulimit -SHn 65535">>/etc/rc.local
[root@localhost ~]# ulimit -SHn 65535
[root@localhost ~]# ulimit -n
65535
```

### 2.5 网卡自启动

```
sed -i 's@ONBOOT=no@ONBOOT=yes@g' /etc/sysconfig/network-scripts/ifcfg-ens33
```

详细操作如下：
```
[root@localhost ~]# sed -i 's@ONBOOT=no@ONBOOT=yes@g' /etc/sysconfig/network-scripts/ifcfg-ens33 
[root@localhost ~]# grep -i 'ONBOOT'  /etc/sysconfig/network-scripts/ifcfg-ens33 
ONBOOT=yes
```

### 2.6 ssh

```
# 禁止ssh反向解析
sed -i 's@UseDNS yes@UseDNS no@' /etc/ssh/sshd_config /etc/ssh/sshd_config
# # 禁止空密码登录
sed -i 's@PermitEmptyPasswords no@PermitEmptyPasswords no@' /etc/ssh/sshd_config
```
详细操作

```
[root@localhost ~]# sed -i 's@UseDNS yes@UseDNS no@' /etc/ssh/sshd_config /etc/ssh/sshd_config
[root@localhost ~]# sed -i 's@PermitEmptyPasswords no@PermitEmptyPasswords no@' /etc/ssh/sshd_config
```

### 2.7 命令补全

```
yum install -y bash-completion 
```

### 2.8 修改字符集
```
[root@localhost ~]# echo $LANG
zh_CN.UTF-8
[root@localhost ~]# vi /etc/locale.conf
LANG="en_US.UTF-8"
[root@localhost ~]# source  /etc/locale.conf
```

### 2.9 更换yum源
使用国内的更新源，下载会比国外要好[默认是使用的国外yum源]。
```
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
cd  /etc/yum.repos.d/
wget  http://mirrors.163.com/.help/CentOS7-Base-163.repo
yum clean all
yum makecache
```
详细操作如下:

```
[root@localhost yum.repos.d]# cd  /etc/yum.repos.d/
[root@localhost yum.repos.d]# wget  http://mirrors.163.com/.help/CentOS7-Base-16
3.repo--2019-04-13 05:18:56--  http://mirrors.163.com/.help/CentOS7-Base-163.repo
Resolving mirrors.163.com (mirrors.163.com)... 59.111.0.251
Connecting to mirrors.163.com (mirrors.163.com)|59.111.0.251|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1572 (1.5K) [application/octet-stream]
Saving to: ‘CentOS7-Base-163.repo’

100%[======================================>] 1,572       --.-K/s   in 0s      

2019-04-13 05:18:56 (259 MB/s) - ‘CentOS7-Base-163.repo’ saved [1572/1572]

[root@localhost yum.repos.d]# yum clean all
Loaded plugins: fastestmirror
Cleaning repos: base extras updates
Cleaning up list of fastest mirrors
[root@localhost yum.repos.d]# yum makecache
Loaded plugins: fastestmirror
Determining fastest mirrors
base                                                     | 3.6 kB     00:00     
......省略
```

### 2.10 安装基本软件

```
yum install gcc cmake bzip2-devel curl-devel db4-devel libjpeg-devel libpng-devel freetype-devel libXpm-devel gmp-devel libc-client-devel openldap-devel unixODBC-devel postgresql-devel sqlite-devel aspell-devel net-snmp-devel libxslt-devel libxml2-devel pcre-devel mysql-devel pspell-devel libmemcached libmemcached-devel zlib-devel  vim wget   lrzsz  tree
```

### 2.11 非图形

```
systemctl get-default                         # 查看当前的运行模式
systemctl set-default graphical.target        # 设置图形模式为默认模式
sudo systemctl set-default multi-user.target  # 设置非图形模式为默认模式
```

```
[root@localhost yum.repos.d]# systemctl get-default 
multi-user.target
```

### 2.12 yum 扩展源
&#160; &#160; &#160; &#160;这是因为像centos这类衍生出来的发行版，他们的源有时候内容更新的比较滞后，或者说有时候一些扩展的源根本就没有。所以在使用yum来search python-pip的时候，会说没有找到该软件包。 
因此为了能够安装这些包，需要先安装扩展源EPEL。EPEL(http://fedoraproject.org/wiki/EPEL) 是由 Fedora 社区打造，为 RHEL 及衍生发行版如 CentOS、Scientific Linux 等提供高质量软件包的项目。 
首先安装epel扩展源：
```
yum -y install epel-release
```

### 2.13 添加公网DNS

```
cat >> /etc/resolv.conf << EOF
nameserver 114.114.114.114
EOF
```

### 2.14 内核优化

```
cat >> /etc/sysctl.conf << EOF
vm.overcommit_memory = 1
net.ipv4.ip_local_port_range = 1024 65536
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_abort_on_overflow = 0
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.ipv4.netfilter.ip_conntrack_max = 2097152
net.nf_conntrack_max = 655360
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
EOF
/sbin/sysctl -p
```

### 2.15 优化服务

```
SERVICES="acpid atd auditd avahi-daemon avahi-dnsconfd bluetooth conman cpuspeed cups dnsmasq dund firstboot hidd httpd ibmasm ip6tables irda kdump lm_sensors mcstrans messagebus microcode_ctl netconsole netfs netplugd nfs nfslock nscd oddjobd pand pcscd portmap psacct rdisc restorecond rpcgssd rpcidmapd rpcsvcgssd saslauthd sendmail setroubleshoot smb vncserver winbind wpa_supplicant ypbind"
for service in $SERVICES
do
#关闭所选服务随系统启动
systemctl disable $SERVICES
#停止所选的服务
systemctl stop $SERVICES
done
```


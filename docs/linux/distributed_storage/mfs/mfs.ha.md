<center><h1>Keepalived + MFS 高可用</h1></center>

## 1. 准备

### 1.1 服务器规划

| 服务器主机                             | IP              | 作用                                     | 系统                  | VIP             |
| -------------------------------------- | --------------- | ---------------------------------------- | --------------------- | --------------- |
| mfs masterKeepalived master            | 192.168.200.151 | 主mfs，主keepalived                      | Ubuntu 14.04.5 LTSx64 | 192.168.200.200 |
| mfs metalog mfs chunk03Keepalived back | 192.168.200.152 | Metalog备份日志，备keepalived,数据存储03 | Ubuntu 14.04.5 LTSx64 |                 |
| mfs chunk01                            | 192.168.200.154 | 数据存储01                               | Ubuntu 14.04.5 LTSx64 |                 |
| mfs chunk02                            | 192.168.200.155 | 数据存储02                               | Ubuntu 14.04.5 LTSx64 |                 |
| mfs client                             | 192.168.200.140 | 客户端                                   | Ubuntu 14.04.5 LTSx64 |                 |

### 1.2 配置文件

mfs master

```
root@master:/etc/mfs# pwd
/etc/mfs
root@master:/etc/mfs# ll
total 52
drwxr-xr-x  2 root root 4096 Dec 26 16:36 ./
drwxr-xr-x 94 root root 4096 Dec 23 10:03 ../
-rw-r--r--  1 root root 3443 Nov 30 14:04 mfschunkserver.cfg.sample
-rw-r--r--  1 root root 4057 Nov 30 14:04 mfsexports.cfg
-rw-r--r--  1 root root 1657 Dec 23 14:43 mfshdd.cfg
-rw-r--r--  1 root root 8515 Dec 23 11:05 mfsmaster.cfg
-rw-r--r--  1 root root 6667 Dec 26 16:36 mfsmaster.etc.tar.gz
-rw-r--r--  1 root root 2194 Dec 23 13:49 mfsmetalogger.cfg
-rw-r--r--  1 root root  402 Nov 30 14:04 mfsmount.cfg.sample
-rw-r--r--  1 root root 1052 Nov 30 14:04 mfstopology.cfg.sample
其中后缀带.cfg都是模板文件，需要即可拷贝相对应去掉.sample即可，如上述所示。
root@master:/etc/mfs# egrep -v "#|^$" mfsmaster.cfg 
DATA_PATH = /var/lib/mfs
EXPORTS_FILENAME = /etc/mfs/mfsexports.cfg
TOPOLOGY_FILENAME = /etc/mfs/mfstopology.cfg
root@master:/etc/mfs# egrep -v "#|^$" mfshdd.cfg 
/mfsdata
root@master:/etc/mfs# egrep -v "#|^$" mfsexports.cfg 
*			/	rw,alldirs,admin,maproot=0:0
*			.	rw
```

## 2. Keepalived

### 2.1 主keepalived

&emsp;主keepalived配置文件。

```
root@master:/var/lib/mfs# cat /etc/keepalived/keepalived.conf
vrrp_script check_run {
   script "/home/leco/script/shell/mfs/keepalived_check_mfsmaster.sh"
   interval 2
}
vrrp_sync_group VG1 {
    group {
          VI_1
    }
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 50
    priority 100
    advert_int 1
    nopreempt
    authentication {
        auth_type PASS
        auth_pass 111111
    }
    track_script {
        check_run 
    }
    virtual_ipaddress {
        192.168.200.200
    }
}
```

配套监控脚本

```
root@master:/var/lib/mfs# ll /home/leco/script/shell/mfs/keepalived_check_mfsmaster.sh
-rwxr-xr-x 1 root root 865 Dec 23 13:12 /home/leco/script/shell/mfs/keepalived_check_mfsmaster.sh*

root@master:/var/lib/mfs# cat /home/leco/script/shell/mfs/keepalived_check_mfsmaster.sh
#!/bin/bash
#write by caimengzhi
#20161220

MFSMASTER_HOST=192.168.200.200
MFSMASTER_PORT=9420
CHECK_MASTER=/usr/local/nagios/libexec/check_tcp
CHECK_TIME=2

CMD_CHECK=/usr/bin/nmap
#mfsmaster  is working MFS_OK is 1 , mfsmaster down MFS_OK is 0
MFS_OK=1
function check_mfsmaster (){
    #$CHECK_MASTER -H $MFSMASTER_HOST -p $MFSMASTER_PORT >/dev/null 2>&1
    #ret=$(CMD_CHECK $MFSMASTER_HOST -p $MFSMASTER_PORT|grep open|wc -l)
    ret=$(netstat -lnp| grep 9420 |wc -l)
    if [ $ret -eq 1 ] ;then
        MFS_OK=1
    else
        MFS_OK=0
    fi
    return $MFS_OK
}
while [ $CHECK_TIME -ne 0 ]
do
    let CHECK_TIME=CHECK_TIME-1
    #sleep 1
    check_mfsmaster
    if [ $MFS_OK -eq 1 ] ; then
        CHECK_TIME=0
        exit 0
    fi
    if [ $MFS_OK -eq 0 ] &&  [ $CHECK_TIME -eq 0 ]
    then
        /etc/init.d/keepalived stop
        exit 1
    fi
Done
```

> 结合keepalived和该脚本大致解释脚本内容：
> Keepalived 两秒中监控一次当前mfsmaster的情况，本来该vip启动在master mfs上，所以keepalived直接监控vip的mfs master，当当前mfsmaster挂掉以后，改脚本就把自身keepalived关掉。关闭自己，我目的是为了防止后面的vip脑裂情况，此时master keepalived stop以后，back也就是metalog上的从keepalived启动，接管vip，在启动通过metlog日志恢复mfsmaster，启动mfsmaster。

### 2.2 从keepalived

配置文件

```
root@metalog:/var/lib/mfsmetalogger# cat /etc/keepalived/keepalived.conf
vrrp_sync_group VG1 {
    group {
          VI_1
    }
    notify_backup "/home/leco/script/shell/mfs/keepalived_notify.sh backup"
    notify_master "/home/leco/script/shell/mfs/keepalived_notify.sh master"
}
vrrp_instance VI_1 {
    state              BACKUP
    interface          eth0
    virtual_router_id  50
    priority           80
    advert_int         1
    authentication {
        auth_type PASS
        auth_pass 111111
    }
    
    virtual_ipaddress {
        192.168.200.200
    }
}
```

脚本

```
root@metalog:/var/lib/mfsmetalogger# ll  /home/leco/script/shell/mfs/keepalived_notify.sh
-rwxr-xr-x 1 root root 1272 Dec 26 14:34 /home/leco/script/shell/mfs/keepalived_notify.sh*

root@metalog:/var/lib/mfsmetalogger# cat /home/leco/script/shell/mfs/keepalived_notify.sh
#!/bin/bash
#write by caimengzhi
#2016122

MFS_HOME=/usr
MFSMARSTER=${MFS_HOME}/sbin/mfsmaster
MFSMETARESTORE=${MFS_HOME}/sbin/mfsmetarestore 
#MFS_DATA_PATH=/home/sdc/mfs/metalogger
MFS_DATA_PATH=/etc/mfs/slave/metalock
MFS_CGIS=/usr/sbin/mfscgiserv
TIME=$(date +%F-%H:%M:%S)
function backup2master(){
    #$MFSMETARESTORE -m ${MFS_DATA_PATH}/metadata.mfs.bak -o ${MFS_DATA_PATH}/metadata.mfs $MFS_DATA_PATH/changelog_ml*.mfs
    cd /var/lib/mfs
    tar zcvf mfs.log.${TIME}.tar.gz *
    [ ! -d /opt/mfslogbak ] && mkdir -p /opt/mfslogbak  && /bin/mv  mfs.log.*.tar.gz /opt/mfslogbak
    cd /var/lib/mfs  && rm -rf changelog_ml* metadata* Master_change.OK
    cp /var/lib/mfsmetalogger/* /var/lib/mfs
    #touch /var/lib/mfs/metadata.mfs
    #touch /var/lib/mfs/metadata.back
    echo $TIME >/var/lib/mfs/Master_change.OK
    chown -R mfs.mfs /var/lib/mfs
    $MFSMARSTER -a
    #$MFSMETARESTORE -a
    $MFSMARSTER stop
    $MFS_CGIS stop
    sleep 2
    $MFSMARSTER start
    $MFS_CGIS start
}

function master2backup(){
    $MFSMARSTER stop
}

function ERROR(){
    echo "USAGE: keepalived_notify.sh master|backup "
}

case $1 in
        master)
        backup2master
        ;;
        backup)
        master2backup
        ;;
        *)
        ERROR
        ;;
Esac
```

```
配合从keepalived和脚本大致解释以下脚本意思：
1. 先解释脚本调用
notify_backup "notify_backup/path/to_backup.sh backup"
notify_master "/path/to_master.sh master"
notify_fault   "/path/fault.sh VG_1"
从名字上我们即可看出，将一个从节点转为master状态的时候则执行后面的脚本
如果变成backup的状态以此类推
如果脚本带有参数，这个脚本需要用引号引起来，务必要注意这样一点
2.解释脚本的作用
  1. 当主keepalived宕机后，接管vip资源，先把metalog上的mfsmaster日志数据先删除，然后通过metalog日志拷贝过来到mfsmaster日志路径下，通过mfsmaster -a 自动恢复。启动mfsmaster和mfascgi
  2. 当主keepalived启动后，过10秒后。原来masterkeepalived启动后，且接管了vip资源，此时metalog也就是备keepalived会自动停掉mfsmaster。
```

## 3. 软件故障模拟与恢复

### 3.1 模拟主keepalived上mfsmaster宕机

#### 3.1.1  主 keepalived上操作

- 启动 主keepalived，mfsmaster，mfsmetalog，mfscgi

```
root@master:/var/lib/mfs# /etc/init.d/keepalived start
*         Starting keepalived keepalived              [ OK ]

root@master:/var/lib/mfs# mfsmetalogger start
root@master:/var/lib/mfs# /usr/bin/python /usr/sbin/mfscgiserv start
```

#### 3.1.2查看vip

```
root@master:/var/lib/mfs# ip addr|grep 200
    inet 192.168.200.151/24 brd 192.168.200.255 scope global eth0
inet 192.168.200.200/32 scope global eth0
```

#### 3.1.3 查看进程

```
root@master:/var/lib/mfs# ps aux|egrep "keep|mfs"
root       4012  0.0  0.8  43280  8060 ?        S    Dec23   0:03 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       24827  1.0  0.2  17220  2296 ?        S<   14:39   0:59 mfsmetalogger start
root      29222  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
root      29235  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
mfs       29445  9.5 48.7 521724 488868 ?       S<   16:10   0:03 mfsmaster start
root      29458  0.0  0.1  46772  1440 ?        Ss   16:10   0:00 /usr/sbin/keepalived
root      29460  0.0  0.5  53096  5188 ?        S    16:10   0:00 /usr/sbin/keepalived
root      29461  0.1  0.3  53096  3860 ?        S    16:10   0:00 /usr/sbin/keepalived
root      29550  0.0  0.2   9452  2096 pts/0    S+   16:11   0:00 egrep --color=auto keep|mfs
```

#### 3.1.4 从 keepalived上操作

从keepalived，mfsmetalog，mfscgi

```
root@master:/var/lib/mfs# /etc/init.d/keepalived start
*         Starting keepalived keepalived              [ OK ]
```

#### 3.1.5 查看vip

```
root@metalog:/var/lib/mfsmetalogger# ip addr|grep 200.200
```

此时发现vip不在，在主keepalived上。表明一切正常。

#### 3.1.6 查看进程

查看keepalived和mfs启动情况

```
root@metalog:/var/lib/mfsmetalogger# ps aux|egrep "keep|mfs"
mfs        3371  2.2 14.2 369060 142828 ?       S<l  Dec23 102:45 mfschunkserver start
root      12873  0.0  0.1  46772  1228 ?        Ss   14:22   0:00 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2640 ?        S    14:22   0:00 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2600 ?        S    14:22   0:03 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17220  2292 ?        S<   14:38   0:46 mfsmetalogger start
root      13517  0.0  0.8  42736  8868 ?        S    15:24   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
root      13527  0.0  0.0      0     0 ?        Z    15:31   0:00 [mfs.cgi] <defunct>
root      13622  0.0  0.2   9452  2028 pts/0    S+   16:17   0:00 egrep --color=auto keep|mfs
```

主宕机

```
root@master:~# ps aux|egrep "keep|mfs"
root       4012  0.0  0.8  43280  8060 ?        S    Dec23   0:03 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       24827  1.0  0.2  17224  2296 ?        S<   14:39   1:04 mfsmetalogger start
root      29222  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
root      29235  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
mfs       29445  1.3 49.4 521724 495648 ?       S<   16:10   0:09 mfsmaster start
root      29458  0.0  0.1  46772  1440 ?        Ss   16:10   0:00 /usr/sbin/keepalived
root      29460  0.0  0.5  53096  5188 ?        S    16:10   0:00 /usr/sbin/keepalived
root      29461  0.0  0.3  53096  3860 ?        S    16:10   0:00 /usr/sbin/keepalived
root      31594  0.0  0.2   9452  2124 pts/0    S+   16:22   0:00 egrep --color=auto keep|mfs
root@master:~# mfsmaster stop
sending SIGTERM to lock owner (pid:29445)
waiting for termination terminated
root@master:~# ps aux|egrep "keep|mfs"
root       4012  0.0  0.8  43280  8060 ?        S    Dec23   0:03 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       24827  1.0  0.2  17220  2296 ?        S<   14:39   1:04 mfsmetalogger start
root      29222  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
root      29235  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
root      31641  0.0  0.2   9452  2136 pts/0    S+   16:22   0:00 egrep --color=auto keep|mfs
root@master:~# ip addr|grep 200.200
此时可以看出主keepalived已经自己关闭。
```

查看从keepalived

```
主keepalived没有宕机之前
root@metalog:/var/lib/mfsmetalogger# ip addr|grep 200
    inet 192.168.200.152/24 brd 192.168.200.255 scope global eth0
root@metalog:/var/lib/mfsmetalogger# ps aux|egrep "keep|mfs"
mfs        3371  2.2 14.2 369060 142828 ?       S<l  Dec23 102:45 mfschunkserver start
root      12873  0.0  0.1  46772  1228 ?        Ss   14:22   0:00 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2640 ?        S    14:22   0:00 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2600 ?        S    14:22   0:03 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17220  2292 ?        S<   14:38   0:46 mfsmetalogger start
root      13517  0.0  0.8  42736  8868 ?        S    15:24   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
root      13527  0.0  0.0      0     0 ?        Z    15:31   0:00 [mfs.cgi] <defunct>
root      13622  0.0  0.2   9452  2028 pts/0    S+   16:17   0:00 egrep --color=auto keep|mfs
root@metalog:/var/lib/mfsmetalogger# ip addr|grep 200.200

主keepalived宕机之后
root@metalog:/var/lib/mfsmetalogger# ip addr|grep 200.200
    inet 192.168.200.200/32 scope global eth0
root@metalog:/var/lib/mfsmetalogger# ps aux|egrep "keep|mfs"
mfs        3371  2.2 14.2 369060 142756 ?       S<l  Dec23 102:53 mfschunkserver start
root      12873  0.0  0.1  46772  1228 ?        Ss   14:22   0:00 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2640 ?        S    14:22   0:00 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2600 ?        S    14:22   0:03 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17220  2292 ?        S<   14:38   0:49 mfsmetalogger start
mfs       13665  1.2 48.7 521732 488956 ?       S<   16:22   0:00 /usr/sbin/mfsmaster start
root      13668  0.0  0.7  36336  7384 ?        S    16:22   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
root      13672  0.0  0.2   9452  2044 pts/0    S+   16:23   0:00 egrep --color=auto keep|mfs
可以看出从keepalived，已经接管了vip，且在从keepalived服务器上启动了mfsmaster
```

查看客户端挂载情况

```
root@ubuntu:/mnt/mfs# ls
0.jdk-8u40-linux-x64.gz  1  10  2  3  4  5  6  7  8  9  jdk-8u40-linux-x64.gz  mfsmetalog
root@ubuntu:/mnt/mfs# df -h
Filesystem            Size  Used Avail Use% Mounted on
udev                  477M  4.0K  477M   1% /dev
tmpfs                  98M  936K   97M   1% /run
/dev/dm-0             491G  2.2G  464G   1% /
none                  4.0K     0  4.0K   0% /sys/fs/cgroup
none                  5.0M     0  5.0M   0% /run/lock
none                  488M   16K  488M   1% /run/shm
none                  100M     0  100M   0% /run/user
/dev/sda1             236M   40M  184M  18% /boot
192.168.200.200:9421  3.2T   13G  3.2T   1% /mnt/mfs
```

> 到此说明切换OK。

### 3.2  模拟主keepalived上mfsmaster启动

```
root@master:/var/lib/mfs# ip addr|grep 200
    inet 192.168.200.151/24 brd 192.168.200.255 scope global eth0
root@master:/var/lib/mfs# ps aux|egrep "keep|mfs"
root       4012  0.0  0.8  43280  8060 ?        S    Dec23   0:03 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       24827  1.0  0.2  17220  2296 ?        S<   14:39   0:58 mfsmetalogger start
root      29222  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
root      29235  0.0  0.0      0     0 ?        Z    15:24   0:00 [mfs.cgi] <defunct>
root      29429  0.0  0.2   9452  2052 pts/0    S+   16:09   0:00 egrep --color=auto keep|mfs
此时已经发现主keepalived，已经没有了vip资源。
此时也就是模拟手动启动原来的mfsmaster
手动恢复主keepalived上mfsmaster，通过主keepalived上的metalog日志恢复。为了检测恢复后区别，此时还是在备keepalived上的mfsmaster，此时我在客户端删除一些问题。这样主备上的metalog都会同步操作日志，然后我才在主keepalived上通过metalog日志恢复mfsmaster，操作过程如下：
```

l 客户操作

```
客户端上删除一些问题，此时metalog日志都会捕获该操作。
root@ubuntu:/mnt/mfs# ls
0.jdk-8u40-linux-x64.gz  1  10  2  3  4  5  6  7  8  9  jdk-8u40-linux-x64.gz  mfsmetalog
root@ubuntu:/mnt/mfs# rm -rf {1..10}
root@ubuntu:/mnt/mfs# ls
0.jdk-8u40-linux-x64.gz  jdk-8u40-linux-x64.gz  mfsmetalog
```

l 主keepalived上操作

```
root@master:~# ll MfsMasterStart.sh 
-rwxr-xr-x 1 root root 767 Dec 26 16:58 MfsMasterStart.sh*
root@master:~# cat MfsMasterStart.sh 
#!/bin/bash
#write by caimengzhi
#2016122

MFS_HOME=/usr
MFSMARSTER=${MFS_HOME}/sbin/mfsmaster
MFSMETARESTORE=${MFS_HOME}/sbin/mfsmetarestore 
MFS_DATA_PATH=/etc/mfs/slave/metalock
MFS_CGIS=/usr/sbin/mfscgiserv

function  MfsMasterStart()
{
    TIME=$(date +%Y%m%d-%H_%M_%S)
    [ ! -d /opt/mfslogbak ] && mkdir -p /opt/mfslogbak
    cd  /var/lib/mfs 
    tar -zcvf mfsmasterlog.${TIME}.tar.gz * && mv *.tar.gz  /opt/mfslogbak
    cd  /var/lib/mfs
    rm -rf c* m* s*
    cp /var/lib/mfsmetalogger/* /var/lib/mfs
    
    chown -R mfs.mfs /var/lib/mfs
    $MFSMARSTER -a
    $MFSMARSTER stop
    $MFS_CGIS stop
    sleep 2
    $MFS_CGIS start
    $MFSMARSTER start && echo $TIME >/var/lib/mfs/Master_change.OK
    /etc/init.d/keepalived start
}
MfsMasterStart

查看启动情况
root@master:~# ps aux|egrep "keep|mfs"
mfs       24827  1.0  0.2  17220  2296 ?        S<   14:39   1:29 mfsmetalogger start
root      31752  0.0  0.7  36336  7384 ?        S    16:58   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       31755  1.8 49.4 521728 495644 ?       S<   16:58   0:03 /usr/sbin/mfsmaster start
root      31768  0.0  0.1  46772  1372 ?        Ss   16:58   0:00 /usr/sbin/keepalived
root      31770  0.0  0.5  53096  5164 ?        S    16:58   0:00 /usr/sbin/keepalived
root      31771  0.0  0.3  53096  3940 ?        S    16:58   0:00 /usr/sbin/keepalived
root      32265  0.0  0.2   9452  2132 pts/0    S+   17:01   0:00 egrep --color=auto keep|mfs
root@master:~# ip addr|grep 200.200
    inet 192.168.200.200/32 scope global eth0
说明主keepalived已经接管vip和启动了mfsmaster
```

从keepalived上操作

```
root@metalog:/var/lib/mfsmetalogger# ip addr|grep 200.200
root@metalog:/var/lib/mfsmetalogger# ps aux|egrep "keep|mfs"
mfs        3371  2.2 14.2 369060 142760 ?       S<l  Dec23 103:42 mfschunkserver start
root      12873  0.0  0.1  46772  1228 ?        Ss   14:22   0:01 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2640 ?        S    14:22   0:01 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2600 ?        S    14:22   0:04 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17220  2292 ?        S<   14:38   1:05 mfsmetalogger start
root      13668  0.0  0.7  36336  7384 ?        S    16:22   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
root      13745  0.0  0.2   9452  2056 pts/0    S+   17:02   0:00 egrep --color=auto keep|mfs
主上启动了keepalived了，此时从上的vip已经被主接管了，且从keepalived有切换到back模式，会调用脚本，此时脚本会关闭mfsmaster。
```

l 客户端上操作

```
root@ubuntu:/mnt/mfs# df -hP
Filesystem            Size  Used Avail Use% Mounted on
udev                  477M  4.0K  477M   1% /dev
tmpfs                  98M  936K   97M   1% /run
/dev/dm-0             491G  2.2G  464G   1% /
none                  4.0K     0  4.0K   0% /sys/fs/cgroup
none                  5.0M     0  5.0M   0% /run/lock
none                  488M   16K  488M   1% /run/shm
none                  100M     0  100M   0% /run/user
/dev/sda1             236M   40M  184M  18% /boot
192.168.200.200:9421  3.2T   13G  3.2T   1% /mnt/mfs
root@ubuntu:/mnt/mfs# ps aux|grep -v grep | grep mfs
root      86013  1.4 28.6 531040 285856 ?       S<sl 14:37   2:07 mfsmount /mnt/mfs/ -H 192.168.200.200
root@ubuntu:/mnt/mfs# ls /mnt/mfs
0.jdk-8u40-linux-x64.gz  jdk-8u40-linux-x64.gz  mfsmetalog
此时可以看出，在没有主keepalived上没有启动之前，我在从keepalived上删除了一些文件也就是1到10文件后，主从keepalived上的metalog都同步了该操作，所以，我在通过主keepalived上metalog日志来恢复mfsmaster，上已经成功。
```

## 4. 服务器掉电模拟与恢复

### 4.1 模拟主keepalived掉电

```
主 keepalived上操作
该服务正常，也就是没有故障之前，
主keepalived宕机前
1.检查主keepalived上情况
root@master:/home/leco# ip addr|grep 200.200
    inet 192.168.200.200/32 scope global eth0
root@master:/home/leco# ps aux|grep -v grep|egrep "keep|mfs"
mfs       24827  1.0  0.2  17224  2296 ?        S<   14:40   2:05 mfsmetalogger start
root      38664  0.0  0.8  42688  8868 ?        S    17:43   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       38667  1.1 50.1 528844 502876 ?       S<   17:43   0:18 /usr/sbin/mfsmaster start
root      39560  0.0  0.0      0     0 ?        Z    17:48   0:00 [mfs.cgi] <defunct>
root      42581  0.0  0.1  46772  1440 ?        Ss   18:04   0:00 /usr/sbin/keepalived
root      42583  0.0  0.5  53096  5264 ?        S    18:04   0:00 /usr/sbin/keepalived
root      42584  0.0  0.3  53096  4004 ?        S    18:04   0:00 /usr/sbin/keepalived

2.检查从keepalived上情况
root@metalog:/etc/mfs# ip addr|grep 200.200
root@metalog:/etc/mfs# ps aux|grep -v grep|egrep "keep|mfs"
mfs        3371  2.2 14.2 369060 142640 ?       S<l  Dec23 105:17 mfschunkserver start
root      12873  0.0  0.1  46772  1216 ?        Ss   14:22   0:01 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2588 ?        S    14:22   0:01 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2552 ?        S    14:22   0:05 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17224  2292 ?        S<   14:38   1:40 mfsmetalogger start
root      14200  0.0  0.7  36336  7388 ?        S    18:03   0:00 /usr/bin/python /usr/sbin/mfscgiserv start

3.检查客户端情况
0.jdk-8u40-linux-x64.gz  1  10  2  3  4  5  6  7  8  9  jdk-8u40-linux-x64.gz  mfsmetalog
root@ubuntu:/mnt/mfs# df -h
Filesystem            Size  Used Avail Use% Mounted on
udev                  477M  4.0K  477M   1% /dev
tmpfs                  98M  936K   97M   1% /run
/dev/dm-0             491G  2.2G  464G   1% /
none                  4.0K     0  4.0K   0% /sys/fs/cgroup
none                  5.0M     0  5.0M   0% /run/lock
none                  488M   16K  488M   1% /run/shm
none                  100M     0  100M   0% /run/user
/dev/sda1             236M   40M  184M  18% /boot
192.168.200.200:9421  3.2T   13G  3.2T   1% /mnt/mfs

3.直接关机主master
     
主keepalived宕机后
1.主keepalived
root@master:/home/leco# 
Connection closed by foreign host.

Disconnected from remote host(14.04-1) at 18:17:36.

Type `help' to learn how to use Xshell prompt.
[d:\~]$  
此时主keepalived主机已经失去联系了。

2.从keepalived
root@metalog:/etc/mfs# ip addr|grep 200.200
    inet 192.168.200.200/32 scope global eth0
root@metalog:/etc/mfs# ps aux|grep -v grep|egrep "keep|mfs"
mfs        3371  2.2 14.2 369128 142860 ?       S<l  Dec23 105:23 mfschunkserver start
root      12873  0.0  0.1  46772  1216 ?        Ss   14:22   0:01 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2588 ?        S    14:22   0:01 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2552 ?        S    14:22   0:05 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17224  2292 ?        S<   14:38   1:41 mfsmetalogger start
mfs       14250  0.9 49.3 521724 494672 ?       S<   18:16   0:01 /usr/sbin/mfsmaster start
root      14253  0.0  0.7  36336  7440 ?        S    18:16   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
说明从keepalived已经接管vip，且也已经启动mfsmaster。

3. 客户端情况
root@ubuntu:/mnt/mfs# df -hP
Filesystem            Size  Used Avail Use% Mounted on
udev                  477M  4.0K  477M   1% /dev
tmpfs                  98M  936K   97M   1% /run
/dev/dm-0             491G  2.2G  464G   1% /
none                  4.0K     0  4.0K   0% /sys/fs/cgroup
none                  5.0M     0  5.0M   0% /run/lock
none                  488M   16K  488M   1% /run/shm
none                  100M     0  100M   0% /run/user
/dev/sda1             236M   40M  184M  18% /boot
192.168.200.200:9421  3.2T   13G  3.2T   1% /mnt/mfs
root@ubuntu:/mnt/mfs# ls
0.jdk-8u40-linux-x64.gz  1  10  2  3  4  5  6  7  8  9  jdk-8u40-linux-x64.gz  mfsmetalog
root@ubuntu:/mnt/mfs# touch switch_back
root@ubuntu:/mnt/mfs# ls
0.jdk-8u40-linux-x64.gz  1  10  2  3  4  5  6  7  8  9  jdk-8u40-linux-x64.gz  mfsmetalog  switch_back
    说明切换换客户端还是能正常操作。
```

### 4.2 模拟主keepalived加电重启

```
 1. 主keepalived
root@master:/home/leco# ip addr|grep 200.200
    inet 192.168.200.200/32 scope global eth0
root@master:/home/leco# ps aux|grep -v grep|egrep "keep|mfs"
mfs       24827  0.9  0.2  17224  2296 ?        S<   14:40   2:10 mfsmetalogger start
root      38664  0.0  0.8  42688  8868 ?        S    17:43   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
mfs       38667  1.2 50.1 528844 502876 ?       S<   17:43   0:26 /usr/sbin/mfsmaster start
root      39560  0.0  0.0      0     0 ?        Z    17:48   0:00 [mfs.cgi] <defunct>
root      42581  0.0  0.1  46772  1440 ?        Ss   18:04   0:00 /usr/sbin/keepalived
root      42583  0.0  0.5  53096  5264 ?        S    18:04   0:00 /usr/sbin/keepalived
root      42584  0.0  0.4  53096  4068 ?        S    18:04   0:00 /usr/sbin/keepalived

   2. 从keepalived
root@metalog:/etc/mfs# ip addr|grep 200.200
root@metalog:/etc/mfs# ps aux|grep -v grep|egrep "keep|mfs"
mfs        3371  2.2 14.2 369060 142992 ?       S<l  Dec23 105:29 mfschunkserver start
root      12873  0.0  0.1  46772  1216 ?        Ss   14:22   0:01 /usr/sbin/keepalived
root      12876  0.0  0.2  53096  2588 ?        S    14:22   0:01 /usr/sbin/keepalived
root      12877  0.0  0.2  53096  2552 ?        S    14:22   0:05 /usr/sbin/keepalived
mfs       13031  0.7  0.2  17220  2292 ?        S<   14:38   1:44 mfsmetalogger start
root      14253  0.0  0.7  36336  7440 ?      S    18:16   0:00 /usr/bin/python /usr/sbin/mfscgiserv start
   3. 客户端
root@ubuntu:/mnt/mfs# ls
0.jdk-8u40-linux-x64.gz  1  10  2  3  4  5  6  7  8  9  jdk-8u40-linux-x64.gz  mfsmetalog
root@ubuntu:/mnt/mfs# df -h
Filesystem            Size  Used Avail Use% Mounted on
udev                  477M  4.0K  477M   1% /dev
tmpfs                  98M  936K   97M   1% /run
/dev/dm-0             491G  2.2G  464G   1% /
none                  4.0K     0  4.0K   0% /sys/fs/cgroup
none                  5.0M     0  5.0M   0% /run/lock
none                  488M   16K  488M   1% /run/shm
none                  100M     0  100M   0% /run/user
/dev/sda1             236M   40M  184M  18% /boot
192.168.200.200:9421  3.2T   13G  3.2T   1% /mnt/mfs
到此为止说明主keepalived上mfsmaster宕机后从keepalived上接管资源。此时然后在加电keepalived主机，然后可以手工切换。
```

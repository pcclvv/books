<center><h1>MFS备份</h1></center>
## 1. 介绍
&emsp;MooseFS[MFS]是一个具有容错性的网络分布式文件系统。它把数据分散存放在多个物理服务器上，而呈现给用户的则是一个统一的资源。 
官网地址：http://www.moosefs.com/

### 1.1 特点

1．高可用性(数据可以存储在多个机器上的多个副本)

2．可动态扩展随时新增加机器或者是磁盘

3．可回收在指定时间内删除的文件(“垃圾回收站”是一个系统级别的服务)

4．可以对整个文件甚至在正在写入的文件创建文件的快照。

### 1.2 结构图

![mfs架构图](https://moosefs.com/wp-content/themes/Moose/img/moosefs-pro-architecture.png)

> 摘自官网的插图

## 2. 数据备份

&emsp;mfs架构，只要备份mfs-sever的数据即可。因为mfs上记录的数据的meta信息不能丢失，一旦丢失找不回来，整个集群的机器数据基本就废了。

### 2.1 sersync 方式

-  rsync服务器端

| IP           | 角色                       | 安装软件     | 目录                                                | 目的                                                    |
| ------------ | -------------------------- | ------------ | --------------------------------------------------- | ------------------------------------------------------- |
| 192.168.5.37 | Rsync 服务器               | rsync        | /BackFile/mfs/192_168_1_32/BackFile/mfs/192_168_1_4 | 将/var/lib/mfs目录文件实时推送到/BackFile/mfs下指定文件 |
| 192.168.5.4  | Rsync客户端sersync服务器端 | Serync,rsync | /var/lib/mfs                                        |                                                         |
| 192.168.5.32 | Rsync客户端sersync服务器端 | Serync,rsync | /var/lib/mfs                                        |                                                         |

- rsync客户端

```
root@cmz12:/usr/local/sersync/conf# cat /etc/rsync.password
admin
root@cmz4:/usr/local/sersync# cat /etc/rsync.password
admin
```

文件

```
root@cmz12:/home/admin_cmz12# cd /usr/local/sersync/
root@cmz12:/usr/local/sersync# ls
bin  conf  log  script
root@cmz12:/usr/local/sersync# cd conf/
root@cmz12:/usr/local/sersync/conf# ls
confxml.xml  confxml.xml.ori
root@cmz12:/usr/local/sersync/conf# cat confxml.xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    <host hostip="localhost" port="8008"></host>
    <debug start="false"/>
    <fileSystem xfs="false"/>
    <filter start="false">
	<exclude expression="(.*)\.svn"></exclude>
	<exclude expression="(.*)\.gz"></exclude>
	<exclude expression="^info/*"></exclude>
	<exclude expression="^static/*"></exclude>
    </filter>
    <inotify>
	<delete start="true"/>
	<createFolder start="true"/>
	<createFile start="false"/>
	<closeWrite start="true"/>
	<moveFrom start="true"/>
	<moveTo start="true"/>
	<attrib start="false"/>
	<modify start="false"/>
    </inotify>

    <sersync>
	<localpath watch="/var/lib/mfs/">
	    <remote ip="192.168.5.37" name="192_168_5_32_data"/>
	    <!--<remote ip="192.168.8.39" name="tongbu"/>-->
	    <!--<remote ip="192.168.8.40" name="tongbu"/>-->
	</localpath>
	<rsync>
	    <commonParams params="-artuz"/>
	    <auth start="true" users="rsync_body" passwordfile="/etc/rsync.password"/>
	    <userDefinedPort start="false" port="874"/><!-- port=874 -->
	    <timeout start="true" time="100"/><!-- timeout=100 -->
	    <ssh start="false"/>
	</rsync>
	<failLog path="/usr/local/sersync/log/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->
	<crontab start="false" schedule="600"><!--600mins-->
	    <crontabfilter start="false">
		<exclude expression="*.php"></exclude>
		<exclude expression="info/*"></exclude>
	    </crontabfilter>
	</crontab>
	<plugin start="false" name="command"/>
    </sersync>

    <plugin name="command">
	<param prefix="/bin/sh" suffix="" ignoreError="true"/>	<!--prefix /opt/tongbu/mmm.sh suffix-->
	<filter start="false">
	    <include expression="(.*)\.php"/>
	    <include expression="(.*)\.sh"/>
	</filter>
    </plugin>

    <plugin name="socket">
	<localpath watch="/opt/tongbu">
	    <deshost ip="192.168.138.20" port="8009"/>
	</localpath>
    </plugin>
    <plugin name="refreshCDN">
	<localpath watch="/data0/htdocs/cms.xoyo.com/site/">
	    <cdninfo domainname="ccms.chinacache.com" port="80" username="xxxx" passwd="xxxx"/>
	    <sendurl base="http://pic.xoyo.com/cms"/>
	    <regexurl regex="false" match="cms.xoyo.com/site([/a-zA-Z0-9]*).xoyo.com/images"/>
	</localpath>
    </plugin>
</head>
root@cmz12:/usr/local/sersync/conf# crontab -l |grep sersync
# add by caimengzhi at 2017-02-24 22:13 sersync mfs master log to 192.168.5.32
*     *    *    *    *    /bin/bash /usr/local/sersync/script/rsync_fail_log.sh    >/dev/null 2>&1
*     *    *    *    *    /bin/bash /usr/local/sersync/script/rsync_log.sh        >/dev/null 2>&1
root@cmz12:/usr/local/sersync/conf# cat /usr/local/sersync/script/rsync_fail_log.sh
#!/bin/bash
#Author: cai meng zhi
SERSYNC="/usr/local/sersync/bin/sersync"
CONF_FILE="/usr/local/sersync/conf/confxml.xml"
#STATUS=$(ps aux |grep 'sersync'|grep -v 'grep'|wc -l)
STATUS=$(ps aux|grep '/usr/local/sersync/bin/sersync -d -r -o /usr/local/sersync/conf/confxml.xml'|grep -v 'grep'|wc -l)
if [ $STATUS -eq 0 ];
then
        $SERSYNC -d -r -o $CONF_FILE &
else
        exit 0;
fi
```

日志

```
root@cmz4:/usr/local/sersync# cat /usr/local/sersync/conf/confxml.xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<head version="2.5">
    <host hostip="localhost" port="8008"></host>
    <debug start="false"/>
    <fileSystem xfs="false"/>
    <filter start="false">
	<exclude expression="(.*)\.svn"></exclude>
	<exclude expression="(.*)\.gz"></exclude>
	<exclude expression="^info/*"></exclude>
	<exclude expression="^static/*"></exclude>
    </filter>
    <inotify>
	<delete start="true"/>
	<createFolder start="true"/>
	<createFile start="false"/>
	<closeWrite start="true"/>
	<moveFrom start="true"/>
	<moveTo start="true"/>
	<attrib start="false"/>
	<modify start="false"/>
    </inotify>

    <sersync>
	<localpath watch="/home/sdc/mfsmaster">
	    <remote ip="192.168.1.37" name="192_168_1_4_data"/>
	    <!--<remote ip="192.168.8.39" name="tongbu"/>-->
	    <!--<remote ip="192.168.8.40" name="tongbu"/>-->
	</localpath>
	<rsync>
	    <commonParams params="-artuz"/>
	    <auth start="true" users="rsync_body" passwordfile="/etc/rsync.password"/>
	    <userDefinedPort start="false" port="874"/><!-- port=874 -->
	    <timeout start="true" time="100"/><!-- timeout=100 -->
	    <ssh start="false"/>
	</rsync>
	<failLog path="/usr/local/sersync/log/rsync_fail_log.sh" timeToExecute="60"/><!--default every 60mins execute once-->
	<crontab start="false" schedule="600"><!--600mins-->
	    <crontabfilter start="false">
		<exclude expression="*.php"></exclude>
		<exclude expression="info/*"></exclude>
	    </crontabfilter>
	</crontab>
	<plugin start="false" name="command"/>
    </sersync>

    <plugin name="command">
	<param prefix="/bin/sh" suffix="" ignoreError="true"/>	<!--prefix /opt/tongbu/mmm.sh suffix-->
	<filter start="false">
	    <include expression="(.*)\.php"/>
	    <include expression="(.*)\.sh"/>
	</filter>
    </plugin>

    <plugin name="socket">
	<localpath watch="/opt/tongbu">
	    <deshost ip="192.168.138.20" port="8009"/>
	</localpath>
    </plugin>
    <plugin name="refreshCDN">
	<localpath watch="/data0/htdocs/cms.xoyo.com/site/">
	    <cdninfo domainname="ccms.chinacache.com" port="80" username="xxxx" passwd="xxxx"/>
	    <sendurl base="http://pic.xoyo.com/cms"/>
	    <regexurl regex="false" match="cms.xoyo.com/site([/a-zA-Z0-9]*).xoyo.com/images"/>
	</localpath>
    </plugin>
</head>
```



### 2.2 metalogger方式

```
root@cmz40:/etc/mfs# ps axf|grep -v grep | grep mfs
 4861 ?        S<   3441:23 /usr/sbin/mfsmetalogger start
root@cmz40:~# cd /etc/mfs/
root@cmz40:/etc/mfs# ls
mfsexports.cfg  mfsmaster.cfg  mfsmetalogger.cfg  sample
root@cmz40:/etc/mfs# egrep -v '#|^$' mfsmetalogger.cfg
DATA_PATH = /var/lib/mfsmeta
MASTER_HOST = 192.168.5.113
root@cmz40:/etc/mfs# ls /var/lib/mfsmeta/
changelog_ml.0.mfs   changelog_ml.19.mfs  changelog_ml.28.mfs  changelog_ml.37.mfs  changelog_ml.46.mfs  changelog_ml.9.mfs
changelog_ml.10.mfs  changelog_ml.1.mfs   changelog_ml.29.mfs  changelog_ml.38.mfs  changelog_ml.47.mfs  changelog_ml_back.0.mfs
changelog_ml.11.mfs  changelog_ml.20.mfs  changelog_ml.2.mfs   changelog_ml.39.mfs  changelog_ml.48.mfs  changelog_ml_back.1.mfs
changelog_ml.12.mfs  changelog_ml.21.mfs  changelog_ml.30.mfs  changelog_ml.3.mfs   changelog_ml.49.mfs  metadata_ml.mfs.back
changelog_ml.13.mfs  changelog_ml.22.mfs  changelog_ml.31.mfs  changelog_ml.40.mfs  changelog_ml.4.mfs   metadata_ml.mfs.back.1
changelog_ml.14.mfs  changelog_ml.23.mfs  changelog_ml.32.mfs  changelog_ml.41.mfs  changelog_ml.50.mfs  metadata_ml.mfs.back.2
changelog_ml.15.mfs  changelog_ml.24.mfs  changelog_ml.33.mfs  changelog_ml.42.mfs  changelog_ml.5.mfs   metadata_ml.mfs.back.3
changelog_ml.16.mfs  changelog_ml.25.mfs  changelog_ml.34.mfs  changelog_ml.43.mfs  changelog_ml.6.mfs
changelog_ml.17.mfs  changelog_ml.26.mfs  changelog_ml.35.mfs  changelog_ml.44.mfs  changelog_ml.7.mfs
changelog_ml.18.mfs  changelog_ml.27.mfs  changelog_ml.36.mfs  changelog_ml.45.mfs  changelog_ml.8.mfs
root@cmz40:/etc/mfs# du -sh  /var/lib/mfsmeta/
6.8G	/var/lib/mfsmeta/

root@cmz12:/etc/mfs# ps axf|grep -v grep |grep  mfsmetalogger
12334 ?        D<     0:04 mfsmetalogger start
root@cmz12:/etc/mfs# egrep -v '#|^$' /etc/mfs/mfsmetalogger.cfg
DATA_PATH = /var/lib/mfsmeta
MASTER_HOST = 192.168.5.113
root@cmz12:/etc/mfs# du -sh /var/lib/mfsmeta/
1.7G	/var/lib/mfsmeta/
```

日志

```
root@cmz5:~# ps aux|grep -v grep | grep mfs
mfs      17555  0.1  0.0  18608  2384 ?        S<    2016 1253:40 /usr/sbin/mfsmetalogger start
root@cmz5:~# egrep -v '#|^$' /etc/mfs/mfsmetalogger.cfg
DATA_PATH = /home/sdc/metalogger
MASTER_HOST = 192.168.5.112
MASTER_PORT = 9519
root@cmz5:~# du -sh /home/sdc/metalogger
1.3M	/home/sdc/metalogger

root@cmz4:/etc/mfs# egrep -v '#|^$' /etc/mfs/mfsmetalogger.cfg
DATA_PATH = /home/sdc/metalogger
MASTER_HOST = 192.168.5.112
MASTER_PORT = 9519
root@cmz4:/etc/mfs# du -sh  /home/sdc/metalogger
1.3M	/home/sdc/metalogger
root@cmz4:/etc/mfs# ps aux|grep -v grep | grep mfsmetalogger
mfs       9410  0.1  0.0  19188  2352 ?        S<    2017 799:25 /usr/sbin/mfsmetalogger start
```



### 2.3 crontab

文件

```
root@cmz12:/usr/local/sersync/conf# crontab  -l|grep rsync_log.sh
*     *    *    *    *    /bin/bash /usr/local/sersync/script/rsync_log.sh       >/dev/null 2>&1
root@cmz12:/usr/local/sersync/conf# cat /usr/local/sersync/script/rsync_log.sh
#!/bin/bash
# Author : caimengzhi
# Date   : 2018-08-29
# Version: 1.0
# Description : rsync mfs master log(/var/lib/mfs/) to 192.168.5.31:/BackFile/mfs/192_168_5_32/

ip_last=$(/sbin/ifconfig bridge01 | awk -F'[ . :]+' '/inet addr:/{print $7}')
username='admin_cmz11'
ip_dest=192.168.5.31
# log path
log_spath=/var/lib/mfs
log_dpath=/BackFile/mfs

# etc path
etc_spath=/etc/mfs
etc_dpath=/BackFile/mfs

# log 备份
/usr/bin/sshpass -p caimengzhi  /usr/bin/rsync -azv ${log_spath}  ${username}@${ip_dest}:${log_dpath}/192_168_5_${ip_last}/log >/dev/null 2>&1

# etc 备份
/usr/bin/sshpass -p caimengzhi  /usr/bin/rsync  -azv ${etc_spath}  ${username}@${ip_dest}:${etc_dpath}/192_168_5_${ip_last}/etc >/dev/null 2>&1
```

日志

```
root@cmz4:/home/sdc/mfsmaster# crontab -l|grep rsync_log.sh
*     *    *    *    *    /bin/bash /usr/local/sersync/script/rsync_log.sh              >/dev/null 2>&1
root@cmz4:/home/sdc/mfsmaster# cat /usr/local/sersync/script/rsync_log.sh
#!/bin/bash
# Author : caimengzhi
# Date   : 2018-08-29
# Version: 1.0
# Description : rsync mfs master log(/var/lib/mfs/) to 192.168.1.31:/BackFile/mfs/192_168_5_32/

ip_last=$(/sbin/ifconfig bridge01 | awk -F'[ . :]+' '/inet addr:/{print $7}')
username='admin_cmz11'
ip_dest=192.168.5.31
# log path
log_spath=/home/sdc/mfsmaster
log_dpath=/BackFile/mfs

# etc path
etc_spath=/etc/mfs
```

<center><h1>HDFS shell基本操作</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;既然HDFS是存取数据的分布式文件系统，那么对HDFS的操作，就是文件系统的基本操作，比如文件的创建、修改、删除、修改权限等，文件夹的创建、删除、重命名等。对HDFS的操作命令类似于Linux的shell对文件的操作，如ls、mkdir、rm等。

&#160; &#160; &#160; &#160;我们执行以下操作的时候，一定要确定hadoop是正常运行的，使用jps命令确保看到各个hadoop进程。

我们执行hadoop fs，

```
[root@master ~]# hdfs dfs -ls /
Found 3 items
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 15:09 /cmz
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 13:34 /tmp
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 13:33 /user
[root@master ~]# hadoop fs
Usage: hadoop fs [generic options]
	[-appendToFile <localsrc> ... <dst>]
	[-cat [-ignoreCrc] <src> ...]
	[-checksum <src> ...]
	[-chgrp [-R] GROUP PATH...]
	[-chmod [-R] <MODE[,MODE]... | OCTALMODE> PATH...]
	[-chown [-R] [OWNER][:[GROUP]] PATH...]
	[-copyFromLocal [-f] [-p] [-l] <localsrc> ... <dst>]
	[-copyToLocal [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
	[-count [-q] [-h] [-v] [-x] <path> ...]
	[-cp [-f] [-p | -p[topax]] <src> ... <dst>]
	[-createSnapshot <snapshotDir> [<snapshotName>]]
	[-deleteSnapshot <snapshotDir> <snapshotName>]
	[-df [-h] [<path> ...]]
	[-du [-s] [-h] [-x] <path> ...]
	[-expunge]
	[-find <path> ... <expression> ...]
	[-get [-p] [-ignoreCrc] [-crc] <src> ... <localdst>]
	[-getfacl [-R] <path>]
	[-getfattr [-R] {-n name | -d} [-e en] <path>]
	[-getmerge [-nl] <src> <localdst>]
	[-help [cmd ...]]
	[-ls [-C] [-d] [-h] [-q] [-R] [-t] [-S] [-r] [-u] [<path> ...]]
	[-mkdir [-p] <path> ...]
	[-moveFromLocal <localsrc> ... <dst>]
	[-moveToLocal <src> <localdst>]
	[-mv <src> ... <dst>]
	[-put [-f] [-p] [-l] <localsrc> ... <dst>]
	[-renameSnapshot <snapshotDir> <oldName> <newName>]
	[-rm [-f] [-r|-R] [-skipTrash] <src> ...]
	[-rmdir [--ignore-fail-on-non-empty] <dir> ...]
	[-setfacl [-R] [{-b|-k} {-m|-x <acl_spec>} <path>]|[--set <acl_spec> <path>]]
	[-setfattr {-n name [-v value] | -x name} <path>]
	[-setrep [-R] [-w] <rep> <path> ...]
	[-stat [format] <path> ...]
	[-tail [-f] <file>]
	[-test -[defsz] <path>]
	[-text [-ignoreCrc] <src> ...]
	[-touchz <path> ...]
	[-usage [cmd ...]]

Generic options supported are
-conf <configuration file>     specify an application configuration file
-D <property=value>            use value for given property
-fs <local|namenode:port>      specify a namenode
-jt <local|resourcemanager:port>    specify a ResourceManager
-files <comma separated list of files>    specify comma separated files to be copied to the map reduce cluster
-libjars <comma separated list of jars>    specify comma separated jar files to include in the classpath.
-archives <comma separated list of archives>    specify comma separated archives to be unarchived on the compute machines.

The general command line syntax is
bin/hadoop command [genericOptions] [commandOptions]
```


## 2. 基本指令

选项名称| 使用格式| 含义
---|---|---
-ls | -ls <路径> | 查看指定路径的当前目录结构
-lsr | -lsr <路径> | 递归查看指定路径的目录结构
-du | -du <路径> | 统计目录下个文件大小
-dus | -dus <路径> |汇总统计目录下文件(夹)大小
-count | -count [-q] <路径> | 统计文件(夹)数量
-mv | -mv <源路径> <目的路径> | 移动
-cp | -cp <源路径> <目的路径> | 复制
-rm | -rm [-skipTrash] <路径> |删除文件/空白文件夹
-rmr | -rmr [-skipTrash] <路径> | 递归删除
-put | -put <多个linux上的文件> <hdfs路径> | 上传文件
-copyFromLocal| -copyFromLocal <多个linux上的文件> <hdfs路径> | 从本地复制
-moveFromLocal | -moveFromLocal <多个linux上的文件> <hdfs路径> | 从本地移动
-getmerge | -getmerge <源路径> <linux路径> | 合并到本地
-cat | -cat <hdfs路径> | 查看文件内容
-text | -text <hdfs路径> | 查看文件内容
-copyToLocal | -copyToLocal [-ignoreCrc] [-crc] [hdfs源路径] [linux目的路径] | 从本地复制
-moveToLocal | -moveToLocal [-crc] <hdfs源路径> <linux目的路径> | 从本地移动
-mkdir | -mkdir <hdfs路径> | 创建空白文件夹
-setrep | -setrep [-R] [-w] <副本数> <路径> | 修改副本数量
-touchz | -touchz <文件路径> | 创建空白文件
-stat | -stat [format] <路径> | 显示文件统计信息
-tail | -tail [-f] <文件> | 查看文件尾部信息
-chmod | -chmod [-R] <权限模式> [路径] | 修改权限
-chown | -chown [-R] [属主][:[属组]] 路径 | 修改属主
-chgrp | -chgrp [-R] 属组名称 路径 | 修改属组
-help | -help [命令选项] | 帮助

### 2.1 ls
-ls 显示当前目录结构,命令选项表示查看指定路径的当前目录结构，后面跟hdfs路径

```
[root@master ~]# hdfs dfs -ls /
Found 3 items
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 15:09 /cmz
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 13:34 /tmp
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 13:33 /user
```
上图中的路径是hdfs根目录，显示的内容格式与linux的命令ls –l显示的内容格式非常相似，下面解析每一行的内容格式：


!!! note "解释"
    ```python
    上图中的路径是hdfs根目录，显示的内容格式与linux的命令ls –l显示的内容格式非常相似，下面解析每一行的内容格式：
    
    首字母表示文件夹(如果是“d”)还是文件（如果是“-”）；
    后面的9位字符表示权限；
    后面的数字或者“-”表示副本数。如果是文件，使用数字表示副本数；文件夹没有副本；
    后面的“root”表示属主；
    后面的“supergroup”表示属组；
    后面的“0”、“6176”、“37645”表示文件大小，单位是字节；
    后面的时间表示修改时间，格式是年月日时分；
    最后一项表示文件路径。
    可见根目录下面有四个文件夹、两个文件。
    如果该命令选项后面没有路径，那么就会访问/user/<当前用户>目录。
    ```
### 2.2 lsr
递归显示
```
[root@master ~]# hdfs dfs -ls -R  /
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 15:09 /cmz
-rw-r--r--   3 hdfs supergroup        231 2019-04-01 15:09 /cmz/hosts
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 13:34 /tmp
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:17 /tmp/.cloudera_health_monitoring_canary_files
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
drwxr-xr-x   - hdfs   supergroup          0 2019-04-01 13:33 /user
drwxrwxrwx   - mapred hadoop              0 2019-04-01 13:33 /user/history
drwxrwx---   - mapred hadoop              0 2019-04-01 13:33 /user/history/done
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /user/history/done_intermediate
```

### 2.3 du
统计目录下各文件大小，该命令选项显示指定路径下的文件大小，单位是字节。
```
[root@master ~]# hdfs dfs -du /cmz
231  693  /cmz/hosts
```
### 2.4 dus
汇总统计目录下文件大小，该命令选项显示指定路径的文件大小，单位是字节。
```
[root@master ~]# hdfs dfs -du -s /cmz
231  693  /cmz
```
### 2.5 count
count 统计文件(夹)数量，该命令选项显示指定路径下的文件夹数量、文件数量、文件总大小信息。

```
[root@master ~]# hdfs dfs -count /user
           4            0                  0 /user
[root@master ~]# hdfs dfs -ls -R /user
drwxrwxrwx   - mapred hadoop          0 2019-04-01 13:33 /user/history
drwxrwx---   - mapred hadoop          0 2019-04-01 13:33 /user/history/done
drwxrwxrwt   - mapred hadoop          0 2019-04-01 13:33 /user/history/done_intermediate
```

### 2.6 mv 
该命令选项表示移动hdfs的文件到指定的hdfs目录中。后面跟两个路径，第一个表示源文件，第二个表示目的目录。

```
[root@master ~]# hdfs dfs -ls -R /
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 15:09 /cmz
-rw-r--r--   3 hdfs supergroup        231 2019-04-01 15:09 /cmz/hosts
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 13:34 /tmp
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:23 /tmp/.cloudera_health_monitoring_canary_files
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
drwxr-xr-x   - hdfs   supergroup          0 2019-04-01 13:33 /user
drwxrwxrwx   - mapred hadoop              0 2019-04-01 13:33 /user/history
drwxrwx---   - mapred hadoop              0 2019-04-01 13:33 /user/history/done
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /user/history/done_intermediate
[root@master ~]# hdfs dfs -mv /cmz/hosts /tmp/
[root@master ~]# hdfs dfs -ls -R /
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 22:24 /cmz
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 22:24 /tmp
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:23 /tmp/.cloudera_health_monitoring_canary_files
-rw-r--r--   3 hdfs   supergroup        231 2019-04-01 15:09 /tmp/hosts
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
drwxr-xr-x   - hdfs   supergroup          0 2019-04-01 13:33 /user
drwxrwxrwx   - mapred hadoop              0 2019-04-01 13:33 /user/history
drwxrwx---   - mapred hadoop              0 2019-04-01 13:33 /user/history/done
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /user/history/done_intermediate
[root@master ~]#
```

### 2.7 cp
该命令选项表示复制hdfs指定的文件到指定的hdfs目录中。后面跟两个路径，第一个是被复制的文件，第二个是目的地。

```
[root@master ~]# hdfs dfs -ls -R /tmp
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:25 /tmp/.cloudera_health_monitoring_canary_files
-rw-r--r--   3 hdfs   supergroup        231 2019-04-01 15:09 /tmp/hosts
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
[root@master ~]# hdfs dfs -ls -R /cmz
[root@master ~]# hdfs dfs -cp /tmp/hosts /cmz
[root@master ~]# hdfs dfs -ls -R /cmz
-rw-r--r--   3 root supergroup        231 2019-04-01 22:26 /cmz/hosts
```

### 2.8 rm
该命令选项表示删除指定的文件或者空目录。

```
[root@master ~]# hdfs dfs -ls -R /cmz
-rw-r--r--   3 root supergroup        231 2019-04-01 22:26 /cmz/hosts
[root@master ~]# hdfs dfs -rm /cmz/hosts
19/04/01 22:27:15 INFO fs.TrashPolicyDefault: Moved: 'hdfs://master:8020/cmz/hosts' to trash at: hdfs://master:8020/user/root/.Trash/Current/cmz/hosts
[root@master ~]# hdfs dfs -ls -R /cmz
```
> 不能删除非空目录

### 2.9 rmr 
该命令选项表示递归删除指定目录下的所有子目录和文件
```
[root@master ~]# hdfs dfs -ls -R /cmz
drwxr-xr-x   - root supergroup          0 2019-04-01 22:28 /cmz/a
-rw-r--r--   3 root supergroup        231 2019-04-01 22:28 /cmz/a/hosts
drwxr-xr-x   - root supergroup          0 2019-04-01 22:28 /cmz/b
-rw-r--r--   3 root supergroup        231 2019-04-01 22:28 /cmz/b/hosts
[root@master ~]# hdfs dfs -rmr /cmz
rmr: DEPRECATED: Please use 'rm -r' instead.
^Crmr: Filesystem closed. Consider using -skipTrash option
[root@master ~]# ^C
[root@master ~]# hdfs dfs -rm -r /cmz
19/04/01 22:29:26 INFO fs.TrashPolicyDefault: Moved: 'hdfs://master:8020/cmz' to trash at: hdfs://master:8020/user/root/.Trash/Current/cmz1554128966724
[root@master ~]# hdfs dfs -ls -R /cmz
ls: `/cmz': No such file or directory
```
### 2.10 put
该命令选项表示把linux上的文件复制到hdfs中，

```
[root@master ~]# hdfs dfs -ls -R /tmp
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:29 /tmp/.cloudera_health_monitoring_canary_files
-rw-r--r--   3 hdfs   supergroup        231 2019-04-01 15:09 /tmp/hosts
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
[root@master ~]# hdfs dfs -put /etc/passwd /tmp/
[root@master ~]# hdfs dfs -ls -R /tmp
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:31 /tmp/.cloudera_health_monitoring_canary_files
-rw-r--r--   3 hdfs   supergroup        231 2019-04-01 15:09 /tmp/hosts
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
-rw-r--r--   3 root   supergroup       1851 2019-04-01 22:31 /tmp/passwd
```

### 2.11 copyFromLocal 
类似put一致。

### 2.12 moveFromLocal 
表示把文件从本地移动到hdfs中。
```
[root@master ~]# echo 'test for caimemzhi' > cmz.txt
[root@master ~]# ls cmz.txt
cmz.txt
[root@master ~]# hdfs dfs -moveFromLocal cmz.txt /tmp/
[root@master ~]# ls
anaconda-ks.cfg  cmz  loocha  mainfests
[root@master ~]# hdfs dfs -ls /tmp
Found 6 items
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:34 /tmp/.cloudera_health_monitoring_canary_files
-rw-r--r--   3 root   supergroup         19 2019-04-01 22:34 /tmp/cmz.txt
-rw-r--r--   3 root   supergroup        231 2019-04-01 22:32 /tmp/cmz_hosts
-rw-r--r--   3 hdfs   supergroup        231 2019-04-01 15:09 /tmp/hosts
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
-rw-r--r--   3 root   supergroup       1851 2019-04-01 22:31 /tmp/passwd
```

### 2.13 getmerge
该命令选项的含义是把hdfs指定目录下的所有文件内容合并到本地文件中。

```
[root@master ~]# hdfs dfs -ls /tmp
Found 6 items
drwxrwxrwx   - hdfs   supergroup          0 2019-04-01 22:34 /tmp/.cloudera_health_monitoring_canary_files
-rw-r--r--   3 root   supergroup         19 2019-04-01 22:34 /tmp/cmz.txt
-rw-r--r--   3 root   supergroup        231 2019-04-01 22:32 /tmp/cmz_hosts
-rw-r--r--   3 hdfs   supergroup        231 2019-04-01 15:09 /tmp/hosts
drwxrwxrwt   - mapred hadoop              0 2019-04-01 13:33 /tmp/logs
-rw-r--r--   3 root   supergroup       1851 2019-04-01 22:31 /tmp/passwd
[root@master ~]# ls
anaconda-ks.cfg  cmz  loocha  mainfests
[root@master ~]# hdfs dfs -getmerge /tmp/ local_text.txt
[root@master ~]# cat local_text.txt
test for caimemzhi
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.186.128  master
192.168.186.129  slave1
192.168.186.137  slave2
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.186.128  master
192.168.186.129  slave1
192.168.186.137  slave2
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
nginx:x:1000:1000::/home/nginx:/sbin/nologin
mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
cloudera-scm:x:997:993:Cloudera SCM User:/opt/cloudera-manager/cm-5.13.1/run/cloudera-scm-server/:/bin/false
flume:x:996:991:Flume:/var/lib/flume-ng:/bin/false
hdfs:x:995:990:Hadoop HDFS:/var/lib/hadoop-hdfs:/bin/bash
solr:x:994:989:Solr:/var/lib/solr:/sbin/nologin
zookeeper:x:993:988:ZooKeeper:/var/lib/zookeeper:/bin/false
llama:x:992:987:Llama:/var/lib/llama:/bin/bash
httpfs:x:991:986:Hadoop HTTPFS:/var/lib/hadoop-httpfs:/bin/bash
mapred:x:990:985:Hadoop MapReduce:/var/lib/hadoop-mapreduce:/bin/bash
sqoop:x:989:984:Sqoop:/var/lib/sqoop:/bin/false
yarn:x:988:983:Hadoop Yarn:/var/lib/hadoop-yarn:/bin/bash
kms:x:987:982:Hadoop KMS:/var/lib/hadoop-kms:/bin/bash
hive:x:986:981:Hive:/var/lib/hive:/bin/false
sqoop2:x:985:980:Sqoop 2 User:/var/lib/sqoop2:/sbin/nologin
oozie:x:984:979:Oozie User:/var/lib/oozie:/bin/false
kudu:x:983:978:Kudu:/var/lib/kudu:/sbin/nologin
hbase:x:982:977:HBase:/var/lib/hbase:/bin/false
sentry:x:981:976:Sentry:/var/lib/sentry:/sbin/nologin
impala:x:980:975:Impala:/var/lib/impala:/bin/bash
spark:x:979:974:Spark:/var/lib/spark:/sbin/nologin
hue:x:978:973:Hue:/usr/lib/hue:/bin/false
```

### 2.14 cat
该命令选项是查看文件内容
```
[root@master ~]# hdfs dfs -cat /tmp/cmz.txt
test for caimemzhi
```

### 2.15 text
该命令选项可以认为作用和用法与-cat相同，此处略。

### 2.16 mkdir
mkdir 创建空白文件夹，后面跟的路径是在hdfs将要创建的文件夹

```
[root@master ~]# hdfs dfs -ls /
Found 2 items
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 22:34 /tmp
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 22:27 /user
[root@master ~]# hdfs dfs -mkdir /cmz
[root@master ~]# hdfs dfs -ls /
Found 3 items
drwxr-xr-x   - root supergroup          0 2019-04-01 22:39 /cmz
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 22:34 /tmp
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 22:27 /user
```

### 2.17 setrep
该命令选项是修改 ==已保存文件== 的副本数量，后面跟副本数量，再跟文件路径。

```
[root@master ~]# hdfs dfs -ls /
Found 3 items
drwxr-xr-x   - root supergroup          0 2019-04-01 22:39 /cmz
drwxrwxrwt   - hdfs supergroup          0 2019-04-01 22:34 /tmp
drwxr-xr-x   - hdfs supergroup          0 2019-04-01 22:27 /user
[root@master ~]# hdfs dfs -put /etc/hosts /cmz/
[root@master ~]# hdfs dfs -ls /cmz
Found 1 items
-rw-r--r--   3 root supergroup        231 2019-04-01 22:40 /cmz/hosts
[root@master ~]# hdfs dfs -setrep 2 /cmz/hosts
Replication 2 set: /cmz/hosts
[root@master ~]# hdfs dfs -ls /cmz
Found 1 items
-rw-r--r--   2 root supergroup        231 2019-04-01 22:40 /cmz/hosts
```
默认是3份副本，我手动设置为2份副本。即使我改变文件夹的副本数是2，以后再新上传到该文件夹下的文件还是默认是3。

> 如果最后的路径表示文件夹，那么需要跟选项-R，表示对文件夹中的所有文件都修改副本，还有一个选项是-w，表示等待副本操作结束才退出命令，如图4-18所示

### 2.18 touch
该命令选项是在hdfs中创建空白文件。

```
[root@master ~]# hdfs dfs -touchz /cmz/leco.txt
[root@master ~]# hdfs dfs -ls /cmz
Found 4 items
-rw-r--r--   2 root supergroup          7 2019-04-01 22:42 /cmz/hostname
-rw-r--r--   2 root supergroup        231 2019-04-01 22:40 /cmz/hosts
-rw-r--r--   3 root supergroup          0 2019-04-01 22:46 /cmz/leco.txt
-rw-r--r--   3 root supergroup       1851 2019-04-01 22:43 /cmz/passwd
```

### 2.19 stat
该命令选项显示文件的一些统计信息。

```
[root@master ~]# hdfs dfs -ls /cmz
Found 4 items
-rw-r--r--   2 root supergroup          7 2019-04-01 22:42 /cmz/hostname
-rw-r--r--   2 root supergroup        231 2019-04-01 22:40 /cmz/hosts
-rw-r--r--   3 root supergroup          0 2019-04-01 22:46 /cmz/leco.txt
-rw-r--r--   3 root supergroup       1851 2019-04-01 22:43 /cmz/passwd
[root@master ~]# hdfs dfs -stat /cmz
2019-04-01 14:46:10
[root@master ~]# hdfs dfs -stat /cmz/hosts
2019-04-01 14:40:54
[root@master ~]# hdfs dfs -stat '%b %n %o %r %Y' /cmz/hosts
231 hosts 134217728 2 1554129654178
```
> 命令选项后面可以有格式，使用引号表示。示例中的格式“%b %n %o %r %Y”依次表示文件大小、文件名称、块大小、副本数、访问时间

### 2.20 tail 
该命令选项显示文件最后1K字节的内容。一般用于查看日志。如果带有选项-f，那么当文件内容变化时，也会自动显示。

```
[root@master ~]# hdfs dfs -tail /tmp/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.186.128  master
192.168.186.129  slave1
192.168.186.137  slave2
```

### 2.21 chmod
该命令选项的使用类似于linux的shell中的chmod用法

```
[root@master ~]# hdfs dfs -ls /cmz/hosts
-rw-r--r--   2 root supergroup        231 2019-04-01 22:40 /cmz/hosts
[root@master ~]# hdfs dfs -chmod 777 /cmz/hosts
[root@master ~]# hdfs dfs -ls /cmz/hosts
-rwxrwxrwx   2 root supergroup        231 2019-04-01 22:40 /cmz/hosts
```

> 如果加上选项-R，可以对文件夹中的所有文件修改权限

### 2.22 chown 
该命令选项表示修改文件的属主,如果带有选项-R，意味着可以递归修改文件夹中的所有文件的属主、属组信息。

### 2.23 chgrp
该命令的作用是修改文件的属组，该命令相当于“chown :属组”的用法.

### 2.24 appendToFile 
向HDFS中指定的文件追加内容，由用户指定内容追加到原有文件的开头或结尾
```
[root@master ~]# echo 'test for caimengzhi'>test.txt
[root@master ~]# hdfs dfs -cat /cmz/leco.txt
[root@master ~]# hdfs dfs -appendToFile test.txt /cmz/leco.txt
[root@master ~]# hdfs dfs -cat /cmz/leco.txt
test for caimengzhi
```

### 2.25 help
该命令选项会显示帮助信息，后面跟上需要查询的命令选项即可。

```
[root@master ~]# hdfs dfs -help chown
-chown [-R] [OWNER][:[GROUP]] PATH... :
  Changes owner and group of a file. This is similar to the shell's chown command
  with a few exceptions.

  -R  modifies the files recursively. This is the only option currently
      supported.

  If only the owner or group is specified, then only the owner or group is
  modified. The owner and group names may only consist of digits, alphabet, and
  any of [-_./@a-zA-Z0-9]. The names are case sensitive.

  WARNING: Avoid using '.' to separate user name and group though Linux allows it.
  If user names have dots in them and you are using local file system, you might
  see surprising results since the shell command 'chown' is used for local files.
```

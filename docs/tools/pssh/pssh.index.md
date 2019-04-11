<center><h1> pssh </h1></center>

## 1. 起因
&#160; &#160; &#160; pssh命令是一个python编写可以在多台服务器上执行命令的工具，同时支持拷贝文件，是同类工具中很出色的，类似pdsh，个人认为相对pdsh更为简便，使用必须在各个服务器上配置好密钥认证访问。

## 2. 部署
### 2.1 在线装

```
# ubuntu 
apt-get install pssh -y
# centos
yum install pssh -y
# mac
brew install pssh -y
```

### 2.2 离线安装

​	若是没有网络的机器，可以选择离线安装。` https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/parallel-ssh/pssh-2.3.1.tar.gz`

下载后解码压，然后进入源码目录：

```
wget http://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz
tar xf pssh-2.3.1.tar.gz
cd pssh-2.3.1/
python setup.py install
```


## 3. 基本参数
 &#160; &#160; pssh参数

??? note "常见参数"
    ```python
    root@master:~/pssh-2.3.1# pssh --help
    Usage: pssh [OPTIONS] command [...]

    Options:
      --version             show program's version number and exit
      --help                show this help message and exit
      -h HOST_FILE, --hosts=HOST_FILE
                            hosts file (each line "[user@]host[:port]")
      -H HOST_STRING, --host=HOST_STRING
                            additional host entries ("[user@]host[:port]")
      -l USER, --user=USER  username (OPTIONAL)
      -p PAR, --par=PAR     max number of parallel threads (OPTIONAL)
      -o OUTDIR, --outdir=OUTDIR
                            output directory for stdout files (OPTIONAL)
      -e ERRDIR, --errdir=ERRDIR
                            output directory for stderr files (OPTIONAL)
      -t TIMEOUT, --timeout=TIMEOUT
                            timeout (secs) (0 = no timeout) per host (OPTIONAL)
      -O OPTION, --option=OPTION
                            SSH option (OPTIONAL)
      -v, --verbose         turn on warning and diagnostic messages (OPTIONAL)
      -A, --askpass         Ask for a password (OPTIONAL)
      -x ARGS, --extra-args=ARGS
                            Extra command-line arguments, with processing for
                            spaces, quotes, and backslashes
      -X ARG, --extra-arg=ARG
                            Extra command-line argument
      -i, --inline          inline aggregated output and error for each server
      --inline-stdout       inline standard output for each server
      -I, --send-input      read from standard input and send as input to ssh
      -P, --print           print output as we get it
    
    Example: pssh -h hosts.txt -l irb2 -o /tmp/foo uptime
    ```

中文解释

```
--version：查看版本
--help：查看帮助，即此信息
-h：主机文件列表，内容格式”[user@]host[:port]”
-H：主机字符串，内容格式”[user@]host[:port]”
-：登录使用的用户名
-p：并发的线程数【可选】
-o：输出的文件目录【可选】
-e：错误输入文件【可选】
-t：TIMEOUT 超时时间设置，0无限制【可选】
-O：SSH的选项
-v：详细模式
-A：手动输入密码模式
-x：额外的命令行参数使用空白符号，引号，反斜线处理
-X：额外的命令行参数，单个参数模式，同-x
-i：每个服务器内部处理信息输出
-P：打印出服务器返回信息
```

## 4. 基本使用

执行pssh的机器一定要先做好线性关系(无密码链接)

```
root@master:/opt# egrep -i 'node1|node2|node3' /etc/hosts
192.168.178.128 node3
192.168.178.129 node2
192.168.178.130 node1
```

配置一个文件[后面pssh会加载这个文件]，里面配置远端的机器

```
root@master:/opt# cat ip.txt 
node1
node2
node3
```
> 也可以直接写ip地址

### 4.1 查看时间

获取每台服务器的时间

```
root@master:/opt# pssh -h ip.txt -i date
[1] 12:12:15 [SUCCESS] node1
Wed Apr 10 21:12:15 PDT 2019
[2] 12:12:15 [SUCCESS] node2
Wed Apr 10 21:12:15 PDT 2019
[3] 12:12:15 [SUCCESS] node3
Wed Apr 10 21:12:15 PDT 2019
```

### 4.2 查看进程

查看每台服务器上mongo线程运行状态信息：

```
root@master:/opt# pssh -h ip.txt -i 'ps aux|grep mongo'
[1] 12:13:35 [SUCCESS] node2
root       3578  0.0  0.1  19592  2920 ?        Ss   21:13   0:00 bash -c ps aux|grep mongo
root       3581  0.0  0.0  21264   944 ?        S    21:13   0:00 grep mongo
[2] 12:13:35 [SUCCESS] node3
root       3614  0.0  0.2  19592  2932 ?        Ss   21:13   0:00 bash -c ps aux|grep mongo
root       3617  0.0  0.0  21264   924 ?        S    21:13   0:00 grep mongo
[3] 12:13:35 [SUCCESS] node1
root       2549  0.0  0.3  19592  2996 ?        Ss   21:13   0:00 bash -c ps aux|grep mongo
root       2552  0.0  0.1  21264  1088 ?        R    21:13   0:00 grep mongo
root       9867  1.0  5.7 1689044 57016 ?       Sl   Apr05  87:23 mongod -f /app/mongo/services/shard1/mongod.conf
root       9899  1.0  5.6 1647068 55948 ?       Sl   Apr05  86:21 mongod -f /app/mongo/services/shard2/mongod.conf
root       9931  1.0  5.8 1740472 57288 ?       Sl   Apr05  91:04 mongod -f /app/mongo/services/shard3/mongod.conf
root       9963  1.4 16.2 1747468 159736 ?      Sl   Apr05 122:25 mongod -f /app/mongo/services/configsvr/cfg.conf
root      10221  0.4  1.2 291696 12804 ?        Sl   Apr05  37:41 mongos -f /app/mongo/services/mongos/mongos.conf
```

### 4.3 查看文件

查看/opt下文件

```
root@master:/opt# pssh -h ip.txt -i 'ls /opt'
[1] 12:15:20 [SUCCESS] node2
cloudera
old
[2] 12:15:20 [SUCCESS] node1
cloudera
cloudera-manager
[3] 12:15:20 [SUCCESS] node3
```

### 4.4 上传文件

拷贝本地文件到远端

```shell
root@master:/opt# echo 'cmz'>cmz.txt
root@master:/opt# pscp  -h  ip.txt cmz.txt   /tmp/
[1] 12:17:42 [SUCCESS] node2
[2] 12:17:42 [SUCCESS] node1
[3] 12:17:42 [SUCCESS] node3
root@master:/opt# pssh -h ip.txt -i 'ls /tmp/cmz.txt'
[1] 12:19:26 [SUCCESS] node1
/tmp/cmz.txt
[2] 12:19:26 [SUCCESS] node2
/tmp/cmz.txt
[3] 12:19:26 [SUCCESS] node3
/tmp/cmz.txt
```

### 4.5 下载文件

从远端服务器文件下载到本地

```
root@master:/opt# pslurp -h ip.txt  -L /opt /tmp/cmz.txt new_cmz.conf
[1] 12:42:40 [SUCCESS] node1
[2] 12:42:40 [SUCCESS] node2
[3] 12:42:40 [SUCCESS] node3
root@master:/opt# ls
chain  cloudera  cloudera-manager  ip.txt  node1  node2  node3  pycharm-2018.3.1  teamviewer
root@master:/opt# tree node1 node2 node3
node1
└── new_cmz.conf
node2
└── new_cmz.conf
node3
└── new_cmz.conf

0 directories, 3 files
```

上边是，将所有远程主机 /tmp/cmz.txt复制到本地主机/home/目录下，并且重新命名为new_cmz.conf, -L 来指定本地文件路径

### 4.6 下载目录

可以从远端下载文件到本地

```
root@master:/opt#  pslurp -h ip.txt -r -L /home/  /usr/local/mongo/ new_dir
[1] 12:46:15 [SUCCESS] node1
[2] 12:46:18 [SUCCESS] node2
[3] 12:46:26 [SUCCESS] node3
root@master:/opt# ls /home/
cmz  node1  node2  node3
root@master:/opt# ls  /home/node1
new_dir
root@master:/opt# ls  /home/node2
new_dir
root@master:/opt# ls  /home/node3
new_dir
```

可以看到从远端直接把/usr/local/mongo的文件夹下载到本地指定目录

### 4.6 杀死进程

pnuke杀掉某一进程，这个命令类似  killall命令

```
root@master:/opt# pssh -h ip.txt -i 'ps aux|grep mongo'
[1] 12:36:32 [SUCCESS] node3
root       5746  1.1  7.3 1498580 72724 ?       Sl   21:22   0:09 mongod -f /app/mongo/services/shard1/mongod.conf
root       5839  1.0  7.3 1482928 72160 ?       Sl   21:22   0:09 mongod -f /app/mongo/services/shard2/mongod.conf
root       5952  1.0  7.5 1517928 74072 ?       Sl   21:22   0:08 mongod -f /app/mongo/services/shard3/mongod.conf
root       6049  1.2  7.6 1481008 75508 ?       Sl   21:22   0:10 mongod -f /app/mongo/services/configsvr/cfg.conf
root       7250  0.0  0.2  19592  2876 ?        Ss   21:36   0:00 bash -c ps aux|grep mongo
root       7253  0.0  0.0  21264   932 ?        S    21:36   0:00 grep mongo
[2] 12:36:36 [SUCCESS] node2
root       6167  1.2  3.8 1523968 78244 ?       Sl   21:21   0:10 mongod -f /app/mongo/services/shard1/mongod.conf
root       6235  1.1  3.6 1508944 74500 ?       Sl   21:21   0:10 mongod -f /app/mongo/services/shard2/mongod.conf
root       6354  1.1  3.6 1490268 72800 ?       Sl   21:21   0:10 mongod -f /app/mongo/services/shard3/mongod.conf
root       6440  1.5  4.0 1535304 80932 ?       Sl   21:21   0:13 mongod -f /app/mongo/services/configsvr/cfg.conf
root       6534  0.3  1.3 226804 27376 ?        Sl   21:21   0:03 mongos -f /app/mongo/services/mongos/mongos.conf
root       7757  0.0  0.1  19592  2952 ?        Ss   21:36   0:00 bash -c ps aux|grep mongo
root       7760  0.0  0.0  21264   956 ?        S    21:36   0:00 grep mongo
[3] 12:36:38 [SUCCESS] node1
root       5769  0.0  0.3  19592  2964 ?        Ss   21:36   0:00 bash -c ps aux|grep mongo
root       5772  0.0  0.1  21264  1012 ?        S    21:36   0:00 grep mongo
root       9867  1.0  7.4 1705464 72904 ?       Sl   Apr05  87:46 mongod -f /app/mongo/services/shard1/mongod.conf
root       9899  1.0  6.6 1675796 65804 ?       Sl   Apr05  86:40 mongod -f /app/mongo/services/shard2/mongod.conf
root       9931  1.0  7.0 1768172 69144 ?       Sl   Apr05  91:24 mongod -f /app/mongo/services/shard3/mongod.conf
root       9963  1.4 17.3 1772084 171388 ?      Sl   Apr05 122:48 mongod -f /app/mongo/services/configsvr/cfg.conf
root      10221  0.4  1.2 291696 12756 ?        Sl   Apr05  37:48 mongos -f /app/mongo/services/mongos/mongos.conf

# 杀死进程
root@master:/opt# pnuke  -h  ip.txt   mongod
[1] 12:37:01 [SUCCESS] node2
[2] 12:37:01 [SUCCESS] node1
[3] 12:37:01 [SUCCESS] node3
root@master:/opt# pssh -h ip.txt -i 'ps aux|grep mongo'
[1] 12:37:05 [SUCCESS] node2
root       6534  0.3  1.3 226804 27376 ?        Sl   21:21   0:03 mongos -f /app/mongo/services/mongos/mongos.conf
root       7878  0.0  0.1  19592  2952 ?        Ss   21:37   0:00 bash -c ps aux|grep mongo
root       7881  0.0  0.0  21264   936 ?        S    21:37   0:00 grep mongo
[2] 12:37:05 [SUCCESS] node1
root       6021  0.0  0.3  19592  3000 ?        Ss   21:37   0:00 bash -c ps aux|grep mongo
root       6024  0.0  0.1  21264  1020 ?        R    21:37   0:00 grep mongo
root      10221  0.4  1.2 291696 12756 ?        Sl   Apr05  37:48 mongos -f /app/mongo/services/mongos/mongos.conf
[3] 12:37:05 [SUCCESS] node3
root       7424  0.0  0.2  19592  2928 ?        Ss   21:37   0:00 bash -c ps aux|grep mongo
root       7427  0.0  0.0  21264   932 ?        S    21:37   0:00 grep mongo

```

上边的意思是在远程主机上批量关闭mongo服务。能通过killall关闭的服务，都可以通过pnuke来批量完成

> 建议分发文件，执行命令，批量杀死进程，使用pssh,pscp，pnuke,速度很快的

<center><h1>Linux命令 进程管理</h1></center>
> 作者: caimengzhi - 2019/05/14

## 9. Linux 进程管理

### 9.1 ps

&emsp;Linux ps命令用于显示当前进程 (process) 的状态。

**语法**

```
ps [options] [--help]
```

**参数**：

- ps 的参数非常多, 在此仅列出几个常用的参数并大略介绍含义
- -A 列出所有的行程
- -w 显示加宽可以显示较多的资讯
- -au 显示较详细的资讯
- -aux 显示所有包含其他使用者的行程
- au(x) 输出格式 :
- USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND
- USER: 行程拥有者
- PID: pid
- %CPU: 占用的 CPU 使用率
- %MEM: 占用的记忆体使用率
- VSZ: 占用的虚拟记忆体大小
- RSS: 占用的记忆体大小
- TTY: 终端的次要装置号码 (minor device number of tty)
- STAT: 该行程的状态:
- D: 无法中断的休眠状态 (通常 IO 的进程)
- R: 正在执行中
- S: 静止状态
- T: 暂停执行
- Z: 不存在但暂时无法消除
- W: 没有足够的记忆体分页可分配
- <: 高优先序的行程
- N: 低优先序的行程
- L: 有记忆体分页分配并锁在记忆体内 (实时系统或捱A I/O)
- START: 行程开始时间
- TIME: 执行的时间
- COMMAND:所执行的指令

```
[root@master01 ~]# ps -A # 显示进程信息
  PID TTY          TIME CMD
    1 ?        00:00:23 systemd
    2 ?        00:00:00 kthreadd
    3 ?        00:00:30 ksoftirqd/0
    5 ?        00:00:00 kworker/0:0H
    7 ?        00:00:00 migration/0
    8 ?        00:00:00 rcu_bh
    9 ?        00:12:39 rcu_sched
   10 ?        00:00:00 lru-add-drain
   11 ?        00:00:02 watchdog/0
   12 ?        00:00:02 watchdog/1
   13 ?        00:00:07 migration/1
   14 ?        00:00:22 ksoftirqd/1
   16 ?        00:00:00 kworker/1:0H
   17 ?        00:00:02 watchdog/2
   18 ?        00:00:00 migration/2
   19 ?        00:00:49 ksoftirqd/2
   。。。。。。。省略。。。。。。。
   
   [root@master01 ~]#  ps -u root # 显示root进程用户信息
  PID TTY          TIME CMD
    1 ?        00:00:23 systemd
    2 ?        00:00:00 kthreadd
    3 ?        00:00:30 ksoftirqd/0
    5 ?        00:00:00 kworker/0:0H
    7 ?        00:00:00 migration/0
    8 ?        00:00:00 rcu_bh
    9 ?        00:12:39 rcu_sched
   10 ?        00:00:00 lru-add-drain
   11 ?        00:00:02 watchdog/0
   12 ?        00:00:02 watchdog/1
   13 ?        00:00:07 migration/1
   。。。。。。。省略。。。。。。。
   
   [root@master01 ~]#  ps -ef # 显示所有命令，连带命令行
	UID        PID  PPID  C STIME TTY          TIME CMD
	。。。。。。。省略。。。。。。。
	root      3386     1  0 May09 ?        00:00:08 /usr/lib/systemd/systemd-logind
    chrony    3404     1  0 May09 ?        00:00:02 /usr/sbin/chronyd
    root      3405     1  0 May09 ?        00:00:43 /usr/sbin/irqbalance --foreground
    dbus      3406     1  0 May09 ?        00:00:19 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation
    root      3407     1  0 May09 ?        00:00:13 /usr/sbin/NetworkManager --no-daemon
    polkitd   3411     1  0 May09 ?        00:00:05 /usr/lib/polkit-1/polkitd --no-debug
    root      3438     1  0 May09 ?        00:00:01 /usr/sbin/crond -n
    root      3461     1  0 May09 tty1     00:00:00 /sbin/agetty --noclear tty1 linux
    root      3716     1  0 May09 ?        00:00:00 /usr/sbin/sshd -D
    root      3718     1  0 May09 ?        00:33:54 /opt/kubernetes/bin/kube-proxy --logtostderr=true --v=4 --hostname-override=192.168.5.100 --cluster-cidr=10.0.0.0/24 --proxy-mode=ipvs --kube
    root      3719     1  0 May09 ?        00:01:03 /usr/bin/python2 -Es /usr/sbin/tuned -l -P
    root      4016     1  5 May09 ?        06:30:36 /opt/etcd/bin/etcd --name=etcd01 --data-dir=/var/lib/etcd/default.etcd --listen-peer-urls=https://192.168.5.100:2380 --listen-client-urls=htt
    root      4021     1  0 May09 ?        00:56:18 /usr/sbin/rsyslogd -n
    root      4955     2  0 06:30 ?        00:00:14 [kworker/3:0]
    root      5226     1  0 May09 ?        00:00:01 /usr/libexec/postfix/master -w
    postfix   5245  5226  0 May09 ?        00:00:00 qmgr -l -t unix -u
    root      6364     1  1 May09 ?        01:31:56 /usr/bin/dockerd --bip=172.17.7.1/24 --ip-masq=false --mtu=1450
    root      7653  6364  0 May09 ?        00:16:15 containerd --config /var/run/docker/containerd/containerd.toml --log-level info
    root     10370     1  3 May09 ?        04:28:12 /opt/kubernetes/bin/kubelet --logtostderr=true --v=4 --hostname-override=192.168.5.100 --kubeconfig=/opt/kubernetes/cfg/kubelet.kubeconfig --
    root     16133     1  6 May09 ?        07:20:04 /opt/kubernetes/bin/kube-apiserver --logtostderr=true --v=4 --etcd-servers=https://192.168.5.100:2379,https://192.168.5.101:2379,https://192.
    root     16311  7653  0 May09 ?        00:00:30 containerd-shim -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/789ab4c31885616c1088da3f44c995
    root     16347 16311  0 May09 ?        00:00:00 /pause
    root     16370     2  0 03:05 ?        00:00:00 [kworker/u8:1]
    root     16575  7653  0 May09 ?        00:00:30 containerd-shim -namespace moby -workdir /var/lib/docker/containerd/daemon/io.containerd.runtime.v1.linux/moby/3e58cddd264f8bb0fde1f9b560ee4d
    root     16610 16575  0 May09 ?        00:00:00 nginx: master process nginx -g daemon off;
    101      16702 16610  0 May09 ?        00:00:00 nginx: worker process
    root     19352     1  7 May09 ?        09:10:04 /opt/kubernetes/bin/kube-controller-manager --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect=true --address=127.0.0.1 --servic
    root     19361     1  1 May09 ?        02:11:38 /opt/kubernetes/bin/kube-scheduler --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect
    root     20956     2  0 03:50 ?        00:00:32 [kworker/0:0]
	。。。。。。。省略。。。。。。。
```

```
ps -ef 是用标准的格式显示进程的、其格式如下
[root@master01 ~]# ps -ef|head -2
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 May09 ?        00:00:23 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
```

其中各列的内容意思如下

- UID //用户ID、但输出的是用户名 
- PID //进程的ID 
- PPID //父进程ID 
- C //进程占用CPU的百分比 
- STIME //进程启动到现在的时间 
- TTY //该进程在那个终端上运行，若与终端无关，则显示? 若为pts/0等，则表示由网络连接主机进程。 
- CMD //命令的名称和参数

```
ps aux 是用BSD的格式来显示、其格式如下
[root@master01 ~]# ps aux|head -2
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1 125576  4044 ?        Ss   May09   0:23 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
```

同ps -ef 不同的有列有

- USER //用户名 
- %CPU //进程占用的CPU百分比 
- %MEM //占用内存的百分比 
- VSZ //该进程使用的虚拟內存量（KB） 
- RSS //该进程占用的固定內存量（KB）（驻留中页的数量） 
- STAT //进程的状态 
- START //该进程被触发启动时间 
- TIME //该进程实际使用CPU运行的时间

### 9.2 pstree

&emsp;pstree命令以树状图显示进程间的关系（display a tree of processes）。ps命令可以显示当前正在运行的那些进程的信息，但是对于它们之间的关系却显示得不够清晰。在Linux系统中，系统调用fork可以创建子进程，通过子shell也可以创建子进程，Linux系统中进程之间的关系天生就是一棵树，树的根就是进程PID为1的init进程。

**语法**

```
pstree [-a] [-c] [-h|-Hpid] [-l] [-n] [-p] [-u] [-G|-U] [pid|user]
```

或

```
pstree -V
```

**参数说明**：

- -a 显示该行程的完整指令及参数, 如果是被记忆体置换出去的行程则会加上括号
- -c 如果有重覆的行程名, 则分开列出（预设值是会在前面加上 *）

```
没有命令就安装
[root@master01 ~]# yum -y install psmisc
 
[root@master01 ~]# pstree
systemd─┬─NetworkManager───2*[{NetworkManager}]
        ├─agetty
        ├─auditd───{auditd}
        ├─chronyd
        ├─crond
        ├─dbus-daemon
        ├─dockerd─┬─containerd─┬─containerd-shim─┬─pause
        │         │            │                 └─9*[{containerd-shim}]
        │         │            ├─containerd-shim─┬─nginx───nginx
        │         │            │                 └─9*[{containerd-shim}]
        │         │            └─19*[{containerd}]
        │         └─17*[{dockerd}]
        ├─etcd───16*[{etcd}]
        ├─irqbalance
        ├─kube-apiserver───17*[{kube-apiserver}]
        ├─kube-controller───17*[{kube-controller}]
        ├─kube-proxy───15*[{kube-proxy}]
        ├─kube-scheduler───16*[{kube-scheduler}]
        ├─kubelet───21*[{kubelet}]
        ├─lvmetad
        ├─master─┬─pickup
        │        └─qmgr
        ├─polkitd───6*[{polkitd}]
        ├─rsyslogd───2*[{rsyslogd}]
        ├─sshd───sshd───bash───pstree
        ├─systemd-journal
        ├─systemd-logind
        ├─systemd-udevd
        └─tuned───4*[{tuned}]

[root@master01 ~]# pstree -p
systemd(1)─┬─NetworkManager(3407)─┬─{NetworkManager}(3463)
           │                      └─{NetworkManager}(3465)
           ├─agetty(3461)
           ├─auditd(3358)───{auditd}(3359)
           ├─chronyd(3404)
           ├─crond(3438)
           ├─dbus-daemon(3406)
           ├─dockerd(6364)─┬─containerd(7653)─┬─containerd-shim(16311)─┬─pause(16347)
           │               │                  │                        ├─{containerd-shim}(16312)
           │               │                  │                        ├─{containerd-shim}(16313)
           │               │                  │                        ├─{containerd-shim}(16314)
           │               │                  │                        ├─{containerd-shim}(16315)
           │               │                  │                        ├─{containerd-shim}(16316)
           │               │                  │                        ├─{containerd-shim}(16317)
           │               │                  │                        ├─{containerd-shim}(16318)
           │               │                  │                        ├─{containerd-shim}(16320)
           │               │                  │                        └─{containerd-shim}(16739)
           │               │                  ├─containerd-shim(16575)─┬─nginx(16610)───nginx(16702)
           │               │                  │                        ├─{containerd-shim}(16576)
           │               │                  │                        ├─{containerd-shim}(16577)
           │               │                  │                        ├─{containerd-shim}(16578)
           │               │                  │                        ├─{containerd-shim}(16579)
           │               │                  │                        ├─{containerd-shim}(16580)
           │               │                  │                        ├─{containerd-shim}(16581)
           │               │                  │                        ├─{containerd-shim}(16582)
           │               │                  │                        ├─{containerd-shim}(16583)
           │               │                  │                        └─{containerd-shim}(16801)
           
显示用户名称
[root@master01 ~]# pstree -u
systemd─┬─NetworkManager───2*[{NetworkManager}]
        ├─agetty
        ├─auditd───{auditd}
        ├─chronyd(chrony)
        ├─crond
        ├─dbus-daemon(dbus)
        ├─dockerd─┬─containerd─┬─containerd-shim─┬─pause
        │         │            │                 └─9*[{containerd-shim}]
        │         │            ├─containerd-shim─┬─nginx───nginx(101)
        │         │            │                 └─9*[{containerd-shim}]
        │         │            └─19*[{containerd}]
        │         └─17*[{dockerd}]
        ├─etcd───16*[{etcd}]
        ├─irqbalance
        ├─kube-apiserver───17*[{kube-apiserver}]
        ├─kube-controller───17*[{kube-controller}]
        ├─kube-proxy───15*[{kube-proxy}]
        ├─kube-scheduler───16*[{kube-scheduler}]
        ├─kubelet───21*[{kubelet}]
        ├─lvmetad
        ├─master─┬─pickup(postfix)
        │        └─qmgr(postfix)
        ├─polkitd(polkitd)───6*[{polkitd}]
        ├─rsyslogd───2*[{rsyslogd}]
        ├─sshd───sshd───bash───pstree
        ├─systemd-journal
        ├─systemd-logind
        ├─systemd-udevd
        └─tuned───4*[{tuned}]

显示进程间关系
[root@master01 ~]# pstree -apnh
systemd,1 --switched-root --system --deserialize 22
  ├─systemd-journal,1764
  ├─lvmetad,1793 -f
  ├─systemd-udevd,1803
  ├─auditd,3358
  │   └─{auditd},3359
  ├─systemd-logind,3386
  ├─chronyd,3404
  ├─irqbalance,3405 --foreground
  ├─dbus-daemon,3406 --system --address=systemd: --nofork --nopidfile --systemd-activation
  ├─NetworkManager,3407 --no-daemon
  │   ├─{NetworkManager},3463
  │   └─{NetworkManager},3465
  ├─polkitd,3411 --no-debug
  │   ├─{polkitd},3415
  │   ├─{polkitd},3416
  │   ├─{polkitd},3417
  │   ├─{polkitd},3418
  │   ├─{polkitd},3419
  │   └─{polkitd},3436
  ├─crond,3438 -n
  ├─agetty,3461 --noclear tty1 linux
  ├─sshd,3716 -D
  │   └─sshd,28435    
  │       └─bash,28437
  │           └─pstree,31471 -apnh
  ├─kube-proxy,3718 --logtostderr=true --v=4 --hostname-override=192.168.5.100 --cluster-cidr=10.0.0.0/24 --proxy-mode=ipvs--kubeconfig=/opt/kubernetes/cfg/kube-proxy.kubeconfig
  │   ├─{kube-proxy},4041
  │   ├─{kube-proxy},4042
  │   ├─{kube-proxy},4043
  │   ├─{kube-proxy},4069
  │   ├─{kube-proxy},4437
  │   ├─{kube-proxy},5470
  │   ├─{kube-proxy},5521
  │   ├─{kube-proxy},6083
  │   ├─{kube-proxy},6100
  │   ├─{kube-proxy},6182
  │   ├─{kube-proxy},15277
  │   ├─{kube-proxy},16883
  │   ├─{kube-proxy},24397
  │   ├─{kube-proxy},27543
  │   └─{kube-proxy},32321
  ├─tuned,3719 -Es /usr/sbin/tuned -l -P
  │   ├─{tuned},3930
  │   ├─{tuned},3931
  │   ├─{tuned},3932
  │   └─{tuned},3939
  ├─etcd,4016 --name=etcd01 --data-dir=/var/lib/etcd/default.etcd --listen-peer-urls=https://192.168.5.100:2380 --listen-client-urls=https://192.168.5.100:2379,http://127.0.0.1:2379--
  │   ├─{etcd},1409
  │   ├─{etcd},5430
  │   ├─{etcd},5431
  │   ├─{etcd},5432
  │   ├─{etcd},5433
  │   ├─{etcd},5434
  │   ├─{etcd},6150
  │   ├─{etcd},6151
  │   ├─{etcd},6264
  │   ├─{etcd},6271
  │   ├─{etcd},6280
  │   ├─{etcd},6293
  │   ├─{etcd},6477
  │   ├─{etcd},8776
  │   ├─{etcd},11314
  │   └─{etcd},19281
  ├─rsyslogd,4021 -n
  │   ├─{rsyslogd},4026
  │   └─{rsyslogd},4047
  ├─master,5226 -w
  │   ├─qmgr,5245 -l -t unix -u
  │   └─pickup,27605 -l -t unix -u
  ├─dockerd,6364 --bip=172.17.7.1/24 --ip-masq=false --mtu=1450
  │   ├─{dockerd},6959
  │   ├─{dockerd},6985
  │   ├─{dockerd},6986
  │   ├─{dockerd},6987
  │   ├─{dockerd},7344
  │   ├─{dockerd},7345
  │   ├─{dockerd},7390
  │   ├─containerd,7653 --config /var/run/docker/containerd/containerd.toml --log-level info
  │   │   ├─{containerd},2214
  │   │   ├─{containerd},3959
  │   │   ├─{containerd},8201
  │   │   ├─{containerd},8208
  │   │   ├─{containerd},8209
  │   │   ├─{containerd},8210
  │   │   ├─{containerd},8211
  │   │   ├─{containerd},8494
  │   │   ├─{containerd},8495
  │   │   ├─{containerd},8496
  │   │   ├─{containerd},8877
  │   │   ├─{containerd},8878
  │   │   ├─{containerd},8886
  │   │   ├─{containerd},8887
  │   │   ├─{containerd},8903
  │   │   ├─{containerd},14163
  │   │   ├─{containerd},14854
  │   │   ├─containerd-shim,16311 -namespace moby -workdir ...
  │   │   │   ├─{containerd-shim},16312
  │   │   │   ├─{containerd-shim},16313
  │   │   │   ├─{containerd-shim},16314
  │   │   │   ├─{containerd-shim},16315
  │   │   │   ├─{containerd-shim},16316
  │   │   │   ├─{containerd-shim},16317
  │   │   │   ├─{containerd-shim},16318
  │   │   │   ├─{containerd-shim},16320
  │   │   │   ├─pause,16347
  │   │   │   └─{containerd-shim},16739
  │   │   ├─containerd-shim,16575 -namespace moby -workdir ...
  │   │   │   ├─{containerd-shim},16576
  │   │   │   ├─{containerd-shim},16577
  │   │   │   ├─{containerd-shim},16578
  │   │   │   ├─{containerd-shim},16579
  │   │   │   ├─{containerd-shim},16580
  │   │   │   ├─{containerd-shim},16581
  │   │   │   ├─{containerd-shim},16582
  │   │   │   ├─{containerd-shim},16583
  │   │   │   ├─nginx,16610
  │   │   │   │   └─nginx,16702
  │   │   │   └─{containerd-shim},16801
  │   │   ├─{containerd},17722
  │   │   └─{containerd},25566
  │   ├─{dockerd},7998
  │   ├─{dockerd},8885
  │   ├─{dockerd},8896
  │   ├─{dockerd},8899
  │   ├─{dockerd},8900
  │   ├─{dockerd},9765
  │   ├─{dockerd},11836
  │   ├─{dockerd},15919
  │   ├─{dockerd},22170
  │   └─{dockerd},22276
  ├─kubelet,10370 --logtostderr=true --v=4 --hostname-override=192.168.5.100 --kubeconfig=/opt/kubernetes/cfg/kubelet.kubeconfig--bootstrap-kubeconfig=/opt/kubernetes/cfg/bootstr
  │   ├─{kubelet},520
  │   ├─{kubelet},10616
  │   ├─{kubelet},10617
  │   ├─{kubelet},10619
  │   ├─{kubelet},10625
  │   ├─{kubelet},10902
  │   ├─{kubelet},10903
  │   ├─{kubelet},11023
  │   ├─{kubelet},11222
  │   ├─{kubelet},11277
  │   ├─{kubelet},11697
  │   ├─{kubelet},11763
  │   ├─{kubelet},11778
  │   ├─{kubelet},11816
  │   ├─{kubelet},11817
  │   ├─{kubelet},11833
  │   ├─{kubelet},11921
  │   ├─{kubelet},15185
  │   ├─{kubelet},17279
  │   ├─{kubelet},17280
  │   └─{kubelet},30329
  ├─kube-apiserver,16133 --logtostderr=true --v=4 --etcd-servers=https://192.168.5.100:2379,https://192.168.5.101:2379,https://192.168.5.102:2379 --bind-address=192.168.5.100--se
  │   ├─{kube-apiserver},11208
  │   ├─{kube-apiserver},16134
  │   ├─{kube-apiserver},16135
  │   ├─{kube-apiserver},16136
  │   ├─{kube-apiserver},16139
  │   ├─{kube-apiserver},16140
  │   ├─{kube-apiserver},16142
  │   ├─{kube-apiserver},16147
  │   ├─{kube-apiserver},16148
  │   ├─{kube-apiserver},16149
  │   ├─{kube-apiserver},16150
  │   ├─{kube-apiserver},16151
  │   ├─{kube-apiserver},16157
  │   ├─{kube-apiserver},16162
  │   ├─{kube-apiserver},17087
  │   ├─{kube-apiserver},17502
  │   └─{kube-apiserver},19924
  ├─kube-controller,19352 --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect=true --address=127.0.0.1 --service-cluster-ip-range=10.0.0.0/24--cluster-name=ku
  │   ├─{kube-controller},3122
  │   ├─{kube-controller},16364
  │   ├─{kube-controller},19354
  │   ├─{kube-controller},19355
  │   ├─{kube-controller},19356
  │   ├─{kube-controller},19357
  │   ├─{kube-controller},19358
  │   ├─{kube-controller},19359
  │   ├─{kube-controller},19360
  │   ├─{kube-controller},19372
  │   ├─{kube-controller},19373
  │   ├─{kube-controller},19410
  │   ├─{kube-controller},19411
  │   ├─{kube-controller},19412
  │   ├─{kube-controller},20118
  │   ├─{kube-controller},23918
  │   └─{kube-controller},26751
  └─kube-scheduler,19361 --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect
      ├─{kube-scheduler},5884
      ├─{kube-scheduler},19362
      ├─{kube-scheduler},19363
      ├─{kube-scheduler},19364
      ├─{kube-scheduler},19365
      ├─{kube-scheduler},19366
      ├─{kube-scheduler},19367
      ├─{kube-scheduler},19368
      ├─{kube-scheduler},19369
      ├─{kube-scheduler},19374
      ├─{kube-scheduler},19375
      ├─{kube-scheduler},19376
      ├─{kube-scheduler},19381
      ├─{kube-scheduler},19819
      ├─{kube-scheduler},29874
      └─{kube-scheduler},31056
```



### 9.3 pgrep

&emsp;pgrep 是通过程序的名字来查询进程的工具，一般是用来判断程序是否正在运行。在服务器的配置和管理中，这个工具常被应用，简单明了；

**用法**

```
ps 参数选项   程序名
```

 常用参数

- -l  列出程序名和进程ID；
- -o  进程起始的ID；
- -n  进程终止的ID；

```
[root@master01 ~]# pgrep -lo etcd
4016 etcd
[root@master01 ~]# pgrep -ln etcd
4016 etcd
[root@master01 ~]# pgrep etcd
4016
[root@master01 ~]# ps axf|grep etcd
31947 pts/0    S+     0:00          \_ grep --color=auto etcd
 4016 ?        Ssl  391:56 /opt/etcd/bin/etcd --name=etcd01 --data-dir=/var/lib/etcd/default.e
tcd --listen-peer-urls=https://192.168.5.100:2380 --listen-client-urls=https://192.168.5.100:2379,http://127.0.0.1:2379 --advertise-client-urls=https://192.168.5.100:2379 --initial-advertise-peer-urls=https://192.168.5.100:2380 --initial-cluster=etcd01=https://192.168.5.100:2380,etcd02=https://192.168.5.101:2380,etcd03=https://192.168.5.102:2380 --initial-cluster-token=etc-cluster --initial-cluster-state=new --cert-file=/opt/etcd/ssl/server.pem --key-file=/opt/etc/ssl/server-key.pem --peer-cert-file=/opt/etcd/ssl/server.pem --peer-key-file=/opt/etcd/ssl/server-key.pem --trusted-ca-file=/opt/etcd/ssl/ca.pem --peer-trusted-ca-file=/opt/etcd/ssl/ca.pe
```

### 9.4 kill

&emsp;Linux kill命令用于删除执行中的程序或工作。kill可将指定的信息送至程序。预设的信息为SIGTERM(15)，可将指定程序终止。若仍无法终止该程序，可使用SIGKILL(9)信息尝试强制删除程序。程序或工作的编号可利用ps指令或jobs指令查看。

**语法**

```
kill [-s <信息名称或编号>][程序]　或　kill [-l <信息编号>]
```

**参数说明**：

- -l <信息编号> 　若不加<信息编号>选项，则-l参数会列出全部的信息名称。
- -s <信息名称或编号> 　指定要送出的信息。
- [程序] 　[程序]可以是程序的PID或是PGID，也可以是工作编号。

```
cat>test.sh<< EOF
#!/bin/sh
int=1
while(( \$int<=100 ))
do
    echo \$int>>test.log &
    let "int++"
    sleep 1
done
EOF
[root@master01 ~]# cat>test.sh<< EOF
> #!/bin/sh
> int=1
> while(( \$int<=100 ))
> do
>     echo \$int>>test.log &
>     let "int++"
>     sleep 1
> done
> EOF
[root@master01 ~]# cat test.sh 
#!/bin/sh
int=1
while(( $int<=100 ))
do
    echo $int>>test.log &
    let "int++"
    sleep 1
done
```

```
[root@master01 ~]# sh test.sh &
[1] 1395
[root@master01 ~]# tail -f test.log
13
14
15
16
17
18
省略

通过pid杀掉进程
[root@master01 ~]# ps axf|grep -v grep|grep test.sh
 1395 pts/0    S      0:00  |       \_ sh test.sh
[root@master01 ~]# kill 1395

强制杀死
[root@master01 ~]# ps axf|grep -v grep|grep test.sh
 1674 pts/0    S      0:00  |       \_ sh test.sh
[root@master01 ~]# kill -KILL 1674
----------------------------------------------------------------------------------------
发送SIGHUP信号，可以使用一下信号
[root@master01 ~]# sh test.sh &
[3] 1948
[2]   Killed                  sh test.sh
[root@master01 ~]# !ps
ps axf|grep -v grep|grep test.sh
 1948 pts/0    S      0:00  |       \_ sh test.sh
[root@master01 ~]# kill -HUP 1948
[root@master01 ~]# !tail
tail -f test.log
7
8
9
10
11
12
13
14
15
16
^C
[3]+  Hangup                  sh test.sh
----------------------------------------------------------------------------------------
强制杀死
[root@master01 ~]# ps axf|grep -v grep|grep test.sh
 2093 pts/0    S      0:00  |       \_ sh test.sh
[root@master01 ~]# kill -9 2093
```

```
显示信号
[root@master01 ~]#  kill -l
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
63) SIGRTMAX-1	64) SIGRTMAX	
```

```
杀死指定用户所有进程
kill -9 $(ps -ef | grep cmz) # 方法一 过滤出cmz用户进程 
kill -u cmz # 方法二
```

>说明：
>
>只有第9种信号(SIGKILL)才可以无条件终止进程，其他信号进程都有权利忽略。 下面是常用的信号：
>
>HUP    1    终端断线
>
>INT     2    中断（同 Ctrl + C）
>
>QUIT    3    退出（同 Ctrl + \）
>
>TERM   15    终止
>
>KILL    9    强制终止
>
>CONT   18    继续（与STOP相反， fg/bg命令）
>
>STOP    19    暂停（同 Ctrl + Z）

### 9.5 killall

&emsp;Linux系统中的killall命令用于杀死指定名字的进程（kill processes by name）。我们可以使用kill命令杀死指定进程PID的进程，如果要找到我们需要杀死的进程，我们还需要在之前使用ps等命令再配合grep来查找进程，而killall把这两个过程合二为一，是一个很好用的命令。

**语法**

```
killall	   [参数]  	[进程名]
```

参数

- -Z 只杀死拥有scontext 的进程
- -e 要求匹配进程名称
- -I 忽略小写
- -g 杀死进程组而不是进程
- -i 交互模式，杀死进程前先询问用户
- -l 列出所有的已知信号名称
- -q 不输出警告信息
- -s 发送指定的信号
- -v 报告信号是否成功发送
- -w 等待进程死亡
- --help 显示帮助信息
- --version 显示版本显示

```
[root@master01 ~]# ps axf|grep -v grep|grep test.sh
[root@master01 ~]# sh test.sh &
[2] 3124
[root@master01 ~]# ps axf|grep -v grep|grep test.sh
 3124 pts/0    S      0:00  |       \_ sh test.sh
[root@master01 ~]# killall sh
[2]-  Terminated              sh test.sh
[root@master01 ~]# ps axf|grep -v grep|grep test.sh
```

### 9.6 pkill

&emsp;killall是杀死所有进程，而pkill是按照进程名称杀死进程，可以达到杀死所有进程的目的，因为linux里面同名的进程是分主进程和子进程的。

**语法**

```
killall	   [参数]  [信号]	[进程名]
```

参数

- -o：仅向找到的最小（起始）进程号发送信号；
- -n：仅向找到的最大（结束）进程号发送信号；
- -P：指定父进程号发送信号；
- -g：指定进程组；
- -t：指定开启进程的终端。

```
[root@master01 ~]# systemctl start nginx
[root@master01 ~]# pgrep nginx
14508
14509
14510
14511
14512
[root@master01 ~]# pkill nginx
[root@master01 ~]# pgrep nginx
```

### 9.7 top



### 9.8 nohup

&emsp;当我们在终端或控制台工作时，可能不希望由于运行一个作业而占住了屏幕，因为可能还有更重要的事情要做，比如阅读电子邮件。对于密集访问磁盘的进程，我们更希望它能够在每天的非负荷高峰时间段运行(例如凌晨)。为了使这些进程能够在后台运行，也就是说不在终端屏幕上运行，有几种选择方法可供使用。

- &

  当在前台运行某个作业时，终端被该作业占据；可以在命令后面加上& 实现后台运行。例如：sh test.sh & 

  适合在后台运行的命令有f i n d、费时的排序及一些s h e l l脚本。在后台运行作业时要当心：需要用户交互的命令不要放在后台执行，因为这样你的机器就会在那里傻等。不过，作业在后台运行一样会将结果输出到屏幕上，干扰你的工作。如果放在后台运行的作业会产生大量的输出，最好使用下面的方法把它的输出重定向到某个文件中：

  ```
  command  >  out.file  2>&1  & 
  ```

  > 这样，所有的标准输出和错误输出都将被重定向到一个叫做out.file 的文件中,PS：当你成功地提交进程以后，就会显示出一个进程号，可以用它来监控该进程，或杀死它。(ps -ef | grep 进程号 或者 kill -9 进程号）

- nohup 

&emsp;使用&命令后，作业被提交到后台运行，当前控制台没有被占用，但是一但把当前控制台关掉(退出帐户时)，作业就会停止运行。nohup命令可以在你退出帐户之后继续运行相应的进程。nohup就是不挂起的意思( no hang up)。该命令的一般形式为：

```
nohup command &
```

&emsp;如果使用nohup命令提交作业，那么在缺省情况下该作业的所有输出都被重定向到一个名为nohup.out的文件中，除非另外指定了输出文件：

```
nohup command > myout.file 2>&1 &
```

> 使用了nohup之后，很多人就这样不管了，其实这样有可能在当前账户非正常退出或者结束的时候，命令还是自己结束了。所以在使用nohup命令后台运行命令之后，需要使用exit正常退出当前账户，这样才能保证命令一直在后台运行。

- Ctrl + z 

  可以将一个正在前台执行的命令放到后台，并且处于暂停状态。

- Ctrl+c 

  终止前台命令

- jobs 

  查看当前有多少在后台运行的命令。 
  jobs -l选项可显示所有任务的PID，jobs的状态可以是running, stopped, Terminated。但是如果任务被终止了（kill），shell 从当前的shell环境已知的列表中删除任务的进程标识。

- 2>&1解析

  ```
  command >out.file 2>&1 &
  ```

  - command>out.file是将command的输出重定向到out.file文件，即输出内容不打印到屏幕上，而是输出到out.file文件中。
  - 2>&1 是将标准出错重定向到标准输出，这里的标准输出已经重定向到了out.file文件，即将标准出错也输出到out.file文件中。最后一个&， 是让该命令在后台执行。
  - 试想2>1代表什么，2与>结合代表错误重定向，而1则代表错误重定向到一个文件1，而不代表标准输出；换成2>&1，&与1结合就代表标准输出了，就变成错误重定向到标准输出.

### 9.9 runlevel

**Linux系统有7个运行级别(runlevel)**

- 运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
- 运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
- 运行级别2：多用户状态(没有NFS)
- 运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
- 运行级别4：系统未使用，保留
- 运行级别5：X11控制台，登陆后进入图形GUI模式
- 运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动

**运行级别的原理：**

- 在目录/etc/rc.d/init.d下有许多服务器脚本程序，一般称为服务(service)
- 在/etc/rc.d下有7个名为rcN.d的**目录**，对应系统的7个运行级别
- rcN.d目录下都是一些符号链接文件，这些链接文件都指向init.d目录下的service脚本文件，命名规则为K+nn+服务名或S+nn+服务名，其中nn为两位数字。
- 系统会根据指定的运行级别进入对应的rcN.d目录，并按照文件名顺序检索目录下的链接文件
       对于以K开头的文件，系统将终止对应的服务
       对于以S开头的文件，系统将启动对应的服务
- 查看运行级别用：runlevel
- 进入其它运行级别用：init N
- 另外init0为关机，init 6为重启系统

```
[root@master01 ~]# runlevel
N 3
```



### 9.10 init

init+数字所代表的命令：


0：停机或者关机（千万不能将initdefault设置为0）

1：单用户模式，只root用户进行维护

2：多用户模式，不能使用NFS(Net File System)

3：完全多用户模式（标准的运行级别）

4：安全模式

5：图形化（即图形界面）

6：重启（千万不要把initdefault设置为6）

```
init 0
init 1
init 2
init 3
init 4
init 5
init 6
```

### 9.11 service

&emsp;service命令，顾名思义，就是用于管理Linux操作系统中服务的命令。==用于centos6==

这个命令不是在所有的linux发行版本中都有。主要是在redhat、fedora、mandriva和centos中。

此命令位于/sbin目录下，用file命令查看此命令会发现它是一个脚本命令。

分析脚本可知此命令的作用是去/etc/init.d目录下寻找相应的服务，进行开启和关闭等操作。

开启httpd服务器：`service httpd start`

关闭httpd服务器：`service httpd stop`

看httpd服务状态：`service httpd status`

```
[root@iZwz9e73kbnnm5ufk088lnZ ~]# service httpd 
Usage: httpd {start|stop|restart|condrestart|try-restart|force-reload|reload|status|fullstatus|graceful|help|configtest}
[root@iZwz9e73kbnnm5ufk088lnZ ~]# service httpd start
Starting httpd: httpd: Could not reliably determine the server's fully qualified domain name, using 172.18.112.104 for ServerName
                                                           [  OK  ]
[root@iZwz9e73kbnnm5ufk088lnZ ~]# service httpd stop
Stopping httpd:                                            [  OK  ]
[root@iZwz9e73kbnnm5ufk088lnZ ~]# service httpd status
httpd is stopped
```

```
[yzc@linux rc3.d]$ pwd
/etc/rc.d/rc3.d
[yzc@linux rc3.d]$ ll
total 0
lrwxrwxrwx  1 root root 16 Dec 20 16:15 K01smartd -> ../init.d/smartd
lrwxrwxrwx. 1 root root 19 Mar 27  2018 K10saslauthd -> ../init.d/saslauthd
lrwxrwxrwx  1 root root 22 Dec  4 17:49 K15htcacheclean -> ../init.d/htcacheclean
lrwxrwxrwx  1 root root 15 Dec  4 17:49 K15httpd -> ../init.d/httpd
lrwxrwxrwx  1 root root 15 May  7 19:13 K15nginx -> ../init.d/nginx
lrwxrwxrwx  1 root root 16 Feb 18 10:29 K50vsftpd -> ../init.d/vsftpd
lrwxrwxrwx  1 root root 15 Feb 15 11:38 K71cgred -> ../init.d/cgred
lrwxrwxrwx  1 root root 18 Feb 15 11:38 K72cgconfig -> ../init.d/cgconfig
lrwxrwxrwx  1 root root 14 Mar 27  2018 K74nscd -> ../init.d/nscd
lrwxrwxrwx  1 root root 15 Jan  8 13:28 K74redis -> ../init.d/redis
lrwxrwxrwx  1 root root 24 Jan  8 13:28 K74redis-sentinel -> ../init.d/redis-sentinel
lrwxrwxrwx  1 root root 17 Mar 27  2018 K75ntpdate -> ../init.d/ntpdate
lrwxrwxrwx. 1 root root 20 Mar 27  2018 K87multipathd -> ../init.d/multipathd
lrwxrwxrwx. 1 root root 21 Mar 27  2018 K87restorecond -> ../init.d/restorecond
lrwxrwxrwx. 1 root root 20 Mar 27  2018 K89netconsole -> ../init.d/netconsole
lrwxrwxrwx. 1 root root 15 Mar 27  2018 K89rdisc -> ../init.d/rdisc
lrwxrwxrwx. 1 root root 22 Mar 27  2018 S02lvm2-monitor -> ../init.d/lvm2-monitor
lrwxrwxrwx. 1 root root 16 Mar 27  2018 S07iscsid -> ../init.d/iscsid
lrwxrwxrwx. 1 root root 19 Mar 27  2018 S08ip6tables -> ../init.d/ip6tables
lrwxrwxrwx. 1 root root 18 Mar 27  2018 S08iptables -> ../init.d/iptables
lrwxrwxrwx. 1 root root 17 Mar 27  2018 S10network -> ../init.d/network
lrwxrwxrwx. 1 root root 16 Mar 27  2018 S11auditd -> ../init.d/auditd
lrwxrwxrwx. 1 root root 17 Mar 27  2018 S12rsyslog -> ../init.d/rsyslog
lrwxrwxrwx  1 root root 20 Mar 27  2018 S13irqbalance -> ../init.d/irqbalance
lrwxrwxrwx. 1 root root 15 Mar 27  2018 S13iscsi -> ../init.d/iscsi
lrwxrwxrwx. 1 root root 19 Mar 27  2018 S15mdmonitor -> ../init.d/mdmonitor
lrwxrwxrwx  1 root root 20 Nov 20 09:29 S22messagebus -> ../init.d/messagebus
lrwxrwxrwx. 1 root root 26 Mar 27  2018 S25blk-availability -> ../init.d/blk-availability
lrwxrwxrwx. 1 root root 15 Mar 27  2018 S25netfs -> ../init.d/netfs
lrwxrwxrwx. 1 root root 19 Mar 27  2018 S26udev-post -> ../init.d/udev-post
lrwxrwxrwx  1 root root 21 Mar 27  2018 S28eni-service -> ../init.d/eni-service
lrwxrwxrwx  1 root root 15 Nov 14 14:27 S50aegis -> ../init.d/aegis
lrwxrwxrwx  1 root root 26 Nov 14 14:24 S50cloud-init-local -> ../init.d/cloud-init-local
lrwxrwxrwx  1 root root 24 Mar 27  2018 S50ecs_mq-service -> ../init.d/ecs_mq-service
lrwxrwxrwx  1 root root 20 Nov 14 14:24 S51cloud-init -> ../init.d/cloud-init
lrwxrwxrwx  1 root root 22 Feb 18 10:29 S52cloud-config -> ../init.d/cloud-config
lrwxrwxrwx  1 root root 21 Feb 18 10:29 S53cloud-final -> ../init.d/cloud-final
lrwxrwxrwx  1 root root 14 Mar 27  2018 S55sshd -> ../init.d/sshd
lrwxrwxrwx  1 root root 14 Mar 27  2018 S58ntpd -> ../init.d/ntpd
lrwxrwxrwx  1 root root 15 Feb  1 10:20 S90crond -> ../init.d/crond
lrwxrwxrwx  1 root root 21 Nov 21 17:34 S96salt-master -> ../init.d/salt-master
lrwxrwxrwx  1 root root 21 Nov 21 17:34 S97salt-minion -> ../init.d/salt-minion
lrwxrwxrwx  1 root root 20 Nov 14 14:24 S98agentwatch -> ../init.d/agentwatch
lrwxrwxrwx  1 root root 11 Nov 14 14:27 S99local -> ../rc.local
```

## 9.12 systemctl

&emsp;虽然linux的命令很多都是相同的，但是新版的centos 7 上面与以前的有些命令还是有所不同，不过还好，有提示。==用于centos7== ，centos7 上面启动服务以及关闭服务已经不是以前的service stop/start xxxx了而是systemctl命令，不过用service他会有一个提醒你用systemctl，所以大可不必担心。

```
启动防火墙              systemctl start firewalld.service
停止防火墙              systemctl stop firewalld.service
查看firewalld防火墙状态 firewall-cmd --state
禁止防火墙开机启动      systemctl disable firewalld.service
防火墙开机自启动        systemctl enable firewalld.service

列出正在运行的服务状态  systemctl

启动一个服务            systemctl start postfix.service
关闭一个服务            systemctl stop postfix.service
重启一个服务            systemctl restart postfix.service
显示一个服务的状态      systemctl status postfix.service
在开机时启用一个服务    systemctl enable postfix.service
在开机时禁用一个服务    systemctl disable postfix.service
查看服务是否开机启动    systemctl is-enabled postfix.service;echo $?
查看已启动的服务列表    systemctl list-unit-files|grep enabled

设置系统默认启动运行级别3 [命令模式]
ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
systemctl set-default multi-user.target

设置系统默认启动运行级别5 [图形模式]
ln -sf/lib/systemd/system/graphical.target/etc/systemd/system/default.target
systemctl set-default graphical.target
```


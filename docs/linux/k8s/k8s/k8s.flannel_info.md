
<center><h1>Kubernets网络</h1></center>


## 1. 准备环境
&#160; &#160; &#160; &#160;

ip | 操作系统|角色|安装软件|主机名
---|---|---|---|---
192.168.186.139|centos7.6_x64|master1|docker|k8s-master01
192.168.186.141|centos7.6_x64|node1|docker|k8s-node01
192.168.186.142|centos7.6_x64|node2|docker|k8s-node02

```
1. 安装好docker
2. 配置docker加速器[dao cloud]
```
> flannel 只需要部署在node节点上

## 2. 网络
### 2.1 网络要求
&#160; &#160; &#160; &#160;Container Network Interface(CNI)：容器网络接口，Google和CoreOS主导研究。

Kubernetes网络模型设计基本要求

- 一个Pod一个IP
- 每个Pod独立IP，Pod内所有容器共享网络（同一个IP）
- 所有容器都可以与所有其他容器通信
- 所有节点都可以与所有容器通信

### 2.2 网络模型实现

- flannel
- calico
- weaveworks
- ovs
- contiv
- romana
- cilium

> 前两个比较用的多。flannel小规模[百台以下]，calcio基于BGP[路由表]适合大规模。但是维护成本高[上百台以上]。

### 2.3 网络对比

&#160; &#160; &#160; &#160;Overlay Network：覆盖网络，在基础网络上叠加的一种虚拟网络技术模式，该网络中的主机通过虚拟链路连接起来。

&#160; &#160; &#160; &#160;Flannel：是Overlay网络的一种，也是将源数据包封装在另一种网络包里面进行路由转发和通信，目前已经支持UDP、VXLAN[最成熟，应用最多的]、AWS、HostGW、AWS VPC和GCE路由等数据转发方式。

<center>![flannel vxlan网络模型](../../../pictures/linux/k8s/flannel/f1.png)</center>

## 3. 部署flannel
### 3.1 下载

```
https://github.com/coreos/flannel/releases
```

### 3.2 写入分配的子网段到etcd

```
/opt/etcd/bin/etcdctl \
--ca-file=/opt/etcd/ssl/ca.pem \
--cert-file=/opt/etcd/ssl/server.pem \
--key-file=/opt/etcd/ssl/server-key.pem \
--endpoints="https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379" \
set /coreos.com/network/config '{ "Network": "172.17.0.0/16", "Backend": {"Type": "vxlan"}}'
```

??? note "操作"
    ```
    设置
    [root@k8s-master01 ssl]# /opt/etcd/bin/etcdctl --ca-file=/opt/etcd/ssl/ca.pem --cert-file=/opt/etcd/ssl/server.pem --key-file=/opt
    /etcd/ssl/server-key.pem --endpoints="https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379" set /coreos.com/network/config '{ "Network": "172.17.0.0/16", "Backend": {"Type": "vxlan"}}'{ "Network": "172.17.0.0/16", "Backend": {"Type": "vxlan"}}
    
    查看
    [root@k8s-master01 ~]# /opt/etcd/bin/etcdctl \
    > --ca-file=/opt/etcd/ssl/ca.pem \
    > --cert-file=/opt/etcd/ssl/server.pem \
    > --key-file=/opt/etcd/ssl/server-key.pem \
    > --endpoints="https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379" get /coreos.com/network/config 
    { "Network": "172.17.0.0/16", "Backend": {"Type": "vxlan"}}
    ```


### 3.3 部署与配置

??? note "flannel.sh"
    ```
    [root@k8s-node01 ~]# cat flannel.sh 
    #!/bin/bash
    
    ETCD_ENDPOINTS=${1:-"http://127.0.0.1:2379"}
    
    cat <<EOF >/opt/kubernetes/cfg/flanneld
    
    FLANNEL_OPTIONS="--etcd-endpoints=${ETCD_ENDPOINTS} \
    -etcd-cafile=/opt/etcd/ssl/ca.pem \
    -etcd-certfile=/opt/etcd/ssl/server.pem \
    -etcd-keyfile=/opt/etcd/ssl/server-key.pem"
    
    EOF
    
    cat <<EOF >/usr/lib/systemd/system/flanneld.service
    [Unit]
    Description=Flanneld overlay address etcd agent
    After=network-online.target network.target
    Before=docker.service
    
    [Service]
    Type=notify
    EnvironmentFile=/opt/kubernetes/cfg/flanneld
    ExecStart=/opt/kubernetes/bin/flanneld --ip-masq \$FLANNEL_OPTIONS
    ExecStartPost=/opt/kubernetes/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/subnet.env
    Restart=on-failure
    
    [Install]
    WantedBy=multi-user.target
    
    EOF
    
    cat <<EOF >/usr/lib/systemd/system/docker.service
    
    [Unit]
    Description=Docker Application Container Engine
    Documentation=https://docs.docker.com
    After=network-online.target firewalld.service
    Wants=network-online.target
    
    [Service]
    Type=notify
    EnvironmentFile=/run/flannel/subnet.env
    ExecStart=/usr/bin/dockerd \$DOCKER_NETWORK_OPTIONS
    ExecReload=/bin/kill -s HUP \$MAINPID
    LimitNOFILE=infinity
    LimitNPROC=infinity
    LimitCORE=infinity
    TimeoutStartSec=0
    Delegate=yes
    KillMode=process
    Restart=on-failure
    StartLimitBurst=3
    StartLimitInterval=60s
    
    [Install]
    WantedBy=multi-user.target
    
    EOF
    
    systemctl daemon-reload
    systemctl enable flanneld
    systemctl restart flanneld
    systemctl restart docker
    ```

??? note "flannel启动文件"
    ```
    [root@k8s-node01 ~]# cat /opt/kubernetes/cfg/flanneld 
    
    FLANNEL_OPTIONS="--etcd-endpoints=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379 -etcd-caf
    ile=/opt/etcd/ssl/ca.pem -etcd-certfile=/opt/etcd/ssl/server.pem -etcd-keyfile=/opt/etcd/ssl/server-key.pem"
    [root@k8s-node01 ~]# cat /usr/lib
    lib/     lib64/   libexec/ 
    [root@k8s-node01 ~]# cat /usr/lib/systemd/system/flanneld.service 
    [Unit]
    Description=Flanneld overlay address etcd agent
    After=network-online.target network.target
    Before=docker.service
    
    [Service]
    Type=notify
    EnvironmentFile=/opt/kubernetes/cfg/flanneld
    ExecStart=/opt/kubernetes/bin/flanneld --ip-masq $FLANNEL_OPTIONS
    ExecStartPost=/opt/kubernetes/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/subnet.env
    Restart=on-failure
    
    [Install]
    WantedBy=multi-user.target
    ```

部署node1节点flannel
```
mkdir -p /opt/kubernetes/{bin,cfg,ssl}
./flannel.sh https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379
tar xf flannel-v0.10.0-linux-amd64.tar.gz 
mv flanneld mk-docker-opts.sh /opt/kubernetes/bin/
systemctl start flanneld
ps axf|grep -v grep|grep flannel
systemctl restart docker
ps -ef | grep -v grep | grep docker
ifconfig
```
部署node2节点flannel

```
# node1拷贝文件夹到node2
\scp -r /opt/kubernetes/ root@192.168.186.142:/opt/
\scp -r /usr/lib/systemd/system/{flanneld,docker}.service root@192.168.186.142:/usr/lib/systemd/system/

# node2操作
systemctl start flanneld.service
systemctl start docker.service
ps -ef | grep -v grep | grep docker
ifconfig
```



详细操作
```
[root@k8s-node01 ~]# mkdir -p /opt/kubernetes/{bin,cfg,ssl}
[root@k8s-node01 ~]# ls
anaconda-ks.cfg  flannel.sh  flannel-v0.10.0-linux-amd64.tar.gz
[root@k8s-node01 ~]# chmod +x flannel.sh 
[root@k8s-node01 ~]# ./flannel.sh https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379
Created symlink from /etc/systemd/system/multi-user.target.wants/flanneld.service to /usr/lib/systemd/system/flanneld.service.
Job for flanneld.service failed because the control process exited with error code. See "systemctl status flanneld.service" and "j
ournalctl -xe" for details.Job for docker.service failed because a configured resource limit was exceeded. See "systemctl status docker.service" and "journal
ctl -xe" for details.

[root@k8s-node01 ~]# cat /opt/kubernetes/cfg/flanneld 

FLANNEL_OPTIONS="--etcd-endpoints=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379 -etcd-caf
ile=/opt/etcd/ssl/ca.pem -etcd-certfile=/opt/etcd/ssl/server.pem -etcd-keyfile=/opt/etcd/ssl/server-key.pem

[root@k8s-node01 ~]# ls
anaconda-ks.cfg  flannel.sh  flannel-v0.10.0-linux-amd64.tar.gz
[root@k8s-node01 ~]# tar xf flannel-v0.10.0-linux-amd64.tar.gz 
[root@k8s-node01 ~]# ll
total 44980
-rw-------. 1 root root     1260 Apr 13 22:20 anaconda-ks.cfg
-rwxr-xr-x  1 1001 1001 36327752 Jan 24  2018 flanneld
-rwxr-xr-x  1 root root     1443 Dec  2 20:42 flannel.sh
-rw-r--r--  1 root root  9706487 Oct 20 16:36 flannel-v0.10.0-linux-amd64.tar.gz
-rwxr-xr-x  1 1001 1001     2139 Mar 18  2017 mk-docker-opts.sh
-rw-rw-r--  1 1001 1001     4298 Dec 24  2017 README.md
[root@k8s-node01 ~]# mv flanneld mk-docker-opts.sh /opt/kubernetes/bin/

# 启动flannel
[root@k8s-node01 ~]# systemctl start flanneld

检查flannel进程
[root@k8s-node01 ~]# ps axf|grep -v grep|grep flannel
  8517 ?        Ssl    0:00 /opt/kubernetes/bin/flanneld --ip-masq --etcd-endpoints=https://192.168.186.139:2379,https://192.168.1
86.141:2379,https://192.168.186.142:2379 -etcd-cafile=/opt/etcd/ssl/ca.pem -etcd-certfile=/opt/etcd/ssl/server.pem -etcd-keyfile=/opt/etcd/ssl/server-key.pem

# 检查docker 使用引用了flannel的网络
[root@k8s-node01 ~]# ps -ef | grep -v grep | grep docker
root       8993      1  0 14:05 ?        00:00:00 /usr/bin/dockerd --bip=172.17.66.1/24 --ip-masq=false --mtu=1450
[root@k8s-node01 ~]# ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.66.1  netmask 255.255.255.0  broadcast 172.17.66.255
        ether 02:42:3a:2c:46:53  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.186.141  netmask 255.255.255.0  broadcast 192.168.186.255
        inet6 fe80::5776:3e49:310:65a6  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:04:3d:d3  txqueuelen 1000  (Ethernet)
        RX packets 878603  bytes 166765744 (159.0 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 848718  bytes 120166782 (114.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

flannel.1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet 172.17.66.0  netmask 255.255.255.255  broadcast 0.0.0.0
        inet6 fe80::801c:f0ff:feb2:11c7  prefixlen 64  scopeid 0x20<link>
        ether 82:1c:f0:b2:11:c7  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 8 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1900  bytes 107854 (105.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1900  bytes 107854 (105.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
同时docker网络和flannel.1网络是在一个网络内
```
部署node2上flannel网络
```
[root@k8s-node01 ~]# scp -r /opt/kubernetes/ root@192.168.186.142:/opt/
The authenticity of host '192.168.186.142 (192.168.186.142)' can't be established.
ECDSA key fingerprint is SHA256:smdGSwwemIA+SHBzs0Lrnjg8ugPzneHChLWhl0y0m38.
ECDSA key fingerprint is MD5:f0:66:dc:78:d3:98:77:97:2c:be:69:58:22:73:a6:cc.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.186.142' (ECDSA) to the list of known hosts.
root@192.168.186.142's password: 
flanneld                                                                                        100%   35MB 104.7MB/s   00:00    
mk-docker-opts.sh                                                                               100% 2139     1.8MB/s   00:00    
flanneld                                                                                        100%  241   289.1KB/s   00:00    

[root@k8s-node01 ~]# scp -r /usr/lib/systemd/system/{flanneld,docker}.service root@192.168.186.142:/usr/lib/systemd/system/
root@192.168.186.142's password: 
flanneld.service                                                                                100%  417   270.4KB/s   00:00    
docker.service                                                                                  100%  526   399.5KB/s   00:00 

[root@k8s-node02 systemd]# ps -ef | grep -v grep | grep docker
root      40501      1  0 14:19 ?        00:00:00 /usr/bin/dockerd --bip=172.17.8.1/24 --ip-masq=false --mtu=1450
[root@k8s-node02 systemd]# ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.8.1  netmask 255.255.255.0  broadcast 172.17.8.255
        ether 02:42:80:81:f2:00  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.186.142  netmask 255.255.255.0  broadcast 192.168.186.255
        inet6 fe80::3b9d:97a8:1fe6:5059  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:8d:a5:15  txqueuelen 1000  (Ethernet)
        RX packets 709632  bytes 165458940 (157.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 686840  bytes 81274859 (77.5 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

flannel.1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
        inet 172.17.8.0  netmask 255.255.255.255  broadcast 0.0.0.0
        inet6 fe80::fcaa:a3ff:feb5:c8c6  prefixlen 64  scopeid 0x20<link>
        ether fe:aa:a3:b5:c8:c6  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 8 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2077  bytes 96650 (94.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2077  bytes 96650 (94.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```


### 3.4 验证
node2启动一个测试容器
```
[root@k8s-node02 systemd]# docker run -it busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
fc1a6b909f82: Pull complete 
Digest: sha256:577311505bc76f39349a2d389d32c7967ca478de918104126c10aa0eb7f101fd
Status: Downloaded newer image for busybox:latest
/ # ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:08:02  
          inet addr:172.17.8.2  Bcast:172.17.8.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1312 (1.2 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
node1上测试
```
[root@k8s-node01 ~]# ping 172.17.8.2  -c1
PING 172.17.8.2 (172.17.8.2) 56(84) bytes of data.
64 bytes from 172.17.8.2: icmp_seq=1 ttl=63 time=1.43 ms

--- 172.17.8.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.435/1.435/1.435/0.000 ms
```
> 说明node1宿主机节点能访问node2上的容器

反过来测试

node1上创建容器，
```
[root@k8s-node01 ~]# docker run -it busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
fc1a6b909f82: Pull complete 
Digest: sha256:954e1f01e80ce09d0887ff6ea10b13a812cb01932a0781d6b0cc23f743a874fd
Status: Downloaded newer image for busybox:latest
/ # ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:42:02  
          inet addr:172.17.66.2  Bcast:172.17.66.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1172 (1.1 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```
node2测试
```
[root@k8s-node02 ~]# ping -c1 172.17.66.2
PING 172.17.66.2 (172.17.66.2) 56(84) bytes of data.
64 bytes from 172.17.66.2: icmp_seq=1 ttl=63 time=0.369 ms

--- 172.17.66.2 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.369/0.369/0.369/0.000 ms
[root@k8s-node02 ~]# 
```
> 说明node2宿主机节点能访问node1上的容器

容器之间互测

```
node2容器去ping node1的容器
[root@k8s-node02 systemd]# docker run -it busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
fc1a6b909f82: Pull complete 
Digest: sha256:577311505bc76f39349a2d389d32c7967ca478de918104126c10aa0eb7f101fd
Status: Downloaded newer image for busybox:latest
/ # ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:08:02  
          inet addr:172.17.8.2  Bcast:172.17.8.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:16 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1312 (1.2 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ # ^C
/ # ping -c1 172.17.66.2
PING 172.17.66.2 (172.17.66.2): 56 data bytes
64 bytes from 172.17.66.2: seq=0 ttl=62 time=0.803 ms

--- 172.17.66.2 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.803/0.803/0.803 ms

node1容器去ping node2的容器
[root@k8s-node01 ~]# docker run -it busybox
Unable to find image 'busybox:latest' locally
latest: Pulling from library/busybox
fc1a6b909f82: Pull complete 
Digest: sha256:954e1f01e80ce09d0887ff6ea10b13a812cb01932a0781d6b0cc23f743a874fd
Status: Downloaded newer image for busybox:latest
/ # ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:42:02  
          inet addr:172.17.66.2  Bcast:172.17.66.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1172 (1.1 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

/ # ping -c1 172.17.8.2
PING 172.17.8.2 (172.17.8.2): 56 data bytes
64 bytes from 172.17.8.2: seq=0 ttl=62 time=0.439 ms

--- 172.17.8.2 ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.439/0.439/0.439 ms

```

以上说明node2和node1之间的容器，以及宿主机之前网络OK。

??? note "网络互通的原因"
    ```python
    路由表
    [root@k8s-node01 ~]# ip route 
    default via 192.168.186.2 dev ens33 proto static metric 100 
    172.17.8.0/24 via 172.17.8.0 dev flannel.1 onlink 
    172.17.66.0/24 dev docker0 proto kernel scope link src 172.17.66.1 
    192.168.186.0/24 dev ens33 proto kernel scope link src 192.168.186.141 metric 100 
    [root@k8s-node01 ~]# route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         192.168.186.2   0.0.0.0         UG    100    0        0 ens33
    172.17.8.0      172.17.8.0      255.255.255.0   UG    0      0        0 flannel.1
    172.17.66.0     0.0.0.0         255.255.255.0   U     0      0        0 docker0
    192.168.186.0   0.0.0.0         255.255.255.0   U     100    0        0 ens33

    [root@k8s-node02 ~]# ip route 
    default via 192.168.186.2 dev ens33 proto static metric 100 
    172.17.8.0/24 dev docker0 proto kernel scope link src 172.17.8.1 
    172.17.66.0/24 via 172.17.66.0 dev flannel.1 onlink 
    192.168.186.0/24 dev ens33 proto kernel scope link src 192.168.186.142 metric 100 
    [root@k8s-node02 ~]# route -n
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    0.0.0.0         192.168.186.2   0.0.0.0         UG    100    0        0 ens33
    172.17.8.0      0.0.0.0         255.255.255.0   U     0      0        0 docker0
    172.17.66.0     172.17.66.0     255.255.255.0   UG    0      0        0 flannel.1
    192.168.186.0   0.0.0.0         255.255.255.0   U     100    0        0 ens33


    [root@k8s-node02 ~]# /opt/etcd/bin/etcdctl \
    > --ca-file=/opt/etcd/ssl/ca.pem \
    > --cert-file=/opt/etcd/ssl/server.pem \
    > --key-file=/opt/etcd/ssl/server-key.pem \
    > --endpoints="https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379" \
    > ls /coreos.com/network/subnets
    /coreos.com/network/subnets/172.17.66.0-24
    /coreos.com/network/subnets/172.17.8.0-24
    [root@k8s-node02 ~]# /opt/etcd/bin/etcdctl \
    > --ca-file=/opt/etcd/ssl/ca.pem \
    > --cert-file=/opt/etcd/ssl/server.pem \
    > --key-file=/opt/etcd/ssl/server-key.pem \
    > --endpoints="https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379" \
    > get /coreos.com/network/subnets/172.17.66.0-24
    {"PublicIP":"192.168.186.141","BackendType":"vxlan","BackendData":{"VtepMAC":"82:1c:f0:b2:11:c7"}}
    [root@k8s-node02 ~]# /opt/etcd/bin/etcdctl \
    > --ca-file=/opt/etcd/ssl/ca.pem \
    > --cert-file=/opt/etcd/ssl/server.pem \
    > --key-file=/opt/etcd/ssl/server-key.pem \
    > --endpoints="https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379" \
    > get /coreos.com/network/subnets/172.17.8.0-24
    {"PublicIP":"192.168.186.142","BackendType":"vxlan","BackendData":{"VtepMAC":"fe:aa:a3:b5:c8:c6"}}
    [root@k8s-node02 ~]# 
    结和 本章的2.3小节的网络模型图来看:
    1. 从上面结果来看，node2节点flannel分配的网络是 172.17.8. 网段
        [root@k8s-node02 ~]# ifconfig | grep -A1 flanne*
        flannel.1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
            inet 172.17.8.0  netmask 255.255.255.255  broadcast 0.0.0.0
    
    2. node1节点flannel分配的网络是 172.17.66.网段
        [root@k8s-node01 ~]# ifconfig | grep -A1 flanne
        flannel.1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
            inet 172.17.66.0  netmask 255.255.255.255  broadcast 0.0.0.0
    3. flannel是在本地基础网络上再次封装，管理了docker ip和宿主机的IP对应关系，这样就flannel知道转发给哪个node了，这样flannel知道之间彼此关系
    ```

<center><h1>Kubernets HA SLB</h1></center>

## 1. 准备环境


ip | 操作系统|角色|安装软件|主机名
---|---|---|---|---
192.168.186.139|centos7.6_x64|master1|docker|k8s-master01
192.168.186.140|centos7.6_x64|master1|docker|k8s-master02
192.168.186.141|centos7.6_x64|node1|docker|k8s-node01
192.168.186.142|centos7.6_x64|node2|docker|k8s-node02
192.168.186.143|centos7.6_x64|lb1|nginx|k8s-lb01
192.168.186.144|centos7.6_x64|lb2|nginx|k8s-lb02

负载均衡，我们使用keepalived+nginx两台机器，实现高可用。

## 2. 部署
### 2.1 nginx 
```
yum install -y nginx
```
> k8s-lb01，k8s-lb02都要安装

centos7要是没有nginx源，添加nginx的源

```
cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
EOF
```

### 2.2 配置nginx

```
stream {
    log_format main '$remote_addr $upstream_addr - [$time_local] $status $upstream_bytes_sent';
    access_log /var/log/nginx/k8s-access.log main; 
    
    upstream k8s-apiserver {
        server 192.168.186.139:6443;
        server 192.168.186.140:6443;
    }
    server {
        listen 6443;
        proxy_pass k8s-apiserver;
    }
}
```

??? note "nginx 配置文件"
    ```
    [root@k8s-lb02 nginx]# egrep -v '#|^$' /etc/nginx/nginx.conf
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;
    include /usr/share/nginx/modules/*.conf;
    events {
        worker_connections 1024;
    }
    stream {
        log_format main '$remote_addr $upstream_addr - [$time_local] $status $upstream_bytes_sent';
        access_log /var/log/nginx/k8s-access.log main; 
        
        upstream k8s-apiserver {
            server 192.168.186.139:6443;
            server 192.168.186.140:6443;
        }
        server {
            listen 6443;
            proxy_pass k8s-apiserver;
        }
    }
    http {
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';
        access_log  /var/log/nginx/access.log  main;
        sendfile            on;
        tcp_nopush          on;
        tcp_nodelay         on;
        keepalive_timeout   65;
        types_hash_max_size 2048;
        include             /etc/nginx/mime.types;
        default_type        application/octet-stream;
        include /etc/nginx/conf.d/*.conf;
        server {
            listen       80 default_server;
            listen       [::]:80 default_server;
            server_name  _;
            root         /usr/share/nginx/html;
            include /etc/nginx/default.d/*.conf;
            location / {
            }
            error_page 404 /404.html;
                location = /40x.html {
            }
            error_page 500 502 503 504 /50x.html;
                location = /50x.html {
            }
        }
    }
    ```
> 两台nginx的配置文件一样


```
[root@k8s-lb01 nginx]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@k8s-lb01 nginx]# systemctl start nginx

```

### 2.3 keepalived
安装keepalived

```
yum install -y keepalived 
```

??? note "k8s-lb01 主keepalived.conf"
    ```
    [root@k8s-lb01 ~]# cat /etc/keepalived/keepalived.conf 
    ! Configuration File for keepalived 
     
    global_defs { 
       notification_email { 
         acassen@firewall.loc 
         failover@firewall.loc 
         sysadmin@firewall.loc 
       } 
       notification_email_from Alexandre.Cassen@firewall.loc  
       smtp_server 127.0.0.1 
       smtp_connect_timeout 30 
       router_id NGINX_MASTER 
    } 
    
    vrrp_script check_nginx {
        script "/etc/nginx/check_nginx.sh"
    }
    
    vrrp_instance VI_1 { 
        state MASTER 
        interface ens33       # 网卡名
        virtual_router_id 51  # VRRP 路由 ID实例，每个实例是唯一的 
        priority 100          # 优先级，备服务器设置 90 
        advert_int 1          # 指定VRRP 心跳包通告间隔时间，默认1秒 
        authentication { 
            auth_type PASS      
            auth_pass 1111 
        }  
        virtual_ipaddress { 
            192.168.186.145/24 # vip地址
        } 
        track_script {
            check_nginx        # 监控脚本
        } 
    }
    ```

??? note "k8s-lb02 从keepalived.conf"
    ```
    [root@k8s-lb02 nginx]# cat /etc/keepalived/keepalived.conf 
    ! Configuration File for keepalived 
     
    global_defs { 
       notification_email { 
         acassen@firewall.loc 
         failover@firewall.loc 
         sysadmin@firewall.loc 
       } 
       notification_email_from Alexandre.Cassen@firewall.loc  
       smtp_server 127.0.0.1 
       smtp_connect_timeout 30 
       router_id NGINX_MASTER 
    } 
    
    vrrp_script check_nginx {
        script "/etc/nginx/check_nginx.sh"
    }
    
    vrrp_instance VI_1 { 
        state BACKUP 
        interface ens33       # 网卡名
        virtual_router_id 51  # VRRP 路由 ID实例，每个实例是唯一的 
        priority 90           # 优先级，备服务器设置 90 
        advert_int 1          # 指定VRRP 心跳包通告间隔时间，默认1秒 
        authentication { 
            auth_type PASS      
            auth_pass 1111 
        }  
        virtual_ipaddress { 
            192.168.186.145/24 # vip地址
        } 
        track_script {
            check_nginx        # 监控脚本
        } 
    }
    ```
    
??? note "check_nginx.sh"
    ```
    count=$(ps -ef |grep nginx |egrep -cv "grep|$$")

    if [ "$count" -eq 0 ];then
        systemctl stop keepalived
    fi
    ```
> keepalived 主备就优先和state 不一样，主备的check_nginx.sh内容一样。

```
[root@k8s-lb01 ~]# cat /etc/nginx/check_nginx.sh 
count=$(ps -ef |grep nginx |egrep -cv "grep|$$")

if [ "$count" -eq 0 ];then
    systemctl stop keepalived
fi
[root@k8s-lb01 ~]# systemctl start keepalived

查看vip
[root@k8s-lb01 ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:c6:79:90 brd ff:ff:ff:ff:ff:ff
    inet 192.168.186.143/24 brd 192.168.186.255 scope global noprefixroute ens33
       valid_lft forever preferred_lft forever
    inet 192.168.186.145/24 scope global secondary ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::9d58:5651:daa8:880a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

拷贝配置文件到备keepalived，尽量别自己手写，防止出错
[root@k8s-lb01 ~]# scp /etc/keepalived/keepalived.conf root@192.168.186.144:/etc/keepalived/
The authenticity of host '192.168.186.144 (192.168.186.144)' can't be established.
ECDSA key fingerprint is SHA256:E5Y64HSJxuf2Rp9/Ub2eH+UJxH09K/QJyP8PRYXC9qQ.
ECDSA key fingerprint is MD5:29:15:f3:14:8b:1c:f4:be:d9:a6:a6:9e:be:27:fa:14.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.186.144' (ECDSA) to the list of known hosts.
root@192.168.186.144's password: 
keepalived.conf                                                                                 100%  904   313.9KB/s   00:00  

拷贝检查nginx的脚本到备keepalived
[root@k8s-lb01 ~]# scp /etc/nginx/check_nginx.sh root@192.168.186.144:/etc/nginx/
root@192.168.186.144's password: 
check_nginx.sh                                                                                  100%  110    78.0KB/s   00:00  

修改从keepalived配置文件。该state为BACKUP ，priority比主100低就行，我写90，接下来启动从keepalived
[root@k8s-lb02 nginx]# systemctl start keepalived
[root@k8s-lb02 nginx]# systemctl status keepalived
● keepalived.service - LVS and VRRP High Availability Monitor
   Loaded: loaded (/usr/lib/systemd/system/keepalived.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2019-04-19 17:11:00 CST; 6s ago
  Process: 48059 ExecStart=/usr/sbin/keepalived $KEEPALIVED_OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 48060 (keepalived)
    Tasks: 3
   Memory: 5.0M
   CGroup: /system.slice/keepalived.service
           ├─48060 /usr/sbin/keepalived -D
           ├─48061 /usr/sbin/keepalived -D
           └─48062 /usr/sbin/keepalived -D

Apr 19 17:11:00 k8s-lb02 Keepalived_vrrp[48062]: Registering gratuitous ARP shared channel
Apr 19 17:11:00 k8s-lb02 Keepalived_vrrp[48062]: Opening file '/etc/keepalived/keepalived.conf'.
Apr 19 17:11:00 k8s-lb02 Keepalived_vrrp[48062]: WARNING - default user 'keepalived_script' for script execution does not...reate.
Apr 19 17:11:00 k8s-lb02 Keepalived_healthcheckers[48061]: Opening file '/etc/keepalived/keepalived.conf'.
Apr 19 17:11:05 k8s-lb02 Keepalived_vrrp[48062]: WARNING - script '/etc/nginx/check_nginx.sh' is not executable for uid:g...bling.
Apr 19 17:11:05 k8s-lb02 Keepalived_vrrp[48062]: SECURITY VIOLATION - scripts are being executed but script_security not enabled.
Apr 19 17:11:05 k8s-lb02 Keepalived_vrrp[48062]: VRRP_Instance(VI_1) removing protocol VIPs.
Apr 19 17:11:05 k8s-lb02 Keepalived_vrrp[48062]: Using LinkWatch kernel netlink reflector...
Apr 19 17:11:05 k8s-lb02 Keepalived_vrrp[48062]: VRRP_Instance(VI_1) Entering BACKUP STATE
Apr 19 17:11:05 k8s-lb02 Keepalived_vrrp[48062]: VRRP sockpool: [ifindex(2), proto(112), unicast(0), fd(10,11)]
Hint: Some lines were ellipsized, use -l to show in full.

```

### 2.4 测试keepalived HA

干掉lb01上的nginx，模拟nginx挂了
```
[root@k8s-lb01 nginx]# ps axf|egrep  'nginx|keepalived'
 50204 pts/0    S+     0:00  |           \_ grep -E --color=auto nginx|keepalived
 48846 ?        Ss     0:00 /usr/sbin/keepalived -D
 48847 ?        S      0:00  \_ /usr/sbin/keepalived -D
 48848 ?        S      0:00  \_ /usr/sbin/keepalived -D
 48863 ?        Ss     0:00 nginx: master process /usr/sbin/nginx
 48864 ?        S      0:00  \_ nginx: worker process
 48865 ?        S      0:00  \_ nginx: worker process
 48866 ?        S      0:00  \_ nginx: worker process
 48867 ?        S      0:00  \_ nginx: worker process
[root@k8s-lb01 nginx]# ip a|grep 145
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 192.168.186.145/24 scope global secondary ens33

----------------------------------------------------------------------------------    
开始ping 这个vip
C:\Users\cmz>ping -t 192.168.186.145

正在 Ping 192.168.186.145 具有 32 字节的数据:
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
请求超时。                                            <-- 这个地方是我pkill nginx时候vip漂移到backup了
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=2ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=2ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
请求超时。                                            <-- 这个地方是我启动了keepalived和nginx，vip又漂移到master上了
来自 192.168.186.145 的回复: 字节=32 时间=1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间=2ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.186.145 的回复: 字节=32 时间<1ms TTL=64

192.168.186.145 的 Ping 统计信息:
    数据包: 已发送 = 45，已接收 = 43，丢失 = 2 (4% 丢失)，
往返行程的估计时间(以毫秒为单位):
    最短 = 0ms，最长 = 2ms，平均 = 0ms
Control-C
^C
---------------------------------------------------------

[root@k8s-lb01 nginx]# pkill nginx

过一会
[root@k8s-lb01 nginx]# ps axf|egrep  'nginx|keepalived'
 50268 pts/0    S+     0:00  |           \_ grep -E --color=auto nginx|keepalived
[root@k8s-lb01 nginx]# ip a|grep 145
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
说明keepalived调用那个检查脚本干掉了自己。此时vip漂移到从keepalived了，去检查一下
[root@k8s-lb02 nginx]# ip a|grep 145
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 192.168.186.145/24 scope global secondary ens33
可以看出vip漂移到从keepalived了。
```
> 到目前为止 k8s的前端HA和SLB做准备已经实现，下面开始部署另一个k8s-master，部署完在测试

## 3.配置slb
### 3.1 配置node
&#160; &#160; &#160; &#160;我们此时将node节点指向到slb上，不在是指向master上了。此时就是将node节点的指向ip由原来的指向master ip改为slb的vip即可。

```
——————> node1
[root@k8s-node01 ~]# cd /opt/kubernetes/cfg/
[root@k8s-node01 cfg]# ls
bootstrap.kubeconfig  flanneld  kubelet  kubelet.config  kubelet.kubeconfig  kube-proxy  kube-proxy.kubeconfig
[root@k8s-node01 cfg]# grep -irn 139 *
bootstrap.kubeconfig:5:    server: https://192.168.186.139:6443
flanneld:2:FLANNEL_OPTIONS="--etcd-endpoints=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:237
9 -etcd-cafile=/opt/etcd/ssl/ca.pem -etcd-certfile=/opt/etcd/ssl/server.pem -etcd-keyfile=/opt/etcd/ssl/server-key.pem"kubelet.kubeconfig:5:    server: https://192.168.186.139:6443
kube-proxy.kubeconfig:5:    server: https://192.168.186.139:6443

期中要修改的 bootstrap.kubeconfig 第五行，kubelet.kubeconfig第五行，kube-proxy.kubeconfig第五行。修改后如下：
[root@k8s-node01 cfg]# grep -irn 145 *
bootstrap.kubeconfig:5:    server: https://192.168.186.145:6443
kubelet.kubeconfig:5:    server: https://192.168.186.145:6443
kube-proxy.kubeconfig:5:    server: https://192.168.186.145:6443

重启服务
[root@k8s-node01 cfg]# systemctl restart kubelet
[root@k8s-node01 cfg]# systemctl restart kube-proxy


——————> node2
[root@k8s-node02 ~]# cd /opt/kubernetes/cfg/
[root@k8s-node02 cfg]# ll
total 32
-rw------- 1 root root 2169 Apr 18 17:49 bootstrap.kubeconfig
-rw-r--r-- 1 root root  241 Apr 18 17:49 flanneld
-rw-r--r-- 1 root root  413 Apr 18 17:55 kubelet
-rw-r--r-- 1 root root  269 Apr 18 17:56 kubelet.config
-rw------- 1 root root 2298 Apr 18 18:07 kubelet.kubeconfig
-rw-r--r-- 1 root root  191 Apr 18 18:01 kube-proxy
-rw------- 1 root root 6271 Apr 18 17:49 kube-proxy.kubeconfig
[root@k8s-node02 cfg]# grep -irn 139 *
bootstrap.kubeconfig:5:    server: https://192.168.186.139:6443
flanneld:2:FLANNEL_OPTIONS="--etcd-endpoints=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:237
9 -etcd-cafile=/opt/etcd/ssl/ca.pem -etcd-certfile=/opt/etcd/ssl/server.pem -etcd-keyfile=/opt/etcd/ssl/server-key.pem"kubelet.kubeconfig:5:    server: https://192.168.186.139:6443
kube-proxy.kubeconfig:5:    server: https://192.168.186.139:6443
[root@k8s-node02 cfg]# vim bootstrap.kubeconfig +5
[root@k8s-node02 cfg]# vim kubelet.kubeconfig +5
[root@k8s-node02 cfg]# vim kube-proxy.kubeconfig +5
[root@k8s-node02 cfg]# grep -irn 100 *
bootstrap.kubeconfig:5:    server: https://192.168.186.145:6443
kubelet.kubeconfig:5:    server: https://192.168.186.145:6443
kube-proxy.kubeconfig:5:    server: https://192.168.186.145:6443
[root@k8s-node02 cfg]# systemctl restart kubelet
[root@k8s-node02 cfg]# systemctl restart kube-proxy
```

### 3.2 生成证书
在master01上操作

??? note "kubectl.sh "
    ```
    [root@k8s-master01 k8s-cert]# cat kubectl.sh 
    kubectl config set-cluster kubernetes \
    --server=https://192.168.186.145:6443 \
    --embed-certs=true \
    --certificate-authority=ca.pem \
    --kubeconfig=config
    kubectl config set-credentials cluster-admin \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --client-key=admin-key.pem \
    --client-certificate=admin.pem \
    --kubeconfig=config
    kubectl config set-context default --cluster=kubernetes --user=cluster-admin --kubeconfig=config
    kubectl config use-context default --kubeconfig=config
    ```


```
[root@k8s-master01 k8s-cert]# pwd
/root/k8s/k8s-cert
[root@k8s-master01 k8s-cert]# bash kubectl.sh 
Cluster "kubernetes" set.
User "cluster-admin" set.
Context "default" created.
Switched to context "default".
[root@k8s-master01 k8s-cert]# ls config 
config
[root@k8s-master01 k8s-cert]# ls
admin.csr       bootstrap.kubeconfig  ca-key.pem   kubeconfig.sh        kube-proxy-key.pem     server-csr.json
admin-csr.json  ca-config.json        ca.pem       kubectl.sh           kube-proxy.kubeconfig  server-key.pem
admin-key.pem   ca.csr                config       kube-proxy.csr       kube-proxy.pem         server.pem
admin.pem       ca-csr.json           k8s-cert.sh  kube-proxy-csr.json  server.csr


[root@k8s-master01 k8s-cert]# scp  /usr/bin/kubectl root@192.168.186.141:/usr/bin/
root@192.168.186.141's password: 
kubectl                                                                                         100%   37MB  68.2MB/s   00:00    
[root@k8s-master01 k8s-cert]# scp  config root@192.168.186.141:/root
root@192.168.186.141's password: 
config                                                                                          100% 6273     3.7MB/s   00:00  
```
在node1上操作。
```
[root@k8s-node01 ~]# pwd
/root
[root@k8s-node01 ~]# ls
anaconda-ks.cfg  config  flannel.sh  flannel-v0.10.0-linux-amd64.tar.gz  kubelet.sh  node.zip  proxy.sh  README.md
[root@k8s-node01 ~]# kubectl --kubeconfig=./config  get nodes
NAME              STATUS   ROLES    AGE     VERSION
192.168.186.141   Ready    <none>   3d18h   v1.13.4
192.168.186.142   Ready    <none>   3d17h   v1.13.4
[root@k8s-node01 ~]# 
[root@k8s-node01 ~]# kubectl --kubeconfig=./config  get nodes -o wide
NAME              STATUS   ROLES    AGE     VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
192.168.186.141   Ready    <none>   3d18h   v1.13.4   192.168.186.141   <none>        CentOS Linux 7 (Core)   3.10.0-957.el7.x86_64        docker://18.9.5
192.168.186.142   Ready    <none>   3d17h   v1.13.4   192.168.186.142   <none>        CentOS Linux 7 (Core)   3.10.0-957.10.1.el7.x86_64   docker://18.9.5
```
> 可以看出，我们从其他非机器的机器通过证书和命令链接到机器中[其实就是通过加载证书，链接apiserver，我没有其他闲置机器。我使用了node1节点，你找其他机器都可以，但是保证你的apiserver的证书中允许该ip]

```
在k8s-cert.sh中指定了api server允许链接的ip

cat > server-csr.json <<EOF
{
    "CN": "kubernetes",
    "hosts": [
      "10.0.0.1",
      "127.0.0.1",
      "192.168.186.139",
      "192.168.186.140",
      "192.168.186.141",
      "192.168.186.142",
      "192.168.186.143",
      "192.168.186.144",
      "192.168.186.145",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "L": "BeiJing",
            "ST": "BeiJing",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare server

具体参考安装master时候，给apiserver 制作的证书
```

??? note "常见问题"
    ```
    我在做master+nginx slb的时候把证书和启动文件拷贝到node1上 启动的时候加载了证书，显示显示如下: 
    [root@k8s-node01 ~]# kubectl --kubeconfig=./config get node   # 其实就是去链接apiserver[apiserver中ip限制].
    Unable to connect to the server: x509: certificate is valid for 10.0.0.1, 127.0.0.1, 192.168.186.139, 192.168.186.140, 192.168.186
    .141, 192.168.186.142, 192.168.186.143, 192.168.186.144, 192.168.186.145, not 192.168.186.100
    
    后面发现我的vip 192.168.186.100不在apiserver 信任里面。解决办法:
    1. 修改我制作apiserver的时候预留的ip
    2. 重新制作spiserver证书，分发到其他机器上。
    我选择了第一种
    ```



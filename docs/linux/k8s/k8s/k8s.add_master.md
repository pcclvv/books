<center><h1>Kubernets master02</h1></center>


## 1. 准备环境
&#160; &#160; &#160; &#160;接下来准备安装另一个Kubernets master。我们要安装两个master前端做slb。其实就是新增一个master节点，无非就是把证书，启动文件，拷过去，然后修改对应参数即可。

```
scp -r /opt/kubernetes root@192.168.186.140:/opt/
scp /usr/lib/systemd/system/{kube-apiserver,kube-controller-manager,kube-scheduler}.service root@192.168.186.140:/usr/lib/systemd/system/
scp /usr/bin/kubectl root@192.168.186.140:/usr/bin/
scp -r /opt/etcd/ssl/ root@192.168.186.140:/opt/etcd/
```
详细操作

```
[root@k8s-master01 ~]# scp -r /opt/kubernetes root@192.168.186.140:/opt/
root@192.168.186.140's password: 
kube-apiserver                                                                                  100%  132MB  50.4MB/s   00:02    
kube-controller-manager                                                                         100%   99MB  40.4MB/s   00:02    
kube-scheduler                                                                                  100%   36MB  48.8MB/s   00:00    
kube-apiserver                                                                                  100%  939   252.0KB/s   00:00    
token.csv                                                                                       100%   84    66.4KB/s   00:00    
kube-controller-manager                                                                         100%  483   557.6KB/s   00:00    
kube-scheduler                                                                                  100%   94   112.0KB/s   00:00    
ca.pem                                                                                          100% 1359     1.5MB/s   00:00    
server.pem                                                                                      100% 1659     1.8MB/s   00:00    
server-key.pem                                                                                  100% 1679   910.7KB/s   00:00    
ca-key.pem                                                                                      100% 1679     1.2MB/s   00:00  
[root@k8s-master01 ~]# scp /usr/lib/systemd/system/{kube-apiserver,kube-controller-manager,kube-scheduler}.service root@192.168.186.140:/usr/lib/systemd/system/
root@192.168.186.140's password: 
kube-apiserver.service                                                                          100%  282   157.7KB/s   00:00    
kube-controller-manager.service                                                                 100%  317   101.8KB/s   00:00    
kube-scheduler.service                                                                          100%  281   162.7KB/s   00:00    
[root@k8s-master01 ~]# scp /usr/bin/kubectl root@192.168.186.140:/usr/bin/
root@192.168.186.140's password: 
kubectl                                                                                                                                                    100%   37MB  55.9MB/s   00:00 

拷贝证书
[root@k8s-master01 ~]# scp -r /opt/etcd/ssl/ root@192.168.186.140:/opt/etcd/
root@192.168.186.140's password: 
ca.pem                                                                                          100% 1265     1.0MB/s   00:00    
server-key.pem                                                                                  100% 1675   901.4KB/s   00:00    
server.pem                                                                                      100% 1338   761.2KB/s   00:00   

[root@k8s-master02 etcd]# ls
ca.pem  server-key.pem  server.pem
[root@k8s-master02 etcd]# pwd
/opt/etcd
[root@k8s-master02 etcd]# mkdir ssl
[root@k8s-master02 etcd]# mv *.pem ssl/
[root@k8s-master02 etcd]# ls
ssl
```
修改配置文件，把`kube-apiserver`和`dvertise-address` 文件ip地址修改为`为本地ip地址`

```
systemctl start kube-apiserver.service 
systemctl start kube-scheduler.service 
systemctl start kube-controller-manager.service 
```

检查
```
[root@k8s-master02 cfg]# ps axf|grep scheduler
  8644 pts/1    S+     0:00          \_ grep --color=auto scheduler
  8576 ?        Ssl    0:01 /opt/kubernetes/bin/kube-scheduler --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect
  
[root@k8s-master02 cfg]# ps axf|grep controller-manager
  8646 pts/1    S+     0:00          \_ grep --color=auto controller-manager
  8628 ?        Ssl    0:00 /opt/kubernetes/bin/kube-controller-manager --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-
elect=true --address=127.0.0.1 --service-cluster-ip-range=10.0.0.0/24 --cluster-name=kubernetes --cluster-signing-cert-file=/opt/kubernetes/ssl/ca.pem --cluster-signing-key-file=/opt/kubernetes/ssl/ca-key.pem --root-ca-file=/opt/kubernetes/ssl/ca.pem --service-account-private-key-file=/opt/kubernetes/ssl/ca-key.pem --experimental-cluster-signing-duration=87600h0m0s
```
发现api-server没启动

```
[root@k8s-master02 cfg]# ps axf|grep apiserver
  8738 pts/1    S+     0:00          \_ grep --color=auto apiserve
```
??? note "排错"
    ```
    [root@k8s-master02 cfg]# source /opt/kubernetes/cfg/kube-apiserver
    [root@k8s-master02 cfg]# /opt/kubernetes/bin/kube-apiserver $KUBE_APISERVER_OPTS
    。。。。。
    error: failed to create listener: failed to listen on 192.168.186.139:6443: listen tcp 192.168.186.139:6443: bind: cannot assign requested address
    [root@k8s-master02 cfg]# grep 139 *
    kube-apiserver:--etcd-servers=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379 \
    kube-apiserver:--bind-address=192.168.186.139 \
    
    --bind-address=192.168.186.139  要修改成本机的。我模拟了该错误，怎么排查
    [root@k8s-master02 cfg]# systemctl start kube-apiserver.service 
    
    [root@k8s-master02 etcd]# ps axf|grep apiserver
      9528 pts/1    S+     0:00          \_ grep --color=auto apiserver
      9479 ?        Ssl    0:28 /opt/kubernetes/bin/kube-apiserver --logtostderr=true --v=4 --etcd-servers=https://192.168.186.139:237
    9,https://192.168.186.141:2379,https://192.168.186.142:2379 --bind-address=192.168.186.140 --secure-port=6443 --advertise-address=192.168.186.140 --allow-privileged=true --service-cluster-ip-range=10.0.0.0/24 --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction --authorization-mode=RBAC,Node --kubelet-https=true --enable-bootstrap-token-auth --token-auth-file=/opt/kubernetes/cfg/token.csv --service-node-port-range=30000-50000 --tls-cert-file=/opt/kubernetes/ssl/server.pem --tls-private-key-file=/opt/kubernetes/ssl/server-key.pem --client-ca-file=/opt/kubernetes/ssl/ca.pem --service-account-key-file=/opt/kubernetes/ssl/ca-key.pem --etcd-cafile=/opt/etcd/ssl/ca.pem --etcd-certfile=/opt/etcd/ssl/server.pem --etcd-keyfile=/opt/etcd/ssl/server-key.pem[root@k8s-master02 etcd]# ps axf|grep scheduler
      9530 pts/1    S+     0:00          \_ grep --color=auto scheduler
      8576 ?        Ssl    0:21 /opt/kubernetes/bin/kube-scheduler --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect
    [root@k8s-master02 etcd]# ps axf|grep controller-manager
      9532 pts/1    S+     0:00          \_ grep --color=auto controller-manager
      8628 ?        Ssl    0:01 /opt/kubernetes/bin/kube-controller-manager --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-
    elect=true --address=127.0.0.1 --service-cluster-ip-range=10.0.0.0/24 --cluster-name=kubernetes --cluster-signing-cert-file=/opt/kubernetes/ssl/ca.pem --cluster-signing-key-file=/opt/kubernetes/ssl/ca-key.pem --root-ca-file=/opt/kubernetes/ssl/ca.pem --service-account-private-key-file=/opt/kubernetes/ssl/ca-key.pem --experimental-cluster-signing-duration=87600h0m0s
    ```

master02的所有配置文件如下:
```
[root@k8s-master02 kubernetes]# tree .
.
├── bin
│   ├── kube-apiserver
│   ├── kube-controller-manager
│   └── kube-scheduler
├── cfg
│   ├── kube-apiserver
│   ├── kube-controller-manager
│   ├── kube-scheduler
│   └── token.csv
├── logs
└── ssl
    ├── ca-key.pem
    ├── ca.pem
    ├── server-key.pem
    └── server.pem

4 directories, 11 files
```


??? note "kube-apiserver配置文件"
    ```
    [root@k8s-master02 cfg]# cat kube-apiserver
    
    KUBE_APISERVER_OPTS="--logtostderr=true \
    --v=4 \
    --etcd-servers=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379 \
    --bind-address=192.168.186.140 \
    --secure-port=6443 \
    --advertise-address=192.168.186.140 \
    --allow-privileged=true \
    --service-cluster-ip-range=10.0.0.0/24 \
    --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction \
    --authorization-mode=RBAC,Node \
    --kubelet-https=true \
    --enable-bootstrap-token-auth \
    --token-auth-file=/opt/kubernetes/cfg/token.csv \
    --service-node-port-range=30000-50000 \
    --tls-cert-file=/opt/kubernetes/ssl/server.pem  \
    --tls-private-key-file=/opt/kubernetes/ssl/server-key.pem \
    --client-ca-file=/opt/kubernetes/ssl/ca.pem \
    --service-account-key-file=/opt/kubernetes/ssl/ca-key.pem \
    --etcd-cafile=/opt/etcd/ssl/ca.pem \
    --etcd-certfile=/opt/etcd/ssl/server.pem \
    --etcd-keyfile=/opt/etcd/ssl/server-key.pem"
    ```

??? note "kube-controller-manager 配置文件"
    ```
    [root@k8s-master02 cfg]# cat kube-controller-manager
    
    
    KUBE_CONTROLLER_MANAGER_OPTS="--logtostderr=true \
    --v=4 \
    --master=127.0.0.1:8080 \
    --leader-elect=true \
    --address=127.0.0.1 \
    --service-cluster-ip-range=10.0.0.0/24 \
    --cluster-name=kubernetes \
    --cluster-signing-cert-file=/opt/kubernetes/ssl/ca.pem \
    --cluster-signing-key-file=/opt/kubernetes/ssl/ca-key.pem  \
    --root-ca-file=/opt/kubernetes/ssl/ca.pem \
    --service-account-private-key-file=/opt/kubernetes/ssl/ca-key.pem \
    --experimental-cluster-signing-duration=87600h0m0s"
    ```

??? note "kube-scheduler 配置文件"
    ```
    [root@k8s-master02 cfg]# cat kube-scheduler
    
    KUBE_SCHEDULER_OPTS="--logtostderr=true \
    --v=4 \
    --master=127.0.0.1:8080 \
    --leader-elect"
    ```

??? note "token.csv 配置文件"
    ```
    [root@k8s-master02 cfg]# cat token.csv
    0fb61c46f8991b718eb38d27b605b008,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
    ```
    
## 2. 测试
```
[root@k8s-master02 ~]# kubectl get pods
NAME                   READY   STATUS    RESTARTS   AGE
nginx-5c7588df-c58ql   1/1     Running   0          3d15h
nginx-5c7588df-gh6l9   1/1     Running   0          3d15h
nginx-5c7588df-nlj5l   1/1     Running   0          3d15h
nginx-5c7588df-p8ls9   1/1     Running   0          2d17h
nginx-5c7588df-sv64n   1/1     Running   0          2d17h
[root@k8s-master02 ~]# kubectl get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP            NODE              NOMINATED NODE   READINESS GATES
nginx-5c7588df-c58ql   1/1     Running   0          3d15h   172.17.8.2    192.168.186.142   <none>           <none>
nginx-5c7588df-gh6l9   1/1     Running   0          3d15h   172.17.66.3   192.168.186.141   <none>           <none>
nginx-5c7588df-nlj5l   1/1     Running   0          3d15h   172.17.66.2   192.168.186.141   <none>           <none>
nginx-5c7588df-p8ls9   1/1     Running   0          2d17h   172.17.8.4    192.168.186.142   <none>           <none>
nginx-5c7588df-sv64n   1/1     Running   0          2d17h   172.17.8.3    192.168.186.142   <none>           <none>
[root@k8s-master02 ~]# kubectl get nodes -o wide
NAME              STATUS   ROLES    AGE     VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
192.168.186.141   Ready    <none>   3d16h   v1.13.4   192.168.186.141   <none>        CentOS Linux 7 (Core)   3.10.0-957.el7.x86_64        docker://18.9.5
192.168.186.142   Ready    <none>   3d15h   v1.13.4   192.168.186.142   <none>        CentOS Linux 7 (Core)   3.10.0-957.10.1.el7.x86_64   docker://18.9.5


[root@k8s-master02 kubernetes]# kubectl get cs
NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok                  
controller-manager   Healthy   ok                  
etcd-0               Healthy   {"health":"true"}   
etcd-1               Healthy   {"health":"true"}   
etcd-2               Healthy   {"health":"true"} 
```
> 到目前为相当完全复制master[除了修改配置文件]过来，启动一个新的master。以后不管新增几台master都是这样操作。

!!! note "注意"
    ```
    1.服务器时间
    2.证书
    3.配置文件
    4.启动命令
    ```


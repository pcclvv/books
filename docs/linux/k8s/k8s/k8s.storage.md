<center><h1>Kubernets PV PVC</h1></center>

## 1. Volume

```
https://kubernetes.io/docs/concepts/storage/volumes/
```

- Kubernetes中的Volume提供了在容器中挂载外部存储的能力
- Pod需要设置卷来源（spec.volume）和挂载点（spec.containers.volumeMounts）两个信息后才可以使用相应的Volume

> Volume使用网络卷或者本地卷

### 1.1 本地卷emptyDir

&#160; &#160; &#160; &#160;创建一个空卷，挂载到Pod中的容器。Pod删除该卷也会被删除。应用场景：Pod中容器之间数据共享

!!! note "emptydir.yaml "
    ```
    #[root@k8s-master01 demo2]# cat emptydir.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
      name: my-pod
    spec:
      containers:
      - name: write
        image: centos
        command: ["bash","-c","for i in {1..100};do echo $i >> /data/hello;sleep 1;done"]
        volumeMounts:
        - name: data
          mountPath: /data
      - name: read
        image: centos
        command: ["bash","-c","tail -f /data/hello"]
        volumeMounts:
          - name: data
            mountPath: /data
      volumes:
      - name: data
        emptyDir: {}
    ```

```
[root@k8s-master01 demo2]# kubectl apply -f emptydir.yaml 
pod/my-pod created
[root@k8s-master01 demo2]# kubectl get pods|grep my-pod
my-pod                              2/2     Running            0          50s
```

??? note "详细信息"
    ```
    [root@k8s-master01 demo2]# kubectl describe pod my-pod
    Name:               my-pod
    Namespace:          default
    Priority:           0
    PriorityClassName:  <none>
    Node:               192.168.186.141/192.168.186.141
    Start Time:         Thu, 25 Apr 2019 16:48:27 +0800
    Labels:             <none>
    Annotations:        kubectl.kubernetes.io/last-applied-configuration:
                          {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"my-pod","namespace":"default"},"spec":{"containers":[{"command":["bas...
    Status:             Running
    IP:                 172.17.67.3
    Containers:
      write:
        Container ID:  docker://f20260fe40af4d096882d974ebf254606e54e5d40cd360766e49fc411a205078
        Image:         centos
        Image ID:      docker-pullable://centos@sha256:b40cee82d6f98a785b6ae35748c958804621dc0f2194759a2b8911744457337d
        Port:          <none>
        Host Port:     <none>
        Command:
          bash
          -c
          for i in {1..100};do echo $i >> /data/hello;sleep 1;done
        State:          Running
          Started:      Thu, 25 Apr 2019 16:50:40 +0800
        Last State:     Terminated
          Reason:       Completed
          Exit Code:    0
          Started:      Thu, 25 Apr 2019 16:48:58 +0800
          Finished:     Thu, 25 Apr 2019 16:50:38 +0800
        Ready:          True
        Restart Count:  1
        Environment:    <none>
        Mounts:
          /data from data (rw)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-r5m2l (ro)
      read:
        Container ID:  docker://b40e9c9ba0647231866c45d43f624873a7ab5cd02a2b8c9463592d1b331fcee0
        Image:         centos
        Image ID:      docker-pullable://centos@sha256:b40cee82d6f98a785b6ae35748c958804621dc0f2194759a2b8911744457337d
        Port:          <none>
        Host Port:     <none>
        Command:
          bash
          -c
          tail -f /data/hello
        State:          Running
          Started:      Thu, 25 Apr 2019 16:48:59 +0800
        Ready:          True
        Restart Count:  0
        Environment:    <none>
        Mounts:
          /data from data (rw)
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-r5m2l (ro)
    Conditions:
      Type              Status
      Initialized       True 
      Ready             True 
      ContainersReady   True 
      PodScheduled      True 
    Volumes:
      data:
        Type:    EmptyDir (a temporary directory that shares a pod's lifetime)
        Medium:  
      default-token-r5m2l:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-r5m2l
        Optional:    false
    QoS Class:       BestEffort
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:
      Type    Reason     Age                  From                      Message
      ----    ------     ----                 ----                      -------
      Normal  Scheduled  2m55s                default-scheduler         Successfully assigned default/my-pod to 192.168.186.141
      Normal  Created    2m24s                kubelet, 192.168.186.141  Created container
      Normal  Pulling    2m24s                kubelet, 192.168.186.141  pulling image "centos"
      Normal  Pulled     2m24s                kubelet, 192.168.186.141  Successfully pulled image "centos"
      Normal  Started    2m23s                kubelet, 192.168.186.141  Started container
      Normal  Created    42s (x2 over 2m24s)  kubelet, 192.168.186.141  Created container
      Normal  Started    42s (x2 over 2m24s)  kubelet, 192.168.186.141  Started container
      Normal  Pulling    42s (x2 over 2m52s)  kubelet, 192.168.186.141  pulling image "centos"
      Normal  Pulled     42s (x2 over 2m24s)  kubelet, 192.168.186.141  Successfully pulled image "centos"
    ```


??? note "查看日志"
    ```python
    [root@k8s-master01 demo2]# kubectl log my-pod
    log is DEPRECATED and will be removed in a future version. Use logs instead.
    Error from server (BadRequest): a container name must be specified for pod my-pod, choose one
     of: [write read][root@k8s-master01 demo2]# kubectl log my-pod -c write
    log is DEPRECATED and will be removed in a future version. Use logs instead.
    
    这个pod中有两个容器。
    [root@k8s-master01 demo2]# kubectl logs my-pod -c write
    [root@k8s-master01 demo2]# kubectl logs my-pod -c read
    1
    2
    3
    4
    5
    6
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
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    44
    45
    46
    47
    48
    49
    50
    51
    52
    53
    54
    55
    56
    57
    58
    59
    60
    61
    62
    63
    64
    65
    66
    67
    68
    69
    70
    71
    72
    73
    74
    75
    76
    77
    78
    79
    80
    81
    82
    83
    84
    85
    86
    87
    88
    89
    90
    91
    92
    93
    94
    95
    96
    97
    98
    99
    100
    1
    2
    3
    4
    5
    6
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
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    44
    45
    46
    47
    48
    49
    50
    51
    52
    53
    54
    55
    56
    57
    58
    59
    60
    61
    62
    63
    64
    65
    66
    67
    68
    69
    70
    71
    72
    73
    74
    75
    76
    77
    78
    79
    80
    81
    82
    83
    84
    85
    86
    87
    88
    89
    90
    91
    92
    93
    94
    95
    96
    97
    98
    99
    100
    1
    2
    3
    4
    5
    6
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
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    ```
> emptyDir,pod删除，数据就没了

### 1.2 本地卷hostPath

&#160; &#160; &#160; &#160;挂载Node文件系统上文件或者目录到Pod中的容器。应用场景：Pod中容器需要访问宿主机文件

??? note "hostpath.yaml"
    ```
    [root@k8s-master01 demo2]# cat hostpath.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
      name: my-busybox
    spec:
      containers:
      - name: busybox
        image: busybox
        args:
        - /bin/sh
        - -c
        - sleep 36000
        volumeMounts:
        - name: data
          mountPath: /data
      volumes:
      - name: data
        hostPath:
          path: /tmp
          type: Directory
    ```

Value|	Behavior
---|---
Empty| string (default) is for backward compatibility, which means that no checks will be performed before mounting the hostPath volume.
DirectoryOrCreate|	If nothing exists at the given path, an empty directory will be created there as needed with permission set to 0755, having the same group and ownership with Kubelet.
Directory|	A directory must exist at the given path
FileOrCreate|	If nothing exists at the given path, an empty file will be created there as needed with permission set to 0644, having the same group and ownership with Kubelet.
File|	A file must exist at the given path
Socket|	A UNIX socket must exist at the given path
CharDevice|	A character device must exist at the given path
BlockDevice|	A block device must exist at the given path

> 容器中/data 挂载宿主机的/tmp目录 

```
[root@k8s-master01 demo2]# kubectl apply -f hostpath.yaml 
pod/my-busybox created
[root@k8s-master01 demo2]# kubectl get pods|grep busybox
my-busybox                          1/1     Running            0          70s

检查
[root@k8s-master01 demo2]# kubectl get pods -o wide |grep box
my-busybox                          1/1     Running            0          6m41s   172.17.22.6    192.168.186.142   <none>           <none>
容器在142上，我们到142的/tmp下弄个文件。
[root@k8s-node02 tmp]# echo 'data from node2'>192.168.186.142.txt

进入容器查看
[root@k8s-master01 demo2]# kubectl exec -it my-busybox sh
/ # ls /data/
192.168.186.142.txt                                                      systemd-private-91d4b443e5c148b580b7f3aacd6dcac7-chronyd.service-4HSlRm
containerd                                                               yum.log
etcd                                                                     yum_save_tx.2019-04-17.00-33.eWz8Yx.yumtx
ks-script-jkDCBH
/ # cat /data/192.168.186.142.txt 
data from node2
```
> 测试OK.

### 1.3 网络卷nfs
nfs网络卷不像上面emptydir，pod删除，数据就没了。我们在`192.168.186.143` 机器上安装一个nfs，作为nfs server。

!!! note "nfs.yaml"
    ```
    [root@k8s-master01 demo2]# cat nfs.yaml 
    apiVersion: apps/v1beta1
    kind: Deployment
    metadata:
      name: caimengzhi-nginx-deployment
    spec:
      replicas: 3
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - name: nginx
            image: nginx
            volumeMounts:
            - name: wwwroot
              mountPath: /usr/share/nginx/html
            ports:
            - containerPort: 80
          volumes:
          - name: wwwroot
            nfs:
             server: 192.168.186.143
             path: /caimengzhi/kubernetes
    ```

```
[root@k8s-lb01 ~]# yum install -y nfs-utils

所有node节点都要安装nfs客户端
[root@k8s-node01 ~]# yum install -y nfs-utils
[root@k8s-node02 ~]# yum install -y nfs-utils

[root@k8s-lb01 ~]# cat /etc/exports
/caimengzhi/kubernetes *(rw,no_root_squash)
[root@k8s-lb01 ~]# mkdir -p /caimengzhi/kubernetes
[root@k8s-lb01 ~]# systemctl restart nfs
[root@k8s-lb01 ~]# ps axf|grep nfs
 58614 ?        S<     0:00  \_ [nfsd4_callbacks]
 58620 ?        S      0:00  \_ [nfsd]
 58621 ?        S      0:00  \_ [nfsd]
 58622 ?        S      0:00  \_ [nfsd]
 58623 ?        S      0:00  \_ [nfsd]
 58624 ?        S      0:00  \_ [nfsd]
 58625 ?        S      0:00  \_ [nfsd]
 58626 ?        S      0:00  \_ [nfsd]
 58627 ?        S      0:00  \_ [nfsd]
 59201 pts/0    S+     0:00          \_ grep --color=auto nfs
 [root@k8s-lb01 ~]# cd /caimengzhi/kubernetes/
[root@k8s-lb01 kubernetes]# ls
[root@k8s-lb01 kubernetes]# echo 'data from nfs server' >nfs_server.txt
[root@k8s-lb01 kubernetes]# ls
nfs_server.txt

简单node端挂载测试
[root@k8s-node01 ~]# mount -t nfs 192.168.186.143:/caimengzhi/kubernetes/ /mnt/
[root@k8s-node01 ~]# cd /mnt/
[root@k8s-node01 mnt]# ls
nfs_server.txt
[root@k8s-node01 mnt]# cat nfs_server.txt 
data from nfs server
[root@k8s-node01 mnt]# umount -l /mnt/
说明node端挂载OK。
```

```
[root@k8s-master01 demo2]# kubectl create -f nfs.yaml 
deployment.apps/caimengzhi-nginx-deployment created

[root@k8s-master01 demo2]# kubectl get pod
NAME                                           READY   STATUS             RESTARTS   AGE
agent-rxgp9                                    1/1     Running            1          2d6h
agent-twh7c                                    1/1     Running            1          2d6h
caimengzhi-nginx-deployment-65cdb6c7bf-55jsb   1/1     Running            0          15s
caimengzhi-nginx-deployment-65cdb6c7bf-dn4c6   1/1     Running            0          15s
caimengzhi-nginx-deployment-65cdb6c7bf-fxpbd   1/1     Running            0          15s
frontend                                       1/2     CrashLoopBackOff   360        2d22h
hello-1556024580-994rw                         0/1     Completed          0          45h
hello-1556024640-54b7k                         0/1     Completed          0          45h
hello-1556024700-rkw4f                         0/1     Completed          0          45h
liveness-exec                                  0/1     CrashLoopBackOff   466        2d22h
my-busybox                                     1/1     Running            0          50m
my-pod                                         1/2     CrashLoopBackOff   12         62m
mypod                                          1/1     Running            1          2d2h
mypod2                                         1/1     Running            1          2d2h
mypod4                                         0/1     Completed          0          2d1h
nginx-57b495474c-79mv7                         0/1     ImagePullBackOff   0          29h
nginx-deployment-5997b94b5c-74bm4              1/1     Running            0          29h
nginx-deployment-5997b94b5c-9fft9              1/1     Running            0          29h
nginx-deployment-5997b94b5c-r88k8              1/1     Running            0          29h
pi-4bz86                                       0/1     Completed          0          2d3h


nfs server 端写一个测试页
[root@k8s-lb01 kubernetes]# echo '<h1>hello world</h1>'>index.html
[root@k8s-lb01 kubernetes]# pwd
/caimengzhi/kubernetes
[root@k8s-lb01 kubernetes]# ls
index.html  nfs_server.txt

找到内网地址
[root@k8s-master01 demo2]# kubectl get pods -o wide
NAME                                           READY   STATUS             RESTARTS   AGE     IP             NODE              NOMINATED NODE   READINESS GATES
agent-rxgp9                                    1/1     Running            1          2d6h    172.17.22.7    192.168.186.142   <none>           <none>
agent-twh7c                                    1/1     Running            1          2d6h    172.17.67.2    192.168.186.141   <none>           <none>
caimengzhi-nginx-deployment-65cdb6c7bf-55jsb   1/1     Running            0          3m23s   172.17.22.8    192.168.186.142   <none>           <none>
caimengzhi-nginx-deployment-65cdb6c7bf-dn4c6   1/1     Running            0          3m23s   172.17.22.9    192.168.186.142   <none>           <none>
caimengzhi-nginx-deployment-65cdb6c7bf-fxpbd   1/1     Running            0          3m23s   172.17.67.4    192.168.186.141   <none>           <none>
frontend                                       1/2     CrashLoopBackOff   361        2d22h   172.17.22.3    192.168.186.142   <none>           <none>
hello-1556024580-994rw                         0/1     Completed          0          45h     172.17.22.26   192.168.186.142   <none>           <none>
hello-1556024640-54b7k                         0/1     Completed          0          45h     172.17.67.9    192.168.186.141   <none>           <none>
hello-1556024700-rkw4f                         0/1     Completed          0          45h     172.17.22.9    192.168.186.142   <none>           <none>
liveness-exec                                  1/1     Running            468        2d22h   172.17.22.17   192.168.186.142   <none>           <none>
my-busybox                                     1/1     Running            0          53m     172.17.22.6    192.168.186.142   <none>           <none>
my-pod                                         1/2     CrashLoopBackOff   13         65m     172.17.67.3    192.168.186.141   <none>           <none>
mypod                                          1/1     Running            1          2d2h    172.17.22.5    192.168.186.142   <none>           <none>
mypod2                                         1/1     Running            1          2d2h    172.17.22.18   192.168.186.142   <none>           <none>
mypod4                                         0/1     Completed          0          2d1h    172.17.8.9     192.168.186.142   <none>           <none>
nginx-57b495474c-79mv7                         0/1     ImagePullBackOff   0          29h     172.17.22.4    192.168.186.142   <none>           <none>
nginx-deployment-5997b94b5c-74bm4              1/1     Running            0          29h     172.17.67.20   192.168.186.141   <none>           <none>
nginx-deployment-5997b94b5c-9fft9              1/1     Running            0          29h     172.17.67.21   192.168.186.141   <none>           <none>
nginx-deployment-5997b94b5c-r88k8              1/1     Running            0          29h     172.17.67.22   192.168.186.141   <none>           <none>
pi-4bz86                                       0/1     Completed          0          2d3h    172.17.8.7     192.168.186.142   <none>           <none>
~~~~
在node上测试
[root@k8s-node02 tmp]# curl 172.17.22.8
<h1>hello world</h1>
```

## 2. PersistentVolume 静态

&#160; &#160; &#160; &#160;管理存储和管理计算有着明显的不同。PersistentVolume子系统给用户和管理员提供了一套API，从而抽象出存储是如何提供和消耗的细节。在这里，我们介绍两种新的API资源：PersistentVolume（简称PV）和PersistentVolumeClaim（简称PVC）。

&#160; &#160; &#160; &#160;PersistentVolume（持久卷，简称PV）是集群内，由管理员提供的网络存储的一部分。就像集群中的节点一样，PV也是集群中的一种资源。它也像Volume一样，是一种volume插件，但是它的生命周期却是和使用它的Pod相互独立的。PV这个API对象，捕获了诸如NFS、ISCSI、或其他云存储系统的实现细节。

&#160; &#160; &#160; &#160;PersistentVolumeClaim（持久卷声明，简称PVC）是用户的一种存储请求。它和Pod类似，Pod消耗Node资源，而PVC消耗PV资源。Pod能够请求特定的资源（如CPU和内存）。PVC能够请求指定的大小和访问的模式（可以被映射为一次读写或者多次只读）。PVC允许用户消耗抽象的存储资源，用户也经常需要各种属性（如性能）的PV。集群管理员需要提供各种各样、不同大小、不同访问模式的PV，而不用向用户暴露这些volume如何实现的细节。因为这种需求，就催生出一种StorageClass资源。

&#160; &#160; &#160; &#160;StorageClass提供了一种方式，使得管理员能够描述他提供的存储的等级。集群管理员可以将不同的等级映射到不同的服务等级、不同的后端策略。

### 2.1 volume和claim的生命周期
&#160; &#160; &#160; &#160;，PVC是对这些资源的请求，同时也是这些资源的“提取证”。PV和PVC的交互遵循以下生命周期：

- 供给
有两种PV提供的方式：静态和动态。

```
- 静态
    集群管理员创建多个PV，它们携带着真实存储的详细信息，这些存储对于集群用户是可用的。它们存在于Kubernetes API中，并可用于存储使用。
    
- 动态
    当管理员创建的静态PV都不匹配用户的PVC时，集群可能会尝试专门地供给volume给PVC。这种供给基于StorageClass：PVC必须请求这样一个等级，而管理员必须已经创建和配置过这样一个等级，以备发生这种动态供给的情况。请求等级配置为“”的PVC，有效地禁用了它自身的动态供给功能。
```

- 绑定

&#160; &#160; &#160; &#160;用户创建一个PVC（或者之前就已经就为动态供给创建了），指定要求存储的大小和访问模式。master中有一个控制回路用于监控新的PVC，查找匹配的PV（如果有），并把PVC和PV绑定在一起。如果一个PV曾经动态供给到了一个新的PVC，那么这个回路会一直绑定这个PV和PVC。另外，用户总是至少能得到它们所要求的存储，但是volume可能超过它们的请求。一旦绑定了，PVC绑定就是专属的，无论它们的绑定模式是什么。

&#160; &#160; &#160; &#160;如果没找到匹配的PV，那么PVC会无限期得处于unbound未绑定状态，一旦PV可用了，PVC就会又变成绑定状态。比如，如果一个供给了很多50G的PV集群，不会匹配要求100G的PVC。直到100G的PV添加到该集群时，PVC才会被绑定。

- 使用

&#160; &#160; &#160; &#160;Pod使用PVC就像使用volume一样。集群检查PVC，查找绑定的PV，并映射PV给Pod。对于支持多种访问模式的PV，用户可以指定想用的模式。一旦用户拥有了一个PVC，并且PVC被绑定，那么只要用户还需要，PV就一直属于这个用户。用户调度Pod，通过在Pod的volume块中包含PVC来访问PV。

- 释放

&#160; &#160; &#160; &#160;当用户使用PV完毕后，他们可以通过API来删除PVC对象。当PVC被删除后，对应的PV就被认为是已经是“released”了，但还不能再给另外一个PVC使用。前一个PVC的属于还存在于该PV中，必须根据策略来处理掉。

- 回收

&#160; &#160; &#160; &#160;PV的回收策略告诉集群，在PV被释放之后集群应该如何处理该PV。当前，PV可以被Retained（保留）、 Recycled（再利用）或者Deleted（删除）。保留允许手动地再次声明资源。对于支持删除操作的PV卷，删除操作会从Kubernetes中移除PV对象，还有对应的外部存储（如AWS EBS，GCE PD，Azure Disk，或者Cinder volume）。动态供给的卷总是会被删除。

- 再利用

&#160; &#160; &#160; &#160;如果PV卷支持再利用，再利用会在PV卷上执行一个基础的擦除操作（rm -rf /thevolume/*），使得它可以再次被其他PVC声明利用。

Kubernetes支持持久卷的存储插件：
```
https://kubernetes.io/docs/concepts/storage/persistent-volumes/
```

- PersistenVolume（PV）：对存储资源创建和使用的抽象，使得存储作为集群中的资源管理
  - 静态
  - 动态
- PersistentVolumeClaim（PVC）：让用户不需要关心具体的Volume实现细节


!!! note "pv.yaml"
    ```
    # [root@k8s-master01 demo2]# cat pv.yaml 
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: caimengzhi-nfs-pv
    spec:
      capacity:
        storage: 5Gi
      accessModes:
        - ReadWriteMany
      nfs:
        path: "/caimengzhi/kubernetes"
        server: 192.168.186.143
    ```

!!! note "nfs-example.yaml"
    ```
    # [root@k8s-master01 demo2]# cat nfs-example.yaml 
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: caimengzhi-nfs-pvc
    spec:
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 5Gi
    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: caimengzhi-pv-pvc-nfs-pod
    spec:
      containers:
        - name: nginx
          image: nginx
          volumeMounts:
          - mountPath: "/usr/share/nginx/html/"
            name: wwwroot
      volumes:
        - name: wwwroot
          persistentVolumeClaim:
            claimName: caimengzhi-nfs-pvc
    ```

```
创建pv
[root@k8s-master01 demo2]# kubectl create -f pv.yaml 
persistentvolume/caimengzhi-nfs-pv created
查看pv
[root@k8s-master01 demo2]# kubectl get pv
NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
caimengzhi-nfs-pv   5Gi        RWX            Retain           Available                                   4s

创建pvc
[root@k8s-master01 demo2]# kubectl create -f nfs-example.yaml 
persistentvolumeclaim/caimengzhi-nfs-pvc created
pod/caimengzhi-pv-pvc-nfs-pod created
查看pvc
[root@k8s-master01 demo2]# kubectl get pvc
NAME                 STATUS   VOLUME              CAPACITY   ACCESS MODES   STORAGECLASS   AGE
caimengzhi-nfs-pvc   Bound    caimengzhi-nfs-pv   5Gi        RWX                           5s
[root@k8s-master01 demo2]# kubectl get pv,pvc
NAME                                 CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   REASON   AGE
persistentvolume/caimengzhi-nfs-pv   5Gi        RWX            Retain           Bound    default/caimengzhi-nfs-pvc                           18s

NAME                                       STATUS   VOLUME              CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/caimengzhi-nfs-pvc   Bound    caimengzhi-nfs-pv   5Gi        RWX                           8s


[root@k8s-master01 demo2]# kubectl get pods
NAME                                           READY   STATUS             RESTARTS   AGE
agent-rxgp9                                    1/1     Running            1          2d7h
agent-twh7c                                    1/1     Running            1          2d7h
caimengzhi-nginx-deployment-65cdb6c7bf-55jsb   1/1     Running            0          94m
caimengzhi-nginx-deployment-65cdb6c7bf-dn4c6   1/1     Running            0          94m
caimengzhi-nginx-deployment-65cdb6c7bf-fxpbd   1/1     Running            0          94m
caimengzhi-pv-pvc-nfs-pod                      1/1     Running            0          61s
nginx-57b495474c-866lv                         0/1     ImagePullBackOff   0          37m
nginx-deployment-5997b94b5c-74bm4              1/1     Running            0          31h
nginx-deployment-5997b94b5c-9fft9              1/1     Running            0          31h
nginx-deployment-5997b94b5c-r88k8              1/1     Running            0          31h
pi-4bz86                                       0/1     Completed          0          2d4h

进入容器查看
[root@k8s-master01 demo2]# kubectl exec -it caimengzhi-pv-pvc-nfs-pod bash
root@caimengzhi-pv-pvc-nfs-pod:/# ls /usr/share/nginx/html/
index.html  nfs_server.txt
```

> 虽然我们使用了pvc，其实还是关联了之前创建的pv，也就是共享了nfs数据一旦数据有变更，其他都跟着变动。

> 以上是静态的供给，也就是先创建pv，然后pvc关联pv，最后容器服务关联pvc，接下来我们讲述另一种pvc自动创建pv。

??? note "删除pv，pvc"
    ```
    [root@k8s-master01 demo2]# kubectl delete -f nfs-example.yaml 
    persistentvolumeclaim "nfs-pvc" deleted
    pod "cmz-mypod" deleted
    [root@k8s-master01 demo2]# kubectl delete -f pv.yaml 
    Error from server (NotFound): error when deleting "pv.yaml": persistentvolumes "nfs-pv" not found
    [root@k8s-master01 demo2]# kubectl delete -f pv.yaml ^C
    [root@k8s-master01 demo2]# kubectl get pv
    No resources found.
    [root@k8s-master01 demo2]# kubectl get pvc
    No resources found.
    
    # 删除pvc的时候，k8s不会默认删除pv，要是删除的话，需要手动删除
    ```

## 3. PersistentVolume 动态

&#160; &#160; &#160; &#160;Dynamic Provisioning机制工作的核心在于StorageClass的API对象。StorageClass声明存储插件，用于自动创建PV。

```
https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/
```

Kubernetes支持动态供给的存储插件：
```
https://kubernetes.io/docs/concepts/storage/storage-classes/
```

<center>![service类型](../../../pictures/linux/k8s/k8s/pvd1.png)</center>

下面使用nfs-client插件

??? note "class.yaml"
    ```
    # [root@k8s-master01 deploy]# pwd
    # /root/external-storage-master/nfs-client/deploy
    # [root@k8s-master01 deploy]# cat class.yaml 
    apiVersion: storage.k8s.io/v1
    kind: StorageClass
    metadata:
      name: managed-nfs-storage
    provisioner: fuseim.pri/ifs # or choose another name, must match deployment's env PROVISIONER_NAME'
    parameters:
      archiveOnDelete: "true" # delete pvc,then not delete pv. if false delet pvc and also delete pv
    # 我修改为true，之前下载下来是false。
    ```
    
??? note ""
    ```
    # [root@k8s-master01 deploy]# pwd
    # /root/external-storage-master/nfs-client/deploy

    # [root@k8s-master01 deploy]# cat deployment.yaml 
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: nfs-client-provisioner
    ---
    kind: Deployment
    apiVersion: extensions/v1beta1
    metadata:
      name: nfs-client-provisioner
    spec:
      replicas: 1
      strategy:
        type: Recreate
      template:
        metadata:
          labels:
            app: nfs-client-provisioner
        spec:
          serviceAccountName: nfs-client-provisioner
          containers:
            - name: nfs-client-provisioner
              image: quay.io/external_storage/nfs-client-provisioner:latest
              volumeMounts:
                - name: nfs-client-root
                  mountPath: /persistentvolumes
              env:
                - name: PROVISIONER_NAME
                  value: fuseim.pri/ifs
                - name: NFS_SERVER
                  value: 192.168.186.143  # 修改你真实的nfs-server的共享目录和ip
                - name: NFS_PATH
                  value: /ifs/kubernetes
          volumes:
            - name: nfs-client-root
              nfs:
                server: 192.168.186.143   # 修改你真实的nfs-server的共享目录和ip
                path: /ifs/kubernetes
    
    ```


测试例子

??? note "pod-sc.yaml"
    ```
    # [root@k8s-master01 demo2]# cat pod-sc.yaml 
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: test-claim
    spec:
      accessModes: [ "ReadWriteMany" ]
      storageClassName: "managed-nfs-storage"
      resources:
        requests:
          storage: 1Gi
    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: test-mypod
    spec:
      containers:
        - name: test-pod
          image: nginx
          ports:
            - containerPort: 80
              name: web
          volumeMounts:
            - name: www
              mountPath: "/usr/share/nginx/html/" 
      volumes:
        - name: www
          persistentVolumeClaim:
            claimName: test-claim
    ```



首先在nfs server创建要暴露的文件存储路径`/ifs/kubernetes`,这个是动态pv的默认路径，
```
[root@k8s-lb01 kubernetes]# mkdir -p /ifs/kubernetes   # 默认的，要和动态存储的位置要一致
[root@k8s-lb01 kubernetes]# cat /etc/exports
/ifs/kubernetes *(rw,no_root_squash)
/caimengzhi/kubernetes *(rw,no_root_squash)
[root@k8s-lb01 kubernetes]# systemctl restart nfs
[root@k8s-lb01 kubernetes]# !ps
ps axf|grep nfs
113679 ?        S<     0:00  \_ [nfsd4_callbacks]
113683 ?        S      0:00  \_ [nfsd]
113684 ?        S      0:00  \_ [nfsd]
113685 ?        S      0:00  \_ [nfsd]
113686 ?        S      0:00  \_ [nfsd]
113687 ?        S      0:00  \_ [nfsd]
113688 ?        S      0:00  \_ [nfsd]
113689 ?        S      0:00  \_ [nfsd]
113690 ?        S      0:00  \_ [nfsd]
113719 pts/0    S+     0:00          \_ grep --color=auto nfs
```


```
[root@k8s-master01 ~]# git clone https://github.com/kubernetes-incubator/external-storage.git
# 使用迅雷下载吧。太他妹的慢了。 https://codeload.github.com/kubernetes-incubator/external-storage/zip/master

[root@k8s-master01 ~]# unzip external-storage-master.zip 
[root@k8s-master01 ~]# ls
demo2  external-storage-master  external-storage-master.zip  harbor  k8s  old  soft  yml
[root@k8s-master01 ~]# cd external-storage-master/nfs-client/
[root@k8s-master01 nfs-client]# pwd
/root/external-storage-master/nfs-client
[root@k8s-master01 nfs-client]# ls
CHANGELOG.md  cmd  deploy  docker  Makefile  OWNERS  README.md
[root@k8s-master01 nfs-client]# cd deploy/
[root@k8s-master01 deploy]# ls
class.yaml           deployment.yaml  rbac.yaml        test-pod.yaml
deployment-arm.yaml  objects          test-claim.yaml
[root@k8s-master01 deploy]# grep -C3 /ifs/kubernetes deployment.yaml 
            - name: NFS_SERVER
              value: 10.10.10.60
            - name: NFS_PATH
              value: /ifs/kubernetes   # 默认路径，需要先在nfs-server中先创建或者修改成你要暴露的文件路径
      volumes:
        - name: nfs-client-root
          nfs:
            server: 10.10.10.60
            path: /ifs/kubernetes

创建角色
[root@k8s-master01 deploy]# kubectl create -f rbac.yaml 
serviceaccount/nfs-client-provisioner created
clusterrole.rbac.authorization.k8s.io/nfs-client-provisioner-runner created
clusterrolebinding.rbac.authorization.k8s.io/run-nfs-client-provisioner created
role.rbac.authorization.k8s.io/leader-locking-nfs-client-provisioner created
rolebinding.rbac.authorization.k8s.io/leader-locking-nfs-client-provisioner created

创建stroage
[root@k8s-master01 deploy]# kubectl create -f class.yaml 
storageclass.storage.k8s.io/managed-nfs-storage created

[root@k8s-master01 deploy]# kubectl get pod
NAME                                           READY   STATUS             RESTARTS   AGE
agent-c8whb                                    1/1     Running            0          12h
agent-vc25d                                    1/1     Running            0          12h
caimengzhi-nginx-deployment-65cdb6c7bf-55jsb   1/1     Running            0          15h
caimengzhi-nginx-deployment-65cdb6c7bf-dn4c6   1/1     Running            0          15h
caimengzhi-nginx-deployment-65cdb6c7bf-fxpbd   1/1     Running            0          15h
caimengzhi-pv-pvc-nfs-pod                      1/1     Running            0          14h
nfs-client-provisioner-d947789f7-xttfd         1/1     Running            0          9m10s
nginx-57b495474c-866lv                         0/1     ImagePullBackOff   0          14h
nginx-deployment-5997b94b5c-74bm4              1/1     Running            0          45h
nginx-deployment-5997b94b5c-9fft9              1/1     Running            0          45h
nginx-deployment-5997b94b5c-r88k8              1/1     Running            0          45h
pi-4bz86                                       0/1     Completed          0          2d18h
test-pod                                       1/1     Running            0          12h

一定要nfs-client-provisioner 这个pod一定要Running。

[root@k8s-master01 deploy]# kubectl get storageclass
NAME                  PROVISIONER      AGE
managed-nfs-storage   fuseim.pri/ifs   98s

[root@k8s-master01 demo2]# kubectl create -f pod-sc.yaml 
persistentvolumeclaim/test-claim created
pod/test-pod created

[root@k8s-master01 demo2]# kubectl get pods
NAME                                           READY   STATUS         RESTARTS   AGE
agent-c8whb                                    1/1     Running        0          12h
agent-vc25d                                    1/1     Running        0          12h
caimengzhi-nginx-deployment-65cdb6c7bf-55jsb   1/1     Running        0          15h
caimengzhi-nginx-deployment-65cdb6c7bf-dn4c6   1/1     Running        0          15h
caimengzhi-nginx-deployment-65cdb6c7bf-fxpbd   1/1     Running        0          15h
caimengzhi-pv-pvc-nfs-pod                      1/1     Running        0          14h
nfs-client-provisioner-d947789f7-xttfd         1/1     Running        0          11m
nginx-57b495474c-866lv                         0/1     ErrImagePull   0          14h
nginx-deployment-5997b94b5c-74bm4              1/1     Running        0          45h
nginx-deployment-5997b94b5c-9fft9              1/1     Running        0          45h
nginx-deployment-5997b94b5c-r88k8              1/1     Running        0          45h
pi-4bz86                                       0/1     Completed      0          2d18h
test-pod                                       1/1     Running        0          39s


[root@k8s-master01 demo2]# kubectl get pv,pvc
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS          REASON   AGE
persistentvolume/caimengzhi-nfs-pv                          5Gi        RWX            Retain           Bound    default/caimengzhi-nfs-pvc                                  14h
persistentvolume/pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca   1Gi        RWX            Delete           Bound    default/test-claim           managed-nfs-storage            4m46s

NAME                                       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
persistentvolumeclaim/caimengzhi-nfs-pvc   Bound    caimengzhi-nfs-pv                          5Gi        RWX                                  14h
persistentvolumeclaim/test-claim           Bound    pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca   1Gi        RWX            managed-nfs-storage   4m54s
```
> 以上自动创建了PV[pvc-7dbc3fcf-67c2-11e9-b3f6-000c2994bdca]且绑定在名字为test-claim的pvc上。同时在nfs-server的共享目录下创建一个含有这个pv名字的目录。

```
弄个文件，然后到镜像里面看看是否更新过来
[root@k8s-lb01 ~]# cd /ifs/kubernetes/default-test-claim-pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca/
[root@k8s-lb01 default-test-claim-pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca]#  echo '动态pvc from nfs server' >index.html
[root@k8s-lb01 default-test-claim-pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca]#  ls
index.html
[root@k8s-lb01 default-test-claim-pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca]#  cat index.html 
动态pvc from nfs server
[root@k8s-master01 ~]# kubectl exec -it test-pod bash
root@test-pod:/# cd /usr/share/nginx/html/
root@test-pod:/usr/share/nginx/html# ls
index.html
root@test-pod:/usr/share/nginx/html# cat index.html 
动态pvc from nfs server

> 说明在nfs-server上数据过来了，接下来反过来测试

root@test-pod:/usr/share/nginx/html# echo 'caimengzhi from k8s docker test-pod' >cmz.txt
root@test-pod:/usr/share/nginx/html# ls
cmz.txt  index.html
在去nfs-server上查看
[root@k8s-lb01 default-test-claim-pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca]# ls
cmz.txt  index.html
[root@k8s-lb01 default-test-claim-pvc-3ad9df6f-67c7-11e9-b3f6-000c2994bdca]# cat cmz.txt 
caimengzhi from k8s docker test-pod
数据过来了。双向测试OK、
```

??? note "碰见问题"
    ```
    1. 使用动态的pvc，也就是我们先创建pvc[会自动创建pv]，我使用了是nfs-client插件，里面有个坑是，在创建pod的时候需要下载镜像，这个镜像pull 很慢，但是pvc一直不ok。
    2. 创建应用pod后，绑定这个pvc。
    
    解决办法：
    1. 我手动下载个镜像 docker pull quay.io/external_storage/nfs-client-provisioner:latest
    2. 删除pvc，应用pod，重新创建。
    ```


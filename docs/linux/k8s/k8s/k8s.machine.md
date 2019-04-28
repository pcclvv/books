<center><h1>Kubernetes平台环境规划</h1></center>

## 1. 机器系统
&#160; &#160; &#160; &#160;开始教程之前，我先说下我这次使用的机器的一些情况，后面每个章节会按照以下情况讲述。

软件 | 版本
---|---
Linux操作系统|centos7.6_x64 mini 非图形
Kubernetes |1.12
Docker |18.xx-ce
Etcd |必须是 3.x
Flannel |0.10

> 镜像下载地址: http://mirrors.163.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso

## 2. rbac 划分
ip | 角色|安装软件|主机名
---|---|---|---
192.168.186.139|master1|etcd,kube-apiserver,kube-controller-manager,kube-scheduler,Harbor|k8s-master01
192.168.186.140|master2|kube-apiserver,kube-controller-manager,kube-scheduler|k8s-master02
192.168.186.141|node1|docker,etcd,kubelet,kube-proxy,flannel|k8s-node01
192.168.186.142|node2|docker,etcd,kubelet,kube-proxy,flannel|k8s-node02
192.168.186.143|slb master|keeaplived，nginx,nfs-server|k8s-lb01
192.168.186.144|slb backup|keeaplived，nginx|k8s-lb02
192.168.186.145|keepalived上的VIP||

!!! note "注意"
    ```
    1. flannel可以只安装node上，flannel只是跨机器宿主机和容器通讯使用
    2. docker可以只安装node上，master上可以不安装
    3. harbor 可以单独使用一个机器左右镜像仓库使用，但是我机器不够只好复用
    4. etcd 键值对的数据库，线上最好是独立三台机器。不要复用。
    5. 以上所有机器的硬件配置我都是 CPU: 2C,内存: 2G,有条件的话，可以分配更多
    6. 192.168.186.145 是keepalived上的vip
    ```

<center><h1>Docker</h1></center>

## 1.简介
### 1.1 docker 是什么

- 使用最广泛的开源容器引擎
- 一种操作系统级的虚拟化技术
- 依赖于Linux内核特性：Namespace（资源隔离）和Cgroups（资源限制）
- 一个简单的应用程序打包工具


### 1.2 docker设计目标

- 提供简单的应用程序打包工具
- 开发人员和运维人员职责逻辑分离
- 多环境保持一致性

### 1.3 docker基本组成

<center>![img](../../../pictures/linux/k8s/docker/p2.png)</center>

- Docker Client：客户端
- Ddocker Daemon：守护进程
- Docker Images：镜像
- Docker Container：容器
- Docker Registry：镜像仓库


### 1.4 dockervs虚拟机

<center>![img](../../../pictures/linux/k8s/docker/p3.png)</center>

虚拟机从下到上理解:

- 基础设施(Infrastructure)。它可以是你的个人电脑，数据中心的服务器，或者是云主机。
- 主操作系统(Host Operating System)。你的个人电脑之上，运行的可能是MacOS，Windows或者某个Linux发行版。
- 虚拟机管理系统(Hypervisor)。利用Hypervisor，可以在主操作系统之上运行多个不同的从操作系统。类型1的Hypervisor有支持MacOS的HyperKit，支持Windows的Hyper-V以及支持Linux的KVM。类型2的Hypervisor有VirtualBox和VMWare。
- 从操作系统(Guest Operating System)。假设你需要运行3个相互隔离的应用，则需要使用Hypervisor启动3个从操作系统，也就是3个虚拟机。这些虚拟机都非常大，也许有700MB，这就意味着它们将占用2.1GB的磁盘空间。更糟糕的是，它们还会消耗很多CPU和内存。
- 各种依赖。每一个从操作系统都需要安装许多依赖。如果你的的应用需要连接PostgreSQL的话，则需要安装libpq-dev；如果你使用Ruby的话，应该需要安装gems；如果使用其他编程语言，比如Python或者Node.js，都会需要安装对应的依赖库。
- 应用。安装依赖之后，就可以在各个从操作系统分别运行应用了，这样各个应用就是相互隔离的。

docker从下到上理解:

- 基础设施(Infrastructure)。
- 主操作系统(Host Operating System)。所有主流的Linux发行版都可以运行Docker。对于MacOS和Windows，也有一些办法”运行”Docker。
- Docker守护进程(Docker Daemon)。Docker守护进程取代了Hypervisor，它是运行在操作系统之上的后台进程，负责管理Docker容器。
- 各种依赖。对于Docker，应用的所有依赖都打包在Docker镜像中，Docker容器是基于Docker镜像创建的。
- 应用。应用的源代码与它的依赖都打包在Docker镜像中，不同的应用需要不同的Docker镜像。不同的应用运行在不同的Docker容器中，它们是相互隔离的。

对比虚拟机与Docker

&#160; &#160; &#160; &#160;Docker守护进程可以直接与主操作系统进行通信，为各个Docker容器分配资源；它还可以将容器与主操作系统隔离，并将各个容器互相隔离。虚拟机启动需要数分钟，而Docker容器可以在数毫秒内启动。由于没有臃肿的从操作系统，Docker可以节省大量的磁盘空间以及其他系统资源。

&#160; &#160; &#160; &#160;说了这么多Docker的优势，大家也没有必要完全否定虚拟机技术，因为两者有不同的使用场景。虚拟机更擅长于彻底隔离整个运行环境。例如，云服务提供商通常采用虚拟机技术隔离不同的用户。而Docker通常用于隔离不同的应用，例如前端，后端以及数据库。


参数|Container | VM
---|---|---
启动速度| 秒级| 分钟级
运行性能 |接近原生| 5%左右损失
磁盘占用 |MB| GB
数量| 成百上千| 一般几十台
隔离性 |进程级别| 系统级（更彻底）
操作系统 |只支持Linux| 几乎所有
封装程度 |只打包项目代码和依赖关系，共享宿主机内核 |完整的操作系统


### 1.5 docker引用场景

- 应用程序打包和发布
- 应用程序隔离
- 持续集成
- 部署微服务
- 快速搭建测试环境
- 提供PaaS产品（平台即服务）


### 1.6 docker设计目标

- 提供简单的应用程序打包工具
- 开发和运维人员职业逻辑分离
- 多环境保持一致性

### 1.7 docker基本组成

- docker client
- docker daemon
- docker images
- docker container
- docker registry

### 1.8 docker应用场景

- 应用程序打包和发布
- 应用程序隔离
- 持续集成
- 部署微服务
- 快速搭建测试环境
- 提供pass产品[平台即服务]

## 2. docker 安装
### 2.1 docker版本

- 社区版（Community Edition，CE）
- 企业版（Enterprise Edition，EE）
> 说白了，社区版是免费的，企业版是收费的，企业版本功能更多，且有专业的支持

### 2.2 支持平台

- Linux 
- mac
- windows

> Linux版本有（CentOS,Debian,Fedora,Oracle Linux,RHEL,SUSE和Ubuntu）等

### 2.3 安装
[docker文档](https://docs.docker.com/)

#### 2.3.1 安装依赖
```
 sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

??? note "详细操作"
    ```python
    [root@localhost ~]# sudo yum install -y yum-utils \
    >   device-mapper-persistent-data \
    >   lvm2
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    epel/x86_64/metalink                                     | 6.3 kB     00:00     
     * epel: ftp.jaist.ac.jp
    base                                                     | 3.6 kB     00:00     
    epel                                                     | 4.7 kB     00:04     
    extras                                                   | 3.4 kB     00:00     
    updates                                                  | 3.4 kB     00:00     
    (1/2): epel/x86_64/updateinfo                              | 985 kB   00:09     
    (2/2): epel/x86_64/primary_db                              | 6.7 MB   00:09     
    Package device-mapper-persistent-data-0.7.3-3.el7.x86_64 already installed and latest version
    Package 7:lvm2-2.02.180-10.el7_6.3.x86_64 already installed and latest version
    Resolving Dependencies
    --> Running transaction check
    ---> Package yum-utils.noarch 0:1.1.31-50.el7 will be installed
    --> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-50.el7.noarch
    --> Processing Dependency: libxml2-python for package: yum-utils-1.1.31-50.el7.noarch
    --> Running transaction check
    ---> Package libxml2-python.x86_64 0:2.9.1-6.el7_2.3 will be installed
    ---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
    --> Processing Dependency: python-chardet for package: python-kitchen-1.1.1-5.el7.noarch
    --> Running transaction check
    ---> Package python-chardet.noarch 0:2.2.1-1.el7_1 will be installed
    --> Finished Dependency Resolution
    
    Dependencies Resolved
    
    =============================================================================================================================================================================================
     Package                                          Arch                                     Version                                              Repository                              Size
    =============================================================================================================================================================================================
    Installing:
     yum-utils                                        noarch                                   1.1.31-50.el7                                        base                                   121 k
    Installing for dependencies:
     libxml2-python                                   x86_64                                   2.9.1-6.el7_2.3                                      base                                   247 k
     python-chardet                                   noarch                                   2.2.1-1.el7_1                                        base                                   227 k
     python-kitchen                                   noarch                                   1.1.1-5.el7                                          base                                   267 k
    
    Transaction Summary
    =============================================================================================================================================================================================
    Install  1 Package (+3 Dependent packages)
    
    Total download size: 861 k
    Installed size: 4.3 M
    Downloading packages:
    (1/4): python-chardet-2.2.1-1.el7_1.noarch.rpm                                                                                                                        | 227 kB  00:00:05     
    (2/4): python-kitchen-1.1.1-5.el7.noarch.rpm                                                                                                                          | 267 kB  00:00:00     
    (3/4): yum-utils-1.1.31-50.el7.noarch.rpm                                                                                                                             | 121 kB  00:00:00     
    (4/4): libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm                                                                                                                      | 247 kB  00:00:06     
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                                                        137 kB/s | 861 kB  00:00:06     
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : python-chardet-2.2.1-1.el7_1.noarch                                                                                                                                       1/4 
      Installing : python-kitchen-1.1.1-5.el7.noarch                                                                                                                                         2/4 
      Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                                                                                     3/4 
      Installing : yum-utils-1.1.31-50.el7.noarch                                                                                                                                            4/4 
      Verifying  : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                                                                                     1/4 
      Verifying  : python-kitchen-1.1.1-5.el7.noarch                                                                                                                                         2/4 
      Verifying  : yum-utils-1.1.31-50.el7.noarch                                                                                                                                            3/4 
      Verifying  : python-chardet-2.2.1-1.el7_1.noarch                                                                                                                                       4/4 
    
    Installed:
      yum-utils.noarch 0:1.1.31-50.el7                                                                                                                                                           
    
    Dependency Installed:
      libxml2-python.x86_64 0:2.9.1-6.el7_2.3                         python-chardet.noarch 0:2.2.1-1.el7_1                         python-kitchen.noarch 0:1.1.1-5.el7                        
    
    Complete!
    ```

#### 2.3.2 添加包源
```
yum-config-manager \
--add-repo \
https://download.docker.com/linux/centos/docker-ce.repo
```

??? note "详细操作"
    ```python
    [root@localhost ~]# sudo yum-config-manager \
    >     --add-repo \
    >     https://download.docker.com/linux/centos/docker-ce.repo
    Loaded plugins: fastestmirror
    adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
    grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
    repo saved to /etc/yum.repos.d/docker-ce.repo
    ```
#### 2.3.3 安装docker-ce

```
yum install -y docker-ce
```

??? note "详细操作"
    ```python
    [root@localhost ~]# yum install -y docker-ce
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
     * epel: ftp.jaist.ac.jp
    docker-ce-stable                                                                                                                                                      | 3.5 kB  00:00:00     
    (1/2): docker-ce-stable/x86_64/updateinfo                                                                                                                             |   55 B  00:00:06     
    (2/2): docker-ce-stable/x86_64/primary_db                                                                                                                             |  27 kB  00:00:06     
    Resolving Dependencies
    --> Running transaction check
    ---> Package docker-ce.x86_64 3:18.09.5-3.el7 will be installed
    --> Processing Dependency: container-selinux >= 2.9 for package: 3:docker-ce-18.09.5-3.el7.x86_64
    --> Processing Dependency: containerd.io >= 1.2.2-3 for package: 3:docker-ce-18.09.5-3.el7.x86_64
    --> Processing Dependency: docker-ce-cli for package: 3:docker-ce-18.09.5-3.el7.x86_64
    --> Processing Dependency: libcgroup for package: 3:docker-ce-18.09.5-3.el7.x86_64
    --> Running transaction check
    ---> Package container-selinux.noarch 2:2.74-1.el7 will be installed
    --> Processing Dependency: policycoreutils-python for package: 2:container-selinux-2.74-1.el7.noarch
    ---> Package containerd.io.x86_64 0:1.2.5-3.1.el7 will be installed
    ---> Package docker-ce-cli.x86_64 1:18.09.5-3.el7 will be installed
    ---> Package libcgroup.x86_64 0:0.41-20.el7 will be installed
    --> Running transaction check
    ---> Package policycoreutils-python.x86_64 0:2.5-29.el7_6.1 will be installed
    --> Processing Dependency: setools-libs >= 3.3.8-4 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: libsemanage-python >= 2.5-14 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: audit-libs-python >= 2.1.3-4 for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: python-IPy for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: libqpol.so.1(VERS_1.4)(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: libqpol.so.1(VERS_1.2)(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: libapol.so.4(VERS_4.0)(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: checkpolicy for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: libqpol.so.1()(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Processing Dependency: libapol.so.4()(64bit) for package: policycoreutils-python-2.5-29.el7_6.1.x86_64
    --> Running transaction check
    ---> Package audit-libs-python.x86_64 0:2.8.4-4.el7 will be installed
    ---> Package checkpolicy.x86_64 0:2.5-8.el7 will be installed
    ---> Package libsemanage-python.x86_64 0:2.5-14.el7 will be installed
    ---> Package python-IPy.noarch 0:0.75-6.el7 will be installed
    ---> Package setools-libs.x86_64 0:3.3.8-4.el7 will be installed
    --> Finished Dependency Resolution
    
    Dependencies Resolved
    
    =============================================================================================================================================================================================
     Package                                             Arch                                Version                                         Repository                                     Size
    =============================================================================================================================================================================================
    Installing:
     docker-ce                                           x86_64                              3:18.09.5-3.el7                                 docker-ce-stable                               19 M
    Installing for dependencies:
     audit-libs-python                                   x86_64                              2.8.4-4.el7                                     base                                           76 k
     checkpolicy                                         x86_64                              2.5-8.el7                                       base                                          295 k
     container-selinux                                   noarch                              2:2.74-1.el7                                    extras                                         38 k
     containerd.io                                       x86_64                              1.2.5-3.1.el7                                   docker-ce-stable                               22 M
     docker-ce-cli                                       x86_64                              1:18.09.5-3.el7                                 docker-ce-stable                               14 M
     libcgroup                                           x86_64                              0.41-20.el7                                     base                                           66 k
     libsemanage-python                                  x86_64                              2.5-14.el7                                      base                                          113 k
     policycoreutils-python                              x86_64                              2.5-29.el7_6.1                                  updates                                       456 k
     python-IPy                                          noarch                              0.75-6.el7                                      base                                           32 k
     setools-libs                                        x86_64                              3.3.8-4.el7                                     base                                          620 k
    
    Transaction Summary
    =============================================================================================================================================================================================
    Install  1 Package (+10 Dependent packages)
    
    Total download size: 57 M
    Installed size: 241 M
    Downloading packages:
    (1/11): audit-libs-python-2.8.4-4.el7.x86_64.rpm                                                                                                                      |  76 kB  00:00:05     
    (2/11): checkpolicy-2.5-8.el7.x86_64.rpm                                                                                                                              | 295 kB  00:00:05     
    (3/11): container-selinux-2.74-1.el7.noarch.rpm                                                                                                                       |  38 kB  00:00:05     
    warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/containerd.io-1.2.5-3.1.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY  ] 724 kB/s |  31 MB  00:00:36 ETA 
    Public key for containerd.io-1.2.5-3.1.el7.x86_64.rpm is not installed
    (4/11): containerd.io-1.2.5-3.1.el7.x86_64.rpm                                                                                                                        |  22 MB  00:00:52     
    (5/11): libcgroup-0.41-20.el7.x86_64.rpm                                                                                                                              |  66 kB  00:00:01     
    (6/11): python-IPy-0.75-6.el7.noarch.rpm                                                                                                                              |  32 kB  00:00:00     
    (7/11): setools-libs-3.3.8-4.el7.x86_64.rpm                                                                                                                           | 620 kB  00:00:00     
    (8/11): policycoreutils-python-2.5-29.el7_6.1.x86_64.rpm                                                                                                              | 456 kB  00:00:05     
    (9/11): libsemanage-python-2.5-14.el7.x86_64.rpm                                                                                                                      | 113 kB  00:00:06     
    (10/11): docker-ce-cli-18.09.5-3.el7.x86_64.rpm                                                                                                                       |  14 MB  00:00:44     
    (11/11): docker-ce-18.09.5-3.el7.x86_64.rpm                                                                                                                           |  19 MB  00:01:45     
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    Total                                                                                                                                                        546 kB/s |  57 MB  00:01:46     
    Retrieving key from https://download.docker.com/linux/centos/gpg
    Importing GPG key 0x621E9F35:
     Userid     : "Docker Release (CE rpm) <docker@docker.com>"
     Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
     From       : https://download.docker.com/linux/centos/gpg
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : libcgroup-0.41-20.el7.x86_64                                                                                                                                             1/11 
      Installing : setools-libs-3.3.8-4.el7.x86_64                                                                                                                                          2/11 
      Installing : audit-libs-python-2.8.4-4.el7.x86_64                                                                                                                                     3/11 
      Installing : checkpolicy-2.5-8.el7.x86_64                                                                                                                                             4/11 
      Installing : python-IPy-0.75-6.el7.noarch                                                                                                                                             5/11 
      Installing : libsemanage-python-2.5-14.el7.x86_64                                                                                                                                     6/11 
      Installing : policycoreutils-python-2.5-29.el7_6.1.x86_64                                                                                                                             7/11 
      Installing : 2:container-selinux-2.74-1.el7.noarch                                                                                                                                    8/11 
    setsebool:  SELinux is disabled.
      Installing : containerd.io-1.2.5-3.1.el7.x86_64                                                                                                                                       9/11 
      Installing : 1:docker-ce-cli-18.09.5-3.el7.x86_64                                                                                                                                    10/11 
      Installing : 3:docker-ce-18.09.5-3.el7.x86_64                                                                                                                                        11/11 
      Verifying  : 1:docker-ce-cli-18.09.5-3.el7.x86_64                                                                                                                                     1/11 
      Verifying  : libcgroup-0.41-20.el7.x86_64                                                                                                                                             2/11 
      Verifying  : containerd.io-1.2.5-3.1.el7.x86_64                                                                                                                                       3/11 
      Verifying  : policycoreutils-python-2.5-29.el7_6.1.x86_64                                                                                                                             4/11 
      Verifying  : libsemanage-python-2.5-14.el7.x86_64                                                                                                                                     5/11 
      Verifying  : python-IPy-0.75-6.el7.noarch                                                                                                                                             6/11 
      Verifying  : 3:docker-ce-18.09.5-3.el7.x86_64                                                                                                                                         7/11 
      Verifying  : checkpolicy-2.5-8.el7.x86_64                                                                                                                                             8/11 
      Verifying  : 2:container-selinux-2.74-1.el7.noarch                                                                                                                                    9/11 
      Verifying  : audit-libs-python-2.8.4-4.el7.x86_64                                                                                                                                    10/11 
      Verifying  : setools-libs-3.3.8-4.el7.x86_64                                                                                                                                         11/11 
    
    Installed:
      docker-ce.x86_64 3:18.09.5-3.el7                                                                                                                                                           
    
    Dependency Installed:
      audit-libs-python.x86_64 0:2.8.4-4.el7        checkpolicy.x86_64 0:2.5-8.el7           container-selinux.noarch 2:2.74-1.el7         containerd.io.x86_64 0:1.2.5-3.1.el7                 
      docker-ce-cli.x86_64 1:18.09.5-3.el7          libcgroup.x86_64 0:0.41-20.el7           libsemanage-python.x86_64 0:2.5-14.el7        policycoreutils-python.x86_64 0:2.5-29.el7_6.1       
      python-IPy.noarch 0:0.75-6.el7                setools-libs.x86_64 0:3.3.8-4.el7       
    
    Complete!
    You have new mail in /var/spool/mail/root
    ```
检查docker版本

```
[root@localhost ~]# docker -v
Docker version 18.09.5, build e8ff056
```


#### 2.3.4 配置开机自启

```
systemctl start docker
systemctl enable docker
```

??? note "详细操作"
    ```python
    [root@localhost ~]# systemctl status docker
    ● docker.service - Docker Application Container Engine
       Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
       Active: inactive (dead)
         Docs: https://docs.docker.com
    [root@localhost ~]# systemctl start docker
    [root@localhost ~]# systemctl status docker
    ● docker.service - Docker Application Container Engine
       Loaded: loaded (/usr/lib/systemd/system/docker.service; disabled; vendor preset: disabled)
       Active: active (running) since Sun 2019-04-14 08:08:47 EDT; 1s ago
         Docs: https://docs.docker.com
     Main PID: 7609 (dockerd)
        Tasks: 14
       Memory: 32.7M
       CGroup: /system.slice/docker.service
               └─7609 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
    
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.067860774-04:00" level=info msg="pickfirstBalancer: HandleSubConnStateChange: 0xc4201a6280, READY" module=grpc
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.068048242-04:00" level=info msg="pickfirstBalancer: HandleSubConnStateChange: 0xc420173ee0, READY" module=grpc
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.093656532-04:00" level=info msg="Graph migration to content-addressability took 0.00 seconds"
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.094299381-04:00" level=info msg="Loading containers: start."
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.234793136-04:00" level=info msg="Default bridge (docker0) is assigned with an IP address 172.17....IP address"
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.289552561-04:00" level=info msg="Loading containers: done."
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.316383386-04:00" level=info msg="Docker daemon" commit=e8ff056 graphdriver(s)=overlay2 version=18.09.5
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.316510066-04:00" level=info msg="Daemon has completed initialization"
    Apr 14 08:08:47 localhost.localdomain dockerd[7609]: time="2019-04-14T08:08:47.325630082-04:00" level=info msg="API listen on /var/run/docker.sock"
    Apr 14 08:08:47 localhost.localdomain systemd[1]: Started Docker Application Container Engine.
    Hint: Some lines were ellipsized, use -l to show in full.
    [root@localhost ~]# systemctl enable docker
    Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
    ```

#### 2.3.5 配置加速源
&#160; &#160; &#160; &#160;docker 下载镜像默认是从 [docker hub](https://hub.docker.com/) 上下载的，但是很慢，所有我们需要配置从国内的镜像源，下载就很快。首推 [DaoCloud](https://www.daocloud.io/mirror)

```
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io
systemctl restart docker
```

??? note "详细操作"
    ```
    [root@localhost ~]# curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh
    docker version >= 1.12
    {"registry-mirrors": ["http://f1361db2.m.daocloud.io"]}
    Success.
    You need to restart docker to take effect: sudo systemctl restart docker 
    You have new mail in /var/spool/mail/root
    添加后会再如下路径添加daemon.json 文件
    [root@localhost ~]# cat /etc/docker/daemon.json 
    {"registry-mirrors": ["http://f1361db2.m.daocloud.io"]}
    [root@localhost ~]#  systemctl restart docker
    ```
查看docker 的镜像仓库是否是配置的daocloud

```
docker info
```

??? note "详细操作"
    ```
    [root@localhost ~]# docker info
    Containers: 0
     Running: 0
     Paused: 0
     Stopped: 0
    Images: 0
    Server Version: 18.09.5
    Storage Driver: overlay2
     Backing Filesystem: xfs
     Supports d_type: true
     Native Overlay Diff: true
    Logging Driver: json-file
    Cgroup Driver: cgroupfs
    Plugins:
     Volume: local
     Network: bridge host macvlan null overlay
     Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk sys
    logSwarm: inactive
    Runtimes: runc
    Default Runtime: runc
    Init Binary: docker-init
    containerd version: bb71b10fd8f58240ca47fbb579b9d1028eea7c84
    runc version: 2b18fe1d885ee5083ef9f0838fee39b62d653e30
    init version: fec3683
    Security Options:
     seccomp
      Profile: default
    Kernel Version: 3.10.0-957.10.1.el7.x86_64
    Operating System: CentOS Linux 7 (Core)
    OSType: linux
    Architecture: x86_64
    CPUs: 4
    Total Memory: 1.777GiB
    Name: localhost.localdomain
    ID: S66N:NN62:5DJ4:77AX:OHR6:ZO6W:FK5J:TZQ5:LECF:TWTL:AYRZ:WFJN
    Docker Root Dir: /var/lib/docker
    Debug Mode (client): false
    Debug Mode (server): false
    Registry: https://index.docker.io/v1/
    Labels:
    Experimental: false
    Insecure Registries:
     127.0.0.0/8
    Registry Mirrors:                     # <---- 这个地方就可以看到了
     http://f1361db2.m.daocloud.io/
    Live Restore Enabled: false
    Product License: Community Engine
    ```


> 该脚本可以将 --registry-mirror 加入到你的 Docker 配置文件 /etc/docker/daemon.json 中。适用于 Ubuntu14.04、Debian、CentOS6 、CentOS7、Fedora、Arch Linux、openSUSE Leap 42.1，其他版本可能有细微不同


#### 2.3.6 简单测试
```
docker run -d -p 88:80 nginx
dockert ps
```

??? note "详细操作"
    ```
    启动nginx容器
    [root@localhost ~]# docker run -d -p 88:80 nginx
    Unable to find image 'nginx:latest' locally
    latest: Pulling from library/nginx
    27833a3ba0a5: Pull complete 
    eb51733b5bc0: Pull complete 
    994d4a01fbe9: Pull complete 
    Digest: sha256:c6bcc3f6f4dfee535dc0cbdaa7f32901727dd93f92c8a45eacd5c6a6d080a9ad
    Status: Downloaded newer image for nginx:latest
    6cdfdebc0d566dfe587fc1f7a184867ef6ace72a0aed6930d5703e0c46d05311
    
    查看进程
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    6cdfdebc0d56        nginx               "nginx -g 'daemon of…"   46 seconds ago      Up 45 seconds       0.0.0.0:88->80/tcp   youthful_saha
    
    查看服务
    [root@localhost ~]# curl 127.0.0.1:88
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>
    
    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>
    
    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    在浏览再次访问后，查看容器里面nginx日志
    [root@localhost ~]# docker logs 6cdfdebc0d56
    172.17.0.1 - - [14/Apr/2019:12:22:50 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
    [root@localhost ~]# docker logs 6cdfdebc0d56
    172.17.0.1 - - [14/Apr/2019:12:22:50 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
    192.168.186.1 - - [14/Apr/2019:12:24:50 +0000] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko Core/1.63.6776.400 QQBrowser/10.3.2601.400
    " "-"
    ```


## 3. 镜像管理
### 3.1 镜像

- 一个分层存储的文件

??? note "查看分层"
    ```python
    [root@localhost ~]# docker history nginx
    IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
    bb776ce48575        3 days ago          /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B                  
    <missing>           3 days ago          /bin/sh -c #(nop)  STOPSIGNAL SIGTERM           0B                  
    <missing>           3 days ago          /bin/sh -c #(nop)  EXPOSE 80                    0B                  
    <missing>           3 days ago          /bin/sh -c ln -sf /dev/stdout /var/log/nginx…   22B                 
    <missing>           3 days ago          /bin/sh -c set -x  && apt-get update  && apt…   54MB                
    <missing>           3 days ago          /bin/sh -c #(nop)  ENV NJS_VERSION=1.15.11.0…   0B                  
    <missing>           3 days ago          /bin/sh -c #(nop)  ENV NGINX_VERSION=1.15.11…   0B                  
    <missing>           2 weeks ago         /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B                  
    <missing>           2 weeks ago         /bin/sh -c #(nop)  CMD ["bash"]                 0B                  
    <missing>           2 weeks ago         /bin/sh -c #(nop) ADD file:4fc310c0cb879c876…   55.3MB              
    You have new mail in /var/spool/mail/root
    ```
- 一个软件的环境
- 一个镜像可以创建N个容器
- 一种标准化的交付
- 一个不包含Linux内核而又精简的Linux操作系统

&#160; &#160; &#160; &#160;镜像不是一个单一的文件，而是有多层构成。我们可以通过`docker history <ID/NAME> `查看镜像中各层内容及大小，每层
对应着Dockerfile中的一条指令。Docker镜像默认存储在`/var/lib/docker/\<storage-driver\>`中。

Docker Hub是由Docker公司负责维护的公共注册中心，包含大量的容器镜像，Docker工具默认从这个公共镜像库下载镜像。地址如下:

```
https://hub.docker.com/explore
```


### 3.2 镜像与容器联系

<center>![img](../../../pictures/linux/k8s/docker/p1.png)</center>

&#160; &#160; &#160; &#160;容器其实是在镜像的最上面加了一层读写层，在运行容器里文件改动时，
会先从镜像里要写的文件复制到容器自己的文件系统中（读写层）。
如果容器删除了，最上面的读写层也就删除了，改动也就丢失了。所以无论多
少个容器共享一个镜像，所做的写操作都是从镜像的文件系统中复制过来操作
的，并不会修改镜像的源文件，这种方式提高磁盘利用率。
若想持久化这些改动，可以通过docker commit 将容器保存成一个新镜像。


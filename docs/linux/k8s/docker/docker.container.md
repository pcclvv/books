<center><h1>容器管理</h1></center>

## 1. 容器
&#160; &#160; &#160; &#160;Docker 容器是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的Linux机器上，也可以实现虚拟化。容器是完全使用沙箱机制，相互之间不会有任何接口（类似 iPhone 的 app）。几乎没有性能开销,可以很容易地在机器和数据中心中运行。最重要的是,他们不依赖于任何语言、框架包括系统。
### 1.1 创建容器

选项| 描述
---|---
-i, –interactive |交互式
-t, –tty |分配一个伪终端
-d, –detach| 运行容器到后台
-e, –env |设置环境变量
-p, –publish list |发布容器端口到主机
-P, –publish-all |发布容器所有EXPOSE的端口到宿主机随机端口
–name string |指定容器名称
-h, –hostname |设置容器主机名
–ip string |指定容器IP，只能用于自定义网络
–network |连接容器到一个网络
–mount mount |将文件系统附加到容器
-v, –volume list |绑定挂载一个卷
–restart string |容器退出时重启策略，默认no，可选值：[always|on-failure]

#### 1.1.1 创建容器

例子1

```
docker container run -d nginx
```

??? note "详细操作"
    ```
    [root@localhost ~]# docker container run -d nginx
    baa8b4bef4ae87c7a3fdc6170bea9e2cdad99720c3302732489583deb300b260
    
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   20 seconds ago      Up 19 seconds       80/tcp              nostalgic_neumann
    ```
例子2

```
[root@localhost ~]# docker run -d -e JAVA_HOME=/usr/local/jdk --name test1 -h java8 java:8
```

??? note "详细操作"
    ```
    [root@localhost ~]# docker run -itd -e JAVA_HOME=/usr/local/jdk --name test1 -h java8 java:8
    f9b3c40a7b8cd234d9c87e29175426d63c196cd0beb8ffe7850f50da860f47a6
    
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    f9b3c40a7b8c        java:8              "/bin/bash"         17 seconds ago      Up 15 seconds                           test1
    
    进入容器查看
    [root@localhost ~]# docker exec -it f9b3c40a7b8c bash
    root@java8:/# echo $JAVA_HOME
    /usr/local/jdk
    
    root@java8:/# hostname
    java8
    
    [root@localhost ~]# docker run -itd -e JAVA_HOME=/usr/local/jdk --name test2 -h java8 --restart=always java:8
    1c11971c17807118d64cb289a7238860e2eb4a5713dfd69ddbd5d9aa7bbe9a31
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    1c11971c1780        java:8              "/bin/bash"         10 seconds ago      Up 8 seconds                            test2
    ```


### 1.2 容器资源限制

选项| 描述
---|---
-m，–memory| 容器可以使用的最大内存量
–memory-swap |允许交换到磁盘的内存量
–memory-swappiness=<0-100> |容器使用SWAP分区交换的百分比（0-100，默认为-1）
–oom-kill-disable |禁用OOM Killer
–cpus |可以使用的CPU数量
–cpuset-cpus |限制容器使用特定的CPU核心，如(0-3, 0,1)
–cpu-shares |CPU共享（相对权重）

#### 1.2.1 内存限制
允许容器最多使用500M内存和100M的Swap，并禁用 OOM Killer：

```
docker run -d --name nginx03 --memory="500m" --memory-swap=“600m" --oom-kill-disable nginx
```

??? note "详细操作"
    ```
    [root@localhost ~]# docker run -d --memory='500m' nginx
    736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   7 seconds ago       Up 6 seconds        80/tcp              musing_yonath
    [root@localhost ~]# docker sta
    stack  start  stats  
    [root@localhost ~]# docker stats 736c3390db1a
    
    CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT   MEM %               NET I/O             BLOCK I/O           PIDS
    736c3390db1a        musing_yonath       0.00%               1.355MiB / 500MiB   0.27%               656B / 0B           0B / 0B             2
    
    可以看到LIMIT 下面是500M内存，此时该容器使用的内存不会超过该宿主机机器的物理内存500M
    ```

#### 1.2.2 cpu限制
允许容器最多使用一个半的CPU：

```
docker run -d --name nginx04 --cpus="1.5" nginx
```
允许容器最多使用50%的CPU：

```
docker run -d --name nginx05 --cpus=".5" nginx
```


### 1.3 管理容器常用命令

选项| 描述
---|---
ls| 列出容器
inspect |查看一个或多个容器详细信息
exec |在运行容器中执行命令 
commit| 创建一个新镜像来自一个容器
cp |拷贝文件/文件夹到一个容器
logs| 获取一个容器日志
port |列出或指定容器端口映射
top| 显示一个容器运行的进程
stats| 显示容器资源使用统计
stop/start| 停止/启动一个或多个容器
rm |删除一个或多个容器

#### 1.3.1 列出容器

```
docker container ls
```

??? note "详细操作"
    ```
    [root@localhost ~]# docker container ls
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   13 minutes ago      Up 13 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              18 minutes ago      Up 18 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              21 minutes ago      Up 21 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   31 minutes ago      Up 31 minutes       80/tcp              nostalgic_neumann
    
    [root@localhost ~]# docker ps 
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   12 minutes ago      Up 12 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              18 minutes ago      Up 18 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              21 minutes ago      Up 21 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   30 minutes ago      Up 30 minutes       80/tcp              nostalgic_neumann
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   12 minutes ago      Up 12 minutes       80/tcp              musing_yonath
    > docker ps -l 是看最后一个起的容器l=last
    ```

#### 1.3.2 容器详情

```
docker inspect  容器id
```

??? note "详细操作"
    ```
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   13 minutes ago      Up 13 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              19 minutes ago      Up 19 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              22 minutes ago      Up 22 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   32 minutes ago      Up 32 minutes       80/tcp              nostalgic_neumann
    [root@localhost ~]# docker inspect 736c3390db1a
    [
        {
            "Id": "736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed",
            "Created": "2019-04-15T01:55:05.093162988Z",
            "Path": "nginx",
            "Args": [
                "-g",
                "daemon off;"
            ],
            "State": {
                "Status": "running",
                "Running": true,
                "Paused": false,
                "Restarting": false,
                "OOMKilled": false,
                "Dead": false,
                "Pid": 11775,
                "ExitCode": 0,
                "Error": "",
                "StartedAt": "2019-04-15T01:55:05.550478433Z",
                "FinishedAt": "0001-01-01T00:00:00Z"
            },
            "Image": "sha256:bb776ce48575796501bcc53e511563116132b789ab0552d520513da8c738cba2",
            "ResolvConfPath": "/var/lib/docker/containers/736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed/resolv.conf",
            "HostnamePath": "/var/lib/docker/containers/736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed/hostname",
            "HostsPath": "/var/lib/docker/containers/736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed/hosts",
            "LogPath": "/var/lib/docker/containers/736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed/736c3390db1a1581737bb6b4f5ef1cb30a749d62e0cdfce593f955104ec022ed-json.log",
            "Name": "/musing_yonath",
            "RestartCount": 0,
            "Driver": "overlay2",
            "Platform": "linux",
            "MountLabel": "",
            "ProcessLabel": "",
            "AppArmorProfile": "",
            "ExecIDs": null,
            "HostConfig": {
                "Binds": null,
                "ContainerIDFile": "",
                "LogConfig": {
                    "Type": "json-file",
                    "Config": {}
                },
                "NetworkMode": "default",
                "PortBindings": {},
                "RestartPolicy": {
                    "Name": "no",
                    "MaximumRetryCount": 0
                },
                "AutoRemove": false,
                "VolumeDriver": "",
                "VolumesFrom": null,
                "CapAdd": null,
                "CapDrop": null,
                "Dns": [],
                "DnsOptions": [],
                "DnsSearch": [],
                "ExtraHosts": null,
                "GroupAdd": null,
                "IpcMode": "shareable",
                "Cgroup": "",
                "Links": null,
                "OomScoreAdj": 0,
                "PidMode": "",
                "Privileged": false,
                "PublishAllPorts": false,
                "ReadonlyRootfs": false,
                "SecurityOpt": null,
                "UTSMode": "",
                "UsernsMode": "",
                "ShmSize": 67108864,
                "Runtime": "runc",
                "ConsoleSize": [
                    0,
                    0
                ],
                "Isolation": "",
                "CpuShares": 0,
                "Memory": 524288000,
                "NanoCpus": 0,
                "CgroupParent": "",
                "BlkioWeight": 0,
                "BlkioWeightDevice": [],
                "BlkioDeviceReadBps": null,
                "BlkioDeviceWriteBps": null,
                "BlkioDeviceReadIOps": null,
                "BlkioDeviceWriteIOps": null,
                "CpuPeriod": 0,
                "CpuQuota": 0,
                "CpuRealtimePeriod": 0,
                "CpuRealtimeRuntime": 0,
                "CpusetCpus": "",
                "CpusetMems": "",
                "Devices": [],
                "DeviceCgroupRules": null,
                "DiskQuota": 0,
                "KernelMemory": 0,
                "MemoryReservation": 0,
                "MemorySwap": 1048576000,
                "MemorySwappiness": null,
                "OomKillDisable": false,
                "PidsLimit": 0,
                "Ulimits": null,
                "CpuCount": 0,
                "CpuPercent": 0,
                "IOMaximumIOps": 0,
                "IOMaximumBandwidth": 0,
                "MaskedPaths": [
                    "/proc/asound",
                    "/proc/acpi",
                    "/proc/kcore",
                    "/proc/keys",
                    "/proc/latency_stats",
                    "/proc/timer_list",
                    "/proc/timer_stats",
                    "/proc/sched_debug",
                    "/proc/scsi",
                    "/sys/firmware"
                ],
                "ReadonlyPaths": [
                    "/proc/bus",
                    "/proc/fs",
                    "/proc/irq",
                    "/proc/sys",
                    "/proc/sysrq-trigger"
                ]
            },
            "GraphDriver": {
                "Data": {
                    "LowerDir": "/var/lib/docker/overlay2/478efedff97ecde31dda1fa68428cd64252811e4fd028aaa0561c9f18ee80a5d-init/diff:/var/lib/docker/overlay2/07e83d63c696445da98597acdaf0bdb46bd
    e0059f37325cc89ef429500ecc680/diff:/var/lib/docker/overlay2/a679632a67a1c7aa9955791eb4c004f315f933dba2fd49cf07d1bd1ee15a8f65/diff:/var/lib/docker/overlay2/06a53fbc7b6333367b1b9a236c21a538e72f7999f9f37269fc7af01c8be85d5e/diff",                "MergedDir": "/var/lib/docker/overlay2/478efedff97ecde31dda1fa68428cd64252811e4fd028aaa0561c9f18ee80a5d/merged",
                    "UpperDir": "/var/lib/docker/overlay2/478efedff97ecde31dda1fa68428cd64252811e4fd028aaa0561c9f18ee80a5d/diff",
                    "WorkDir": "/var/lib/docker/overlay2/478efedff97ecde31dda1fa68428cd64252811e4fd028aaa0561c9f18ee80a5d/work"
                },
                "Name": "overlay2"
            },
            "Mounts": [],
            "Config": {
                "Hostname": "736c3390db1a",
                "Domainname": "",
                "User": "",
                "AttachStdin": false,
                "AttachStdout": false,
                "AttachStderr": false,
                "ExposedPorts": {
                    "80/tcp": {}
                },
                "Tty": false,
                "OpenStdin": false,
                "StdinOnce": false,
                "Env": [
                    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                    "NGINX_VERSION=1.15.11-1~stretch",
                    "NJS_VERSION=1.15.11.0.3.0-1~stretch"
                ],
                "Cmd": [
                    "nginx",
                    "-g",
                    "daemon off;"
                ],
                "ArgsEscaped": true,
                "Image": "nginx",
                "Volumes": null,
                "WorkingDir": "",
                "Entrypoint": null,
                "OnBuild": null,
                "Labels": {
                    "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
                },
                "StopSignal": "SIGTERM"
            },
            "NetworkSettings": {
                "Bridge": "",
                "SandboxID": "9dbb20f2fb9b0409336ee0dd88a51055e62177b979dba0f66022a175acdea20d",
                "HairpinMode": false,
                "LinkLocalIPv6Address": "",
                "LinkLocalIPv6PrefixLen": 0,
                "Ports": {
                    "80/tcp": null
                },
                "SandboxKey": "/var/run/docker/netns/9dbb20f2fb9b",
                "SecondaryIPAddresses": null,
                "SecondaryIPv6Addresses": null,
                "EndpointID": "69d5be5608ad937ec9a519320ebf0eef911ff455fbdd71dc43568ac90704be83",
                "Gateway": "172.17.0.1",
                "GlobalIPv6Address": "",
                "GlobalIPv6PrefixLen": 0,
                "IPAddress": "172.17.0.5",
                "IPPrefixLen": 16,
                "IPv6Gateway": "",
                "MacAddress": "02:42:ac:11:00:05",
                "Networks": {
                    "bridge": {
                        "IPAMConfig": null,
                        "Links": null,
                        "Aliases": null,
                        "NetworkID": "fded918d7084ddc2d769881d6588d18be64884dfbb83228200662b9f547daf41",
                        "EndpointID": "69d5be5608ad937ec9a519320ebf0eef911ff455fbdd71dc43568ac90704be83",
                        "Gateway": "172.17.0.1",
                        "IPAddress": "172.17.0.5",
                        "IPPrefixLen": 16,
                        "IPv6Gateway": "",
                        "GlobalIPv6Address": "",
                        "GlobalIPv6PrefixLen": 0,
                        "MacAddress": "02:42:ac:11:00:05",
                        "DriverOpts": null
                    }
                }
            }
        }
    ]
    ```


#### 1.3.3 执行命令
进入容器
```
docker exec -it 容器id bash
```
> exec 执行命令，-it交互式，bash启动一个虚拟bash

不进入容器执行命令
```
docker exec  容器id 命令
```


??? note "操作"
    ```
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   15 minutes ago      Up 15 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              20 minutes ago      Up 20 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              24 minutes ago      Up 24 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   33 minutes ago      Up 33 minutes       80/tcp              nostalgic_neumann
    [root@localhost ~]# docker exec -it 736c3390db1a bash
    root@736c3390db1a:/# exit
    exit
    
    [root@localhost ~]# docker exec ec0fcb3bf39a ls
    bin
    boot
    dev
    etc
    home
    lib
    lib64
    media
    mnt
    opt
    proc
    root
    run
    sbin
    srv
    sys
    tmp
    usr
    var
    ```

#### 1.3.4 拷贝

```
docker cp 宿主机本地文件 容器ID:容器内目录
docker cp 容器ID:容器内目录 宿主机本地文件 
```

??? note "操作"
    ```
    宿主机本地文件拷贝到容器内
    [root@localhost ~]# echo 'from out file'>file
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   17 minutes ago      Up 17 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              23 minutes ago      Up 23 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              26 minutes ago      Up 26 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   35 minutes ago      Up 35 minutes       80/tcp              nostalgic_neumann
    [root@localhost ~]# docker cp file 736c3390db1a:/tmp
    [root@localhost ~]# docker exec -it 736c3390db1a bash
    root@736c3390db1a:/# ls /tmp/
    file
    
    容器文件拷贝到宿主机本地
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   23 minutes ago      Up 23 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              29 minutes ago      Up 29 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              32 minutes ago      Up 32 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   41 minutes ago      Up 41 minutes       80/tcp              nostalgic_neumann
    [root@localhost ~]# docker cp 736c3390db1a:/tmp/file .
    [root@localhost ~]# ls file 
    file
    [root@localhost ~]# cat file 
    from out file
    ```

#### 1.3.5 日志

```
docker logs 容器id
```


??? note "操作"
    ```
    [root@localhost ~]# docker run -d -p90:80 nginx
    08830b345718b9b63e81d7c9a1b0565a1176cc83ae6242fe9ad76d769c6432ea
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    08830b345718        nginx               "nginx -g 'daemon of…"   4 seconds ago       Up 3 seconds        0.0.0.0:90->80/tcp   thirsty_ritchie
    [root@localhost ~]# curl 127.0.0.1:90
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
    [root@localhost ~]# docker logs 08830b345718
    172.17.0.1 - - [15/Apr/2019:02:21:19 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
    ```

#### 1.3.6 端口映射

```
docker run -d -p90:80 nginx
```
> -p:宿主机port: 容器port

??? note "操作"
    ```
    [root@localhost ~]# docker run -d -p90:80 nginx
    08830b345718b9b63e81d7c9a1b0565a1176cc83ae6242fe9ad76d769c6432ea
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    08830b345718        nginx               "nginx -g 'daemon of…"   4 seconds ago       Up 3 seconds        0.0.0.0:90->80/tcp   thirsty_ritchie
    
    [root@localhost ~]# docker port 08830b345718
    80/tcp -> 0.0.0.0:90
    ```
    
#### 1.3.7 容器进程

```
docker top 容器id
```

??? note "操作"
    ```
    [root@localhost ~]# docker top 08830b345718
    UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
    root                12709               12691               0                   22:21               ?                   00:00:00            nginx: master process nginx -g daemon off;
    101                 12747               12709               0                   22:21               ?                   00:00:00            nginx: worker process
    ```
    
#### 1.3.8 查看资源

```
docker stats 容器id
```

??? note "操作"
    ```
    [root@localhost ~]# docker stats 08830b345718
    
    CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
    08830b345718        thirsty_ritchie     0.00%               1.387MiB / 1.777GiB   0.08%               1.24kB / 1.23kB     0B / 0B             2
    
    CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
    08830b345718        thirsty_ritchie     0.00%               1.387MiB / 1.777GiB   0.08%               1.24kB / 1.23kB     0B / 0B             2
    ```

#### 1.3.9 启停容器

```
docker start|stop|restart 容器id
```

??? note "操作"
    ```
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    08830b345718        nginx               "nginx -g 'daemon of…"   5 minutes ago       Up 5 minutes        0.0.0.0:90->80/tcp   thirsty_ritchie
    [root@localhost ~]# docker stop 08830b345718
    08830b345718
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                    PORTS               NAMES
    08830b345718        nginx               "nginx -g 'daemon of…"   5 minutes ago       Exited (0) 1 second ago                       thirsty_ritchie
    [root@localhost ~]# docker start 08830b345718
    08830b345718
    [root@localhost ~]# docker ps -l
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    08830b345718        nginx               "nginx -g 'daemon of…"   5 minutes ago       Up 2 seconds        0.0.0.0:90->80/tcp   thirsty_ritchie
    [root@localhost ~]# docker restart 08830b345718
    08830b345718
    ```

#### 1.3.10 删除容器

```
# 删除停止的容器
docker rm 容器id

# 强制删除容器
docker rm -f 容器id

# 强制删除所有容器
docker rm -f $(docker ps -a |awk '{print $1}')
```

??? note "操作"
    ```
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
    08830b345718        nginx               "nginx -g 'daemon of…"   6 minutes ago       Up 53 seconds       0.0.0.0:90->80/tcp   thirsty_ritchie
    736c3390db1a        nginx               "nginx -g 'daemon of…"   32 minutes ago      Up 32 minutes       80/tcp               musing_yonath
    1c11971c1780        java:8              "/bin/bash"              38 minutes ago      Up 38 minutes                            test2
    f9b3c40a7b8c        java:8              "/bin/bash"              41 minutes ago      Up 41 minutes                            test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   About an hour ago   Up About an hour    80/tcp               nostalgic_neumann
    [root@localhost ~]# docker rm 08830b345718
    Error response from daemon: You cannot remove a running container 08830b345718b9b63e81d7c9a1b0565a1176cc83ae6242fe9ad76d769c6432ea. Stop the container before attempting removal or force rem
    ove[root@localhost ~]# docker rm -f 08830b345718
    08830b345718
    -f 表示强制删除容器，一般先停止容器，在删除容器，正则运行的容器，直接删除会报错。-f就直接删除，不论容器是否在运行。
    [root@localhost ~]# docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
    736c3390db1a        nginx               "nginx -g 'daemon of…"   32 minutes ago      Up 32 minutes       80/tcp              musing_yonath
    1c11971c1780        java:8              "/bin/bash"              38 minutes ago      Up 38 minutes                           test2
    f9b3c40a7b8c        java:8              "/bin/bash"              41 minutes ago      Up 41 minutes                           test1
    baa8b4bef4ae        nginx               "nginx -g 'daemon of…"   About an hour ago   Up About an hour    80/tcp              nostalgic_neumann
    
    [root@localhost ~]# docker rm -f $(docker ps -a |awk '{print $1}')
    ef3076db4d89
    736c3390db1a
    78ad26fe92dc
    1c11971c1780
    f9b3c40a7b8c
    baa8b4bef4ae
    Error: No such container: CONTAINER
    [root@localhost ~]# docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    ```


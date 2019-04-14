
<center><h1>Docker 常用命令</h1></center>

## 1. 参数
```
[root@localhost ~]# docker --help

Usage:	docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/root/.docker")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/root/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/root/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/root/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  builder     Manage builds
  config      Manage Docker configs
  container   Manage containers
  engine      Manage the docker engine
  image       Manage images
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker COMMAND --help' for more information on a command.

```

&#160; &#160; &#160; &#160;常用的指令

指令 | 描述
---|---
ls |列出镜像
build| 构建镜像来自Dockerfile
history| 查看镜像历史
inspect |显示一个或多个镜像详细信息
pull| 从镜像仓库拉取镜像
push| 推送一个镜像到镜像仓库
rm| 移除一个或多个镜像
prune| 移除未使用的镜像。没有被标记或被任何容器引用的。
tag| 创建一个引用源镜像标记目标镜像
export| 导出容器文件系统到tar归档文件
import| 导入容器文件系统tar归档文件创建镜像
save| 保存一个或多个镜像到一个tar归档文件
load| 加载镜像来自tar归档或标准输入

### 1.1 查看容器

```
[root@localhost ~]# docker container ls
```

??? note "操作"
    ```
    [root@localhost ~]# docker container ls
    CONTAINER ID        IMAGE               COMMAND                  CREATED         
    6cdfdebc0d56        nginx               "nginx -g 'daemon of…"   2 hours ago     
    ```

### 1.2 查看镜像

```
docker image ls
```

??? note "操作"
    ```python
    [root@localhost ~]# docker image ls
    REPOSITORY          TAG                 IMAGE ID            CREATED             S
    nginx               latest              bb776ce48575        3 days ago          1
    ```

### 1.3 查看历史

```
docker history nginx
```

??? note "操作"
    ```
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
    ```

### 1.4 镜像详情

```
docker image inspect nginx 
```

??? note "操作"
    ```
    [root@localhost ~]# docker image inspect --help

    Usage:	docker image inspect [OPTIONS] IMAGE [IMAGE...]
    
    Display detailed information on one or more images
    
    Options:
      -f, --format string   Format the output using the given Go template

    [root@localhost ~]# docker image inspect nginx
    [
        {
            "Id": "sha256:bb776ce48575796501bcc53e511563116132b789ab0552d520513da8c738cba2",
            "RepoTags": [
                "nginx:latest"
            ],
            "RepoDigests": [
                "nginx@sha256:c6bcc3f6f4dfee535dc0cbdaa7f32901727dd93f92c8a45eacd5c6a6d080a9ad"
            ],
            "Parent": "",
            "Comment": "",
            "Created": "2019-04-10T21:22:15.797870505Z",
            "Container": "72c77d6abc2dc476d5ed0331239cbcab1c26019a28f6bd7941158acd55a4c4ff",
            "ContainerConfig": {
                "Hostname": "72c77d6abc2d",
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
                    "/bin/sh",
                    "-c",
                    "#(nop) ",
                    "CMD [\"nginx\" \"-g\" \"daemon off;\"]"
                ],
                "ArgsEscaped": true,
                "Image": "sha256:8ecbd4eb2e99de8e73ae47a97f843860ac7127c1c39baf150f0943fd5e4bfbc3",
                "Volumes": null,
                "WorkingDir": "",
                "Entrypoint": null,
                "OnBuild": null,
                "Labels": {
                    "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
                },
                "StopSignal": "SIGTERM"
            },
            "DockerVersion": "18.06.1-ce",
            "Author": "",
            "Config": {
                "Hostname": "",
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
                "Image": "sha256:8ecbd4eb2e99de8e73ae47a97f843860ac7127c1c39baf150f0943fd5e4bfbc3",
                "Volumes": null,
                "WorkingDir": "",
                "Entrypoint": null,
                "OnBuild": null,
                "Labels": {
                    "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
                },
                "StopSignal": "SIGTERM"
            },
            "Architecture": "amd64",
            "Os": "linux",
            "Size": 109294563,
            "VirtualSize": 109294563,
            "GraphDriver": {
                "Data": {
                    "LowerDir": "/var/lib/docker/overlay2/b52d2bc3589c04658e834d2ad9480edb1d07ceb9c964f8c8789362b5893f3d66/diff:/var/lib/docker/overlay2/78f939f67ca4017de179f33f8ee9d7085f1082ae
    e5018efbc0f656936afcb91f/diff",                "MergedDir": "/var/lib/docker/overlay2/a1c121b73464b321a93c7ec2c09ae4c0c1ac5d7e3819a7f5a24cf30990c291a4/merged",
                    "UpperDir": "/var/lib/docker/overlay2/a1c121b73464b321a93c7ec2c09ae4c0c1ac5d7e3819a7f5a24cf30990c291a4/diff",
                    "WorkDir": "/var/lib/docker/overlay2/a1c121b73464b321a93c7ec2c09ae4c0c1ac5d7e3819a7f5a24cf30990c291a4/work"
                },
                "Name": "overlay2"
            },
            "RootFS": {
                "Type": "layers",
                "Layers": [
                    "sha256:5dacd731af1b0386ead06c8b1feff9f65d9e0bdfec032d2cd0bc03690698feda",
                    "sha256:b0a13438d0d39cb4d9d355a0618247f94b97a38208c8a2a4f3d7d7f06378acb2",
                    "sha256:19d384dcffcccd44d9f475ed776358a81fb05e7948249bb50f8d7784e0f0f433"
                ]
            },
            "Metadata": {
                "LastTagTime": "0001-01-01T00:00:00Z"
            }
        }
    ]
    ```

### 1.5 下载镜像

```
docker pull centos:7
```

??? note "操作"
    ```python
    [root@localhost ~]# docker pull centos:7
    7: Pulling from library/centos
    Digest: sha256:8d487d68857f5bc9595793279b33d082b03713341ddec91054382641d14db861
    Status: Image is up to date for centos:7
    
    [root@localhost ~]# docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    nginx               latest              bb776ce48575        3 days ago          109MB
    centos              7                   9f38484d220f        4 weeks ago         202MB
    ```

### 1.6 上传镜像
暂时没有参考，后面在写。类似如下：

```
docker push dockerhub.xx.com/xxx/ubuntu:16.04
```

### 1.7 删除镜像

```
You have new mail in /var/spool/mail/root
[root@localhost ~]# docker image rm -f nginx
Untagged: nginx:latest
Untagged: nginx@sha256:c6bcc3f6f4dfee535dc0cbdaa7f32901727dd93f92c8a45eacd5c6a6d080a9ad
[root@localhost ~]# 
```

### 1.8 移除为使用镜像

移除的镜像是，么有容器基于这个镜像。
```
[root@localhost ~]# docker image prune 
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
[root@localhost ~]# docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              bb776ce48575        3 days ago          109MB
centos              7                   9f38484d220f        4 weeks ago         202MB
[root@localhost ~]# docker image prune -a
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
Deleted Images:
untagged: centos:7
untagged: centos@sha256:2dc7ed6df9dcfa3e0129d8613a1e1b17f5683425d8fe81dd0c4166e6c211ac9f
untagged: centos@sha256:8d487d68857f5bc9595793279b33d082b03713341ddec91054382641d14db861
deleted: sha256:9f38484d220fa527b1fb19747638497179500a1bed8bf0498eb788229229e6e1
deleted: sha256:d69483a6face4499acb974449d1303591fcbb5cdce5420f36f8a6607bda11854
untagged: nginx:latest
deleted: sha256:bb776ce48575796501bcc53e511563116132b789ab0552d520513da8c738cba2
deleted: sha256:43e4bf6ebb72bc17f5f35af0ace5e5d5db31b2b631fac2cca3d4be2420ca9758
deleted: sha256:2ceeec5cb749c4154ae2390bc3e0c2a4dee8663ca7012ca37a293734de83d498
deleted: sha256:5dacd731af1b0386ead06c8b1feff9f65d9e0bdfec032d2cd0bc03690698feda

Total reclaimed space: 311.1MB
[root@localhost ~]# docker images 
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

### 1.9 打tag

将镜像nginx标记为 caimengzhi_nginx 镜像。
```
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              bb776ce48575        3 days ago          109MB
[root@localhost ~]# docker tag nginx caimengzhi_nginx
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
caimengzhi_nginx    latest              bb776ce48575        3 days ago          109MB
nginx               latest              bb776ce48575        3 days ago          109MB

```

### 1.10 容器导入导出
导出某个容器，非常简单，使用docker export命令，语法：docker export $container_id > 容器快照名
```
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
caimengzhi_nginx    latest              bb776ce48575        3 days ago          109MB
nginx               latest              bb776ce48575        3 days ago          109MB
[root@localhost ~]# docker run -itd -p88:80 caimengzhi_nginx
8670f902dc094eb1de78eeccac90a4618ab59a8ba787e6da6324589c1039daa7
[root@localhost ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
8670f902dc09        caimengzhi_nginx    "nginx -g 'daemon of…"   2 seconds ago       Up 2 seconds        0.0.0.0:88->80/tcp   compassionate_gates
[root@localhost ~]# docker export 8670f902dc09 > caimengzhi_nginx.tar
[root@localhost ~]# du -sh caimengzhi_nginx.tar 
107M	caimengzhi_nginx.tar
```
导出后在本地可以看到有一个`caimengzhi_nginx.tar`的容器快照。

导入某个容器，有了容器快照之后，我们可以在想要的时候随时导入。导入快照使用docker import命令。

```
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              bb776ce48575        3 days ago          109MB
[root@localhost ~]# cat caimengzhi_nginx.tar | docker import - caimengzhi_nginx 
sha256:a2855f206c05c76a2ef1bc369b24dded80df110bf4fef27e2f5107633be1226b
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
caimengzhi_nginx    latest              a2855f206c05        1 second ago        108MB
nginx               latest              bb776ce48575        3 days ago          109MB
```

### 1.11 保存
```
[root@localhost ~]# 
[root@localhost ~]# docker save nginx>nginx.tar
[root@localhost ~]# du -sh nginx.tar 
108M	nginx.tar
You have new mail in /var/spool/mail/root
[root@localhost ~]# docker image rm -f nginx
Untagged: nginx:latest
Untagged: nginx@sha256:c6bcc3f6f4dfee535dc0cbdaa7f32901727dd93f92c8a45eacd5c6a6d080a9ad

[root@localhost ~]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
6cdfdebc0d56        bb776ce48575        "nginx -g 'daemon of…"   3 hours ago         Up 3 hours          0.0.0.0:88->80/tcp   youthful_saha
[root@localhost ~]# docker container rm -f 6cdfdebc0d56
6cdfdebc0d56
[root@localhost ~]# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              bb776ce48575        3 days ago          109MB
centos              7                   9f38484d220f        4 weeks ago         202MB
[root@localhost ~]# docker image rm -f bb776ce48575
Deleted: sha256:bb776ce48575796501bcc53e511563116132b789ab0552d520513da8c738cba2
Deleted: sha256:43e4bf6ebb72bc17f5f35af0ace5e5d5db31b2b631fac2cca3d4be2420ca9758
Deleted: sha256:2ceeec5cb749c4154ae2390bc3e0c2a4dee8663ca7012ca37a293734de83d498
Deleted: sha256:5dacd731af1b0386ead06c8b1feff9f65d9e0bdfec032d2cd0bc03690698feda
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
centos              7                   9f38484d220f        4 weeks ago         202MB

[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
centos              7                   9f38484d220f        4 weeks ago         202MB
[root@localhost ~]# docker load < nginx.tar 
5dacd731af1b: Loading layer [==================================================>]  58.45MB/58.45MB
b0a13438d0d3: Loading layer [==================================================>]  54.55MB/54.55MB
19d384dcffcc: Loading layer [==================================================>]  3.584kB/3.584kB
Loaded image: nginx:latest
[root@localhost ~]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               latest              bb776ce48575        3 days ago          109MB
centos              7                   9f38484d220f        4 weeks ago         202MB
```

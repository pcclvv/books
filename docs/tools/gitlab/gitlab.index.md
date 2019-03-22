<center><h1>Gitlab 部署</h1></center>
## 1. 介绍
### 1.1 参考指南

- [官网](https://about.gitlab.com/)
- [安装指南](https://about.gitlab.com/install/)
- [离线安装](https://packages.gitlab.com/gitlab/gitlab-ce)
- [清华源](https://mirrors.tuna.tsinghua.edu.cn/)

### 1.2 区别

- gitlab-ce 社区版本(免费)
- gitlab-ee 企业版本(收费)

### 1.3 在线安装

```
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates
sudo apt-get install -y postfix
```

### 1.4 在线安装(指定版本)
```
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt-get install gitlab-ce=10.2.2-ce.0
```

### 1.5 离线安装（指定版本）

```
root@k8s4:~/git_test# lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.5 LTS
Release:	16.04
Codename:	xenial
root@k8s4:~/git_test# wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/xenial/gitlab-ce_10.2.2-ce.0_amd64.deb/download.deb
--2019-01-15 16:15:50--  https://packages.gitlab.com/gitlab/gitlab-ce/packages/ubuntu/xenial/gitlab-ce_10.2.2-ce.0_amd64.deb/download.deb
。。。。。省略。。。。。

开始安装
root@k8s4:~/git_test# dpkg -i gitlab-ce_10.2.2-ce.0_amd64.deb
Selecting previously unselected package gitlab-ce.
(Reading database ... 120662 files and directories currently installed.)
Preparing to unpack gitlab-ce_10.2.2-ce.0_amd64.deb ...
Unpacking gitlab-ce (10.2.2-ce.0) ...
Setting up gitlab-ce (10.2.2-ce.0) ...
It looks like GitLab has not been configured yet; skipping the upgrade script.

       *.                  *.
      ***                 ***
     *****               *****
    .******             *******
    ********            ********
   ,,,,,,,,,***********,,,,,,,,,
  ,,,,,,,,,,,*********,,,,,,,,,,,
  .,,,,,,,,,,,*******,,,,,,,,,,,,
      ,,,,,,,,,*****,,,,,,,,,.
         ,,,,,,,****,,,,,,
            .,,,***,,,,
                ,*,.



     _______ __  __          __
    / ____(_) /_/ /   ____ _/ /_
   / / __/ / __/ /   / __ \`/ __ \
  / /_/ / / /_/ /___/ /_/ / /_/ /
  \____/_/\__/_____/\__,_/_.___/


Thank you for installing GitLab!
GitLab was unable to detect a valid hostname for your instance.
Please configure a URL for your GitLab instance by setting `external_url`
configuration in /etc/gitlab/gitlab.rb file.
Then, you can start your GitLab instance by running the following command:
  sudo gitlab-ctl reconfigure

For a comprehensive list of configuration options please see the Omnibus GitLab readme
https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md
```
> 下载和安装的时候都比较慢，请稍等片刻

## 2. 配置
### 2.1 修改配置文件
修改配置文件 external_url 为本机IP地址
```
root@k8s4:/etc/gitlab# cp gitlab.rb gitlab.rb.ori
root@k8s4:/etc/gitlab# vim /etc/gitlab/gitlab.rb
root@k8s4:/etc/gitlab# diff gitlab.rb gitlab.rb.ori
13c13
< external_url 'http://192.168.5.106'
---
> external_url 'http://gitlab.example.com

# 只有修改/etc/gitlab/gitlab.rb就要执行以下操作(其他很多文件都依赖这个文件)
root@k8s4:/etc/gitlab# gitlab-ctl reconfigure
root@k8s4:/etc/gitlab# gitlab-ctl status
run: gitaly: (pid 39985) 31s; run: log: (pid 39567) 70s
run: gitlab-monitor: (pid 40000) 30s; run: log: (pid 39685) 62s
run: gitlab-workhorse: (pid 39972) 31s; run: log: (pid 39470) 80s
run: logrotate: (pid 39513) 72s; run: log: (pid 39512) 72s
run: nginx: (pid 39490) 78s; run: log: (pid 39489) 78s
run: node-exporter: (pid 39664) 64s; run: log: (pid 39663) 64s
run: postgres-exporter: (pid 40034) 29s; run: log: (pid 39878) 48s
run: postgresql: (pid 39075) 128s; run: log: (pid 39074) 128s
run: prometheus: (pid 40010) 30s; run: log: (pid 39787) 54s
run: redis: (pid 38976) 134s; run: log: (pid 38975) 134s
run: redis-exporter: (pid 39768) 56s; run: log: (pid 39767) 56s
run: sidekiq: (pid 39454) 81s; run: log: (pid 39453) 81s
run: unicorn: (pid 39383) 87s; run: log: (pid 39382) 87s
```

### 2.2 查看日志

```
root@k8s4:/etc/gitlab# gitlab-ctl tail
```

### 2.3 日志路径
```
root@k8s4:/etc/gitlab# cd /var/log/gitlab/
```

### 2.4 gitlab数据
```
root@k8s4:/var/log/gitlab# ls /var/opt/gitlab/
```

### 2.5 github备份数据
```
root@k8s4:/var/opt/gitlab/backups# pwd
/var/opt/gitlab/backups
```

### 2.6 安装后程序位置
```
root@k8s4:/opt/gitlab# pwd
/opt/gitlab
root@k8s4:/opt/gitlab# ll
total 1656
drwxr-xr-x 10 root root    4096 Jan 15 16:27 ./
drwxr-xr-x  4 root root    4096 Jan 15 16:21 ../
-rw-r--r--  1 root root 1460869 Nov 24  2017 LICENSE
drwxr-xr-x  2 root root    4096 Jan 15 16:22 LICENSES/
drwxr-xr-x  2 root root    4096 Jan 15 16:22 bin/
-rw-r--r--  1 root root  157364 Nov 24  2017 dependency_licenses.json
drwxr-xr-x 18 root root    4096 Jan 15 16:26 embedded/
drwxr-xr-x  6 root root    4096 Jan 15 16:28 etc/
drwxr-xr-x  2 root root    4096 Jan 15 16:28 init/
drwxr-xr-x  2 root root    4096 Jan 15 16:28 service/
drwxr-xr-x 15 root root    4096 Jan 15 16:28 sv/
drwxr-xr-x  3 root root    4096 Jan 15 16:27 var/
-rw-r--r--  1 root root   19881 Nov 24  2017 version-manifest.json
-rw-r--r--  1 root root    8696 Nov 24  2017 version-manifest.txt

```


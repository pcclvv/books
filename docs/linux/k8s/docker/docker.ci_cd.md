<center><h1>Jenkins与Docker的自动化CI/CD</h1></center>

## 1.介绍
&#160; &#160; &#160; &#160;

1. 什么是CI/CD
2. CI流程
3. 部署Git代码仓库
4. 上传java项目代码
5. 部署Harbor镜像仓库
6. 配置JDK和Maven环境
7. 安装Jenkins
8. 安装docker
9. 构建Tomcat基础镜像
10. 流水线发布测试


## 2. CI/CD

&#160; &#160; &#160; &#160;持续集成（Continuous Integration，CI）：代码合并、构建、部署、测试都在一起，不断地执行这个过程，并对结果反馈。

&#160; &#160; &#160; &#160;持续部署（Continuous Deployment，CD）：部署到测试环境、预生产环境、生产环境。

&#160; &#160; &#160; &#160;持续交付（Continuous Delivery，CD）：将最终产品发布到生产环境，给用户使用。

高效的CI/CD环境可以获得

- 及时发现问题
- 大幅度减少故障率
- 加快迭代速度
- 减少时间成本

![发布流程](../../../pictures/linux/k8s/docker/deploy.png)
![发布流程](../../../pictures/linux/k8s/docker/deploy1.png)


## 3. 环境准备

IP | 角色
---|---
192.168.186.139 | Harbor仓库， docker仓库
192.168.186.140 | git客户端， docker软件


我们主要完成以下效果。

- 140机器从139上拉取源代码。
- 在140机器本地打包生成war包
- 在140基于139harbor基本镜像生成新的镜像
- 在140上推送新的镜像到139harbor上
- 在140上拉取139对于的那镜像
- 在140机上启动那个镜像，从而生成新的容器

<center>![jenkins](../../../pictures/linux/k8s/jenkins/demo.png)</center>

140 安装docker
```
sudo yum install -y yum-utils \
device-mapper-persistent-data lvm2

yum-config-manager --add-repo 
https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io

cat >/etc/docker/daemon.json<<EOF
{
"registry-mirrors": ["http://f1361db2.m.daocloud.io"],
"insecure-registries":["192.168.186.139"]
}
EOF
systemctl restart docker
```


## 4. 部署
### 4.1 部署git
&#160; &#160; &#160; &#160;在139上部署。
#### 4.1.1 配置git账号和密码
```
[root@139 ~]# useradd git
[root@139 ~]# passwd git
Changing password for user git.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.
```
#### 4.1.2 安装git

```
[root@139 ~]# yum install git -y 
[root@140 ~]# yum install git -y 
```
> 139和140机器都安装

#### 4.1.3 初始化git

```
[root@139 ~]# su - git
[git@139 ~]$ mkdir tomcat-java-demo.git
[git@139 ~]$ cd tomcat-java-demo.git/
[git@139 tomcat-java-demo.git]$ git --bare init
Initialized empty Git repository in /home/git/tomcat-java-demo.git/
[git@139 tomcat-java-demo.git]$ ls
branches  config  description  HEAD  hooks  info  objects  refs
```

#### 4.1.4 pull
我们从jenksin机器上去拉取git机器上创建的git仓库
```
[root@140 ~]# git clone git@192.168.186.139:/home/git/tomcat-java-demo
Cloning into 'tomcat-java-demo'...
git@192.168.186.139's password: 
remote: Counting objects: 229, done.
remote: Compressing objects: 100% (185/185), done.
remote: Total 229 (delta 25), reused 229 (delta 25)
Receiving objects: 100% (229/229), 4.52 MiB | 0 bytes/s, done.
Resolving deltas: 100% (25/25), done.
[root@140 ~]# ls
anaconda-ks.cfg  tomcat-java-demo
```

> pull成功了。期中输入的git密码是139上配置的git密码。这个是基于ssh去拉取的

```
[root@140 ~]# mv tomcat-java-demo/ tomcat-java-demo.bak
[root@140 ~]# git clone https://github.com/lizhenliang/tomcat-java-demo
Cloning into 'tomcat-java-demo'...
remote: Enumerating objects: 229, done.
remote: Counting objects: 100% (229/229), done.
remote: Compressing objects: 100% (205/205), done.
remote: Total 229 (delta 25), reused 180 (delta 5), pack-reused 0
Receiving objects: 100% (229/229), 4.52 MiB | 437.00 KiB/s, done.
Resolving deltas: 100% (25/25), done.
```

#### 4.1.5 修改地址

```
[root@140 ~]# cd tomcat-java-demo
[root@140 tomcat-java-demo]# ls
doc  Dockerfile  LICENSE  pom.xml  README.md  src
[root@140 tomcat-java-demo]# vim .git/config 
[root@140 tomcat-java-demo]# grep url .git/config 
	url = git@192.168.186.139:/home/git/tomcat-java-demo.git
```
#### 4.1.6 pull到远端

```
[root@140 tomcat-java-demo]# pwd
/root/tomcat-java-demo
[root@140 tomcat-java-demo]# ls
doc  Dockerfile  LICENSE  pom.xml  README.md  src
[root@140 tomcat-java-demo]#  git add .
[root@140 tomcat-java-demo]# git commit -m 'all'

*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: unable to auto-detect email address (got 'root@140.(none)')
[root@140 tomcat-java-demo]# git config --global user.email "610658552@qq.com"
[root@140 tomcat-java-demo]# git config --global user.name "caimengzhi"
[root@140 tomcat-java-demo]# git commit -m 'all'
# On branch master
nothing to commit, working directory clean

[root@139 tomcat-java-demo]# git push origin master
git@192.168.186.140's password: 
Counting objects: 229, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (185/185), done.
Writing objects: 100% (229/229), 4.52 MiB | 0 bytes/s, done.
Total 229 (delta 25), reused 229 (delta 25)
To git@192.168.186.140:/home/git/tomcat-java-demo.git
 * [new branch]      master -> master
```

> origin是仓库名称。master是仓库的master分支。


#### 4.2 安装jdk

```
[root@140 ~]# ls jdk-8u45-linux-x64.tar.gz 
jdk-8u45-linux-x64.tar.gz
[root@140 ~]# tar xf jdk-8u45-linux-x64.tar.gz -C /usr/local/

[root@140 local]# mv jdk1.8.0_45/ jdk

[root@140 ~]# tail -3 /etc/profile
JAVA_HOME=/usr/local/jdk
PATH=$PATH:$JAVA_HOME/bin
export JAVA_HOME PATH
[root@140 ~]# source /etc/profile
[root@140 ~]# java -version
java version "1.8.0_45"
Java(TM) SE Runtime Environment (build 1.8.0_45-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.45-b02, mixed mode)
```

#### 4.3 安装mvn

```
[root@140 ~]# ls apache-maven-3.5.0-bin.tar.gz 
apache-maven-3.5.0-bin.tar.gz
[root@140 ~]# tar xf apache-maven-3.5.0-bin.tar.gz
[root@140 ~]# mv apache-maven-3.5.0 /usr/local/maven
```

### 5. jenkins

#### 5.1 安装启动jenkins
[下载地址](https://jenkins.io/download/)

```
[root@140 ~]# wget https://mirrors.tuna.tsinghua.edu.cn/jenkins/war-stable/2.164.2/jenkins.war
[root@140 ~]# ls apache-tomcat-8.0.46.tar.gz jenkins.war 
apache-tomcat-8.0.46.tar.gz  jenkins.war
[root@140 ~]# tar xf apache-tomcat-8.0.46.tar.gz 
[root@140 ~]# mv apache-tomcat-8.0.46 /usr/local/jenkins_tomcat
[root@140 ~]# cd /usr/local/jenkins_tomcat/
[root@140 jenkins_tomcat]# cd webapps/
[root@140 webapps]# ls 
docs  examples  host-manager  manager  ROOT
[root@140 webapps]# rm -rf *
[root@140 webapps]# mv /root/jenkins.war ROOT.war
[root@140 webapps]# ls
ROOT.war
[root@140 webapps]# cd ../bin
[root@140 bin]# ./startup.sh 
Using CATALINA_BASE:   /usr/local/jenkins_tomcat
Using CATALINA_HOME:   /usr/local/jenkins_tomcat
Using CATALINA_TMPDIR: /usr/local/jenkins_tomcat/temp
Using JRE_HOME:        /usr/local/jdk
Using CLASSPATH:       /usr/local/jenkins_tomcat/bin/bootstrap.jar:/usr/local/jenkins_tomcat/bin/tomcat-juli.jar
Tomcat started.
```
jenkins的密码

```
[root@139 jenkins_tomcat]# cat /root/.jenkins/secrets/initialAdminPassword 
c4a5466198494da5b3a4e5eb86d25fdb
```

<center>![jenkins](../../../pictures/linux/k8s/jenkins/j1.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j2.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j3.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j4.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j5.png)</center>

开始登陆
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j6.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j7.png)</center>

#### 5.2 安装插件
此步骤需要安装pipeline和scm插件。
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j8.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j9.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j10.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j11.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j12.png)</center>
安装pipeline插件

<center>![jenkins](../../../pictures/linux/k8s/jenkins/j13.png)</center>



#### 5.3 推送镜像到harbor

```
[root@139 ~]# docker images | egrep 'php|tomcat|mysql'
192.168.186.139/library/php     v1                  4e102a80b17b        19 hours ago        540MB
php                             v1                  4e102a80b17b        19 hours ago        540MB
tomcat                          v1                  199049d7998d        19 hours ago        436MB
mysql                           5.7                 98455b9624a9        2 weeks ago         372MB

[root@139 ~]# docker tag tomcat:v1 192.168.186.139/library/tomcat:v1

[root@139 ~]# docker images | egrep 'php|tomcat|mysql'
192.168.186.139/library/php      v1                  4e102a80b17b        19 hours ago        540MB
php                              v1                  4e102a80b17b        19 hours ago        540MB
192.168.186.139/library/tomcat   v1                  199049d7998d        19 hours ago        436MB
tomcat                           v1                  199049d7998d        19 hours ago        436MB
mysql                            5.7                 98455b9624a9        2 weeks ago         372MB

检查仓库地址
[root@139 ~]# cat /etc/docker/daemon.json 
{
"registry-mirrors": ["http://f1361db2.m.daocloud.io"],
"insecure-registries":["192.168.186.139"]
}
insecure-registries 后面就是仓库地址默认是80端口。

推送到harbor仓库
[root@139 ~]# docker push 192.168.186.139/library/tomcat:v1
The push refers to repository [192.168.186.139/library/tomcat]
78d9df8683f3: Pushed 
0feed6d7a49a: Pushed 
3958a3885db8: Pushed 
d69483a6face: Mounted from library/nginx 
v1: digest: sha256:99c6974d46d286b0726c7be252221b41a4ed463ee067042de3e37a673f69b0a7 size: 1163
```

#### 5.4 创建项目

<center>![jenkins](../../../pictures/linux/k8s/jenkins/j14.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j15.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j16.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j17.png)</center>

通过秘钥拉取代码

```
[root@140 jenkins_tomcat]# ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:gi58nmUJI5ZhTTA+Gk/ocsSOat9LtV51u0iRCM/IqWQ root@140
The key's randomart image is:
+---[RSA 2048]----+
|  o..            |
| + +             |
|o O .  .         |
|.X + .. * . .    |
|+.B +E.=S+ + .   |
|o+ ooooo. . o .  |
|..o oo+. . . .   |
|. .+o+. . . . .  |
|   .oo..   . .   |
+----[SHA256]-----+

[root@140 jenkins_tomcat]# ssh-copy-id git@192.168.186.139
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
git@192.168.186.139's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'git@192.168.186.139'"
and check to make sure that only the key(s) you wanted were added.
```

<center>![jenkins](../../../pictures/linux/k8s/jenkins/j18.png)</center>

??? note "私钥"
    ```
    [root@140 ~]# cat .ssh/id_rsa
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAoywWc582daih2tZ15dmp+gm6J4WeSH/GL/OlZD5qUlvr4uuW
    85jbtdF2hcIUoX18VW5iNHcewpbecFZa+QpRmG+x/LLMSG4W/Rtg9PTluCWFUAgi
    8376VxZsSuqLiBW95bZr0hpl3K+aW8iv5bmF7T4J5NOl254mjocdss7DwXqpvAVO
    a4gZxylHHgd2AiCMq1Tr0159GH4SXZC8fcz1R8SU1wNxR3EsuszV0p9WXWiBVk8X
    rPE7pkpo688iWgbX5DRIateRoSHoeN3165P3DadDehTy2Dg1BYo6jDqpkk2/LvfB
    OM6yogTEOBzEKwkazblZLxBrAv1HaE41a40XFwIDAQABAoIBAFxH6sqpGFuiaycg
    crzzRLYsGiOP5dyKpsMnwDnZMrgxVE6Zfl117Yv+UlGDWbebCF4od1HErJjQSiyu
    KfT+aPcU9Ew9slqkKEws18CxX9mtHqAMeffLsDjgbY5Q52inIyZu7Lt+Qm10wo92
    CESbj6qEk4PeTsbNwnCI6breRMd+eDzhUJop855wVW7QZ7HBwDHy4HDEdB9ccNiY
    1MhnubOw1RYfu3DYeAvShDVawA6UkLlLZF2sXhpp8DLnIB1f+SOw/ZmR846dWHCO
    c/AZIUmsxMnIEvrBnZI1bqEcZGoMV1gPXJV3x9J99Z8QhE0BVsWlih5R7EZCBfDe
    DpTaxYECgYEA2La8fUExwpe6bNPlDjV0sCa/yI2bsT50aiiNvYrY6YV5+GN98tUR
    a4MxQik6L/jLh6ZDO3wbbG5hIaJRZS2UlGt8psse5eRkjbTw2+T7+NFBO8pCnckw
    /jo6Z6hG+UqPeUi+xNe6iB4zckaSZJWK05ZwjoJY4WHGUacqmLY3aP8CgYEAwMCX
    PgzsbjloMfyD1Ooq/c/Ds6+Y4O7dgZqPaz3nfQJ7LPPKxhwJmtcO5ThZV9Z2ofTP
    s+bl3N//v+CChn6cbxkqVVpvCOUDz+wMrUra19BU6U5fQcFAZsj4Z0MjAS97EolK
    lJNU1YQN0wqjtmhrvc1GJBtr7gc6hclKEu+CeekCgYAUxQaxlnL3bGVAktpMD1F8
    pGoTBYdbaFnt5q8W8FyznMhAxwBGKqd9v1gUODFMcbLH8GZXKCDUtot2lsDoSoMH
    6nlK3wK6E7aTYjkHSh3gDeYLneneh267nscEMjuDHuM7Q36NDQPikcpqdFsJas+g
    UbW94r4z85P3NWc+tY//7wKBgQCg2ZbcvygmK13aKOFSsj9CIzkrH6QyQOM0HmkE
    k1o0JffoYWGbxRX20vSpMEbOWDgTmxohBNRZZ8wisRX7anjc9WEwbREvmP1/a3qA
    unC5nC7fqvkvBDfcDmXMtmflu1u28j78kZ4/t71Zmg1YUPdoIn8f7oo4zmt17a4U
    8y4s0QKBgAV1iWWQCT4fN04UN3yATFOp1W7//9eEg7BmJhy7qn1Ce9UciiwUJAdW
    uAbpnqzE0y4A1IKCknz6UO3s3vy2zmbAYOQImeaLP+lVQj9ku7v/eCHR2aKJLmha
    wtiFjtFCdosKyX7Y80bX70CODXzKucV6BUfdzyWJBmU0WYHh8zbP
    -----END RSA PRIVATE KEY-----
    ```

<center>![jenkins](../../../pictures/linux/k8s/jenkins/j19.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j20.png)</center>
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j21.png)</center>
```
checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'de20e245-d8c2-4aca-a084-db7d48486b11', url: 'git@192.168.186.139:/home/git/tomcat-java-demo.git']]])
```

??? note "jenkinsfile"
    ```
       node{   
       // 拉取代码
       stage('Git Checkout') { 
           checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'de20e245-d8c2-4aca-a084-db7d48486b11', url: 'git@192.168.186.139:/home/git/tomcat-java-demo.git']]])
       }
       // 代码编译
       stage('Maven Build') {
            sh '''
            export JAVA_HOME=/usr/local/jdk
            /usr/local/maven/bin/mvn clean package -Dmaven.test.skip=true
            '''
       }
       // 项目打包到镜像并推送到镜像仓库
       stage('Build and Push Image') {
            sh '''
            REPOSITORY=192.168.186.139/library/tomcat-java-demo:${branch}
            echo '
            FROM 192.168.186.139/library/tomcat:v1
            MAINTAINER caimengzhi
            RUN rm -rf /usr/local/tomcat/webapps/*
            ADD target/*.war /usr/local/tomcat/webapps/ROOT.war
            ' > Dockerfile
            docker build -t $REPOSITORY .
            docker login 192.168.186.139 -u admin -p  Harbor12345
            docker push $REPOSITORY
            '''
       }
       // 部署到Docker主机
       stage('Deploy to Docker') {
            sh '''
            REPOSITORY=192.168.186.139/library/tomcat-java-demo:${branch}
            docker rm -f java-demo |true
            docker pull $REPOSITORY
            docker container run -d --name tomcat-java-demo -p 88:8080 $REPOSITORY
            '''
       }
    }
    ```
<center>![jenkins](../../../pictures/linux/k8s/jenkins/j22.png)</center><center>[jenkins](../../../pictures/linux/k8s/jenkins/j23.png)</center>

??? note "jenkins 日志输出"
    ```
    执行中Console Output
    Started by user admin
    Running in Durability level: MAX_SURVIVABILITY
    [Pipeline] Start of Pipeline
    [Pipeline] node
    Running on Jenkins in /root/.jenkins/workspace/tomcat-java-demo
    [Pipeline] {
    [Pipeline] stage
    [Pipeline] { (Git Checkout)
    [Pipeline] checkout
    using credential de20e245-d8c2-4aca-a084-db7d48486b11
     > git rev-parse --is-inside-work-tree # timeout=10
    Fetching changes from the remote Git repository
     > git config remote.origin.url git@192.168.186.139:/home/git/tomcat-java-demo.git # timeout=10
    Fetching upstream changes from git@192.168.186.139:/home/git/tomcat-java-demo.git
     > git --version # timeout=10
    using GIT_SSH to set credentials git
     > git fetch --tags --progress git@192.168.186.139:/home/git/tomcat-java-demo.git +refs/heads/*:refs/remotes/origin/*
     > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
     > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
    Checking out Revision d95e43a1da128feec3f97ad200303f426bc57362 (refs/remotes/origin/master)
     > git config core.sparsecheckout # timeout=10
     > git checkout -f d95e43a1da128feec3f97ad200303f426bc57362
    Commit message: "all"
     > git rev-list --no-walk d95e43a1da128feec3f97ad200303f426bc57362 # timeout=10
    [Pipeline] }
    [Pipeline] // stage
    [Pipeline] stage
    [Pipeline] { (Maven Build)
    [Pipeline] sh
    + export JAVA_HOME=/usr/local/jdk
    + JAVA_HOME=/usr/local/jdk
    + /usr/local/maven/bin/mvn clean package -Dmaven.test.skip=true
    [INFO] Scanning for projects...
    [INFO] 
    [INFO] ------------------------------------------------------------------------
    [INFO] Building ly-simple-tomcat 0.0.1-SNAPSHOT
    [INFO] ------------------------------------------------------------------------
    [INFO] 
    [INFO] --- maven-clean-plugin:3.0.0:clean (default-clean) @ ly-simple-tomcat ---
    [INFO] Deleting /root/.jenkins/workspace/tomcat-java-demo/target
    [INFO] 
    [INFO] --- maven-resources-plugin:3.0.1:resources (default-resources) @ ly-simple-tomcat ---
    [INFO] Using 'UTF-8' encoding to copy filtered resources.
    [INFO] Copying 1 resource
    [INFO] Copying 136 resources
    [INFO] 
    [INFO] --- maven-compiler-plugin:3.7.0:compile (default-compile) @ ly-simple-tomcat ---
    [INFO] Changes detected - recompiling the module!
    [INFO] Compiling 7 source files to /root/.jenkins/workspace/tomcat-java-demo/target/classes
    [INFO] 
    [INFO] --- maven-resources-plugin:3.0.1:testResources (default-testResources) @ ly-simple-tomcat ---
    [INFO] Not copying test resources
    [INFO] 
    [INFO] --- maven-compiler-plugin:3.7.0:testCompile (default-testCompile) @ ly-simple-tomcat ---
    [INFO] Not compiling test sources
    [INFO] 
    [INFO] --- maven-surefire-plugin:2.21.0:test (default-test) @ ly-simple-tomcat ---
    [INFO] Tests are skipped.
    [INFO] 
    [INFO] --- maven-war-plugin:3.1.0:war (default-war) @ ly-simple-tomcat ---
    [INFO] Packaging webapp
    [INFO] Assembling webapp [ly-simple-tomcat] in [/root/.jenkins/workspace/tomcat-java-demo/target/ly-simple-tomcat-0.0.1-SNAPSHOT]
    [INFO] Processing war project
    [INFO] Webapp assembled in [206 msecs]
    [INFO] Building war: /root/.jenkins/workspace/tomcat-java-demo/target/ly-simple-tomcat-0.0.1-SNAPSHOT.war
    [INFO] ------------------------------------------------------------------------
    [INFO] BUILD SUCCESS
    [INFO] ------------------------------------------------------------------------
    [INFO] Total time: 5.084 s
    [INFO] Finished at: 2019-04-16T03:06:09-04:00
    [INFO] Final Memory: 29M/187M
    [INFO] ------------------------------------------------------------------------
    [Pipeline] }
    [Pipeline] // stage
    [Pipeline] stage
    [Pipeline] { (Build and Push Image)
    [Pipeline] sh
    + REPOSITORY=192.168.186.139/library/tomcat-java-demo:master
    + echo '
            FROM 192.168.186.139/library/tomcat:v1
            MAINTAINER caimengzhi
            RUN rm -rf /usr/local/tomcat/webapps/*
            ADD target/*.war /usr/local/tomcat/webapps/ROOT.war
            '
    + docker build -t 192.168.186.139/library/tomcat-java-demo:master .
    Sending build context to Docker daemon  63.12MB
    
    Step 1/4 : FROM 192.168.186.139/library/tomcat:v1
    v1: Pulling from library/tomcat
    8ba884070f61: Pulling fs layer
    6bc3863e7ff7: Pulling fs layer
    314099d7cdc0: Pulling fs layer
    723dfd4053ce: Pulling fs layer
    723dfd4053ce: Waiting
    314099d7cdc0: Verifying Checksum
    314099d7cdc0: Download complete
    723dfd4053ce: Verifying Checksum
    723dfd4053ce: Download complete
    6bc3863e7ff7: Verifying Checksum
    6bc3863e7ff7: Download complete
    8ba884070f61: Download complete
    8ba884070f61: Pull complete
    6bc3863e7ff7: Pull complete
    314099d7cdc0: Pull complete
    723dfd4053ce: Pull complete
    Digest: sha256:99c6974d46d286b0726c7be252221b41a4ed463ee067042de3e37a673f69b0a7
    Status: Downloaded newer image for 192.168.186.139/library/tomcat:v1
     ---> 199049d7998d
    Step 2/4 : MAINTAINER caimengzhi
     ---> Running in dd3cb11c6c34
    Removing intermediate container dd3cb11c6c34
     ---> 81d0647cf6ff
    Step 3/4 : RUN rm -rf /usr/local/tomcat/webapps/*
     ---> Running in 5104ee7d9b89
    Removing intermediate container 5104ee7d9b89
     ---> a191a914b200
    Step 4/4 : ADD target/*.war /usr/local/tomcat/webapps/ROOT.war
     ---> 9bae5cc3a6d6
    Successfully built 9bae5cc3a6d6
    Successfully tagged 192.168.186.139/library/tomcat-java-demo:master
    + docker login 192.168.186.139 -u admin -p Harbor12345
    WARNING! Using --password via the CLI is insecure. Use --password-stdin.
    WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store
    
    Login Succeeded
    + docker push 192.168.186.139/library/tomcat-java-demo:master
    The push refers to repository [192.168.186.139/library/tomcat-java-demo]
    ddd289681966: Preparing
    b7c128a85c86: Preparing
    78d9df8683f3: Preparing
    0feed6d7a49a: Preparing
    3958a3885db8: Preparing
    d69483a6face: Preparing
    d69483a6face: Waiting
    78d9df8683f3: Mounted from library/tomcat
    3958a3885db8: Mounted from library/tomcat
    b7c128a85c86: Pushed
    0feed6d7a49a: Mounted from library/tomcat
    d69483a6face: Mounted from library/tomcat
    ddd289681966: Pushed
    master: digest: sha256:3469e4c2239479927a6175bef75fc81ff9e5bcc05fcefe55d5d773e00832b866 size: 1582
    [Pipeline] }
    [Pipeline] // stage
    [Pipeline] stage
    [Pipeline] { (Deploy to Docker)
    [Pipeline] sh
    + REPOSITORY=192.168.186.139/library/tomcat-java-demo:master
    + docker rm -f java-demo
    + true
    Error: No such container: java-demo
    + docker pull 192.168.186.139/library/tomcat-java-demo:master
    master: Pulling from library/tomcat-java-demo
    Digest: sha256:3469e4c2239479927a6175bef75fc81ff9e5bcc05fcefe55d5d773e00832b866
    Status: Image is up to date for 192.168.186.139/library/tomcat-java-demo:master
    + docker container run -d --name tomcat-java-demo -p 88:8080 192.168.186.139/library/tomcat-java-demo:master
    01c0d5a95729bf51d045c2b4f66c6a00e9fbe9e6b08238b45ca0078ad4009656
    [Pipeline] }
    [Pipeline] // stage
    [Pipeline] }
    [Pipeline] // node
    [Pipeline] End of Pipeline
    Finished: SUCCESS
    ```

查看新启动的容器

```
[root@140 cmz]# docker ps
CONTAINER ID        IMAGE                                             COMMAND             CREATED             STATUS              PORTS                  NAMES
01c0d5a95729        192.168.186.139/library/tomcat-java-demo:master   "catalina.sh run"   22 minutes ago      Up 22 minutes       0.0.0.0:88->8080/tcp   tomcat-java-demo
```

> 从构建镜像到推送都harbor，然后从harbor上拉取，然后启动。

<center>![jenkins](../../../pictures/linux/k8s/jenkins/j26.png)</center>

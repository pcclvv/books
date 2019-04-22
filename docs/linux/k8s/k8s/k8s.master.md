
<center><h1>Kubernets master</h1></center>


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

## 2. 部署

- kube-apiserver
- kube-controller-manager
- kube-scheduler

> 配置文件 -> systemd管理组件 -> 启动

kubernets的下载[地址](https://github.com/kubernetes/kubernetes/releases)

```
https://github.com/kubernetes/kubernetes/releases
```

### 2.1 kube-apiserver

??? note "k8s-cert.sh"
    ```
    [root@k8s-master01 k8s-cert]# cat  k8s-cert.sh 
    cat > ca-config.json <<EOF
    {
      "signing": {
        "default": {
          "expiry": "87600h"
        },
        "profiles": {
          "kubernetes": {
             "expiry": "87600h",
             "usages": [
                "signing",
                "key encipherment",
                "server auth",
                "client auth"
            ]
          }
        }
      }
    }
    EOF
    
    cat > ca-csr.json <<EOF
    {
        "CN": "kubernetes",
        "key": {
            "algo": "rsa",
            "size": 2048
        },
        "names": [
            {
                "C": "CN",
                "L": "Beijing",
                "ST": "Beijing",
          	    "O": "k8s",
                "OU": "System"
            }
        ]
    }
    EOF
    
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
    
    #-----------------------
    
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
    
    #-----------------------
    
    cat > admin-csr.json <<EOF
    {
      "CN": "admin",
      "hosts": [],
      "key": {
        "algo": "rsa",
        "size": 2048
      },
      "names": [
        {
          "C": "CN",
          "L": "BeiJing",
          "ST": "BeiJing",
          "O": "system:masters",
          "OU": "System"
        }
      ]
    }
    EOF
    
    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
    
    #-----------------------
    
    cat > kube-proxy-csr.json <<EOF
    {
      "CN": "system:kube-proxy",
      "hosts": [],
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
    
    cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-
    proxy
    ```

命令
```
sh k8s-cert.sh 
ls -l
cp ca.pem ca-key.pem server.pem server-key.pem /opt/kubernetes/ssl/

# 生成token文件
BOOTSTRAP_TOKEN=0fb61c46f8991b718eb38d27b605b008

cat > token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
mv token.csv /opt/kubernetes/cfg/
systemctl start kube-apiserver
systemctl status kube-apiserver
netstat -lnp|egrep '8080|6443'
```
 

详细操作
```
[root@k8s-master01 k8s-cert]# sh k8s-cert.sh 
2019/04/18 15:35:55 [INFO] generating a new CA key and certificate from CSR
2019/04/18 15:35:55 [INFO] generate received request
2019/04/18 15:35:55 [INFO] received CSR
2019/04/18 15:35:55 [INFO] generating key: rsa-2048
2019/04/18 15:35:56 [INFO] encoded CSR
2019/04/18 15:35:56 [INFO] signed certificate with serial number 241119064329440576584372707594511202166980750174
2019/04/18 15:35:56 [INFO] generate received request
2019/04/18 15:35:56 [INFO] received CSR
2019/04/18 15:35:56 [INFO] generating key: rsa-2048
2019/04/18 15:35:56 [INFO] encoded CSR
2019/04/18 15:35:56 [INFO] signed certificate with serial number 534925926822911487989404786746217251923733657099
2019/04/18 15:35:56 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2019/04/18 15:35:56 [INFO] generate received request
2019/04/18 15:35:56 [INFO] received CSR
2019/04/18 15:35:56 [INFO] generating key: rsa-2048
2019/04/18 15:35:56 [INFO] encoded CSR
2019/04/18 15:35:56 [INFO] signed certificate with serial number 112864343340575063841679898865276132997300012231
2019/04/18 15:35:56 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").
2019/04/18 15:35:56 [INFO] generate received request
2019/04/18 15:35:56 [INFO] received CSR
2019/04/18 15:35:56 [INFO] generating key: rsa-2048
2019/04/18 15:35:56 [INFO] encoded CSR
2019/04/18 15:35:56 [INFO] signed certificate with serial number 639713345028309638507679332001340084790736763856
2019/04/18 15:35:56 [WARNING] This certificate lacks a "hosts" field. This makes it unsuitable for
websites. For more information see the Baseline Requirements for the Issuance and Management
of Publicly-Trusted Certificates, v.1.1.6, from the CA/Browser Forum (https://cabforum.org);
specifically, section 10.2.3 ("Information Requirements").

[root@k8s-master01 k8s-cert]# ls -l
total 72
-rw-r--r-- 1 root root 1009 Apr 18 15:35 admin.csr
-rw-r--r-- 1 root root  229 Apr 18 15:35 admin-csr.json
-rw------- 1 root root 1675 Apr 18 15:35 admin-key.pem
-rw-r--r-- 1 root root 1399 Apr 18 15:35 admin.pem
-rw-r--r-- 1 root root  294 Apr 18 15:35 ca-config.json
-rw-r--r-- 1 root root 1001 Apr 18 15:35 ca.csr
-rw-r--r-- 1 root root  263 Apr 18 15:35 ca-csr.json
-rw------- 1 root root 1679 Apr 18 15:35 ca-key.pem
-rw-r--r-- 1 root root 1359 Apr 18 15:35 ca.pem
-rw-r--r-- 1 root root 2370 Apr 18 15:34 k8s-cert.sh
-rw-r--r-- 1 root root 1009 Apr 18 15:35 kube-proxy.csr
-rw-r--r-- 1 root root  230 Apr 18 15:35 kube-proxy-csr.json
-rw------- 1 root root 1675 Apr 18 15:35 kube-proxy-key.pem
-rw-r--r-- 1 root root 1403 Apr 18 15:35 kube-proxy.pem
-rw-r--r-- 1 root root 1293 Apr 18 15:35 server.csr
-rw-r--r-- 1 root root  663 Apr 18 15:35 server-csr.json
-rw------- 1 root root 1679 Apr 18 15:35 server-key.pem
-rw-r--r-- 1 root root 1659 Apr 18 15:35 server.pem

[root@k8s-master01 k8s-cert]# cp ca.pem ca-key.pem server.pem server-key.pem /opt/kubernetes/ssl/
[root@k8s-master01 k8s-cert]# BOOTSTRAP_TOKEN=0fb61c46f8991b718eb38d27b605b008
[root@k8s-master01 k8s-cert]# cat > token.csv <<EOF
> ${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
> EOF
[root@k8s-master01 k8s-cert]# cat token.csv 
0fb61c46f8991b718eb38d27b605b008,kubelet-bootstrap,10001,"system:kubelet-bootstrap"
[root@k8s-master01 k8s-cert]# mv token.csv /opt/kubernetes/cfg/

# 启动kube-apiserver
[root@k8s-master01 k8s-cert]# systemctl start kube-apiserver

# 查看状态
[root@k8s-master01 k8s-cert]# systemctl status kube-apiserver
● kube-apiserver.service - Kubernetes API Server
   Loaded: loaded (/usr/lib/systemd/system/kube-apiserver.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-04-18 15:52:22 CST; 2min 55s ago
     Docs: https://github.com/kubernetes/kubernetes
 Main PID: 107702 (kube-apiserver)
    Tasks: 14
   Memory: 271.7M
   CGroup: /system.slice/kube-apiserver.service
           └─107702 /opt/kubernetes/bin/kube-apiserver --logtostderr=true --v=4 --etcd-servers=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379 --bi...

Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.038216  107702 wrap.go:47] GET /apis/admissionregistration.k8s.io/v1beta1?timeout=32s: (167.098µs) 200 [kub…86.139:40042]
Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.038905  107702 wrap.go:47] GET /apis/apiextensions.k8s.io/v1beta1?timeout=32s: (123.136µs) 200 [kube-apiser…86.139:40042]
Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.039633  107702 wrap.go:47] GET /apis/scheduling.k8s.io/v1beta1?timeout=32s: (183.735µs) 200 [kube-apiserver…86.139:40042]
Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.040199  107702 wrap.go:47] GET /apis/coordination.k8s.io/v1beta1?timeout=32s: (172.826µs) 200 [kube-apiserv…86.139:40042]
Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.505740  107702 wrap.go:47] GET /api/v1/namespaces/default: (3.237194ms) 200 [kube-apiserver/v1.13.4 (linux/....139:40042]
Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.513184  107702 wrap.go:47] GET /api/v1/namespaces/default/services/kubernetes: (6.18309ms) 200 [kube-apiser....139:40042]
Apr 18 15:54:59 k8s-master01 kube-apiserver[107702]: I0418 15:54:59.523248  107702 wrap.go:47] GET /api/v1/namespaces/default/endpoints/kubernetes: (2.810184ms) 200 [kube-apis....139:40042]
Apr 18 15:55:09 k8s-master01 kube-apiserver[107702]: I0418 15:55:09.536820  107702 wrap.go:47] GET /api/v1/namespaces/default: (6.354246ms) 200 [kube-apiserver/v1.13.4 (linux/....139:40042]
Apr 18 15:55:09 k8s-master01 kube-apiserver[107702]: I0418 15:55:09.544944  107702 wrap.go:47] GET /api/v1/namespaces/default/services/kubernetes: (5.982051ms) 200 [kube-apise....139:40042]
Apr 18 15:55:09 k8s-master01 kube-apiserver[107702]: I0418 15:55:09.565551  107702 wrap.go:47] GET /api/v1/namespaces/default/endpoints/kubernetes: (1.775132ms) 200 [kube-apis....139:40042]
Hint: Some lines were ellipsized, use -l to show in full.

查看进程
[root@k8s-master01 k8s-cert]# ps axf|grep kube
112457 pts/1    S+     0:00          \_ grep --color=auto kube
107702 ?        Ssl    0:19 /opt/kubernetes/bin/kube-apiserver --logtostderr=true --v=4 --etcd-servers=https://192.168.186.139:2379,https://192.168.186.141:2379,https://192.168.186.142:2379
 --bind-address=192.168.186.139 --secure-port=6443 --advertise-address=192.168.186.139 --allow-privileged=true --service-cluster-ip-range=10.0.0.0/24 --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction --authorization-mode=RBAC,Node --kubelet-https=true --enable-bootstrap-token-auth --token-auth-file=/opt/kubernetes/cfg/token.csv --service-node-port-range=30000-50000 --tls-cert-file=/opt/kubernetes/ssl/server.pem --tls-private-key-file=/opt/kubernetes/ssl/server-key.pem --client-ca-file=/opt/kubernetes/ssl/ca.pem --service-account-key-file=/opt/kubernetes/ssl/ca-key.pem --etcd-cafile=/opt/etcd/ssl/ca.pem --etcd-certfile=/opt/etcd/ssl/server.pem --etcd-keyfile=/opt/etcd/ssl/server-key.pem

查看端口
[root@k8s-master01 k8s]# netstat -lnp|egrep '8080|6443'
tcp        0      0 192.168.186.139:6443    0.0.0.0:*               LISTEN      107702/kube-apiserv 
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN      107702/kube-apiserv
```
> token.csv是kubelet加入集群时候颁发证书使用




### 2.2 kube-controller-manager

??? note "controller-manager.sh"
    ```
    [root@k8s-master01 k8s]# cat controller-manager.sh 
    #!/bin/bash
    MASTER_ADDRESS=$1
    cat <<EOF >/opt/kubernetes/cfg/kube-controller-manager
    KUBE_CONTROLLER_MANAGER_OPTS="--logtostderr=true \\
    --v=4 \\
    --master=${MASTER_ADDRESS}:8080 \\
    --leader-elect=true \\
    --address=127.0.0.1 \\
    --service-cluster-ip-range=10.0.0.0/24 \\
    --cluster-name=kubernetes \\
    --cluster-signing-cert-file=/opt/kubernetes/ssl/ca.pem \\
    --cluster-signing-key-file=/opt/kubernetes/ssl/ca-key.pem  \\
    --root-ca-file=/opt/kubernetes/ssl/ca.pem \\
    --service-account-private-key-file=/opt/kubernetes/ssl/ca-key.pem \\
    --experimental-cluster-signing-duration=87600h0m0s"
    
    EOF
    
    cat <<EOF >/usr/lib/systemd/system/kube-controller-manager.service
    [Unit]
    Description=Kubernetes Controller Manager
    Documentation=https://github.com/kubernetes/kubernetes
    
    [Service]
    EnvironmentFile=-/opt/kubernetes/cfg/kube-controller-manager
    ExecStart=/opt/kubernetes/bin/kube-controller-manager \$KUBE_CONTROLLER_MANAGER_OPTS
    Restart=on-failure
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    systemctl daemon-reload
    systemctl enable kube-controller-manager
    systemctl restart kube-controller-manager
    ```

```
sh controller-manager.sh 127.0.0.1
```
详细操作

```
[root@k8s-master01 k8s]# sh controller-manager.sh 127.0.0.1
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-controller-manager.service to /usr/lib/systemd/system/kube-controller-manager.service.

检查
[root@k8s-master01 k8s]# ps axf|grep kube-con
122803 pts/1    S+     0:00          \_ grep --color=auto kube-con
120170 ?        Ssl    0:08 /opt/kubernetes/bin/kube-controller-manager --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-
elect=true --address=127.0.0.1 --service-cluster-ip-range=10.0.0.0/24 --cluster-name=kubernetes --cluster-signing-cert-file=/opt/kubernetes/ssl/ca.pem --cluster-signing-key-file=/opt/kubernetes/ssl/ca-key.pem --root-ca-file=/opt/kubernetes/ssl/ca.pem --service-account-private-key-file=/opt/kubernetes/ssl/ca-key.pem --experimental-cluster-signing-duration=87600h0m0s
```


### 2.3 kube-scheduler

??? note "scheduler.sh"
    ```
    [root@k8s-master01 k8s]# cat scheduler.sh 
    #!/bin/bash
    
    MASTER_ADDRESS=$1
    
    cat <<EOF >/opt/kubernetes/cfg/kube-scheduler
    
    KUBE_SCHEDULER_OPTS="--logtostderr=true \\
    --v=4 \\
    --master=${MASTER_ADDRESS}:8080 \\
    --leader-elect"
    
    EOF
    
    cat <<EOF >/usr/lib/systemd/system/kube-scheduler.service
    [Unit]
    Description=Kubernetes Scheduler
    Documentation=https://github.com/kubernetes/kubernetes
    
    [Service]
    EnvironmentFile=-/opt/kubernetes/cfg/kube-scheduler
    ExecStart=/opt/kubernetes/bin/kube-scheduler \$KUBE_SCHEDULER_OPTS
    Restart=on-failure
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    systemctl daemon-reload
    systemctl enable kube-scheduler
    systemctl restart kube-scheduler
    ```

> logtostderr 也可以配置单独日志输出地方

```
sh controller-manager.sh 127.0.0.1
```
详细操作

```
[root@k8s-master01 k8s]# sh scheduler.sh 127.0.0.1
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-scheduler.service to /usr/lib/systemd/system/kube-scheduler.service.

检查
[root@k8s-master01 k8s]# ps axf|grep kube-sch
122835 pts/1    S+     0:00          \_ grep --color=auto kube-sch
121551 ?        Ssl    0:02 /opt/kubernetes/bin/kube-scheduler --logtostderr=true --v=4 --master=127.0.0.1:8080 --leader-elect
```


### 2.4 查看集群状态
拷贝管理bin
```
[root@k8s-master01 k8s]# cp /root/soft/kubernetes/server/bin/kubectl /usr/bin/
[root@k8s-master01 k8s]# kubectl get cs
NAME                 STATUS    MESSAGE             ERROR
controller-manager   Healthy   ok                  
scheduler            Healthy   ok                  
etcd-0               Healthy   {"health":"true"}   
etcd-1               Healthy   {"health":"true"}   
etcd-2               Healthy   {"health":"true"}   
```
> cs 是缩写

??? note "cs 是componentstatuses缩写"
    ```
    [root@k8s-master01 bin]# kubectl get componentstatuses
    NAME                 STATUS    MESSAGE             ERROR
    scheduler            Healthy   ok                  
    controller-manager   Healthy   ok                  
    etcd-1               Healthy   {"health":"true"}   
    etcd-0               Healthy   {"health":"true"}   
    etcd-2               Healthy   {"health":"true"}   
    ```

??? note "常见缩写"
    ```
    [root@k8s-master01 k8s]# kubectl api-resources
    NAME                              SHORTNAMES   APIGROUP                       NAMESPACED   KIND
    bindings                                                                      true         Binding
    componentstatuses                 cs                                          false        ComponentStatus
    configmaps                        cm                                          true         ConfigMap
    endpoints                         ep                                          true         Endpoints
    events                            ev                                          true         Event
    limitranges                       limits                                      true         LimitRange
    namespaces                        ns                                          false        Namespace
    nodes                             no                                          false        Node
    persistentvolumeclaims            pvc                                         true         PersistentVolumeClaim
    persistentvolumes                 pv                                          false        PersistentVolume
    pods                              po                                          true         Pod
    podtemplates                                                                  true         PodTemplate
    replicationcontrollers            rc                                          true         ReplicationController
    resourcequotas                    quota                                       true         ResourceQuota
    secrets                                                                       true         Secret
    serviceaccounts                   sa                                          true         ServiceAccount
    services                          svc                                         true         Service
    mutatingwebhookconfigurations                  admissionregistration.k8s.io   false        MutatingWebhookConfiguration
    validatingwebhookconfigurations                admissionregistration.k8s.io   false        ValidatingWebhookConfiguration
    customresourcedefinitions         crd,crds     apiextensions.k8s.io           false        CustomResourceDefinition
    apiservices                                    apiregistration.k8s.io         false        APIService
    controllerrevisions                            apps                           true         ControllerRevision
    daemonsets                        ds           apps                           true         DaemonSet
    deployments                       deploy       apps                           true         Deployment
    replicasets                       rs           apps                           true         ReplicaSet
    statefulsets                      sts          apps                           true         StatefulSet
    tokenreviews                                   authentication.k8s.io          false        TokenReview
    localsubjectaccessreviews                      authorization.k8s.io           true         LocalSubjectAccessReview
    selfsubjectaccessreviews                       authorization.k8s.io           false        SelfSubjectAccessReview
    selfsubjectrulesreviews                        authorization.k8s.io           false        SelfSubjectRulesReview
    subjectaccessreviews                           authorization.k8s.io           false        SubjectAccessReview
    horizontalpodautoscalers          hpa          autoscaling                    true         HorizontalPodAutoscaler
    cronjobs                          cj           batch                          true         CronJob
    jobs                                           batch                          true         Job
    certificatesigningrequests        csr          certificates.k8s.io            false        CertificateSigningRequest
    leases                                         coordination.k8s.io            true         Lease
    events                            ev           events.k8s.io                  true         Event
    daemonsets                        ds           extensions                     true         DaemonSet
    deployments                       deploy       extensions                     true         Deployment
    ingresses                         ing          extensions                     true         Ingress
    networkpolicies                   netpol       extensions                     true         NetworkPolicy
    podsecuritypolicies               psp          extensions                     false        PodSecurityPolicy
    replicasets                       rs           extensions                     true         ReplicaSet
    networkpolicies                   netpol       networking.k8s.io              true         NetworkPolicy
    poddisruptionbudgets              pdb          policy                         true         PodDisruptionBudget
    podsecuritypolicies               psp          policy                         false        PodSecurityPolicy
    clusterrolebindings                            rbac.authorization.k8s.io      false        ClusterRoleBinding
    clusterroles                                   rbac.authorization.k8s.io      false        ClusterRole
    rolebindings                                   rbac.authorization.k8s.io      true         RoleBinding
    roles                                          rbac.authorization.k8s.io      true         Role
    priorityclasses                   pc           scheduling.k8s.io              false        PriorityClass
    storageclasses                    sc           storage.k8s.io                 false        StorageClass
    volumeattachments                              storage.k8s.io                 false        VolumeAttachment
    ```

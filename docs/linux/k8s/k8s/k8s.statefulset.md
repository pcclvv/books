
<center><h1>Kubernets 有状态部署</h1></center>


## 1. Headless
&#160; &#160; &#160; &#160;

```
1. Headless
2. StatefulSet
```

??? note "nginx.yaml"
    ```
    #[root@k8s-master01 demo]# cat nginx.yaml 
    apiVersion: apps/v1beta2
    kind: Deployment
    metadata:
      name: nginx-deployment
      namespace: default
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
    #      imagePullSecrets:
    #        - name: myregistrykey
          restartPolicy: Always
          nodeSelector:
            env_role: dev
          containers:
          - name: nginx
            imagePullPolicy: IfNotPresent
            image: nginx:1.15
            ports:
            - containerPort: 80
    ```

```
[root@k8s-master01 demo]# kubectl create -f service.yaml 
[root@k8s-master01 demo]# kubectl get service
NAME            TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
kubernetes      ClusterIP   10.0.0.1     <none>        443/TCP        8d
nginx-service   NodePort    10.0.0.228   <none>        80:41583/TCP   3d23h
```

??? note "headless.yaml"
    ```
    apiVersion: v1
    kind: Service
    metadata:
      name: headless-service 
      labels:
        app: nginx
    spec:
      clusterIP: None
      ports:
      - port: 80
        targetPort: 80
      selector:
        app: nginx
    ```


```
[root@k8s-master01 demo]# kubectl create -f headless.yaml 
service/headless-service created
[root@k8s-master01 demo]# kubectl get service
NAME               TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
headless-service   ClusterIP   None         <none>        80/TCP         18s
kubernetes         ClusterIP   10.0.0.1     <none>        443/TCP        8d
nginx-service      NodePort    10.0.0.228   <none>        80:41583/TCP   3d23h
```
> headless service和其他正常service唯一区别是，clusterip是none


## 2. statefulset

```
https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
```

- 部署有状态应用
- 解决Pod独立生命周期，保持Pod启动顺序和唯一性

    - 1. 稳定，唯一的网络标识符，持久存储
    - 2. 有序，优雅的部署和扩展、删除和终止
    - 3. 有序，滚动更新应用场景：数据库

??? note "sts.yaml"
    ```
    # [root@k8s-master01 demo2]# cat sts.yaml 
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      ports:
      - port: 80
        name: web
      clusterIP: None
      selector:
        app: nginx
    ---
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
      name: web
    spec:
      selector:
        matchLabels:
          app: nginx # has to match .spec.template.metadata.labels
      serviceName: "nginx"
      replicas: 3 # by default is 1
      template:
        metadata:
          labels:
            app: nginx # has to match .spec.selector.matchLabels
        spec:
          terminationGracePeriodSeconds: 10
          containers:
          - name: nginx
            image: nginx
            ports:
            - containerPort: 80
              name: web
            volumeMounts:
            - name: www
              mountPath: /usr/share/nginx/html
      volumeClaimTemplates:
      - metadata:
          name: www
        spec:
          accessModes: [ "ReadWriteOnce" ]
          storageClassName: "managed-nfs-storage"
          resources:
            requests:
              storage: 1Gi
    
    ```
> sts.yml中storageClassName要使用之前定义的managed-nfs-storage,[kubectl get storageclass结果可以看出]


```
[root@k8s-master01 ~]# kubectl delete -f k8s/demo/nginx.yaml 
deployment.apps "nginx-deployment" deleted
[root@k8s-master01 ~]# kubectl delete -f k8s/demo/service.yaml 
service "nginx-service" deleted

[root@k8s-master01 demo2]# kubectl create -f sts.yaml 
service/nginx created
statefulset.apps/web created

动态查看过程
[root@k8s-master01 demo2]# kubectl get pod -w
NAME                                     READY   STATUS              RESTARTS   AGE
agent-85j4c                              1/1     Running             2          40h
agent-kp5fp                              1/1     Running             1          40h
nfs-client-provisioner-d947789f7-rchmw   1/1     Running             1          40h
web-0                                    1/1     Running             0          18s
web-1                                    0/1     ContainerCreating   0          2s
web-1   1/1   Running   0     3s
web-2   0/1   Pending   0     0s
web-2   0/1   Pending   0     0s
web-2   0/1   Pending   0     0s
web-2   0/1   ContainerCreating   0     0s
web-2   1/1   Running   0     2s
q

^C[root@k8s-master01 demo2]# 
[root@k8s-master01 demo2]# 
[root@k8s-master01 demo2]# 
[root@k8s-master01 demo2]# kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
agent-85j4c                              1/1     Running   2          40h
agent-kp5fp                              1/1     Running   1          40h
nfs-client-provisioner-d947789f7-rchmw   1/1     Running   1          40h
web-0                                    1/1     Running   0          58s
web-1                                    1/1     Running   0          42s
web-2                                    1/1     Running   0          39s

[root@k8s-master01 demo2]# kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.0.0.1     <none>        443/TCP   9d
nginx        ClusterIP   None         <none>        80/TCP    4m17s
没有分配cluster-ip
```
> 有状态的部署，有顺序的，通过-w，来查看启动过程。


StatefulSet与Deployment区别：有身份的！身份三要素

- 域名
- 主机名
- 存储（PVC）

```
ClusterIP A记录格式：<service-name>.<namespace-name>.svc.cluster.localClusterIP=None 
A记录格式：<statefulsetName-index>.<service-name>.svc.cluster.local
示例：web-0.nginx.default.svc.cluster.local
```

??? note "bs.yaml"
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: busybox
    spec:
      containers:
      - name: busybox
        image: busybox:1.28.4
        command:
        - sleep
        - "3600"
    ```

```
[root@k8s-master01 demo2]# kubectl create -f bs.yaml 
pod/busybox created
[root@k8s-master01 demo2]# kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
agent-85j4c                              1/1     Running   2          40h
agent-kp5fp                              1/1     Running   1          40h
busybox                                  1/1     Running   0          7s
nfs-client-provisioner-d947789f7-rchmw   1/1     Running   1          40h
web-0                                    1/1     Running   0          3m37s
web-1                                    1/1     Running   0          3m21s
web-2                                    1/1     Running   0          3m18s

因为没有分配cluster-ip，只好通过servername来访问，进入容器测试
[root@k8s-master01 demo2]# kubectl exec -it busybox sh
/ # ping nginx
PING nginx (172.17.26.6): 56 data bytes
64 bytes from 172.17.26.6: seq=0 ttl=62 time=0.609 ms
64 bytes from 172.17.26.6: seq=1 ttl=62 time=0.370 ms
64 bytes from 172.17.26.6: seq=2 ttl=62 time=0.397 ms
64 bytes from 172.17.26.6: seq=3 ttl=62 time=0.525 ms
^C
--- nginx ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.370/0.475/0.609 ms
/ # nslookup nginx
Server:    10.0.0.2
Address 1: 10.0.0.2 kube-dns.kube-system.svc.cluster.local

Name:      nginx
Address 1: 172.17.26.6 web-1.nginx.default.svc.cluster.local
Address 2: 172.17.26.7 web-2.nginx.default.svc.cluster.local
Address 3: 172.17.73.5 web-0.nginx.default.svc.cluster.local
/ # 

/ # ping web-0.nginx.default.svc.cluster.local -c1
PING web-0.nginx.default.svc.cluster.local (172.17.73.5): 56 data bytes
64 bytes from 172.17.73.5: seq=0 ttl=64 time=0.046 ms

--- web-0.nginx.default.svc.cluster.local ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.046/0.046/0.046 ms

后面的cluster.local可以省略
/ # ping web-0.nginx.default.svc -c1
PING web-0.nginx.default.svc (172.17.73.5): 56 data bytes
64 bytes from 172.17.73.5: seq=0 ttl=64 time=0.094 ms

--- web-0.nginx.default.svc ping statistics ---
1 packets transmitted, 1 packets received, 0% packet loss
round-trip min/avg/max = 0.094/0.094/0.094 ms
也就是说通过这个可以访问对于的pod，体现了网络唯一的网络标识
```
> 通过 web-0.nginx.default.svc.cluster.local 可以找到172.17.73.5这个pod


```
[root@k8s-master01 demo2]# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS          REASON   AGE
pvc-7383e81d-695d-11e9-8c4f-000c2994bdca   1Gi        RWO            Delete           Bound    default/www-web-0   managed-nfs-storage            57m
pvc-7d6cbcac-695d-11e9-8c4f-000c2994bdca   1Gi        RWO            Delete           Bound    default/www-web-1   managed-nfs-storage            57m
pvc-7f234bb6-695d-11e9-8c4f-000c2994bdca   1Gi        RWO            Delete           Bound    default/www-web-2   managed-nfs-storage            57m

[root@k8s-master01 demo2]# kubectl get pvc
NAME        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
www-web-0   Bound    pvc-7383e81d-695d-11e9-8c4f-000c2994bdca   1Gi        RWO            managed-nfs-storage   58m
www-web-1   Bound    pvc-7d6cbcac-695d-11e9-8c4f-000c2994bdca   1Gi        RWO            managed-nfs-storage   58m
www-web-2   Bound    pvc-7f234bb6-695d-11e9-8c4f-000c2994bdca   1Gi        RWO            managed-nfs-storage   58m
```
> 自动创建了三个pv，动态供给，独立了存储，期中pod-->pv-->pvc都是一一对应的。

```
[root@k8s-master01 demo2]# kubectl exec -it web-0 sh
# hostname  
web-0
```
> 主机名唯一。

> 简单演示有状态部署，难点。

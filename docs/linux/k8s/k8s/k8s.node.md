
<center><h1>Kubernets node</h1></center>


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

## 2. 部署node

### 2.1 原理图

<center>![node](../../../pictures/linux/k8s/k8s/node.png)</center>

### 2.2 创建和分发证书

```
1. 将kubelet-bootstrap用户绑定到系统集群角色
kubectl create clusterrolebinding kubelet-bootstrap \
--clusterrole=system:node-bootstrapper \
--user=kubelet-bootstrap 
2. 创建kubeconfig文件
3. 部署kubelet，kube-proxy组件
```

??? note "kubeconfig.sh 修改后"
    ```
    [root@k8s-master01 k8s-cert]# cat kubeconfig.sh 
    # 创建 TLS Bootstrapping Token
    #BOOTSTRAP_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
    BOOTSTRAP_TOKEN=0fb61c46f8991b718eb38d27b605b008
    
    #cat > token.csv <<EOF
    #${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
    #EOF
    
    #----------------------
    
    APISERVER=$1
    SSL_DIR=$2
    
    # 创建kubelet bootstrapping kubeconfig 
    export KUBE_APISERVER="https://$APISERVER:6443"
    
    # 设置集群参数
    kubectl config set-cluster kubernetes \
      --certificate-authority=$SSL_DIR/ca.pem \
      --embed-certs=true \
      --server=${KUBE_APISERVER} \
      --kubeconfig=bootstrap.kubeconfig
    
    # 设置客户端认证参数
    kubectl config set-credentials kubelet-bootstrap \
      --token=${BOOTSTRAP_TOKEN} \
      --kubeconfig=bootstrap.kubeconfig
    
    # 设置上下文参数
    kubectl config set-context default \
      --cluster=kubernetes \
      --user=kubelet-bootstrap \
      --kubeconfig=bootstrap.kubeconfig
    
    # 设置默认上下文
    kubectl config use-context default --kubeconfig=bootstrap.kubeconfig
    
    #----------------------
    
    # 创建kube-proxy kubeconfig文件
    
    kubectl config set-cluster kubernetes \
      --certificate-authority=$SSL_DIR/ca.pem \
      --embed-certs=true \
      --server=${KUBE_APISERVER} \
      --kubeconfig=kube-proxy.kubeconfig
    
    kubectl config set-credentials kube-proxy \
      --client-certificate=$SSL_DIR/kube-proxy.pem \
      --client-key=$SSL_DIR/kube-proxy-key.pem \
      --embed-certs=true \
      --kubeconfig=kube-proxy.kubeconfig
    
    kubectl config set-context default \
      --cluster=kubernetes \
      --user=kube-proxy \
      --kubeconfig=kube-proxy.kubeconfig
    
    kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
    ```


详细部署
```
kubectl create clusterrolebinding kubelet-bootstrap \
--clusterrole=system:node-bootstrapper \
--user=kubelet-bootstrap

生成kubeconfig证书
bash kubeconfig.sh 192.168.186.139 /root/k8s/k8s-cert/
scp -r bootstrap.kubeconfig kube-proxy.kubeconfig root@192.168.186.141:/opt/kubernetes/cfg/
scp -r bootstrap.kubeconfig kube-proxy.kubeconfig root@192.168.186.142:/opt/kubernetes/cfg/
```
> kubeconfig是链接master相关信息，kublet需要bootstrap.kubeconfig，kubeproxy需要kube-proxy.kubeconfig

> 删除 kubectl delete clusterrolebinding kubelet-bootstrap
详细步骤

```
[root@k8s-master01 k8s]# kubectl create clusterrolebinding kubelet-bootstrap \
> --clusterrole=system:node-bootstrapper \
> --user=kubelet-bootstrap
clusterrolebinding.rbac.authorization.k8s.io/kubelet-bootstrap created


[root@k8s-master01 k8s-cert]# cat bootstrap.kubeconfig
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUR2akNDQXFhZ0F3SUJBZ0lVS2p3bkhQeXVMdkhWMW0wWndYUENDUUUwSz
E0d0RRWUpLb1pJaHZjTkFRRUwKQlFBd1pURUxNQWtHQTFVRUJoTUNRMDR4RURBT0JnTlZCQWdUQjBKbGFXcHBibWN4RURBT0JnTlZCQWNUQjBKbAphV3BwYm1jeEREQUtCZ05WQkFvVEEyczRjekVQTUEwR0ExVUVDeE1HVTNsemRHVnRNUk13RVFZRFZRUURFd3ByCmRXSmxjbTVsZEdWek1CNFhEVEU1TURReE9EQTNNekV3TUZvWERUSTBNRFF4TmpBM016RXdNRm93WlRFTE1Ba0cKQTFVRUJoTUNRMDR4RURBT0JnTlZCQWdUQjBKbGFXcHBibWN4RURBT0JnTlZCQWNUQjBKbGFXcHBibWN4RERBSwpCZ05WQkFvVEEyczRjekVQTUEwR0ExVUVDeE1HVTNsemRHVnRNUk13RVFZRFZRUURFd3ByZFdKbGNtNWxkR1Z6Ck1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBeTNoSTFFek5TakJsSzJBRWdpSkMKOVdvQzluRXorVDh3NldWTEZ2Y0N4bGEyeVpHSzFtaVNzOHpHMGk3SStiTW1CV2paV0tQaVdkbzlGQlJqVFJmNQpiR01nWHRKQ3JOUlY2WWhVeEM3UkFBVTlpMXp1OWswbkJSNFBKVngxSGg4TzJ2MStucXhyZ200YzRTUzVXNW5ICkZDNmlHOGpsYzVEbDA3QUx1ZG1seXpoVTlTcFFtQW9DY1pVbUFHR3c5NUNkam9pWFFHaVF5MnVVK1dTSHhYakoKVGhtSmx3MTZ6WWY0SGwzK2FFZ3lqRDE2LzNYbC9OYm1qTDhwTzRDWjBMbncwV3RCQTc5cWVTSWhXNkxGUVB4MwpENDNzQmJFUDRrWElRSUNSTnRLSUxYU0RrSVQrNUNIcjg4MTJoU2hpQzRqY2hFY1pmWk1YQXJQUXF2cHN2QlZHCnF3SURBUUFCbzJZd1pEQU9CZ05WSFE4QkFmOEVCQU1DQVFZd0VnWURWUjBUQVFIL0JBZ3dCZ0VCL3dJQkFqQWQKQmdOVkhRNEVGZ1FVYVJ6OEl5aUtCSGVnODdQQzhQZFovcjAxRytnd0h3WURWUjBqQkJnd0ZvQVVhUno4SXlpSwpCSGVnODdQQzhQZFovcjAxRytnd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFFZjQ2N0I4YldvWi9ERmhQN3pGCmFieFFySTRIaGFhd1ZoK3RXaUNGUFkwdTh6ZWJtZGtGS2NEY000Q3QvWlNzaldhZEhVdXQ4TkZianA1K1E5UGEKTnRUWUFKR3U3NnNpODlxSHpmTDhIdmJjZWpNNlE1V29mR3h3NkFPWVNjVDIzdmlibVZyZXQ0b1J0dng1TmRidApJcFZCY0NxL0FyMDZNb0VIaVRvaCtMejZWUjFGZlA4VEJMNThqVWs2Snh2dEVKbnNicldhQ21KcENwcSs4ZDJnCmtDemhzK1p5WUtvUElMK3JyUStycXYzMVpFSDF0a09QTHhCVFlUUDhwZEZqQUk3MFdlNE9RTkpjaWdRZ2hhaVgKb1ZiUTZsS2xYdUhUSkJOc0l2U0o0azlHL3pObGFGenZTUVFGWG03NEQrYXVsbEE4SEdPUUEvU0F4Tys3Q2p4Nwowbmc9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K    server: https://192.168.186.139:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubelet-bootstrap
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: kubelet-bootstrap
  user:
    token: 0fb61c46f8991b718eb38d27b605b008

[root@k8s-master01 k8s-cert]# cat kube-proxy.kubeconfig
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUR2akNDQXFhZ0F3SUJBZ0lVS2p3bkhQeXVMdkhWMW0wWndYUENDUUUwSz
E0d0RRWUpLb1pJaHZjTkFRRUwKQlFBd1pURUxNQWtHQTFVRUJoTUNRMDR4RURBT0JnTlZCQWdUQjBKbGFXcHBibWN4RURBT0JnTlZCQWNUQjBKbAphV3BwYm1jeEREQUtCZ05WQkFvVEEyczRjekVQTUEwR0ExVUVDeE1HVTNsemRHVnRNUk13RVFZRFZRUURFd3ByCmRXSmxjbTVsZEdWek1CNFhEVEU1TURReE9EQTNNekV3TUZvWERUSTBNRFF4TmpBM016RXdNRm93WlRFTE1Ba0cKQTFVRUJoTUNRMDR4RURBT0JnTlZCQWdUQjBKbGFXcHBibWN4RURBT0JnTlZCQWNUQjBKbGFXcHBibWN4RERBSwpCZ05WQkFvVEEyczRjekVQTUEwR0ExVUVDeE1HVTNsemRHVnRNUk13RVFZRFZRUURFd3ByZFdKbGNtNWxkR1Z6Ck1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBTUlJQkNnS0NBUUVBeTNoSTFFek5TakJsSzJBRWdpSkMKOVdvQzluRXorVDh3NldWTEZ2Y0N4bGEyeVpHSzFtaVNzOHpHMGk3SStiTW1CV2paV0tQaVdkbzlGQlJqVFJmNQpiR01nWHRKQ3JOUlY2WWhVeEM3UkFBVTlpMXp1OWswbkJSNFBKVngxSGg4TzJ2MStucXhyZ200YzRTUzVXNW5ICkZDNmlHOGpsYzVEbDA3QUx1ZG1seXpoVTlTcFFtQW9DY1pVbUFHR3c5NUNkam9pWFFHaVF5MnVVK1dTSHhYakoKVGhtSmx3MTZ6WWY0SGwzK2FFZ3lqRDE2LzNYbC9OYm1qTDhwTzRDWjBMbncwV3RCQTc5cWVTSWhXNkxGUVB4MwpENDNzQmJFUDRrWElRSUNSTnRLSUxYU0RrSVQrNUNIcjg4MTJoU2hpQzRqY2hFY1pmWk1YQXJQUXF2cHN2QlZHCnF3SURBUUFCbzJZd1pEQU9CZ05WSFE4QkFmOEVCQU1DQVFZd0VnWURWUjBUQVFIL0JBZ3dCZ0VCL3dJQkFqQWQKQmdOVkhRNEVGZ1FVYVJ6OEl5aUtCSGVnODdQQzhQZFovcjAxRytnd0h3WURWUjBqQkJnd0ZvQVVhUno4SXlpSwpCSGVnODdQQzhQZFovcjAxRytnd0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFFZjQ2N0I4YldvWi9ERmhQN3pGCmFieFFySTRIaGFhd1ZoK3RXaUNGUFkwdTh6ZWJtZGtGS2NEY000Q3QvWlNzaldhZEhVdXQ4TkZianA1K1E5UGEKTnRUWUFKR3U3NnNpODlxSHpmTDhIdmJjZWpNNlE1V29mR3h3NkFPWVNjVDIzdmlibVZyZXQ0b1J0dng1TmRidApJcFZCY0NxL0FyMDZNb0VIaVRvaCtMejZWUjFGZlA4VEJMNThqVWs2Snh2dEVKbnNicldhQ21KcENwcSs4ZDJnCmtDemhzK1p5WUtvUElMK3JyUStycXYzMVpFSDF0a09QTHhCVFlUUDhwZEZqQUk3MFdlNE9RTkpjaWdRZ2hhaVgKb1ZiUTZsS2xYdUhUSkJOc0l2U0o0azlHL3pObGFGenZTUVFGWG03NEQrYXVsbEE4SEdPUUEvU0F4Tys3Q2p4Nwowbmc9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K    server: https://192.168.186.139:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kube-proxy
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: kube-proxy
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUQzakNDQXNhZ0F3SUJBZ0lVY0EyOURoRG1nQllsS2tUMWdZSDhwQmRFdTlBd
0RRWUpLb1pJaHZjTkFRRUwKQlFBd1pURUxNQWtHQTFVRUJoTUNRMDR4RURBT0JnTlZCQWdUQjBKbGFXcHBibWN4RURBT0JnTlZCQWNUQjBKbAphV3BwYm1jeEREQUtCZ05WQkFvVEEyczRjekVQTUEwR0ExVUVDeE1HVTNsemRHVnRNUk13RVFZRFZRUURFd3ByCmRXSmxjbTVsZEdWek1CNFhEVEU1TURReE9EQTNNekV3TUZvWERUSTVNRFF4TlRBM016RXdNRm93YkRFTE1Ba0cKQTFVRUJoTUNRMDR4RURBT0JnTlZCQWdUQjBKbGFVcHBibWN4RURBT0JnTlZCQWNUQjBKbGFVcHBibWN4RERBSwpCZ05WQkFvVEEyczRjekVQTUEwR0ExVUVDeE1HVTNsemRHVnRNUm93R0FZRFZRUURFeEZ6ZVhOMFpXMDZhM1ZpClpTMXdjbTk0ZVRDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTjQ3OVE5OENWZy8KRmdiTjdaS3RxQm9ZdmY3YWRRcmtRTU5odnBzeFozc0hiVmFieVNWN0hwcU5BbHFyMytyVjc4R3Z5VWFaUHpIRgorQ0gwQXJyVE91YjFJcWhLOUlOU2svWnRValhxNkcvYXpoeStKRFE1ckFsT0VyZVZzUmQ2alVncHBDMVhxUlQzCmdBanBEeCtDaE9GcndHMkJBa2o1ZTk0VDVtOFNDWkthQWFDZWVieFZJSUVhTkxFdEtVUk9kaDU2cVpqbVJOUTAKWStGVEhKNHE2Rjd3dkpQODBTTVNGZ3BwbDB2RWV1V2dpK0Nmc0xpdjIrQW5zS25xRHpwTm9oR1g2QkxEQnRTQQpHM29hRzAvTWp0bVk0VFZDMU9xYlFnL3FJWERVTTZhREpTYUlJREZKL2U0TEJwa2F4RUJNbjNyZ3VGQ1lQaWxECnBUZUNsbWcydjdFQ0F3RUFBYU4vTUgwd0RnWURWUjBQQVFIL0JBUURBZ1dnTUIwR0ExVWRKUVFXTUJRR0NDc0cKQVFVRkJ3TUJCZ2dyQmdFRkJRY0RBakFNQmdOVkhSTUJBZjhFQWpBQU1CMEdBMVVkRGdRV0JCUm1UdzJKZi9SdgpNV05TNU45OThQK2xFMTBrNFRBZkJnTlZIU01FR0RBV2dCUnBIUHdqS0lvRWQ2RHpzOEx3OTFuK3ZUVWI2REFOCkJna3Foa2lHOXcwQkFRc0ZBQU9DQVFFQUM3NUEwQmdEZ1MrZ0F6VGVkNVYyNlV0RmlMQW1KTkQ4d1hQV1Mra0sKNDBMMGlyT1ZhVUtrZTVRMGUzYjJqTGx5NWpzYUNEVG03dVE3OXBuVUNSRVBQNUpkSzR3TUhPNy9YQ2ZRSmU5RAplZWI0cTh2UCtYdVFCT01jVlNFcHJSMXc5MzBIbTdsK2M5WFVRdHE0M2p3YWl3RXVWQ3UzTjlFYVMvSGFXM0pvClE0RDRqdEFGQUNsbDl6Y3JTYjd3RWhwMFpmaDJJYVlpUy9nUlVFTzAwWFJ6T1doUktac1pZaDZuOStBMXlnUUMKL1poSUlnR1Exdlp4d2U4RHkyY3M5ZUVHVHI3Yis0T3Z6RjNDMDB6Wmlyc2owbkFkVlFyR0N6cjErS0JHNzVBWgptRDFnVVdGNzVhZjN2VWo0WGIzT1NCZTNmU0c1WmpJUmduMXpGQlRKTlN4b213PT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBM2p2MUQzd0pXRDhXQnMzdGtxMm9HaGk5L3RwMUN1UkF3M
kcrbXpGbmV3ZHRWcHZKCkpYc2VtbzBDV3F2ZjZ0WHZ3YS9KUnBrL01jWDRJZlFDdXRNNjV2VWlxRXIwZzFLVDltMVNOZXJvYjlyT0hMNGsKTkRtc0NVNFN0NVd4RjNxTlNDbWtMVmVwRlBlQUNPa1BINEtFNFd2QWJZRUNTUGw3M2hQbWJ4SUprcG9Cb0o1NQp2RlVnZ1JvMHNTMHBSRTUySG5xcG1PWkUxRFJqNFZNY25pcm9YdkM4ay96Ukl4SVdDbW1YUzhSNjVhQ0w0Sit3CnVLL2I0Q2V3cWVvUE9rMmlFWmZvRXNNRzFJQWJlaG9iVDh5TzJaamhOVUxVNnB0Q0Qrb2hjTlF6cG9NbEpvZ2cKTVVuOTdnc0dtUnJFUUV5ZmV1QzRVSmcrS1VPbE40S1dhRGEvc1FJREFRQUJBb0lCQUNabitqd0kxWnlZbW5mbQprczRza01haHpBUUZRUUQyM1hKbXJBZ3FDNVlwZkczaFVtdlYwVDRvYkdXN0dtRjlRNGdYbHhOS1hLOS9aUmlKCkVRZTBoWk53ZmVMVHdWb0lwV1dMRXhBYVhyMGw5VVRtWDE5Zk1Db1RnZ3lVSkJ6SW95MzdkRkladWpEVGJSOGQKRiszOEluYktwbURHVU56SHNPNTZSZktnRFdOMlE2UDQ4RnJ4eWF6WHhJYjBWT1diNGxFK0I0T0FBZXVONzh6UwoyeWJROXoza3VsMzVlODVEcmpKbml1Z0xkTUxBVDlCdkNXRnZ4eXdIY29FbDFWZElnZFJmWE03RDJqd2NhRTYzCnZDOWFWazQ0SXBUVlBzc2pJUTFtVDEycStsYXl3SmY0TGcwczI2aVRjU3FhUDgwQzU2UXJtcjYreGtaaEx5VTAKbUovdEJCa0NnWUVBNTk2ZWFZd1hIdVdNRUlqMitmWnBoMUlmWWFydVhvYWpMNDVyQkU1YkpBK2lxcmd2cnVsYwpXTWpuVys2TVBmSFNaS3VYUUNzelNYaUVpejFOVk51Q3RKLzBoZkZia2pHazl0cHdwSUJwUnlLTWZCek5sWWtPCm0zK1JmNXNrQjRXWHpkdWozWmQ3TGlQQmFNQWwyOUdSbEtWNy9BY0hXanlZQmlBRkZpd1g5UHNDZ1lFQTlWeWkKeStLZTZkQ3ZQdjR5TmNVaEduRUlmZ0daTk96M1A1QVpyNnI5SnUzakp2KytSQmNZRFNIcWNsZjN0aGxZMU43bApseG83SlR6RXJVRUd1WERnMzFIZ2VZdE9ZNWdzUnlLcXpNUk05TXVQMWNXQ2FUQU5COVdwTjNkV0NES0dYZzZkCmJCMCsyNW9ITnhnSUtBMi9sK1YxWlUyOFd1elJlQ2tyNkk3UFJrTUNnWUJoV1JMVEozRFJsUGhBUFBETU0wdE0KK0FxYTI4UG1SY3FmZmNDcWR5ZEd0WlhLN1RkL3pSUHJaclhUNEF4Yk9Ycm1yeS82VGVqamNNamRHS2l0OXRjaQpkSUdaOXFKR2Q3ZFZ1SkpRVG1WazZ6bG1Ka1dlQVlQemZ4U2NLWXR2NlFPNTl2d09YYm5tdmpaR2YxMmxzNC9XCmc3L1JLVFpLQ1dTZU5iVk5BTWd5SHdLQmdRRGlra1pxaTd3L0lVdVNtZHozdGk5WllXTjhLREczbzlLMVNYWE8KdDlESThBZEFiZ3plaDR6WUk2ZUJLeVk5YTY2Ujg3cURDOS91Qk8yQkozajBLUDRlZWxjVkpjU2ZSMWdyNENGawpzU2gzTExxSHBybEVOUER6ZVNPbmFuVnhZR2FmMkZNYUVPK0lqZlYzdEtOamlUNlJIM3lHclgvdlhwd1huNzFDCkpRM1dUUUtCZ0NETE5EZDBrbkJjeXNScHRURjh0NzRBbGFBUE02eWxpVFNuRURLQVUyNzVhSHpTbHRSazFQR3cKRjdSUGN3MEE1V0Y3ckQyVXVMZTNsQ1NuUnBnamRHZ1JXc3ZTTlVybm9yZ0tIZEw3OHFYUHVHYW9hUUN3azFjZgpSaUF5ZEgvYVhmZjhLU0drd1Z0ZE9XdGJwS2pYOXdabmM0MWI1RS9HNE1Fd3A5OFlpWWJSCi0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==

拷贝到node节点
[root@k8s-master01 k8s-cert]# scp -r bootstrap.kubeconfig kube-proxy.kubeconfig root@192.168.186.141:/opt/kubernetes/cfg/
root@192.168.186.141's password: 
bootstrap.kubeconfig                                                                            100% 2169     1.4MB/s   00:00    
kube-proxy.kubeconfig                                                                           100% 6271     2.3MB/s   00:00
[root@k8s-master01 k8s-cert]# scp -r bootstrap.kubeconfig kube-proxy.kubeconfig root@192.168.186.142:/opt/kubernetes/cfg/
root@192.168.186.142's password: 
bootstrap.kubeconfig                                                                            100% 2169     1.4MB/s   00:00    
kube-proxy.kubeconfig                                                                           100% 6271     3.8MB/s   00:00  
```

### 2.3 部署node节点

??? note "kubelet.sh"
    ```
    [root@k8s-node01 ~]# cat kubelet.sh 
    #!/bin/bash
    
    NODE_ADDRESS=$1
    DNS_SERVER_IP=${2:-"10.0.0.2"}
    
    cat <<EOF >/opt/kubernetes/cfg/kubelet
    
    KUBELET_OPTS="--logtostderr=false \\
    --log-dir=/opt/kubernetes/logs \\
    --v=4 \\
    --hostname-override=${NODE_ADDRESS} \\
    --kubeconfig=/opt/kubernetes/cfg/kubelet.kubeconfig \\
    --bootstrap-kubeconfig=/opt/kubernetes/cfg/bootstrap.kubeconfig \\
    --config=/opt/kubernetes/cfg/kubelet.config \\
    --cert-dir=/opt/kubernetes/ssl \\
    --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0"
    
    EOF
    
    cat <<EOF >/opt/kubernetes/cfg/kubelet.config
    
    kind: KubeletConfiguration
    apiVersion: kubelet.config.k8s.io/v1beta1
    address: ${NODE_ADDRESS}
    port: 10250
    readOnlyPort: 10255
    cgroupDriver: cgroupfs
    clusterDNS:
    - ${DNS_SERVER_IP} 
    clusterDomain: cluster.local.
    failSwapOn: false
    authentication:
      anonymous:
        enabled: true
    EOF
    
    cat <<EOF >/usr/lib/systemd/system/kubelet.service
    [Unit]
    Description=Kubernetes Kubelet
    After=docker.service
    Requires=docker.service
    
    [Service]
    EnvironmentFile=/opt/kubernetes/cfg/kubelet
    ExecStart=/opt/kubernetes/bin/kubelet \$KUBELET_OPTS
    Restart=on-failure
    KillMode=process
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    systemctl daemon-reload
    systemctl enable kubelet
    systemctl restart kubelet
    ```

??? note "proxy.sh"
    ```
    [root@k8s-node01 ~]# cat proxy.sh 
    #!/bin/bash
    
    NODE_ADDRESS=$1
    
    cat <<EOF >/opt/kubernetes/cfg/kube-proxy
    
    KUBE_PROXY_OPTS="--logtostderr=true \\
    --v=4 \\
    --hostname-override=${NODE_ADDRESS} \\
    --cluster-cidr=10.0.0.0/24 \\
    --proxy-mode=ipvs \\
    --kubeconfig=/opt/kubernetes/cfg/kube-proxy.kubeconfig"
    
    EOF
    
    cat <<EOF >/usr/lib/systemd/system/kube-proxy.service
    [Unit]
    Description=Kubernetes Proxy
    After=network.target
    
    [Service]
    EnvironmentFile=-/opt/kubernetes/cfg/kube-proxy
    ExecStart=/opt/kubernetes/bin/kube-proxy \$KUBE_PROXY_OPTS
    Restart=on-failure
    
    [Install]
    WantedBy=multi-user.target
    EOF
    
    systemctl daemon-reload
    systemctl enable kube-proxy
    systemctl restart kube-proxy
    ```

- 在master上操作

拷贝命令到node上
```
scp kubelet kube-proxy root@192.168.186.141:/opt/kubernetes/bin/
scp kubelet kube-proxy root@192.168.186.142:/opt/kubernetes/bin/
```
详细操作

```
[root@k8s-master01 bin]# scp kubelet kube-proxy root@192.168.186.141:/opt/kubernetes/bin/
root@192.168.186.141's password: 
kubelet                                                                                         100%  108MB  61.1MB/s   00:01    
kube-proxy                                                                                      100%   33MB  45.2MB/s   00:00    
[root@k8s-master01 bin]# scp kubelet kube-proxy root@192.168.186.142:/opt/kubernetes/bin/
root@192.168.186.142's password: 
kubelet                                                                                         100%  108MB  65.4MB/s   00:01    
kube-proxy                                                                                      100%   33MB  48.8MB/s   00:00    
```


- 在node上操作
```
unzip node.zip 
mkdir -p /opt/kubernetes/logs 
sh kubelet.sh 192.168.186.141
systemctl status kubelet
ps axf|grep kubelet
```
详细步骤

```
[root@k8s-node01 ~]# ls
anaconda-ks.cfg  flannel.sh  flannel-v0.10.0-linux-amd64.tar.gz  node.zip  README.md
[root@k8s-node01 ~]# unzip node.zip 
Archive:  node.zip
  inflating: proxy.sh                
  inflating: kubelet.sh              
[root@k8s-node01 ~]# ls
anaconda-ks.cfg  flannel.sh  flannel-v0.10.0-linux-amd64.tar.gz  kubelet.sh  node.zip  proxy.sh  README.md
[root@k8s-node01 ~]# sh kubelet.sh 192.168.186.141
Created symlink from /etc/systemd/system/multi-user.target.wants/kubelet.service to /usr/lib/systemd/system/kubelet.service.

检查进程
[root@k8s-node01 ~]# systemctl status kubelet
● kubelet.service - Kubernetes Kubelet
   Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-04-18 17:21:09 CST; 48s ago
 Main PID: 23949 (kubelet)
    Tasks: 11
   Memory: 17.7M
   CGroup: /system.slice/kubelet.service
           └─23949 /opt/kubernetes/bin/kubelet --logtostderr=false --log-dir=/opt/kubernetes/logs --v=4 --hostname-override=192...

Apr 18 17:21:09 k8s-node01 systemd[1]: Started Kubernetes Kubelet.

[root@k8s-node01 ~]# ps axf|grep kubelet
 25488 pts/0    S+     0:00  |       \_ grep --color=auto kubelet
 23949 ?        Ssl    0:00 /opt/kubernetes/bin/kubelet --logtostderr=false --log-dir=/opt/kubernetes/logs --v=4 --hostname-overri
de=192.168.186.141 --kubeconfig=/opt/kubernetes/cfg/kubelet.kubeconfig --bootstrap-kubeconfig=/opt/kubernetes/cfg/bootstrap.kubeconfig --config=/opt/kubernetes/cfg/kubelet.config --cert-dir=/opt/kubernetes/ssl --pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0
```

授权加入.在master上操作

```
[root@k8s-master01 bin]# kubectl get csr
NAME                                                   AGE   REQUESTOR           CONDITION
node-csr-ve2dlsj5vwoAxLhYmkait9Cc013EV6TuMc3mFmPlrMY   22m   kubelet-bootstrap   Pending
[root@k8s-master01 bin]# kubectl certificate approve node-csr-ve2dlsj5vwoAxLhYmkait9Cc013EV6TuMc3mFmPlrMY
certificatesigningrequest.certificates.k8s.io/node-csr-ve2dlsj5vwoAxLhYmkait9Cc013EV6TuMc3mFmPlrMY approved
[root@k8s-master01 bin]# kubectl get node
NAME              STATUS   ROLES    AGE   VERSION
192.168.186.141   Ready    <none>   14s   v1.13.4

```


安装 kube-proxy

```
sh proxy.sh 192.168.186.141
ps axf|grep proxy
```
详细步骤
```
[root@k8s-node01 ~]# sh proxy.sh 192.168.186.141
Created symlink from /etc/systemd/system/multi-user.target.wants/kube-proxy.service to /usr/lib/systemd/system/kube-proxy.service.
[root@k8s-node01 ~]# ps axf|grep proxy
 26210 pts/0    S+     0:00  |       \_ grep --color=auto proxy
 26019 ?        Ssl    0:00 /opt/kubernetes/bin/kube-proxy --logtostderr=true --v=4 --hostname-override=192.168.186.141 --cluster-
cidr=10.0.0.0/24 --proxy-mode=ipvs --kubeconfig=/opt/kubernetes/cfg/kube-proxy.kubeconfig
```

到目前为止node1已经OK，下面增加node

- node1上操作

```
scp -r /opt/kubernetes/ root @192.168.186.142:/opt/
scp /usr/lib/systemd/system/{kubelet,kube-proxy}.service root@192.168.186.142:/usr/lib/systemd/system/
```

- node2上操作

```
cd /opt/kubernetes/ssl
rm -rf *
cd /opt/kubernetes/cfg
sed -i 's@192.168.186.141@192.168.186.142@g' kubelet
sed -i 's@192.168.186.141@192.168.186.142@g' kubelet.config
sed -i 's@192.168.186.141@192.168.186.142@g' kube-proxy
systemctl start kube-proxy
systemctl status kube-proxy

systemctl start kubelet.service
systemctl status kubelet.service
```

详细步骤

```
在node1上操作
[root@k8s-node01 ~]# scp -r /opt/kubernetes/ root @192.168.186.142:/opt/
root@192.168.186.142's password: 
scp: /opt//kubernetes/bin/flanneld: Text file busy
mk-docker-opts.sh                                                                               100% 2139     1.1MB/s   00:00    
kubelet                                                                                         100%  108MB  68.5MB/s   00:01    
kube-proxy                                                                                      100%   33MB  42.8MB/s   00:00    
flanneld                                                                                        100%  241   114.4KB/s   00:00    
bootstrap.kubeconfig                                                                            100% 2169     1.4MB/s   00:00    
kube-proxy.kubeconfig                                                                           100% 6271     3.0MB/s   00:00    
kubelet                                                                                         100%  413   206.2KB/s   00:00    
kubelet.config                                                                                  100%  269    74.5KB/s   00:00    
kubelet.kubeconfig                                                                              100% 2298     1.2MB/s   00:00    
kube-proxy                                                                                      100%  191    98.9KB/s   00:00    
kubelet.crt                                                                                     100% 2197   412.9KB/s   00:00    
kubelet.key                                                                                     100% 1679   865.2KB/s   00:00    
kubelet-client-2019-04-18-17-44-09.pem                                                          100% 1277   167.2KB/s   00:00    
kubelet-client-current.pem                                                                      100% 1277   290.6KB/s   00:00    
kubelet.k8s-node01.root.log.INFO.20190418-172109.23949                                          100%  234KB  23.8MB/s   00:00    
kubelet.INFO                                                                                    100%  234KB  22.9MB/s   00:00    
kubelet.k8s-node01.root.log.WARNING.20190418-174409.23949                                       100% 1164   270.6KB/s   00:00    
kubelet.WARNING                                                                                 100% 1164   738.6KB/s   00:00    
kubelet.k8s-node01.root.log.ERROR.20190418-174409.23949                                         100%  465   213.4KB/s   00:00    
kubelet.ERROR                                                                                   100%  465   351.2KB/s   00:00  

[root@k8s-node01 ~]# scp /usr/lib/systemd/system/{kubelet,kube-proxy}.service root@192.168.186.142:/usr/lib/systemd/system/
root@192.168.186.142's password: 
kubelet.service                                                                                 100%  264   185.1KB/s   00:00    
kube-proxy.service                                                                              100%  231    75.3KB/s   00:00    
[root@k8s-node01 ~]# 


在node2操作
[root@k8s-node02 cfg]# cd ../ssl
[root@k8s-node02 ssl]# pwd
/opt/kubernetes/ssl
[root@k8s-node02 ssl]# ls
kubelet-client-2019-04-18-17-44-09.pem  kubelet-client-current.pem  kubelet.crt  kubelet.key
[root@k8s-node02 ssl]# rm -f *
[root@k8s-node02 ssl]# ls
[root@k8s-node02 ssl]# cd ..
[root@k8s-node02 kubernetes]# ls
bin  cfg  logs  ssl
[root@k8s-node02 kubernetes]# cd cfg/
[root@k8s-node02 cfg]# ls
bootstrap.kubeconfig  flanneld  kubelet  kubelet.config  kubelet.kubeconfig  kube-proxy  kube-proxy.kubeconfig
                                                                                                                       
[root@k8s-node02 cfg]# sed -i 's@192.168.186.141@192.168.186.142@g' kubelet
[root@k8s-node02 cfg]# cat kubelet

KUBELET_OPTS="--logtostderr=false \
--log-dir=/opt/kubernetes/logs \
--v=4 \
--hostname-override=192.168.186.142 \
--kubeconfig=/opt/kubernetes/cfg/kubelet.kubeconfig \
--bootstrap-kubeconfig=/opt/kubernetes/cfg/bootstrap.kubeconfig \
--config=/opt/kubernetes/cfg/kubelet.config \
--cert-dir=/opt/kubernetes/ssl \
--pod-infra-container-image=registry.cn-hangzhou.aliyuncs.com/google-containers/pause-amd64:3.0"
[root@k8s-node02 cfg]# sed -i 's@192.168.186.141@192.168.186.142@g' kubelet.config 
[root@k8s-node02 cfg]# cat kubelet.config 

kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
address: 192.168.186.142
port: 10250
readOnlyPort: 10255
cgroupDriver: cgroupfs
clusterDNS:
- 10.0.0.2 
clusterDomain: cluster.local.
failSwapOn: false
authentication:
  anonymous:
    enabled: true

[root@k8s-node02 cfg]# sed -i 's@192.168.186.141@192.168.186.142@g' kube-proxy
[root@k8s-node02 cfg]# cat kube-proxy

KUBE_PROXY_OPTS="--logtostderr=true \
--v=4 \
--hostname-override=192.168.186.142 \
--cluster-cidr=10.0.0.0/24 \
--proxy-mode=ipvs \
--kubeconfig=/opt/kubernetes/cfg/kube-proxy.kubeconfig"

[root@k8s-node02 cfg]# systemctl start kube-proxy
[root@k8s-node02 cfg]# systemctl status kube-proxy
● kube-proxy.service - Kubernetes Proxy
   Loaded: loaded (/usr/lib/systemd/system/kube-proxy.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-04-18 18:02:27 CST; 6s ago
 Main PID: 57457 (kube-proxy)
    Tasks: 0
   Memory: 11.0M
   CGroup: /system.slice/kube-proxy.service
           ‣ 57457 /opt/kubernetes/bin/kube-proxy --logtostderr=true --v=4 --hostname-override=192.168.186.142 --cluster-cidr=1...

Apr 18 18:02:28 k8s-node02 kube-proxy[57457]: -A KUBE-FORWARD -s 10.0.0.0/24 -m comment --comment "kubernetes forwarding ...ACCEPT
Apr 18 18:02:28 k8s-node02 kube-proxy[57457]: -A KUBE-FORWARD -m comment --comment "kubernetes forwarding conntrack pod d...ACCEPT
Apr 18 18:02:28 k8s-node02 kube-proxy[57457]: COMMIT
Apr 18 18:02:28 k8s-node02 kube-proxy[57457]: I0418 18:02:28.234622   57457 proxier.go:719] syncProxyRules took 176.666464ms
Apr 18 18:02:29 k8s-node02 kube-proxy[57457]: I0418 18:02:29.442751   57457 config.go:141] Calling handler.OnEndpointsUpdate
Apr 18 18:02:29 k8s-node02 kube-proxy[57457]: I0418 18:02:29.458787   57457 config.go:141] Calling handler.OnEndpointsUpdate
Apr 18 18:02:31 k8s-node02 kube-proxy[57457]: I0418 18:02:31.450647   57457 config.go:141] Calling handler.OnEndpointsUpdate
Apr 18 18:02:31 k8s-node02 kube-proxy[57457]: I0418 18:02:31.470753   57457 config.go:141] Calling handler.OnEndpointsUpdate
Apr 18 18:02:33 k8s-node02 kube-proxy[57457]: I0418 18:02:33.459719   57457 config.go:141] Calling handler.OnEndpointsUpdate
Apr 18 18:02:33 k8s-node02 kube-proxy[57457]: I0418 18:02:33.477608   57457 config.go:141] Calling handler.OnEndpointsUpdate
Hint: Some lines were ellipsized, use -l to show in full.
[root@k8s-node02 cfg]# ps axf|grep proxy
 57707 pts/1    S+     0:00          \_ grep --color=auto proxy
 57457 ?        Ssl    0:00 /opt/kubernetes/bin/kube-proxy --logtostderr=true --v=4 --hostname-override=192.168.186.142 --cluster-
cidr=10.0.0.0/24 --proxy-mode=ipvs --kubeconfig=/opt/kubernetes/cfg/kube-proxy.kubeconfig

[root@k8s-node02 logs]# systemctl start kubelet.service 
[root@k8s-node02 logs]# systemctl status kubelet.service 
● kubelet.service - Kubernetes Kubelet
   Loaded: loaded (/usr/lib/systemd/system/kubelet.service; disabled; vendor preset: disabled)
   Active: active (running) since Thu 2019-04-18 18:05:06 CST; 1s ago
 Main PID: 58060 (kubelet)
    Tasks: 9
   Memory: 17.3M
   CGroup: /system.slice/kubelet.service
           └─58060 /opt/kubernetes/bin/kubelet --logtostderr=false --log-dir=/opt/kubernetes/logs --v=4 --hostname-override=192.168.186.142 --kubeconfig=/opt/kubernetes/cfg/kubelet.kubec...

Apr 18 18:05:06 k8s-node02 systemd[1]: Started Kubernetes Kubelet.
Apr 18 18:05:06 k8s-node02 kubelet[58060]: E0418 18:05:06.935679   58060 bootstrap.go:184] Unable to read existing bootstrap client config: invalid configuration: [unable to read client-...
Hint: Some lines were ellipsized, use -l to show in full.
```
到此node2上的Kubelet和proxy都启动了，接下来要去master授权加入给node颁发证书。

```
[root@k8s-master01 bin]# kubectl get csr
NAME                                                   AGE    REQUESTOR           CONDITION
node-csr-AAISS6f1ueC4zdGHiKj9KOiZsXwcCicG8oNXJuLRKmw   116s   kubelet-bootstrap   Pending
node-csr-ve2dlsj5vwoAxLhYmkait9Cc013EV6TuMc3mFmPlrMY   45m    kubelet-bootstrap   Approved,Issued

[root@k8s-master01 bin]# kubectl certificate approve node-csr-AAISS6f1ueC4zdGHiKj9KOiZsXwcCicG8oNXJuLRKmw
certificatesigningrequest.certificates.k8s.io/node-csr-AAISS6f1ueC4zdGHiKj9KOiZsXwcCicG8oNXJuLRKmw approved

[root@k8s-master01 bin]# kubectl get csr
NAME                                                   AGE    REQUESTOR           CONDITION
node-csr-AAISS6f1ueC4zdGHiKj9KOiZsXwcCicG8oNXJuLRKmw   3m4s   kubelet-bootstrap   Approved,Issued
node-csr-ve2dlsj5vwoAxLhYmkait9Cc013EV6TuMc3mFmPlrMY   47m    kubelet-bootstrap   Approved,Issued
[root@k8s-master01 bin]# kubectl get node
NAME              STATUS   ROLES    AGE   VERSION
192.168.186.141   Ready    <none>   24m   v1.13.4
192.168.186.142   Ready    <none>   33s   v1.13.4
```
到目前为止一个master和两个node部署OK。


## 3. 部署测试示例

```
kubectl create deployment nginx --image=nginx
# kubectl create deployment nginx --image=nginx --replicas=3
kubectl get pod
kubectl expose deployment nginx --port=88 --target-port=80 --type=NodePort
kubectl get svc nginx
kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
```
详细操作

```
root@k8s-master01 bin]# kubectl create deployment nginx --image=nginx
deployment.apps/nginx created
[root@k8s-master01 bin]# kubectl get pods
NAME                   READY   STATUS              RESTARTS   AGE
nginx-5c7588df-nlj5l   0/1     ContainerCreating   0          9s
过一会在查看
[root@k8s-master01 bin]# kubectl get pods
NAME                   READY   STATUS    RESTARTS   AGE
nginx-5c7588df-nlj5l   1/1     Running   0          26s
已经运行了。

接下来扩容为3个
[root@k8s-master01 bin]# kubectl scale deployment nginx --replicas=3
deployment.extensions/nginx scaled
[root@k8s-master01 bin]# kubectl get pods
NAME                   READY   STATUS              RESTARTS   AGE
nginx-5c7588df-c58ql   0/1     ContainerCreating   0          3s
nginx-5c7588df-gh6l9   1/1     Running             0          3s
nginx-5c7588df-nlj5l   1/1     Running             0          84s

过一会在查看
[root@k8s-master01 bin]# kubectl get pods
NAME                   READY   STATUS    RESTARTS   AGE
nginx-5c7588df-c58ql   1/1     Running   0          28s
nginx-5c7588df-gh6l9   1/1     Running   0          28s
nginx-5c7588df-nlj5l   1/1     Running   0          109s

可以查看pod在哪个节点上
[root@k8s-master01 bin]# kubectl get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP            NODE              NOMINATED NODE   READINESS GATES
nginx-5c7588df-c58ql   1/1     Running   0          55s     172.17.8.2    192.168.186.142   <none>           <none>
nginx-5c7588df-gh6l9   1/1     Running   0          55s     172.17.66.3   192.168.186.141   <none>           <none>
nginx-5c7588df-nlj5l   1/1     Running   0          2m16s   172.17.66.2   192.168.186.141   <none>     

为新部署的nginx容器暴露端口
[root@k8s-master01 bin]# kubectl expose deployment nginx --port=88 --target-port=80 --type=NodePort
service/nginx exposed
[root@k8s-master01 bin]# kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.0.0.1     <none>        443/TCP        144m
nginx        NodePort    10.0.0.88    <none>        88:30232/TCP   74s
容器内是ip是10.0.0.88[在随便哪个node上都可以访问]，端口是88，30232端口是宿主机的对应IP，是随机的，也可以指定

在node上测试
[root@k8s-node01 ~]# curl 10.0.0.88:88
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

[root@k8s-master01 bin]# curl 192.168.186.141:30232 -I
HTTP/1.1 200 OK
Server: nginx/1.15.12
Date: Thu, 18 Apr 2019 10:18:53 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 16 Apr 2019 13:08:19 GMT
Connection: keep-alive
ETag: "5cb5d3c3-264"
Accept-Ranges: bytes

查看pod日志
[root@k8s-master01 bin]# kubectl get pods -o wide
NAME                   READY   STATUS    RESTARTS   AGE     IP            NODE              NOMINATED NODE   READINESS GATES
nginx-5c7588df-c58ql   1/1     Running   0          6m40s   172.17.8.2    192.168.186.142   <none>           <none>
nginx-5c7588df-gh6l9   1/1     Running   0          6m40s   172.17.66.3   192.168.186.141   <none>           <none>
nginx-5c7588df-nlj5l   1/1     Running   0          8m1s    172.17.66.2   192.168.186.141   <none>           <none>
[root@k8s-master01 bin]# kubectl logs nginx-5c7588df-c58ql
Error from server (Forbidden): Forbidden (user=system:anonymous, verb=get, resource=nodes, subresource=proxy) ( pods/log nginx-5c7588df-c58ql)
出现这个错误，需要先授权。
[root@k8s-master01 bin]# kubectl create clusterrolebinding cluster-system-anonymous --clusterrole=cluster-admin --user=system:anonymous
clusterrolebinding.rbac.authorization.k8s.io/cluster-system-anonymous created
[root@k8s-master01 bin]# kubectl logs nginx-5c7588df-c58ql
172.17.66.0 - - [18/Apr/2019:10:17:42 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
172.17.66.0 - - [18/Apr/2019:10:18:50 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"
```


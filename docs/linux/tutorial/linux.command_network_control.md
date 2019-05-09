<center><h1>Linux命令 网络管理</h1></center>
> 作者: caimengzhi

## 10. 网络管理

### 10.1 ifconfig

&emsp;Linux ifconfig命令用于显示或设置网络设备。ifconfig可设置网络设备的状态，或是显示目前的设置。


````
ifconfig [网络设备][down up -allmulti -arp -promisc][add<地址>][del<地址>][<hw<网络设备类型><硬件地址>][io_addr<I/O地址>][irq<IRQ地址>][media<网络媒介类型>][mem_start<内存地址>][metric<数目>][mtu<字节>][netmask<子网掩码>][tunnel<地址>][-broadcast<地址>][-pointopoint<地址>][IP地址]
````

- add<地址> 设置网络设备IPv6的IP地址。
- del<地址> 删除网络设备IPv6的IP地址。
- down 关闭指定的网络设备。
- hw<网络设备类型><硬件地址> 设置网络设备的类型与硬件地址。
- io_addr<I/O地址> 设置网络设备的I/O地址。
- irq<IRQ地址> 设置网络设备的IRQ。
- media<网络媒介类型> 设置网络设备的媒介类型。
- mem_start<内存地址> 设置网络设备在主内存所占用的起始地址。
- metric<数目> 指定在计算数据包的转送次数时，所要加上的数目。
- mtu<字节> 设置网络设备的MTU。
- netmask<子网掩码> 设置网络设备的子网掩码。
- tunnel<地址> 建立IPv4与IPv6之间的隧道通信地址。
- up 启动指定的网络设备。
- broadcast<地址> 将要送往指定地址的数据包当成广播数据包来处理。
- pointopoint<地址> 与指定地址的网络设备建立直接连线，此模式具有保密功能。
- promisc 关闭或启动指定网络设备的promiscuous模式。
- [IP地址] 指定网络设备的IP地址。
- [网络设备] 指定网络设备的名称。

!!! note "案例"
    ```
    显示所有网卡信息
    [root@master01 ~]# ifconfig
    docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
            inet 172.17.7.1  netmask 255.255.255.0  broadcast 172.17.7.255
            inet6 fe80::42:eeff:fe6d:570b  prefixlen 64  scopeid 0x20<link>
            ether 02:42:ee:6d:57:0b  txqueuelen 0  (Ethernet)
            RX packets 45  bytes 4919 (4.8 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 62  bytes 4736 (4.6 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 192.168.5.100  netmask 255.255.255.0  broadcast 192.168.5.255
            inet6 fe80::56d2:664e:e6f6:82db  prefixlen 64  scopeid 0x20<link>
            ether 0c:54:a5:01:7c:5b  txqueuelen 1000  (Ethernet)
            RX packets 15724030  bytes 3085207447 (2.8 GiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 16417165  bytes 3228395397 (3.0 GiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    flannel.1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
            inet 172.17.7.0  netmask 255.255.255.255  broadcast 0.0.0.0
            inet6 fe80::ec2e:1dff:fea3:e33e  prefixlen 64  scopeid 0x20<link>
            ether ee:2e:1d:a3:e3:3e  txqueuelen 0  (Ethernet)
            RX packets 60  bytes 7875 (7.6 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 68  bytes 5195 (5.0 KiB)
            TX errors 0  dropped 8 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 14094691  bytes 3311043347 (3.0 GiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 14094691  bytes 3311043347 (3.0 GiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    veth5db34eb: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
            inet6 fe80::e88d:90ff:fe4d:4cd6  prefixlen 64  scopeid 0x20<link>
            ether ea:8d:90:4d:4c:d6  txqueuelen 0  (Ethernet)
            RX packets 26  bytes 4079 (3.9 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 44  bytes 3364 (3.2 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0



    显示指定网卡信息
    root@leco:~# ifconfig enp3s0
    enp3s0    Link encap:以太网  硬件地址 74:27:ea:b0:aa:2c  
              inet 地址:192.168.5.110  广播:192.168.5.255  掩码:255.255.255.0
              inet6 地址: fe80::7627:eaff:feb0:aa2c/64 Scope:Link
              UP BROADCAST RUNNING MULTICAST  MTU:1500  跃点数:1
              接收数据包:318562 错误:0 丢弃:0 过载:0 帧数:0
              发送数据包:219695 错误:0 丢弃:0 过载:0 载波:0
              碰撞:0 发送队列长度:1000 
              接收字节:23933588 (23.9 MB)  发送字节:243692185 (243.6 MB)

    网卡开启和关闭
    ifconfig eth0 down
    ifconfig eth0 up

    用ifconfig修改MAC地址
    ifconfig eth0 down # 关闭网卡
    ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE # 修改MAC地址
    ifconfig eth0 up # 启动网卡
    ifconfig eth1 hw ether 00:1D:1C:1D:1E # 关闭网卡并修改MAC地址 
    ifconfig eth1 up # 启动网卡

    配置IP地址
    ifconfig eth0 192.168.1.56 # 给eth0网卡配置IP地址
    ifconfig eth0 192.168.1.56 netmask 255.255.255.0 # 给eth0网卡配置IP地址,并加上子掩码
    # 给eth0网卡配置IP地址,加上子掩码,加上个广播地址
    ifconfig eth0 192.168.1.56 netmask 255.255.255.0 broadcast 192.168.1.255 

    开启和关闭arp
    ifconfig eth0 arp   # 开启
    ifconfig eth0 arp   # 关闭

    设置最大的传输单元
    ifconfig eth0 mtu 1500 # 设置能通过的最大数据包大小为 1500 bytes
    ```



### 10.2 ifup

### 10.3 ifdown

### 10.4 route 

### 10.5 arp

### 10.6 ip

### 10.7 netstat 

### 10.8 ss

### 10.9 ping

### 10.10 traceroute

### 10.11 arpinp

### 10.12 telnet

### 10.13 nc

### 10.14 ssh

### 10.15 wget

### 10.16 mailq

### 10.17 mail

### 10.18 nslookup

### 10.19 dig

### 10.20 nmap

### 10.21 tcpdump


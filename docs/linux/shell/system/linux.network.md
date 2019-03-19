<center><h1></h1></center>
## 1. 服务的信息
采集服务的,MAC,DNS和外网IP
```
#/usr/bin/env bash
# Name: get_network_info.sh
# Author: caimengzhi
# This is a script to gather network information of your Linux system.
# Test under Ubuntu 10.04 only.
#----------------------------
NIC=bridge01
MAC=$(LANG=C ifconfig $NIC | awk '/HWaddr/{ print $5 }')
IP=$(LANG=C ifconfig $NIC | awk '/inet addr:/{ print $2 }' | awk -F: '{print $2 }')
MASK=$(LANG=C ifconfig $NIC | awk -F: '/Mask/{print $4}')
ext_ip=$(curl -s ifconfig.me)
if [ -f /etc/resolv.conf ];
then
   dns=$(/usr/bin/awk '/^nameserver/{print $2}' /etc/resolv.conf)
fi
#----------------------------
echo "Your network information is as below:"
echo $MAC
echo $IP
echo $dns
echo $ext_ip
```

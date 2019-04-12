<center><h1>安装时候报错</h1></center>

## 1. 问题1
我在安装软件的时候，出现以下错误.
```
root@ubuntu:/etc/apt# apt-get install telegraf
Reading package lists... Done
Building dependency tree       
Reading state information... Done
E: The package telegraf needs to be reinstalled, but I can't find an archive for it.
```
我发现随便安装什么软件都是报这错误。后来发现是之前安装telegraf的时候出现过错误。

解决如下:
```
root@ubuntu# cp -a /var/lib/dpkg/status /var/lib/dpkg/status.bkp
root@ubuntu# vim /var/lib/dpkg/status
```
删除报错的telegraf相关部分
```
Package: telegraf
Status: install reinstreq half-installed
Priority: extra
Section: default
Installed-Size: 37530
Maintainer: support@influxdb.com
Architecture: amd64
Version: 1.3.5-1
Config-Version: 1.3.5-1
Conffiles:
 /etc/logrotate.d/telegraf e8b654479dc3f727652531061f818f7a
 /etc/telegraf/telegraf.conf 154d53eb67bf9fd2d1fb91ab7b82c39d
Description: Plugin-driven server agent for reporting metrics into InfluxDB.
License: MIT
Vendor: InfluxData
Homepage: https://github.com/influxdata/telegraf
```

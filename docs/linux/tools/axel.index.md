<center><h1>Axel 快速下载</h1></center>

## 1. 介绍

[Axel](https://axel.alioth.debian.org/) 是一个轻量级下载程序，它和其他加速器一样，对同一个文件建立多个连接，每个连接下载单独的文件片段以更快地完成下载。

Axel 支持 HTTP、HTTPS、FTP 和 FTPS 协议。它也可以使用多个镜像站点下载单个文件，所以，Axel 可以加速下载高达 40％（大约，我个人认为）。它非常轻量级，因为它没有依赖并且使用非常少的 CPU 和内存。

Axel 一步到位地将所有数据直接下载到目标文件（LCTT 译注：而不是像其它的下载软件那样下载成多个文件块，然后拼接）。

注意：不支持在单条命令中下载两个文件。

你还可以尝试其他命令行下载管理器/加速器。

- [aria2 - 超快速下载程序](http://www.2daygeek.com/aria2-command-line-download-utility-tool/)
- [wget - 标准命令行下载程序](http://www.2daygeek.com/wget-command-line-download-utility-tool/)
- [curl - 命令行下载程序](http://www.2daygeek.com/aria2-command-line-download-utility-tool/)
- [Linux 下的最好的 4 个命令行下载管理器/加速器](https://linux.cn/article-8124-1.html)

​    大多数发行版（Debian、Ubuntu、Mint、Fedora、suse、openSUSE、Arch Linux、Manjaro、Mageia 等）都有 axel 包，所以我们可以从发行版官方仓库轻松安装。对于 CentOS/RHEL，我们需要启用 [EPEL Repository](https://linux.cn/article-2324-1.html)。

### 1.1 Debian/Ubuntu/LinuxMint 上安装 Axel

```linux
sudo apt-get install axel
```

### 1.2  RHEL/CentOS 上安装 Axel

```
sudo yum install axel
```

### 1.3 Fedora 上安装 Axel

```
dnf install axel
```

### 1.4  openSUSE 上安装 Axel

```
sudo zypper install axel
```

## 2. 下载单个文件

​    以下命令将从给定的 URL 下载文件并存储在当前目录中，下载文件时，我们可以看到文件的信息（建立的连接数、下载速度、下载进度、完成下载所花费的时间以及连接完成的时间）。

```
root@leco:/tmp/cmz# axel https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
初始化下载: https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
文件大小: 22678208 字节
打开输出文件 owncloud-9.0.0.tar.bz2
开始下载

[  0%]  .......... .......... .......... .......... ..........  [   8.6KB/s]
[  0%]  .......... .......... .......... .......... ..........  [   8.6KB/s]
[  0%]  .......... .......... .......... .......... ..........  [   8.1KB/s]
[  0%]  .......... .......... .......... .......... ..........  [   8.7KB/s]
[  0%]  .......... .......... .......... .......... ..........  [   9.8KB/s]
[  1%]  .......... .......... .......... .......... ..........  [  10.5KB/s]
[  1%]  .......... .......... .......... .......... ..........  [  11.1KB/s]
[  1%]  .......... .......... .......... .......... ..........  [  10.6KB/s]
[  1%]  .......... .......... .......... .......... ..........  [   8.4KB/s]
[  2%]  .......... .....
连接超时 0
        ,,,,,,,,,, ,,,,,..... .......... .......... ..........  [   8.8KB/s]
[  2%]  .......... .......... .......... .......... ..........  [   9.5KB/s]
[  2%]  .......... .......... .......... .......... ..........  [  10.3KB/s]
[  2%]  .......... .......... .......... .......... ..........  [  11.0KB/s]
[  2%]  .......... .......... .......... .......... ..........  [  11.6KB/s]
[  3%]  .......... .......... .......... .......... ..........  [  12.2KB/s]
[  3%]  .......... .......... .......... .......... ..........  [  12.7KB/s]
[  3%]  .......... .......... .......... .......... ..........  [  12.8KB/s]
[  3%]  .......... .......... .......... .......... ..........  [  12.6KB/s]
[  4%]  .......... .......... .......... .......... ..........  [  12.5KB/s]
[  4%]  .......... .......... .......... .......... ..........  [  12.6KB/s]
[  4%]  .......... .......... .......... .......... ..........  [  12.7KB/s]
```

## 3. 用不同的名称保存文件

```
root@leco:/tmp/cmz# axel -o cloud.tar.bz2 https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
初始化下载: https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
文件大小: 22678208 字节
打开输出文件 cloud.tar.bz2
开始下载

[  0%]  .......... .......... .......... .......... ..........  [   2.9KB/s]
[  0%]  .......... .......... .......^C

77.7 千字节 已下载，用时 19 秒。（3.96 千字节/秒）
root@leco:/tmp/cmz# ls owncloud-9.0.0.tar.bz2
owncloud-9.0.0.tar.bz2
```

## 4. 限制下载速度

​    默认情况下 axel 以字节/秒为单位设置下载文件的最大速度。当我们的网络连接速度较慢时，可以使用此选项。只需添加 `-s` 选项，后面跟字节值。这里我们要限速 `512 KB/s` 下载一个文件。

```
root@leco:/tmp/cmz# axel -s 512000 https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
初始化下载: https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
文件大小: 22678208 字节
打开输出文件 owncloud-9.0.0.tar.bz2
找到状态文件： 2151071 字节已下载，继续下载 20527137 字节。
开始下载

        ,,,,,,,,,, ,,,,,,,,,, ,,,,,,,,,, ,,,,,,,,,, ,,,,,,,,,,  [   3.3KB/s]
[  9%]  .......... .......... ...
```

## 5. 限制连接数

​    axel 默认建立 4 个连接以从不同的镜像获取文件。此外，我们可以通过使用 `-n` 选项添加更多的连接，后跟连接数 `10` 来提高下载速度。保险起见，我们添加了十个连接，但不幸的是，它花了更多时间来下载文件。

```
root@leco:/tmp/cmz# axel -n 10 https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
初始化下载: https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
文件大小: 22678208 字节
打开输出文件 owncloud-9.0.0.tar.bz2
找到状态文件： 2217319 字节已下载，继续下载 20460889 字节。
开始下载

        ,,,,,,,,,, ,,,,,..... .......... .......... ..........  [  28.7KB/s]
[  9%]  .......... .......... .......... .......... ..........  [  40.2KB/s]
[ 10%]  .......... .......... .......... .......... ..........  [  38.9KB/s]
[ 10%]  ........
```

## 6.  恢复未完成的下载

​    axel 默认具有恢复未完成的下载的行为。Axel 在下载文件时定期更新状态文件（扩展名为 `.st`）。由于某些原因，下载中途停止了？不用担心，只要使用相同的 axel 命令，它将会检查 `file` 和 `file.st`，如果找到，它会从停止处恢复下载。

```
root@leco:/tmp/cmz# ll
总用量 2496
drwxr-xr-x  2 root root     4096 3月  25 14:36 ./
drwxrwxrwt 31 root root    12288 3月  25 14:41 ../
-rw-r--r--  1 root root 17028450 3月  25 14:36 cloud.tar.bz2
-rw-r--r--  1 root root       44 3月  25 14:36 cloud.tar.bz2.st
-rw-r--r--  1 root root 17651050 3月  25 14:41 owncloud-9.0.0.tar.bz2
-rw-r--r--  1 root root       44 3月  25 14:41 owncloud-9.0.0.tar.bz2.st
root@leco:/tmp/cmz# axel -n 10 https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
初始化下载: https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
文件大小: 22678208 字节
打开输出文件 owncloud-9.0.0.tar.bz2
找到状态文件： 2424295 字节已下载，继续下载 20253913 字节。
开始下载

        ,,,,,,,,,, ,,,,,,,... .......... .......... ..........  [  42.8KB/s]
[ 10%]  .......... .......... .......... .......... ..........  [  45.9KB/s]
[ 11%]  .......... .......... .......... .......... ..........  [  64.8KB/s]
[ 11%]  .......... .......... .......... .......... ..........  [  82.4KB/s]
[ 11%]  .......... ..^C

195.1 千字节 已下载，用时 2 秒。（77.54 千字节/秒）
```

上面的输出清晰地显示了在下载断开时有两个文件 `owncloud-9.0.0.tar.bz2` 和 `owncloud-9.0.0.tar.bz2.st`。当重新开始下载时，它会从停止处开始下载。

## 7. 不显示文件下载进度

如果你不想要看到文件的下载进度，只要在 axel 命令中加入 `-q` 选项。

```
root@leco:/tmp/cmz# axel -q https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
```

## 8.  替换进度条

如果你不喜欢默认的进度条，你可以使用 `-a` 选项来替换进度条。

```
root@leco:/tmp/cmz# axel -q https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
^Croot@leco:/tmp/cmz# axel -a https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
初始化下载: https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
文件大小: 22678208 字节
打开输出文件 owncloud-9.0.0.tar.bz2
找到状态文件： 3204427 字节已下载，继续下载 19473781 字节。
开始下载

[ 14%] [.0           .1          .2           .3          ] [  16.2KB/s] [19:33]
```



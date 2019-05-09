<center><h1>Linux命令 系统显示</h1></center>
> 作者: caimengzhi

## 5. 系统显示

###  5.1 uname

&emsp;Linux uname命令用于显示系统信息。`uname`可显示电脑以及操作系统的相关信息。

```
uname [-amnrsv][--help][--version]
```

**参数**：

- m 　显示系统位数[32bit/64bit]。
- -n或-nodename 　显示在网络上的主机名称。
- -r或--release 　显示操作系统的发行编号。
- -s或--sysname 　显示操作系统名称。
- -v 　显示操作系统的版本。
- --help 　显示帮助。
- --version 　显示版本信息。

```
显示系统信息
[root@master01 ~]# uname -a
Linux master01 3.10.0-957.10.1.el7.x86_64 #1 SMP Mon Mar 18 15:06:45 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux

显示计算机类型
[root@master01 ~]# uname -m
x86_64

显示计算名
[root@master01 ~]# uname -n
master01
[root@master01 ~]# hostname
master01

显示操作系统发行编号
[root@master01 ~]# uname -r
3.10.0-957.10.1.el7.x86_64

显示操作系统名称
[root@master01 ~]# uname -s
Linux

显示系统时间
[root@master01 ~]# uname -v
#1 SMP Mon Mar 18 15:06:45 UTC 2019
[root@master01 ~]# date
Tue May  7 03:17:36 EDT 2019
```

### 5.2 hostname

&emsp;显示和设置系统的主机名

**语法**

```
hostname [选项]
```

**参数**：

- -a  如果设置了主机名，则可以使用-a来显示主机别名
- -i 显示主机IP地址，这个参数需要DNS解析
- -I 显示主机IP地址，不依赖DNS解析
- -s 显示短格式主机名

```
显示主机名
[root@master01 ~]# hostname # 不接受参数，就表示显示主机名
master01

设置主机名,临时生效，重启机器后失效
[root@master01 ~]# hostname caimengzhi
[root@master01 ~]# bash
[root@caimengzhi ~]# hostname
caimengzhi
永久生效的话，需要在/etc/hostname 中编辑
[root@master01 ~]# cat /etc/hostname
master01

显示主机ip地址
[root@master01 ~]# hostname -i
192.168.5.100
[root@master01 ~]# hostname -I # 有多少块网卡[有IP地址]就显示多少个IP地址 
192.168.5.100 172.17.7.1 172.17.7.0 
```

### 5.3 dmesg

&emsp;Linux dmesg命令用于显示开机信息。kernel会将开机信息存储在ring buffer中。您若是开机时来不及查看信息，可利用dmesg来查看。开机信息亦保存在/var/log目录中，名称为dmesg的文件里。

**语法**

```
dmesg [-cn][-s <缓冲区大小>]
```

**参数说明**：

- -c 　显示信息后，清除ring buffer中的内容。
- -s<缓冲区大小> 　预设置为8196，刚好等于ring buffer的大小。
- -n 　设置记录信息的层级。

```
[root@master01 ~]# dmesg|less
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-957.10.1.el7.x86_64 (mockbuild@kbuilder.bsys.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-36) (GCC) ) #1 SMP Mon Mar 18 15:06:45 UTC 2019
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.0-957.10.1.el7.x86_64 root=/dev/mapper/centos-root ro crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet LANG=en_U
S.UTF-8[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000009d914fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009d915000-0x000000009dc09fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009dc0a000-0x000000009e822fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009e823000-0x000000009eed4fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009eed5000-0x000000009eed5fff] usable
[    0.000000] BIOS-e820: [mem 0x000000009eed6000-0x000000009f0dbfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000009f0dc000-0x000000009f50ffff] usable
[    0.000000] BIOS-e820: [mem 0x000000009f510000-0x000000009f7f2fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000009f7f3000-0x000000009f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100001000-0x000000013effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Acer Shangqi N6120/AAHD3-VF, BIOS MAP23SB 09/02/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x13f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CFFFF write-protect
以下省略
```

### 5.4 stat

&emsp;Linux stat命令用于显示inode内容。stat以文字的格式来显示inode的内容。

**语法**

```
stat [文件或目录]
```

```
[root@master01 etcd]# stat etcd.sh 
  File: ‘etcd.sh’
  Size: 1773      	Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 100909135   Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-05-04 22:33:49.742966577 -0400
Modify: 2019-05-04 22:31:50.597254997 -0400
Change: 2019-05-04 22:33:38.758177561 -0400
 Birth: -
```



### 5.5 du

&emsp;Linux du命令用于显示目录或文件的大小。`du`会显示指定的目录或文件所占用的磁盘空间。

**语法**

```
du [-abcDhHklmsSx][-L <符号连接>][-X <文件>][--block-size][--exclude=<目录或文件>][--max-depth=<目录层数>][--help][--version][目录或文件]
```

**参数说明**：

- -a或-all 显示目录中个别文件的大小。
- -b或-bytes 显示目录或文件大小时，以byte为单位。
- -c或--total 除了显示个别目录或文件的大小外，同时也显示所有目录或文件的总和。
- -D或--dereference-args 显示指定符号连接的源文件大小。
- -h或--human-readable 以K，M，G为单位，提高信息的可读性。
- -H或--si 与-h参数相同，但是K，M，G是以1000为换算单位。
- -k或--kilobytes 以1024 bytes为单位。
- -l或--count-links 重复计算硬件连接的文件。
- -L<符号连接>或--dereference<符号连接> 显示选项中所指定符号连接的源文件大小。
- -m或--megabytes 以1MB为单位。
- -s或--summarize 仅显示总计。
- -S或--separate-dirs 显示个别目录的大小时，并不含其子目录的大小。
- -x或--one-file-xystem 以一开始处理时的文件系统为准，若遇上其它不同的文件系统目录则略过。
- -X<文件>或--exclude-from=<文件> 在<文件>指定目录或文件。
- --exclude=<目录或文件> 略过指定的目录或文件。
- --max-depth=<目录层数> 超过指定层数的目录后，予以忽略。
- --help 显示帮助。
- --version 显示版本信息。

显示目录或者文件所占空间

```
[root@master01 ~]# cd /opt/
[root@master01 opt]# du -s  # 显示当前目录总大小
525876	.
[root@master01 opt]# du -h  # h参数会自动换算成K，M,G这样容易理解和阅读
0	./containerd/bin
0	./containerd/lib
0	./containerd
12K	./etcd/ssl
4.0K	./etcd/cfg
34M	./etcd/bin
34M	./etcd
481M	./kubernetes/bin
48K	./kubernetes/cfg
28K	./kubernetes/ssl
481M	./kubernetes
514M	.
[root@master01 opt]# du -sh . # 推荐使用，显示指定目录总大小
514M	.


[root@master01 opt]# du 
0	./containerd/bin
0	./containerd/lib
0	./containerd
12	./etcd/ssl
4	./etcd/cfg
34236	./etcd/bin
34252	./etcd
491548	./kubernetes/bin
48	./kubernetes/cfg
28	./kubernetes/ssl
491624	./kubernetes
525876	.
```

> 只显示当前目录下面的子目录的目录大小和当前目录的总的大小，最下面的525876为当前目录的总大小

显示指定文件所占空间

```
[root@master01 opt]# du etcd/cfg/etcd 
4	etcd/cfg/etcd
默认是kb
```

方便阅读的格式显示/opt目录所占空间情况：

```
[root@master01 opt]# du -h /opt/
0	/opt/containerd/bin
0	/opt/containerd/lib
0	/opt/containerd
12K	/opt/etcd/ssl
4.0K	/opt/etcd/cfg
34M	/opt/etcd/bin
34M	/opt/etcd
481M	/opt/kubernetes/bin
48K	/opt/kubernetes/cfg
28K	/opt/kubernetes/ssl
481M	/opt/kubernetes
514M	/opt/
```

```
只显示第一层目录大小
[root@master01 opt]# du -h --max-depth=1 /usr/local/  
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
0	/usr/local/share
8.0K	/usr/local/src
19M	/usr/local/

只显示第一层和第二层目录大小
[root@master01 opt]# du -h --max-depth=2 /usr/local/
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
0	/usr/local/share/applications
0	/usr/local/share/info
0	/usr/local/share/man
0	/usr/local/share
8.0K	/usr/local/src
19M	/usr/local/

排除指定目录
[root@master01 opt]# du -h --max-depth=2 /usr/local/ --exclude=/usr/local/share
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
8.0K	/usr/local/src
19M	/usr/local/
```

> 排除指定目录，要排除的目录，最后不能有/结尾。

错误写法

```
[root@master01 opt]# du -h --max-depth=2 /usr/local/ --exclude=/usr/local/share/  # 最后/share后面多了一个/
19M	/usr/local/bin
0	/usr/local/etc
0	/usr/local/games
0	/usr/local/include
0	/usr/local/lib
0	/usr/local/lib64
0	/usr/local/libexec
0	/usr/local/sbin
0	/usr/local/share/applications
0	/usr/local/share/info
0	/usr/local/share/man
0	/usr/local/share
8.0K	/usr/local/src
19M	/usr/local/
```

### 5.6 date

### 5.7 echo

&emsp;Linux echo命令用于显示输出

**语法**

```
echo [选项] 输出字符
```

**参数说明**：

- -n    不自动换行
- -E    不解析转意字符(默认参数)
- -e    若字符串中出现以下字符，则需要特别处理，而不是将它当做一般字符处理，也就是需要转意。
  - \a    发出警告声音
  - \b    删除前一个字符
  - \c    最后不加上换行符号
  - \f    换行单光标依然停留在原来的位置
  - \n    换行且光标移动至行首
  - \r     光标移动到行首，但是不换行
  - \t    插入tab
  - \v    与\f相反
  - \\\\    插入\字符
  - \\'    插入单引号
  - \\"   插入双引号
  - \\nnn    插入nnn[八进制]所代表的ASCII字符  

```
直接输出要输出的文字
[root@master01 ~]# echo hello caimenzhi! 
hello caimenzhi!

可以将要输出的单引号括起来
[root@master01 ~]# echo 'hello caimenzhi!' 
hello caimenzhi!

！特殊性
[root@master01 ~]# echo "hello caimenzhi!" 
bash: !": event not found
[root@master01 ~]# echo "hello caimenzhi"!
hello caimenzhi!

重定向到文件[保存到文件]
> 每次都会情况文件
>> 追加到文件

[root@master01 ~]# echo 'hello caimengzhi'>info
[root@master01 ~]# cat info
hello caimengzhi
[root@master01 ~]# echo 'hello caimengzhi'>info
[root@master01 ~]# cat info
hello caimengzhi
[root@master01 ~]# echo 'hello caimengzhi'>>info
[root@master01 ~]# echo 'hello caimengzhi'>>info
[root@master01 ~]# cat info
hello caimengzhi
hello caimengzhi
hello caimengzhi

输出不换行[-n]
[root@master01 ~]# echo 'caimengzhi';echo 'caimengzhi'
caimengzhi
caimengzhi
[root@master01 ~]# echo -n 'caimengzhi';echo 'caimengzhi'
caimengzhicaimengzhi
```

### 5.8 watch

&emsp;主要监控命令输出结果，或者程序执行情况.

**语法**

```
watch [选项] [命令]
```

**参数说明**：

- -n    命令执行间隔时间，默认2秒
- -d    高亮显示命令结果的变动之处
- -t     关闭watch命令在顶部显示的时间间隔，命令以及当前时间的输出

```
每隔1秒显示网络链接数的变化情况
[root@master01 ~]# watch  -n 1 -d netstat -ant
Every 1.0s: netstat -ant                                                                                                                                             Tue May  7 04:09:05 2019

Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0	  0 127.0.0.1:10248         0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:10249         0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:10250     0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:6443      0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:2379      0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:2379          0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:10252         0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:2380      0.0.0.0:*               LISTEN
tcp        0	  0 192.168.5.100:10255     0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:8080          0.0.0.0:*               LISTEN
tcp        0	  0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:25            0.0.0.0:*               LISTEN
tcp        0	  0 127.0.0.1:33503         0.0.0.0:*               LISTEN

监控文件
[root@master01 ~]# echo 'line 1'>cmz.txt
[root@master01 ~]# watch cat cmz.txt 
Every 2.0s: cat cmz.txt                                                                                                                                              Tue May  7 04:11:04 2019

line 1
line 2
line 3

新开一个界面终端往cmz.txt文件中输入数据
[root@master01 ~]# echo 'line 2'>>cmz.txt
[root@master01 ~]# echo 'line 3'>>cmz.txt
上面 watch cat cmz.txt 就会动态显示类似 tail -f cmz.txt | tailf cmz.txt

不显示标题
[root@master01 ~]# watch -t cat cmz.txt 
line 1
line 2
line 3
```

### 5.9 which

&emsp;Linux which命令用于查找文件。which指令会在环境变量$PATH设置的目录里查找符合条件的文件。

**语法**

```
which [文件...]
```

**参数**：

- -n<文件名长度> 　指定文件名长度，指定的长度必须大于或等于所有文件中最长的文件名。
- -p<文件名长度> 　与-n参数相同，但此处的<文件名长度>包括了文件的路径。
- -w 　指定输出时栏位的宽度。
- -V 　显示版本信息。

```
[root@master01 ~]# which sh
/usr/bin/sh
```

### 5.10 whereis

&emsp;Linux whereis命令用于查找文件。该指令会在特定目录中查找符合条件的文件。这些文件应属于原始代码、二进制文件，或是帮助文件。该指令只能用于查找二进制文件、源代码文件和man手册页，一般文件的定位需使用locate命令。

```
whereis [-bfmsu][-B <目录>...][-M <目录>...][-S <目录>...][文件...]
```

**参数**：

- -b 　只查找二进制文件。
- -B<目录> 　只在设置的目录下查找二进制文件。
- -f 　不显示文件名前的路径名称。
- -m 　只查找说明文件。
- -M<目录> 　只在设置的目录下查找说明文件。
- -s 　只查找原始代码文件。
- -S<目录> 　只在设置的目录下查找原始代码文件。
- -u 　查找不包含指定类型的文件。

```
[root@master01 ~]# whereis bash 
bash: /usr/bin/bash /usr/share/man/man1/bash.1.gz
```

注意：以上输出信息从左至右分别为查询的程序名、bash路径、bash的man 手册页路径。

如果用户需要单独查询二进制文件或帮助文件，可使用如下命令：

```
[root@master01 ~]# whereis -b bash   # 显示bash 命令的二进制程序
bash: /usr/bin/bash                  # bash命令的二进制程序的地址
[root@master01 ~]# whereis -m bash   # 显示bash 命令的帮助文件
bash: /usr/share/man/man1/bash.1.gz  # bash命令的帮助文件地址
```

### 5.11 locate

&emsp;Linux locate命令用于查找符合条件的文档，他会去保存文档和目录名称的数据库内，查找合乎范本样式条件的文档或目录。一般情况我们只需要输入 **locate your_file_name** 即可查找指定文件。

**语法**

```
locate [-d ][--help][--version][范本样式...]
```

**参数：**

- -d或--database= 配置locate指令使用的数据库。locate指令预设的数据库位于/var/lib/slocate目录里，文档名为slocate.db，您可使用 这个参数另行指定。
- --help 　在线帮助。
- --version 　显示版本信息。

```
root@leco:~/book# locate book.conf
/etc/nginx/sites-enabled/book.conf
/var/lib/dpkg/info/account-plugin-facebook.conffiles

只显示匹配到的行数
root@leco:~/book# locate book.conf -c
2
```

&emsp;locate与find 不同: find 是去硬盘找，locate 只在/var/lib/slocate资料库中找。

&emsp;locate的速度比find快，它并不是真的查找，而是查数据库，一般文件数据库在/var/lib/slocate/slocate.db中，所以locate的查找并不是实时的，而是以数据库的更新为准，一般是系统自己维护。

### 5.12 updatedb

&emsp;创建或者修改数据库，

```
root@leco:~# ls /var/lib/mlocate/mlocate.db 
/var/lib/mlocate/mlocate.db

root@leco:~# locate cmz -c
1951
root@leco:~# touch cmz12.txt
root@leco:~# locate cmz -c  # 没有变
1951
root@leco:~# updatedb -vU /root/  # 更新数据库
root@leco:~# ll /var/lib/mlocate/mlocate.db  # 数据库时间也变了
-rw-r----- 1 root mlocate 3694627 5月   7 17:54 /var/lib/mlocate/mlocate.db 
root@leco:~# locate cmz -c  # 出现了
1952
```


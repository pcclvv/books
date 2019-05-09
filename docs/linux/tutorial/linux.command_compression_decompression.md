<center><h1>Linux命令 压缩和解压</h1></center>
> 作者: caimengzhi

##  6. 文件压缩和解压

### 6.1 tar

&emsp;Linux tar命令用于备份文件。tar是用来建立，还原备份文件的工具程序，它可以加入，解开备份文件内的文件。

**语法**

```
tar [-ABcdgGhiklmMoOpPrRsStuUvwWxzZ][-b <区块数目>][-C <目的目录>][-f <备份文件>][-F <Script文件>][-K <文件>][-L <媒体容量>][-N <日期时间>][-T <范本文件>][-V <卷册名称>][-X <范本文件>][-<设备编号><存储密度>][--after-date=<日期时间>][--atime-preserve][--backuup=<备份方式>][--checkpoint][--concatenate][--confirmation][--delete][--exclude=<范本样式>][--force-local][--group=<群组名称>][--help][--ignore-failed-read][--new-volume-script=<Script文件>][--newer-mtime][--no-recursion][--null][--numeric-owner][--owner=<用户名称>][--posix][--erve][--preserve-order][--preserve-permissions][--record-size=<区块数目>][--recursive-unlink][--remove-files][--rsh-command=<执行指令>][--same-owner][--suffix=<备份字尾字符串>][--totals][--use-compress-program=<执行指令>][--version][--volno-file=<编号文件>][文件或目录...]
```

**参数**：

- -A或--catenate 新增文件到已存在的备份文件。
- -b<区块数目>或--blocking-factor=<区块数目> 设置每笔记录的区块数目，每个区块大小为12Bytes。
- -B或--read-full-records 读取数据时重设区块大小。
- -c或--create 建立新的备份文件。
- -C<目的目录>或--directory=<目的目录> 切换到指定的目录。
- -d或--diff或--compare 对比备份文件内和文件系统上的文件的差异。
- -f<备份文件>或--file=<备份文件> 指定备份文件。
- -F<Script文件>或--info-script=<Script文件> 每次更换磁带时，就执行指定的Script文件。
- -g或--listed-incremental 处理GNU格式的大量备份。
- -G或--incremental 处理旧的GNU格式的大量备份。
- -h或--dereference 不建立符号连接，直接复制该连接所指向的原始文件。
- -i或--ignore-zeros 忽略备份文件中的0 Byte区块，也就是EOF。
- -k或--keep-old-files 解开备份文件时，不覆盖已有的文件。
- -K<文件>或--starting-file=<文件> 从指定的文件开始还原。
- -l或--one-file-system 复制的文件或目录存放的文件系统，必须与tar指令执行时所处的文件系统相同，否则不予复制。
- -L<媒体容量>或-tape-length=<媒体容量> 设置存放每体的容量，单位以1024 Bytes计算。
- -m或--modification-time 还原文件时，不变更文件的更改时间。
- -M或--multi-volume 在建立，还原备份文件或列出其中的内容时，采用多卷册模式。
- -N<日期格式>或--newer=<日期时间> 只将较指定日期更新的文件保存到备份文件里。
- -o或--old-archive或--portability 将资料写入备份文件时使用V7格式。
- -O或--stdout 把从备份文件里还原的文件输出到标准输出设备。
- -p或--same-permissions 用原来的文件权限还原文件。
- -P或--absolute-names 文件名使用绝对名称，不移除文件名称前的"/"号。
- -r或--append 新增文件到已存在的备份文件的结尾部分。
- -R或--block-number 列出每个信息在备份文件中的区块编号。
- -s或--same-order 还原文件的顺序和备份文件内的存放顺序相同。
- -S或--sparse 倘若一个文件内含大量的连续0字节，则将此文件存成稀疏文件。
- -t或--list 列出备份文件的内容。
- -T<范本文件>或--files-from=<范本文件> 指定范本文件，其内含有一个或多个范本样式，让tar解开或建立符合设置条件的文件。
- -u或--update 仅置换较备份文件内的文件更新的文件。
- -U或--unlink-first 解开压缩文件还原文件之前，先解除文件的连接。
- -v或--verbose 显示指令执行过程。
- -V<卷册名称>或--label=<卷册名称> 建立使用指定的卷册名称的备份文件。
- -w或--interactive 遭遇问题时先询问用户。
- -W或--verify 写入备份文件后，确认文件正确无误。
- -x或--extract或--get 从备份文件中还原文件。
- -X<范本文件>或--exclude-from=<范本文件> 指定范本文件，其内含有一个或多个范本样式，让ar排除符合设置条件的文件。
- -z或--gzip或--ungzip 通过gzip指令处理备份文件。
- -Z或--compress或--uncompress 通过compress指令处理备份文件。
- -<设备编号><存储密度> 设置备份用的外围设备编号及存放数据的密度。
- --after-date=<日期时间> 此参数的效果和指定"-N"参数相同。
- --atime-preserve 不变更文件的存取时间。
- --backup=<备份方式>或--backup 移除文件前先进行备份。
- --checkpoint 读取备份文件时列出目录名称。
- --concatenate 此参数的效果和指定"-A"参数相同。
- --confirmation 此参数的效果和指定"-w"参数相同。
- --delete 从备份文件中删除指定的文件。
- --exclude=<范本样式> 排除符合范本样式的问家。
- --group=<群组名称> 把加入设备文件中的文件的所属群组设成指定的群组。
- --help 在线帮助。
- --ignore-failed-read 忽略数据读取错误，不中断程序的执行。
- --new-volume-script=<Script文件> 此参数的效果和指定"-F"参数相同。
- --newer-mtime 只保存更改过的文件。
- --no-recursion 不做递归处理，也就是指定目录下的所有文件及子目录不予处理。
- --null 从null设备读取文件名称。
- --numeric-owner 以用户识别码及群组识别码取代用户名称和群组名称。
- --owner=<用户名称> 把加入备份文件中的文件的拥有者设成指定的用户。
- --posix 将数据写入备份文件时使用POSIX格式。
- --preserve 此参数的效果和指定"-ps"参数相同。
- --preserve-order 此参数的效果和指定"-A"参数相同。
- --preserve-permissions 此参数的效果和指定"-p"参数相同。
- --record-size=<区块数目> 此参数的效果和指定"-b"参数相同。
- --recursive-unlink 解开压缩文件还原目录之前，先解除整个目录下所有文件的连接。
- --remove-files 文件加入备份文件后，就将其删除。
- --rsh-command=<执行指令> 设置要在远端主机上执行的指令，以取代rsh指令。
- --same-owner 尝试以相同的文件拥有者还原文件。
- --suffix=<备份字尾字符串> 移除文件前先行备份。
- --totals 备份文件建立后，列出文件大小。
- --use-compress-program=<执行指令> 通过指定的指令处理备份文件。
- --version 显示版本信息。
- --volno-file=<编号文件> 使用指定文件内的编号取代预设的卷册编号。

```
压缩文件
[root@master01 cmz]# touch {1..10}.txt
[root@master01 cmz]# ls
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt
[root@master01 cmz]# tar zcvf all.tgz ./*  # -v 显示过程
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
-----------------------------------------------------------------------------------------
[root@master01 cmz]# tar tvfz all.tgz  # 查看压缩包详细内容，-t不解压意思，-v显示属性
-rw-r--r-- root/root         0 2019-05-07 07:36 ./10.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./1.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./2.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./3.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./4.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./5.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./6.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./7.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./8.txt
-rw-r--r-- root/root         0 2019-05-07 07:36 ./9.txt
-----------------------------------------------------------------------------------------
[root@master01 cmz]# tar tfz all.tgz # 查看包内容
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
-----------------------------------------------------------------------------------------
[root@master01 cmz]# tar tf all.tgz # 若不指定-z，那么tar会自动判断压缩包类型，自动调用gzip命令
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
-----------------------------------------------------------------------------------------
解压
[root@master01 cmz]# ls
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt  all.tgz
[root@master01 cmz]# mkdir cc
[root@master01 cmz]# tar zxvf all.tgz -C cc/ # -C 指定解压后的目录，若不加-C，解压到当前的目录下
./10.txt
./1.txt
./2.txt
./3.txt
./4.txt
./5.txt
./6.txt
./7.txt
./8.txt
./9.txt
[root@master01 cmz]# ls cc/
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt
-----------------------------------------------------------------------------------------
精简输出。不输出相关信息，脚本建议使用这样模式
[root@master01 cmz]# rm cc/* -rf
[root@master01 cmz]# tar xf all.tgz -C cc/
[root@master01 cmz]# ls cc/
10.txt  1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt  8.txt  9.txt
-----------------------------------------------------------------------------------------
打包的时候排除某个目录
[root@master01 cmz]# tree .
.
├── 1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── aa
│   ├── aa_1.txt
│   ├── aa_2.txt
│   ├── aa_3.txt
│   └── aa_4.txt
└── bb
    ├── bb_1.txt
    ├── bb_2.txt
    ├── bb_3.txt
    └── bb_4.txt

2 directories, 12 files
[root@master01 cmz]# tar zcvf all.tgz * --exclude=aa    # 文件后不能加/.否则失败
1.txt
2.txt
3.txt
4.txt
bb/
bb/bb_1.txt
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
[root@master01 cmz]# tar tvf all.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 1.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 2.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  all.tgz  bb

排除多个目录
[root@master01 cmz]# rm all.tgz 
rm: remove regular file ‘all.tgz’? y
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  bb
排除多个目录就是有多个 --exclude
[root@master01 cmz]# tar zcvf all.tgz * --exclude=aa --exclude=bb  
1.txt
2.txt
3.txt
4.txt
[root@master01 cmz]# tar tvf all.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 1.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 2.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
-----------------------------------------------------------------------------------------
排除某个文件
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  bb
[root@master01 cmz]# tar zcvf paichu1.tgz * --exclude=1.txt
2.txt
3.txt
4.txt
aa/
aa/aa_1.txt
aa/aa_2.txt
aa/aa_3.txt
aa/aa_4.txt
bb/
bb/bb_1.txt
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
[root@master01 cmz]# tar tvf paichu1.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 2.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:47 aa/
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt
[root@master01 cmz]# 
排除多个文件,和排除文件夹一样
[root@master01 cmz]# tar zcvf paichu2.tgz * --exclude=1.txt --exclude=2.txt
3.txt
4.txt
aa/
aa/aa_1.txt
aa/aa_2.txt
aa/aa_3.txt
aa/aa_4.txt
bb/
bb/bb_1.txt
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
[root@master01 cmz]# tar tvf paichu2.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:47 aa/
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt

排除多个文件，使用文件
[root@master01 cmz]# cat list.txt  # 指定一个目当前目录下文件，里面记录不需要的打包的文件
2.txt
bb/bb_1.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  aa  bb  list.txt
[root@master01 cmz]# ll
total 4
-rw-r--r-- 1 root root  0 May  7 07:46 1.txt
-rw-r--r-- 1 root root  0 May  7 07:46 2.txt
-rw-r--r-- 1 root root  0 May  7 07:46 3.txt
-rw-r--r-- 1 root root  0 May  7 07:46 4.txt
drwxr-xr-x 2 root root 70 May  7 07:47 aa
drwxr-xr-x 2 root root 70 May  7 07:48 bb
-rw-r--r-- 1 root root 18 May  7 07:53 list.txt
[root@master01 cmz]# tar zcvfX paichu.tgz list.txt *
1.txt
3.txt
4.txt
aa/
aa/aa_1.txt
aa/aa_2.txt
aa/aa_3.txt
aa/aa_4.txt
bb/
bb/bb_2.txt
bb/bb_3.txt
bb/bb_4.txt
list.txt
[root@master01 cmz]# tar tvf paichu.tgz 
-rw-r--r-- root/root         0 2019-05-07 07:46 1.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 3.txt
-rw-r--r-- root/root         0 2019-05-07 07:46 4.txt
drwxr-xr-x root/root         0 2019-05-07 07:47 aa/
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_1.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:47 aa/aa_4.txt
drwxr-xr-x root/root         0 2019-05-07 07:48 bb/
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_2.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_3.txt
-rw-r--r-- root/root         0 2019-05-07 07:48 bb/bb_4.txt
-rw-r--r-- root/root        18 2019-05-07 07:53 list.txt
```

### 6.2 gzip

&emsp;Linux gzip命令用于压缩文件。gzip是个使用广泛的压缩程序，文件经它压缩过后，其名称后面会多出".gz"的扩展名。

**语法**

```
gzip [-acdfhlLnNqrtvV][-S &lt;压缩字尾字符串&gt;][-&lt;压缩效率&gt;][--best/fast][文件...] 或 gzip [-acdfhlLnNqrtvV][-S &lt;压缩字尾字符串&gt;][-&lt;压缩效率&gt;][--best/fast][目录]
```

**参数**：

- -a或--ascii 　使用ASCII文字模式。
- -c或--stdout或--to-stdout 　把压缩后的文件输出到标准输出设备，不去更动原始文件。
- -d或--decompress或----uncompress 　解开压缩文件。 **
- -f或--force 　强行压缩文件。不理会文件名称或硬连接是否存在以及该文件是否为符号连接。
- -h或--help 　在线帮助。
- -l或--list 　列出压缩文件的相关信息。
- -L或--license 　显示版本与版权信息。
- -n或--no-name 　压缩文件时，不保存原来的文件名称及时间戳记。
- -N或--name 　压缩文件时，保存原来的文件名称及时间戳记。
- -q或--quiet 　不显示警告信息。
- -r或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
- -S<压缩字尾字符串>或----suffix<压缩字尾字符串> 　更改压缩字尾字符串。
- -t或--test 　测试压缩文件是否正确无误。
- -v或--verbose 　显示指令执行过程。
- -V或--version 　显示版本信息。
- -<压缩效率> 　压缩效率是一个介于1－9的数值，预设值为"6"，指定愈大的数值，压缩效率就会愈高。
- --best 　此参数的效果和指定"-9"参数相同。
- --fast 　此参数的效果和指定"-1"参数相同。

```
[root@master01 cmz]# touch {1..5}.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  5.txt
[root@master01 cmz]# gzip *   # 直接压缩当前每个文件，源文件消失
[root@master01 cmz]# ls
1.txt.gz  2.txt.gz  3.txt.gz  4.txt.gz  5.txt.gz

不解压查看压缩包信息
[root@master01 cmz]# gzip -l *
         compressed        uncompressed  ratio uncompressed_name
                 26                   0   0.0% 1.txt
                 26                   0   0.0% 2.txt
                 26                   0   0.0% 3.txt
                 26                   0   0.0% 4.txt
                 26                   0   0.0% 5.txt
解压
[root@master01 cmz]# ls
1.txt.gz  2.txt.gz  3.txt.gz  4.txt.gz  5.txt.gz
[root@master01 cmz]# gzip -dv *.gz  # -d解压，-v显示解压过程，解压后压缩包消失
1.txt.gz:	  0.0% -- replaced with 1.txt
2.txt.gz:	  0.0% -- replaced with 2.txt
3.txt.gz:	  0.0% -- replaced with 3.txt
4.txt.gz:	  0.0% -- replaced with 4.txt
5.txt.gz:	  0.0% -- replaced with 5.txt
[root@master01 cmz]# ls
1.txt  2.txt  3.txt  4.txt  5.txt
```

### 6.3 zip

&emsp;Linux zip命令用于压缩文件。zip是个使用广泛的压缩程序，文件经它压缩后会另外产生具有".zip"扩展名的压缩文件。

**语法**

```
zip [-AcdDfFghjJKlLmoqrSTuvVwXyz$][-b <工作目录>][-ll][-n <字尾字符串>][-t <日期时间>][-<压缩效率>][压缩文件][文件...][-i <范本样式>][-x <范本样式>]
```

**参数**：

- -A 调整可执行的自动解压缩文件。
- -b<工作目录> 指定暂时存放文件的目录。
- -c 替每个被压缩的文件加上注释。
- -d 从压缩文件内删除指定的文件。
- -D 压缩文件内不建立目录名称。
- -f 此参数的效果和指定"-u"参数类似，但不仅更新既有文件，如果某些文件原本不存在于压缩文件内，使用本参数会一并将其加入压缩文件中。
- -F 尝试修复已损坏的压缩文件。
- -g 将文件压缩后附加在既有的压缩文件之后，而非另行建立新的压缩文件。
- -h 在线帮助。
- -i<范本样式> 只压缩符合条件的文件。
- -j 只保存文件名称及其内容，而不存放任何目录名称。
- -J 删除压缩文件前面不必要的数据。
- -k 使用MS-DOS兼容格式的文件名称。
- -l 压缩文件时，把LF字符置换成LF+CR字符。
- -ll 压缩文件时，把LF+CR字符置换成LF字符。
- -L 显示版权信息。
- -m 将文件压缩并加入压缩文件后，删除原始文件，即把文件移到压缩文件中。
- -n<字尾字符串> 不压缩具有特定字尾字符串的文件。
- -o 以压缩文件内拥有最新更改时间的文件为准，将压缩文件的更改时间设成和该文件相同。
- -q 不显示指令执行过程。
- -r 递归处理，将指定目录下的所有文件和子目录一并处理。
- -S 包含系统和隐藏文件。
- -t<日期时间> 把压缩文件的日期设成指定的日期。
- -T 检查备份文件内的每个文件是否正确无误。
- -u 更换较新的文件到压缩文件内。
- -v 显示指令执行过程或显示版本信息。
- -V 保存VMS操作系统的文件属性。
- -w 在文件名称里假如版本编号，本参数仅在VMS操作系统下有效。
- -x<范本样式> 压缩时排除符合条件的文件。
- -X 不保存额外的文件属性。
- -y 直接保存符号连接，而非该连接所指向的文件，本参数仅在UNIX之类的系统下有效。
- -z 替压缩文件加上注释。
- -$ 保存第一个被压缩文件所在磁盘的卷册名称。
- -<压缩效率> 压缩效率是一个介于1-9的数值。

```
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt
[root@master01 cmz]# zip all.zip *
  adding: 2.txt (stored 0%)
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip
-----------------------------------------------------------------------------------------
递归压缩
[root@master01 cmz]# tree .
.
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── cc
    ├── 2.txt
    ├── 3.txt
    ├── 4.txt
    └── 5.txt

1 directory, 8 files
[root@master01 cmz]# zip all.zip *
  adding: 2.txt (stored 0%)
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%) # 没有压缩cc下面文件
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip  cc

[root@master01 cmz]# zip -r all.zip * # 递归压缩
  adding: 2.txt (stored 0%)
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%)
  adding: cc/2.txt (stored 0%)
  adding: cc/3.txt (stored 0%)
  adding: cc/4.txt (stored 0%)
  adding: cc/5.txt (stored 0%)
  
排除某个文件不压缩
[root@master01 cmz]# zip -r all.zip * -x 2.txt  # -x 指定某个文件不压缩
  adding: 3.txt (stored 0%)
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%)
  adding: cc/2.txt (stored 0%)
  adding: cc/3.txt (stored 0%)
  adding: cc/4.txt (stored 0%)
  adding: cc/5.txt (stored 0%)
[root@master01 cmz]# zip -r all.zip * -x 2.txt 3.txt # -x后面可以接多个文件，表示都不参与压缩
  adding: 4.txt (stored 0%)
  adding: 5.txt (stored 0%)
  adding: cc/ (stored 0%)
  adding: cc/2.txt (stored 0%)
  adding: cc/3.txt (stored 0%)
  adding: cc/4.txt (stored 0%)
  adding: cc/5.txt (stored 0%)

删除压缩包内某个文件
[root@master01 cmz]# zip -dv all.zip 4.txt
1>1: updating: 4.txt (stored 0%)

不显示执行过程 -q
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  cc
[root@master01 cmz]# zip -qr all.zip *
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip  cc
```

### 6.4 unzip

&emsp;Linux unzip命令用于解压缩zip文件,unzip为.zip压缩文件的解压缩程序。

**语法**

```
unzip [-cflptuvz][-agCjLMnoqsVX][-P <密码>][.zip文件][文件][-d <目录>][-x <文件>] 或 unzip [-Z]
```

**参数**：

- -c 将解压缩的结果显示到屏幕上，并对字符做适当的转换。
- -f 更新现有的文件。
- -l 显示压缩文件内所包含的文件。**
- -p 与-c参数类似，会将解压缩的结果显示到屏幕上，但不会执行任何的转换。
- -t 检查压缩文件是否正确。
- -u 与-f参数类似，但是除了更新现有的文件外，也会将压缩文件中的其他文件解压缩到目录中。
- -v 执行是时显示详细的信息。 **
- -z 仅显示压缩文件的备注文字。
- -a 对文本文件进行必要的字符转换。
- -b 不要对文本文件进行字符转换。
- -C 压缩文件中的文件名称区分大小写。
- -j 不处理压缩文件中原有的目录路径。
- -L 将压缩文件中的全部文件名改为小写。
- -M 将输出结果送到more程序处理。
- -n 解压缩时不要覆盖原有的文件。
- -o 不必先询问用户，unzip执行后覆盖原有文件。**
- -P<密码> 使用zip的密码选项。
- -q 执行时不显示任何信息。
- -s 将文件名中的空白字符转换为底线字符。
- -V 保留VMS的文件版本信息。
- -X 解压缩时同时回存文件原来的UID/GID。
- [.zip文件] 指定.zip压缩文件。
- [文件] 指定要处理.zip压缩文件中的哪些文件。
- -d<目录> 指定文件解压缩后所要存储的目录。 **
- -x<文件> 指定不要处理.zip压缩文件中的哪些文件。
- -Z unzip -Z等于执行zipinfo指令。

```
查看zip包中文件列表
[root@master01 cmz]# unzip -l all.zip 
Archive:  all.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        0  05-07-2019 08:02   2.txt
        0  05-07-2019 08:02   3.txt
        0  05-07-2019 08:02   4.txt
        0  05-07-2019 08:02   5.txt
        0  05-07-2019 08:12   cc/
        0  05-07-2019 08:12   cc/2.txt
        0  05-07-2019 08:12   cc/3.txt
        0  05-07-2019 08:12   cc/4.txt
        0  05-07-2019 08:12   cc/5.txt
---------                     -------
        0                     9 files
        
[root@master01 cmz]# unzip -v all.zip  # -v 参数用于查看压缩文件目录信息，但是不解压该文件。
Archive:  all.zip
 Length   Method    Size  Cmpr    Date    Time   CRC-32   Name
--------  ------  ------- ---- ---------- ----- --------  ----
       0  Stored        0   0% 05-07-2019 08:02 00000000  2.txt
       0  Stored        0   0% 05-07-2019 08:02 00000000  3.txt
       0  Stored        0   0% 05-07-2019 08:02 00000000  4.txt
       0  Stored        0   0% 05-07-2019 08:02 00000000  5.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/2.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/3.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/4.txt
       0  Stored        0   0% 05-07-2019 08:12 00000000  cc/5.txt
--------          -------  ---                            -------
       0                0   0%                            9 files
[root@master01 cmz]# 
----------------------------------------------------------------------------
解压，-d指定解压到该后面文件夹内，不指定就解压到当前目录下
[root@master01 cmz]# ls
2.txt  3.txt  4.txt  5.txt  all.zip  cc
[root@master01 cmz]# unzip all.zip 
Archive:  all.zip
replace 2.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: n         
replace 3.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: n
replace 4.txt? [y]es, [n]o, [A]ll, [N]one, [r]ename: N

[root@master01 cmz]# mkdir caimz
[root@master01 cmz]# unzip all.zip -d caimz/
Archive:  all.zip
 extracting: caimz/2.txt             
 extracting: caimz/3.txt             
 extracting: caimz/4.txt             
 extracting: caimz/5.txt             
   creating: caimz/cc/
 extracting: caimz/cc/2.txt          
 extracting: caimz/cc/3.txt          
 extracting: caimz/cc/4.txt          
 extracting: caimz/cc/5.txt          
[root@master01 cmz]# ls caimz/
2.txt  3.txt  4.txt  5.txt  cc

解压不提示文件是否覆盖
[root@master01 cmz]# unzip -o all.zip 
Archive:  all.zip
 extracting: 2.txt                   
 extracting: 3.txt                   
 extracting: 4.txt                   
 extracting: 5.txt                   
 extracting: cc/2.txt                
 extracting: cc/3.txt                
 extracting: cc/4.txt                
 extracting: cc/5.txt   
```

### 6.5 scp

&emsp;Linux scp命令用于Linux之间复制文件和目录。scp是 secure copy的缩写, scp是linux系统下基于ssh登陆进行安全的远程文件拷贝命令。

**语法**

```
scp [-1246BCpqrv] [-c cipher] [-F ssh_config] [-i identity_file]
[-l limit] [-o ssh_option] [-P port] [-S program]
[[user@]host1:]file1 [...] [[user@]host2:]file2
```

简易写法:

```
scp [可选参数] file_source file_target 
```

**参数说明：**

- -1： 强制scp命令使用协议ssh1
- -2： 强制scp命令使用协议ssh2
- -4： 强制scp命令只使用IPv4寻址
- -6： 强制scp命令只使用IPv6寻址
- -B： 使用批处理模式（传输过程中不询问传输口令或短语）
- -C： 允许压缩。（将-C标志传递给ssh，从而打开压缩功能）**
- -p：保留原文件的修改时间，访问时间和访问权限。
- -q： 不显示传输进度条。
- -r： 递归复制整个目录。**
- -v：详细方式显示输出。scp和ssh(1)会显示出整个过程的调试信息。这些信息用于调试连接，验证和配置问题。
- -c cipher： 以cipher将数据传输进行加密，这个选项将直接传递给ssh。
- -F ssh_config： 指定一个替代的ssh配置文件，此参数直接传递给ssh。
- -i identity_file： 从指定文件中读取传输时使用的密钥文件，此参数直接传递给ssh。
- -l limit： 限定用户所能使用的带宽，以Kbit/s为单位。**
- -o ssh_option： 如果习惯于使用ssh_config(5)中的参数传递方式，
- -P port：注意是大写的P, port是指定数据传输用到的端口号 **
- -p:  不显示传输进度条 **
- -S program： 指定加密传输时所使用的程序。此程序必须能够理解ssh(1)的选项。

````
scp local_file remote_username@remote_ip:remote_folder 
或者 
scp local_file remote_username@remote_ip:remote_file 
或者 
scp local_file remote_ip:remote_folder 
或者 
scp local_file remote_ip:remote_file 

第1,2个指定了用户名，命令执行后需要再输入密码，第1个仅指定了远程的目录，文件名字不变，第2个指定了文件名；
第3,4个没有指定用户名，命令执行后需要输入用户名和密码，第3个仅指定了远程的目录，文件名字不变，第4个指定了文件名；
````



````
推送[本地文件/文件夹推送到远端]
1. 文件发送
root@master01 cmz]# ls
master.txt
[root@master01 cmz]# scp master.txt root@192.168.5.110:/tmp/
root@192.168.5.110's password: 
master.txt       100%    9    13.4KB/s   00:00 
2. 文件夹发送
[root@master01 cmz]# scp -r caimengzhi root@192.168.5.110:/tmp
root@192.168.5.110's password: 
hosts            100%  266   359.6KB/s   00:00  
----------------------------------------------------------------------------
拉取[远端文件/文件夹拉取到本地]
1. 拉取文件
[root@master01 cmz]# scp 192.168.5.110:/tmp/master.txt .
root@192.168.5.110's password: 
master.txt    100%    9     7.7KB/s   00:00    
[root@master01 cmz]# ls
master.txt

2. 拉取文件夹
[root@master01 cmz]# scp -r 192.168.5.110:/tmp/caimengzhi .
root@192.168.5.110's password: 
hosts          100%  266   174.7KB/s   00:00    
[root@master01 cmz]# ls
caimengzhi  master.txt
[root@master01 cmz]# ls caimengzhi/
hosts
````

> scp是全量复制，本地有也会再起拉取

### 6.6 rsync

&emsp;`rsync`是一款开源的，多功能的，快速的，可以实现全量和增量的本地或者远程的数据同步工具。`rsync` 命令一般有三种常见模式

```
1. 本地模式
	rsync	[选项]	[源文件]	[目标文件]
2. shell访问模式
	1. 拉取
		rsync	[选项]	[用户@主机:源文件]	   [目标文件]
	2. 推送
		rsync	[选项]	[目标文件]            [用户@主机:源文件]
3. rsync守护进程模式
	1. 拉取
		rsync	[选项]	[用户名@主机::源文件]  [目标文件]
		rsync	[选项]	rsync://用户@主机:端口/源文件	[目标文件]
	2. 推送
		rsync	[选项]	[源文件]	用户@主机::目标文件
		rsync	[选项]	[源文件]	rsync://用户@主机:端口/目标文件
```

> 命令之间，至少要有一个空格。

**参数说明：**

- -v, --verbose 详细模式输出
- -q, --quiet 精简输出模式
- -c, --checksum 打开校验开关，强制对文件传输进行校验
- -a, --archive 归档模式，表示以递归方式传输文件，并保持所有文件属性，等于-rlptgoD
- -r, --recursive 对子目录以递归模式处理
- -R, --relative 使用相对路径信息
- -b, --backup 创建备份，也就是对于目的已经存在有同样的文件名时，将老的文件重新命名为~filename。可以使用--suffix选项来指定不同的备份文件前缀。
- --backup-dir 将备份文件(如~filename)存放在在目录下。
- -suffix=SUFFIX 定义备份文件前缀
- -u, --update 仅仅进行更新，也就是跳过所有已经存在于DST，并且文件时间晚于要备份的文件。(不覆盖更新的文件)
- -l, --links 保留软链结
- -L, --copy-links 想对待常规文件一样处理软链结
- --copy-unsafe-links 仅仅拷贝指向SRC路径目录树以外的链结
- --safe-links 忽略指向SRC路径目录树以外的链结
- -H, --hard-links 保留硬链结
- -p, --perms 保持文件权限
- -o, --owner 保持文件属主信息
- -g, --group 保持文件属组信息
- -D, --devices 保持设备文件信息
- -t, --times 保持文件时间信息
- -S, --sparse 对稀疏文件进行特殊处理以节省DST的空间
- -n, --dry-run现实哪些文件将被传输
- -W, --whole-file 拷贝文件，不进行增量检测
- -x, --one-file-system 不要跨越文件系统边界
- -B, --block-size=SIZE 检验算法使用的块尺寸，默认是700字节
- -e, --rsh=COMMAND 指定使用rsh、ssh方式进行数据同步
- --rsync-path=PATH 指定远程服务器上的rsync命令所在路径信息
- -C, --cvs-exclude 使用和CVS一样的方法自动忽略文件，用来排除那些不希望传输的文件
- --existing 仅仅更新那些已经存在于DST的文件，而不备份那些新创建的文件
- --delete 删除那些DST中SRC没有的文件
- --delete-excluded 同样删除接收端那些被该选项指定排除的文件
- --delete-after 传输结束以后再删除
- --ignore-errors 及时出现IO错误也进行删除
- --max-delete=NUM 最多删除NUM个文件
- --partial 保留那些因故没有完全传输的文件，以是加快随后的再次传输
- --force 强制删除目录，即使不为空
- --numeric-ids 不将数字的用户和组ID匹配为用户名和组名
- --timeout=TIME IP超时时间，单位为秒
- -I, --ignore-times 不跳过那些有同样的时间和长度的文件
- --size-only 当决定是否要备份文件时，仅仅察看文件大小而不考虑文件时间
- --modify-window=NUM 决定文件是否时间相同时使用的时间戳窗口，默认为0
- -T --temp-dir=DIR 在DIR中创建临时文件
- --compare-dest=DIR 同样比较DIR中的文件来决定是否需要备份
- -P 等同于 --partial
- --progress 显示备份过程
- -z, --compress 对备份的文件在传输时进行压缩处理
- --exclude=PATTERN 指定排除不需要传输的文件模式
- --include=PATTERN 指定不排除而需要传输的文件模式
- --exclude-from=FILE 排除FILE中指定模式的文件
- --include-from=FILE 不排除FILE指定模式匹配的文件
- --version 打印版本信息
- --address 绑定到特定的地址
- --config=FILE 指定其他的配置文件，不使用默认的rsyncd.conf文件
- --port=PORT 指定其他的rsync服务端口
- --blocking-io 对远程shell使用阻塞IO
- -stats 给出某些文件的传输状态
- --progress 在传输时现实传输过程
- --log-format=formAT 指定日志文件格式
- --password-file=FILE 从FILE中得到密码
- --bwlimit=KBPS 限制I/O带宽，KBytes per second
- -h, --help 显示帮助信息

```
[root@master01 cmz]# ls
caimengzhi  master.txt
[root@master01 cmz]# mkdir aa bb
[root@master01 cmz]# tree .
.
├── aa
├── bb
├── caimengzhi
│   └── hosts
└── master.txt

3 directories, 2 files
[root@master01 cmz]# rsync -avz caimengzhi/ aa/  # 源文件后加/，就复制源文件里面文件到目标文件下
sending incremental file list
./
hosts

sent 210 bytes  received 38 bytes  496.00 bytes/sec
total size is 266  speedup is 1.07
[root@master01 cmz]# rsync -avz caimengzhi bb/ # 源文件后不加/，就复制源文件和源文件下文件到目标文件下
sending incremental file list
caimengzhi/
caimengzhi/hosts

sent 229 bytes  received 39 bytes  536.00 bytes/sec
total size is 266  speedup is 0.99
[root@master01 cmz]# tree .
.
├── aa
│   └── hosts
├── bb
│   └── caimengzhi
│       └── hosts
├── caimengzhi
│   └── hosts
└── master.txt

4 directories, 4 files
```

> 目标文件后面有没有/都没有影响，主要是源文件后面的/

```
目标文件和源文件都在一个机器上，也就是同机器上的文件拷贝.
[root@master01 cmz]# rsync -avz caimengzhi /tmp/
sending incremental file list
caimengzhi/
caimengzhi/hosts

sent 229 bytes  received 39 bytes  536.00 bytes/sec
total size is 266  speedup is 0.99
[root@master01 cmz]# ls /tmp/caimengzhi/
hosts
```

> 类似`cp`，只不过能增量复制。	

````
删除文件的特殊例子 --delete，怎么能快速删除海量文件，
[root@master01 cmz]# mkdir null aa
[root@master01 cmz]# touch aa/{1..100000}.txt
[root@master01 cmz]# ls
aa  null
[root@master01 cmz]# ll aa|wc -l
100001
[root@master01 cmz]# rsync -abz --delete null/ aa/
--delete 使aa目录下内容要和控目录null保持一致，不同的文件及目录将会呗删除，即null里面有什么内容，aa里面就有什么内容，null里面没有的，aa里面必须要删除，因为null目录为空，因此会删除aa目录下所有内容。


对比删除时间
[root@master01 cmz]# touch aa/{1..100000}.txt
[root@master01 cmz]# time rsync -abz --delete null/ aa/

real	0m6.731s
user	0m0.242s
sys	0m5.141s
[root@master01 cmz]# touch aa/{1..100000}.txt
[root@master01 cmz]# time rm -rf aa/

real	0m6.647s
user	0m0.178s
sys	0m6.276s
因为文件比较少，差异不是那么明显
````

```
远程推送
	1. 文件推送
	[root@master01 cmz]# rsync -avz 1.txt 2.txt 3.txt  root@192.168.5.110:/tmp/
    root@192.168.5.110's password: 
    sending incremental file list
    1.txt
    2.txt
    3.txt

    sent 188 bytes  received 73 bytes  104.40 bytes/sec
    total size is 0  speedup is 0.00
	
	2. 文件夹推送
	[root@master01 cmz]# rsync -avz aa  root@192.168.5.110:/tmp/
    root@192.168.5.110's password: 
    sending incremental file list
    aa/
    aa/1.txt
    aa/2.txt
    aa/3.txt

    sent 216 bytes  received 77 bytes  83.71 bytes/sec
    total size is 0  speedup is 0.00
	
	源目录后面没有/，就是推送目录。源目录后面有/，就是推送目录下文件及目录

远程拉取
	1. 拉取文件
	[root@master01 cmz]# ls
    1.txt  2.txt  3.txt  aa
    [root@master01 cmz]# rm -rf *  # 删除文件
    [root@master01 cmz]# ls
    [root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/{1,2,3}.txt .
    root@192.168.5.110's password: 
    receiving incremental file list
    1.txt
    2.txt
    3.txt

    sent 81 bytes  received 185 bytes  106.40 bytes/sec
    total size is 0  speedup is 0.00
	[root@master01 cmz]# ls 
	1.txt  2.txt  3.txt   # 可见文件已经被拉取过来了
	
	2. 拉取目录
	[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa .
    root@192.168.5.110's password: 
    receiving incremental file list
    aa/
    aa/1.txt
    aa/2.txt
    aa/3.txt

    sent 85 bytes  received 216 bytes  120.40 bytes/sec
    total size is 0  speedup is 0.00
    [root@master01 cmz]# ll
    total 0
    -rw-r--r-- 1 root root  0 May  7 22:41 1.txt
    -rw-r--r-- 1 root root  0 May  7 22:41 2.txt
    -rw-r--r-- 1 root root  0 May  7 22:41 3.txt
    drwxr-xr-x 2 root root 45 May  7 22:41 aa
    [root@master01 cmz]# tree a
    a [error opening dir]

    0 directories, 0 files
    [root@master01 cmz]# tree aa
    aa
    ├── 1.txt
    ├── 2.txt
    └── 3.txt

    0 directories, 3 files
	
	效果一样，源目录下后加/，就同步源目录下文件及目录
	[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
    root@192.168.5.110's password: 
    receiving incremental file list
    ./
    1.txt
    2.txt
    3.txt

    sent 84 bytes  received 203 bytes  114.80 bytes/sec
    total size is 0  speedup is 0.00
    [root@master01 cmz]# ls
    1.txt  2.txt  3.txt
```

> `rsync`和`scp`都可以远程同步数据，scp是全量拷贝。而rsync可以是增量拷贝。

```
[root@master01 cmz]# rm -rf *
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list
./
1.txt
2.txt
3.txt

sent 84 bytes  received 203 bytes  114.80 bytes/sec
total size is 0  speedup is 0.00
[root@master01 cmz]# ls
1.txt  2.txt  3.txt
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list

sent 20 bytes  received 88 bytes  43.20 bytes/sec
total size is 0  speedup is 0.00
和本地一样就不拷贝了。
去远程机器上，增加一个文件。再次拷贝一下，
root@leco:/tmp# cd aa/
root@leco:/tmp/aa# cp /etc/hosts .
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list
./
hosts

sent 46 bytes  received 373 bytes  167.60 bytes/sec
total size is 387  speedup is 0.92

改变源文件数据
root@leco:/tmp/aa# ls
1.txt  2.txt  3.txt  hosts
root@leco:/tmp/aa# echo "1111">1.txt 
[root@master01 cmz]# rsync -avz root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
receiving incremental file list
1.txt

sent 43 bytes  received 167 bytes  84.00 bytes/sec
total size is 392  speedup is 1.87
可见只同步有差异的数据，
---------------------------------------------------------------------------------------------------
[root@master01 cmz]# scp -r  root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
1.txt                           100%    5     4.3KB/s   00:00    
hosts                           100%  387   237.5KB/s   00:00    
3.txt                           100%    0     0.0KB/s   00:00    
2.txt                           100%    0     0.0KB/s   00:00    
[root@master01 cmz]# scp -r  root@192.168.5.110:/tmp/aa/ .
root@192.168.5.110's password: 
1.txt                           100%    5     6.4KB/s   00:00    
hosts                           100%  387   322.5KB/s   00:00    
3.txt                           100%    0     0.0KB/s   00:00    
2.txt                           100%    0     0.0KB/s   00:00   
可见scp复制数据，都是全量的。不管你本地有没有，都给你再拷贝一遍过来。
```

> 不管是`rsync`还是`scp`都是基于ssh通道，所有输入的密码就是ssh对应的账号密码。

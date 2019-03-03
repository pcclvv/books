<center><h1> OS 模块 </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; 在自动化测试中，经常需要查找操作文件，比如说查找配置文件（从而读取配置文件的信息），查找测试报告（从而发送测试报告邮件），经常要对大量文件和大量路径进行操作，这就依赖于os模块，所以今天整理下比较常用的几个方法。网上这方面资料也很多，每次整理，只是对自己所学的知识进行梳理，从而加深对某个模块的使用。 

```
os.remove(‘path/filename’) 删除文件

os.rename(oldname, newname) 重命名文件

os.walk() 生成目录树下的所有文件名

os.chdir('dirname') 改变目录

os.mkdir/makedirs('dirname')创建目录/多层目录

os.rmdir/removedirs('dirname') 删除目录/多层目录

os.listdir('dirname') 列出指定目录的文件

os.getcwd() 取得当前工作目录

os.chmod() 改变目录权限

os.path.basename(‘path/filename’) 去掉目录路径，返回文件名

os.path.dirname(‘path/filename’) 去掉文件名，返回目录路径

os.path.join(path1[,path2[,...]]) 将分离的各部分组合成一个路径名

os.path.split('path') 返回( dirname(), basename())元组

os.path.splitext() 返回 (filename, extension) 元组

os.path.getatime\ctime\mtime 分别返回最近访问、创建、修改时间

os.path.getsize() 返回文件大小

os.path.exists() 是否存在

os.path.isabs() 是否为绝对路径

os.path.isdir() 是否为目录

os.path.isfile() 是否为文件
```

## 2. 当前路径
&#160; &#160; &#160; &#160; os.getcwd()：查看当前所在路径。
```
In [1]: import os

In [2]: os.getcwd()
Out[2]: '/root/book/books'

In [3]: os.getcwdb()
Out[3]: b'/root/book/books'
```

## 3. 列举文件
&#160; &#160; &#160; &#160; os.listdir(path):列举目录下的所有文件。返回的是列表类型。

```
In [4]: os.listdir()
Out[4]: ['docs', 'README.md', 'site', '.2.21.mkdocs.yml.ok', '.git', 'mkdocs.yml']
```

## 4. 绝对路径
&#160; &#160; &#160; &#160;os.path.abspath(path):返回path的绝对路径。

```
In [14]: os.path.abspath('.')
Out[14]: '/root/book/books'

In [15]: os.path.abspath('..')
Out[15]: '/root/book'

In [16]: os.path.abspath('/usr/local/src')
Out[16]: '/usr/local/src'

```

## 5. 文件名
&#160; &#160; &#160; &#160;os.path.basename(path):返回path中的文件名。

```
In [18]: os.path.basename('/usr/local/src/name.txt')
Out[18]: 'name.txt'

In [19]: os.path.basename('.')
Out[19]: '.'

```

## 6. 文件父路径
&#160; &#160; &#160; &#160; os.path.dirname(path):返回path中的文件夹部分，结果不包含'\'

```
In [23]: os.path.dirname('.')
Out[23]: ''

In [24]: os.path.dirname('/usr/local/src/cmz.log')
Out[24]: '/usr/local/src'

```

## 7. 文件大小
&#160; &#160; &#160; &#160;os.path.getsize(path):文件或文件夹的大小，若是文件夹返回0。

```
In [39]: os.path.getsize('mkdocs.yml')
Out[39]: 13843

root@leco:~/book/books# du -sh mkdocs.yml
16K	mkdocs.yml
```

## 8. 文件路径分割
&#160; &#160; &#160; &#160;os.path.split(path):将路径分解为(文件夹,文件名)，返回的是元组类型。可以看出，若路径字符串最后一个字符是/,则只有文件夹部分有值；若路径字符串中均无/,则只有文件名部分有值。若路径字符串有/，且不在最后，则文件夹和文件名均有值。且返回的文件夹的结果不包含/.

```
In [25]: os.path.split('/usr/local/src/cmz.log')
Out[25]: ('/usr/local/src', 'cmz.log')

In [26]: os.path.split('/opt/cmz.log')
Out[26]: ('/opt', 'cmz.log')


In [27]: os.path.split('/usr/local/src/')
Out[27]: ('/usr/local/src', '')

In [28]: os.path.split('/usr/local/src')
Out[28]: ('/usr/local', 'src')
```

## 9. 文件路径拼接
&#160; &#160; &#160; &#160;os.path.join(path1,path2,...):将path进行组合，若其中有绝对路径，则之前的path将被删除。

```
In [31]: os.path.join('/a','cmz.txt')
Out[31]: '/a/cmz.txt'

In [32]: os.path.join('/a','/b','cmz.txt')
Out[32]: '/b/cmz.txt'

In [33]: os.path.join('/a','/b','/c','cmz.txt')
Out[33]: '/c/cmz.txt'

In [34]: os.path.join('/usr/local/src','cmz.txt')
Out[34]: '/usr/local/src/cmz.txt'

In [35]: os.path.join('a','b','c','cmz.txt')
Out[35]: 'a/b/c/cmz.txt'
```

## 10. 查看文件是否存在
&#160; &#160; &#160; &#160;os.path.exists(path):文件或文件夹是否存在，返回True 或 False。

```
In [2]: os.path.exists('mkdocs.yml')
Out[2]: True

In [3]: os.path.exists('mkdocs2222.yml')
Out[3]: False
```

## 11. 查看时间
&#160; &#160; &#160; &#160;
os.path.getmtime(path):文件或文件夹的最后修改时间，从新纪元到访问时的秒数。

os.path.getatime(path):文件或文件夹的最后访问时间，从新纪元到访问时的秒数。

os.path.getctime(path):文件或文件夹的创建时间，从新纪元到访问时的秒数。

```
In [5]: ls
docs/  mkdocs.yml  README.md  site/

In [6]: os.path.getmtime('mkdocs.yml')
Out[6]: 1551450797.9045475

In [7]: os.path.getatime('mkdocs.yml')
Out[7]: 1551450803.2045667

In [8]: os.path.getctime('mkdocs.yml')
Out[8]: 1551450797.9045475

```

## 12. 创建硬链接
&#160; &#160; &#160; &#160;创建硬链接，名为参数 dst，指向参数 src
```
In [18]: pwd
Out[18]: '/tmp/cmz'

In [19]: ls
hosts

In [20]: os.link('hosts','mylink_hosts')

In [21]: ls
hosts  mylink_hosts

In [22]: ll
总用量 8
-rw-r--r-- 2 root 369 3月   2 22:48 hosts
-rw-r--r-- 2 root 369 3月   2 22:48 mylink_hosts

```

## 13. 创建软链接
&#160; &#160; &#160; &#160;
```
In [21]: ls
myhosts  mylink_hosts  new_cmz/

In [22]: os.symlink('myhosts','mysoftlink_hosts')

In [23]: ll
总用量 12
-rw-r--r-- 2 root  369 3月   2 22:48 myhosts
-rw-r--r-- 2 root  369 3月   2 22:48 mylink_hosts
lrwxrwxrwx 1 root    7 3月   2 23:02 mysoftlink_hosts -> myhosts
drwxr-xr-x 3 root 4096 3月   2 22:50 new_cmz/

```

## 14. 重命名文件或者目录
&#160; &#160; &#160; &#160; os.rename(src, dst)，重命名文件或目录，从 src 到 dst
```
In [10]: ls
cmz1/  hosts  mylink_hosts

In [11]: os.rename('hosts','myhosts')

In [12]: ls
cmz1/  myhosts  mylink_hosts

In [13]: os.rename('cmz1','new_cmz')

In [14]: ls
myhosts  mylink_hosts  new_cmz/
```

## 15. 改变路径
&#160; &#160; &#160; &#160; 改变当前工作目录
```
In [24]: pwd
Out[24]: '/tmp/cmz'

In [25]: ls
myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/

In [26]: os.chdir('new_cmz')

In [27]: pwd
Out[27]: '/tmp/cmz/new_cmz'

In [28]: ls
cmz2/
```

## 16. cpu个数

```
In [36]: os.cpu_count()
Out[36]: 4
```

## 17. 公共部分
&#160; &#160; &#160; &#160; 以"/"分割，将路径分成几部分，找到公共的这一个部分。
```
In [41]: name = ['/a/b/cmz1.txt','/a/b/cmz2.txt','/a/b/cmz3.txt']

In [42]: os.path.commonpath(name)
Out[42]: '/a/b'

In [43]: name = ['/a/cmz1.txt','/b/cmz2.txt','/c/cmz3.txt']

In [44]: os.path.commonpath(name)
Out[44]: '/'

In [45]: name = ['/a/b/c/cmz1.txt','/a/b/d/cmz2.txt','/a/b/m/cmz3.txt']

In [46]: os.path.commonpath(name)
Out[46]: '/a/b'
```

## 18. 判断是否是文件
&#160; &#160; &#160; &#160; 

```
In [52]: os.path.isfile('myhosts')
Out[52]: True

In [53]: os.path.isfile('new_cmz')
Out[53]: False
```

## 19. 判断是否是文件夹
&#160; &#160; &#160; &#160; 返回true或者false

```
In [48]: ls
myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/

In [49]: os.path.isdir('myhosts')
Out[49]: False

In [50]: os.path.isdir('new_cmz')
Out[50]: True
```

## 20. 判断是否是文件夹
&#160; &#160; &#160; &#160; 判断是否 是软连接
```
In [54]: ls
myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/

In [55]: os.path.islink('myhosts')
Out[55]: False

In [56]: os.path.islink('mylink_hosts')
Out[56]: False

In [57]: os.path.islink('mysoftlink_hosts')
Out[57]: True

```

## 21. 生成单级目录

```
In [92]: ls
a/  myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/

In [93]: os.mkdir('test1')

In [94]: ls
a/  myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/  test1/

```

## 22. 生成多级目录
&#160; &#160; &#160; &#160; 类似mkdir -p a/b/c
```
In [76]: os.makedirs('a/b/c')

In [77]: ls
a/  myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/

In [78]: ls a/b/c

In [79]: ls a/b
c/
```

## 23. 删单级空目录
&#160; &#160; &#160; &#160; 删除单级空目录，若目录不为空则无法删除，报错

```
In [102]: os.mkdir('test')

In [103]: ls
a/  myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/  test/

In [105]: ls a
b/

In [106]: os.rmdir('a')
---------------------------------------------------------------------------
OSError                                   Traceback (most recent call last)
<ipython-input-106-00cb998d57ad> in <module>()
----> 1 os.rmdir('a')

OSError: [Errno 39] Directory not empty: 'a'

In [107]: os.rmdir('test')

In [108]: ls
a/  myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/
```

## 24. 删单文件
&#160; &#160; &#160; &#160; 删除一个文件。删除非文件就报错

```
In [111]: ls
a/  myhosts  mylink_hosts  mysoftlink_hosts@  new_cmz/

In [112]: os.remove('myhosts','mysoftlink_hosts')
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-112-985bdc8d4d7f> in <module>()
----> 1 os.remove('myhosts','mysoftlink_hosts')

TypeError: Function takes at most 1 positional arguments (2 given)

In [113]: os.remove('mysoftlink_hosts')

In [114]: ls
a/  myhosts  mylink_hosts  new_cmz/

```

## 25. 分离文件名和扩展名

```
In [123]: os.path.splitext('cmz.log')
Out[123]: ('cmz', '.log')

In [124]: os.path.splitext('/usr/local/src/cmz.log')
Out[124]: ('/usr/local/src/cmz', '.log')

```


## 26. 操作系统特定路径分隔符
&#160; &#160; &#160; &#160; win下为"\\",Linux下为"/"

```
In [115]: os.sep
Out[115]: '/'
```

## 27. 操作系统终止符
&#160; &#160; &#160; &#160; 输出当前平台使用的行终止符，win下为"\t\n",Linux下为"\n"

```
In [116]: os.linesep
Out[116]: '\n'
```

## 28. 分割路径的符
&#160; &#160; &#160; &#160;  win下为; , Linux下为:

```
In [117]: os.pathsep
Out[117]: ':'
```

## 29. 系统环境变量

```
In [120]: os.environ
Out[120]: environ({'SHELL': '/bin/bash', 'TERM': 'xterm', 'JRE_HOME': '/usr/lib/jvm/jdk1.8.0_40/jre', 'USER':'root', 'LS_COLORS': 'rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:','SUDO_USER': 'leco', 'SUDO_UID': '1000', 'USERNAME': 'root', 'MAIL': '/var/mail/root', 'PATH': '/usr/lib/jvm/jdk1.8.0_40/bin:/root/anaconda3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games', 'PWD': '/root', 'JAVA_HOME': '/usr/lib/jvm/jdk1.8.0_40', 'LANG': 'zh_CN.UTF-8', 'SHLVL': '1','SUDO_COMMAND': '/bin/su', 'HOME': '/root', 'LANGUAGE': 'zh_CN:zh', 'LOGNAME': 'root', 'CLASSPATH': '.:/usr/lib/jvm/jdk1.8.0_40/lib:/usr/lib/jvm/jdk1.8.0_40/jre/lib', 'LESSOPEN': '| /usr/bin/lesspipe %s', 'SUDO_GID': '1000', 'DISPLAY': 'localhost:10.0', 'LESSCLOSE': '/usr/bin/lesspipe %s %s', '_': '/usr/local/bin/ipython', 'OLDPWD': '/root/book/books'})
```

## 30. 运行shell
&#160; &#160; &#160; &#160;运行shell命令，直接显示

```
In [121]: os.system('ls')
a  myhosts  mylink_hosts  new_cmz
Out[121]: 0

In [122]: os.system('uptime')
 23:37:50 up 3 days, 14:28,  3 users,  load average: 0.15, 0.19, 0.17
Out[122]: 0
```

## 31. 文件四大权限

- os.F_OK  作为access()的mode参数，测试path是否存在. 
- os.R_OK  包含在access()的mode参数中 ， 测试path是否可读. 
- os.W_OK  包含在access()的mode参数中 ，测试path是否可写. 
- os.X_OK  包含在access()的mode参数中 ，测试path是否可执行.

```
In [130]: ls
a/  myhosts  mylink_hosts  new_cmz/

In [131]: os.access('myhosts',os.F_OK)
Out[131]: True

In [132]: os.access('myhosts',os.R_OK)
Out[132]: True

In [133]: os.access('myhosts',os.W_OK)
Out[133]: True

In [134]: os.access('myhosts',os.X_OK)
Out[134]: False
```


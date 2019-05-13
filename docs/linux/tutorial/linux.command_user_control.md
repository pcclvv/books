<center><h1>Linux命令 用户管理</h1></center>
> 作者: caimengzhi - 2019/5/13


## 7. 用户管理

### 7.1 useradd

&emsp;Linux useradd命令用于建立用户帐号。useradd可用来建立用户帐号。帐号建好之后，再用passwd设定帐号的密码．而可用userdel删除帐号。使用useradd指令所建立的帐号，实际上是保存在/etc/passwd文本文件中。

**语法**

```
useradd [-mMnr][-c <备注>][-d <登入目录>][-e <有效期限>][-f <缓冲天数>][-g <群组>][-G <群组>][-s <shell>][-u <uid>][用户帐号]
```

或

```
useradd -D [-b][-e <有效期限>][-f <缓冲天数>][-g <群组>][-G <群组>][-s <shell>]
```

**参数说明**：

- -c<备注> 　加上备注文字。备注文字会保存在passwd的备注栏位中。
- -d<登入目录> 　指定用户登入时的启始目录。
- -D 　变更预设值．
- -e<有效期限> 　指定帐号的有效期限。
- -f<缓冲天数> 　指定在密码过期后多少天即关闭该帐号。
- -g<群组> 　指定用户所属的群组。
- -G<群组> 　指定用户所属的附加群组。
- -m 　自动建立用户的登入目录。
- -M 　不要自动建立用户的登入目录。
- -n 　取消建立以用户名称为名的群组．
- -r 　建立系统帐号。
- -s<shell>　 　指定用户登入后所使用的shell。
- -u<uid> 　指定用户ID。

---

在没开始之前，我们先看一下`/etc/passwd`这个文件内容解释

```
[root@master01 home]# grep -w ^root /etc/passwd
root:x:0:0:root:/root:/bin/bash
|    | | |  |     |     |_________ shell命令目录   
|    | | |  |     |_______________ 家目录
|    | | |  |_____________________ 注释
|    | | |________________________ 用户所在组id
|    | |__________________________ 用户id
|    |____________________________ 密码
|_________________________________ 用户名
```

> 用户名:口令:用户标识号:组标识号:注释性描述:主目录:登录Shell

```
“用户名”是代表用户账号的字符串。通常长度不超过8个字符，并且由大小写字母和/或数字组成。登录名中不能有冒号(:)，因为冒号在这里是分隔符。为了兼容起见，登录名中最好不要包含点字符(.)，并且不使用连字符(-)和加号(+)打头。

“密码”一些系统中，存放着加密后的用户口令字。虽然这个字段存放的只是用户口令的加密串，不是明文，但是由于/etc/passwd文件对所有用户都可读，所以这仍是一个安全隐患。因此，现在许多Linux系统（如SVR4）都使用了shadow技术，把真正的加密后的用户口令字存放到/etc/shadow文件中，而在/etc/passwd文件的口令字段中只存放一个特殊的字符，例如“x”或者“*”。

“用户标识号”是一个整数，系统内部用它来标识用户。一般情况下它与用户名是一一对应的。如果几个用户名对应的用户标识号是一样的，系统内部将把它们视为同一个用户，但是它们可以有不同的口令、不同的主目录以及不同的登录Shell等。通常用户标识号的取值范围是0～65535。0是超级用户root的标识号，1～99由系统保留，作为管理账号，普通用户的标识号从100开始。在Linux系统中，这个界限是500。

“组标识号”字段记录的是用户所属的用户组。它对应着/etc/group文件中的一条记录。

“注释性描述”字段记录着用户的一些个人情况，例如用户的真实姓名、电话、地址等，这个字段并没有什么实际的用途。在不同的Linux系统中，这个字段的格式并没有统一。在许多Linux系统中，这个字段存放的是一段任意的注释性描述文字，用做finger命令的输出。

“主目录[家目录]”，也就是用户的起始工作目录，它是用户在登录到系统之后所处的目录。在大多数系统中，各用户的主目录都被组织在同一个特定的目录下，而用户主目录的名称就是该用户的登录名。各用户对自己的主目录有读、写、执行（搜索）权限，其他用户对此目录的访问权限则根据具体情况设置。

用户登录后，要启动一个进程，负责将用户的操作传给内核，这个进程是用户登录到系统后运行的命令解释器或某个特定的程序，即Shell。Shell是用户与Linux系统之间的接口。Linux的Shell有许多种，每种都有不同的特点。常用的有sh(BourneShell),csh(CShell),ksh(KornShell),tcsh(TENEX/TOPS20typeCShell),bash(BourneAgainShell)等。系统管理员可以根据系统情况和用户习惯为用户指定某个Shell。如果不指定Shell，那么系统使用sh为默认的登录Shell，即这个字段的值为/bin/sh。

用户的登录Shell也可以指定为某个特定的程序（此程序不是一个命令解释器）。利用这一特点，我们可以限制用户只能运行指定的应用程序，在该应用程序运行结束后，用户就自动退出了系统。有些Linux系统要求只有那些在系统中登记了的程序才能出现在这个字段中。系统中有一类用户称为伪用户（psuedousers），这些用户在Linux /etc/passwd文件中也占有一条记录，但是不能登录，因为它们的登录Shell为空。它们的存在主要是方便系统管理，满足相应的系统进程对文件属主的要求。常见的伪用户如下所示。伪用户含义bin拥有可执行的用户命令文件sys拥有系统文件adm拥有帐户文件uucpUUCP使用lplp或lpd子系统使用nobodyNFS使用拥有帐户文件除了上面列出的伪用户外，还有许多标准的伪用户，例如：audit,cron,mail,usenet等，它们也都各自为相关的进程和文件所需要。
```


家目录

```
添加一般用户
[root@master01 ~]# grep cmz /etc/passwd
[root@master01 ~]# ls /home/
[root@master01 ~]# useradd cmz
[root@master01 ~]# grep cmz /etc/passwd
cmz:x:1000:1000::/home/cmz:/bin/bash
[root@master01 ~]# ls /home/
cmz
```

> 普通创建用户的话，会默认在`/etc/passwd`文件中添加`cmz`这个用户,且在`/home/`下创建用户cmz的家目录

```
指定家目录 -d
[root@master01 ~]# ls /opt/
containerd  etcd  kubernetes
[root@master01 ~]# useradd -d /opt/cmz caimengzhi
[root@master01 ~]# ls /opt/
cmz  containerd  etcd  kubernetes
[root@master01 ~]# su - caimengzhi
[caimengzhi@master01 ~]$ pwd
/opt/cmz
[root@master01 ~]# grep caimengzhi /etc/passwd
caimengzhi:x:1000:1000::/opt/cmz:/bin/bash
```

> -d 指定家目录的位置，默认会在`/home/`目录中创建一个用户命名的文件。以后`cd ~`都会进入这个目录。

```
创建用户，不创建家目录
[root@master01 home]# grep caimengzhi /etc/passwd
[root@master01 home]# useradd -M caimengzhi
[root@master01 home]# ls 
[root@master01 home]# grep caimengzhi /etc/passwd
caimengzhi:x:1000:1000::/home/caimengzhi:/bin/bash
[root@master01 home]# su - caimengzhi
su: warning: cannot change directory to /home/caimengzhi: No such file or directory
-bash-4.2$ 
```

> 不创建家目录用户。切换到该用户，环境变量会有bash问题

```
创建用户，不能登录, -s 指定登录bash,期中如/sbin/bash,/sbin/sh,/sbin/nologin【这个不能登录系统】
[root@master01 home]# sudo useradd -s /sbin/nologin keke
[root@master01 home]# su - keke
This account is currently not available.
```

---

```
用户组，首先我们要搞清楚，什么是初始群组？简单来说在 /etc/passwd 文件中，每行的第四个字段指定的就是用户的初始群组。用户登录后立即就拥有了初始群组中的权限。
[root@master01 home]# sudo useradd tester1
[root@master01 home]# ls 
keke  tester1
没有使用任何群组相关的参数，默认在创建用户 tester1 的同时会创建一个同名的群组。用户 tester1 的初始群组就是这个新建的群组。

[root@master01 home]# sudo useradd tester2 -N
[root@master01 home]# ls 
keke  tester1  tester2
[root@master01 home]# grep tester2 /etc/passwd
tester2:x:1002:100::/home/tester2:/bin/bash
这次我们使用了 -N 选项，即不要生成与用户同名的群组。查看下 /etc/passwd 文件，发现 tester2 用户的初始群组ID是100。这个100是哪来的？有ID为100的群组吗？其实100作为 -N 的默认值是写在配置文件中的。不管有没有ID为100的群组，都是这个值。当然我们也可以通过修改配置文件来改变这个默认值！

[root@master01 home]# sudo useradd tester3 -g root
[root@master01 home]# ls /home/
keke  tester1  tester2  tester3
[root@master01 home]# grep tester3 /etc/passwd
tester3:x:1003:0::/home/tester3:/bin/bash
root是一个非常有权势的群组，我决定把 tester3 加入到这个群组。好，现在去查看一下 /etc/passwd 和 /etc/group 文件，看看有没有新的群组被创建？ tester3 的初始群组又是谁？这次没有创建与 tester3 同名的群组。用户 tester3 的初始群组变成了 root。

[root@master01 home]# sudo useradd tester4 -G root
[root@master01 home]# grep tester4 /etc/passwd
tester4:x:1004:1004::/home/tester4:/bin/bash
[root@master01 home]# grep tester4 /etc/shadow
shadow   shadow-  
[root@master01 home]# grep tester4 /etc/shadow
tester4:!!:18029:0:99999:7:::
[root@master01 home]# grep tester4 /etc/group 
root:x:0:tester4
tester4:x:1004:
和上一条命令相比我们只是把小写的g替换成了大写的G。但结果可相差太多了，请您一定要好好的检查 /etc/passwd 和 /etc/group 文件。因为这次不仅创建了群组 tester4，它还是用户 tester4 的初始群组。和tester1 的唯一不同是 tester4 被加入了 root 群组。

查看组
[root@master01 home]# groups tester1
tester1 : tester1
[root@master01 home]# groups tester2
tester2 : users
[root@master01 home]# groups tester3
tester3 : root
[root@master01 home]# groups tester4
tester4 : tester4 root

在实际的使用中，tester3 和 tester4 的场景都是比较常见的，需要根据实际情况进行区分。
```

```
添加用户时候带注释注释
[root@master01 home]# useradd -c '我是leco用户备注'  leco
[root@master01 home]# grep leco /etc/passwd
leco:x:1005:1005:我是leco用户备注:/home/leco:/bin/bash
```

指定用户有效期 `-e`

```
新增用户cc，且账户过期时间为`2019-05-14`
[root@master01 ~]# useradd -e '2019/5/14' cc 
查看用户信息
[root@master01 ~]# chage -l cc
Last password change					: May 13, 2019
Password expires					: never
Password inactive					: never
Account expires						: May 14, 2019  <----- 账户有效期
Minimum number of days between password change		: 0 
Maximum number of days between password change		: 99999
Number of days of warning before password expires	: 7

[root@master01 ~]# date -s '2019/05/15'  # 修改当前系统时间
Wed May 15 00:00:00 CST 2019
[root@master01 ~]# date
Wed May 15 00:00:02 CST 2019
[root@master01 ~]# passwd cc             # 设置cc用户密码，方便后面使用cc账户登录
Changing password for user cc.
New password: 
BAD PASSWORD: The password is a palindrome
Retype new password: 
passwd: all authentication tokens updated successfully.

先查看当前系统时间，然后使用cc账户登录当前系统，
[root@master01 ~]# date
Wed May 15 00:03:02 CST 2019
[root@master01 ~]# ssh cc@192.168.5.100
cc@192.168.5.100's password: 
Your account has expired; please contact your system administrator
Authentication failed.
此时登录被拒接，显示该账户已经过期了，需要联系系统管理员。
```

```
添加用户指定uid值
[root@master01 ~]# useradd -u 8888 loocha
[root@master01 ~]# grep loocha /etc/passwd
loocha:x:8888:8888::/home/loocha:/bin/bash
```

> UID是系统中用来表示用户的标识符，启动的进程的uid就是当前登录用户的uid，
>
> 查看用户uid可使用`id -u <username>`命令，uid不允许重复
>
> uid=0的用户是超级管理员用户，一般系统uid的等于0的用户默认名字是root

useradd 默认值

```
上面的示例可以让我们了解到，系统其实已经规范好了一些新增用户时的参数了，像我没有指定用户的家目录，也没有指定用户的 UID 和 GID 可是系统会帮我们为用户加上，同时其默认shell被设置成了 /bin/bash ，也让我知道了，使用 useradd 命令一定要有 root 权限。那么， useradd 去新增用户时，其默认值是多少呢？

使用上面所说的 useradd 的 -D 参数可以显示出其默认值，各位可以看出，其值完全与 /etc/default/useradd 这个文件里面的内容相同。原来在 linux 中使用 useradd 去新增用户时，一些在 /etc/passwd 中的值是会去参考 /etc/default/useradd 这个文件的。其文件内容基本如下：

# useradd defaults file
# 默认的用户组
GROUP=100
# 家目录的地址
HOME=/home 
# 密码过期的宽限时间，对应 /etc/shadow 的第七栏
INACTIVE=-1             
# 账号失效日期，对应 /etc/shadow 的第八栏
EXPIRE=                 
# 默认使用的shell
SHELL=/bin/bash          
# 用户家目录里面的内容参照文件(里面基本上全为隐藏文件——>以“.”开头的文件)
SKEL=/etc/skel            
# 建立使用者的mailbox
CREATE_MAIL_SPOOL=yes
```

### 7.2 usermod

&emsp;Linux usermod命令用于修改用户帐号。usermod可用来修改用户帐号的各项设定。

**密码**

```
usermod [-LU][-c <备注>][-d <登入目录>][-e <有效期限>][-f <缓冲天数>][-g <群组>][-G <群组>][-l <帐号名称>][-s <shell>][-u <uid>][用户帐号]
```

**参数说明**：

- -c<备注> 　修改用户帐号的备注文字。
- -d登入目录> 　修改用户登入时的目录。
- -e<有效期限> 　修改帐号的有效期限。
- -f<缓冲天数> 　修改在密码过期后多少天即关闭该帐号。
- -g<群组> 　修改用户所属的群组。
- -G<群组> 　修改用户所属的附加群组。
- -l<帐号名称> 　修改用户帐号名称。
- -L 　锁定用户密码，使密码无效。
- -s<shell> 　修改用户登入后所使用的shell。
- -u<uid> 　修改用户ID。
- -U 　解除密码锁定。

```
[root@master01 ~]# useradd -c '我是用户的密码字段注释' -d /opt/summer -e '2019/05/14'  -G root -u 10000 summer
[root@master01 ~]# ls /opt/
containerd  etcd  kubernetes  summer
[root@master01 ~]# grep summer /etc/passwd
summer:x:10000:10000:我是用户的密码字段注释:/opt/summer:/bin/bash

修改备注
[root@master01 ~]# usermod -c '我是修改后的用户注释' summer
[root@master01 ~]# grep summer /etc/passwd
summer:x:10000:10000:我是修改后的用户注释:/opt/summer:/bin/bash

修改家目录位置
[root@master01 ~]# usermod -d /home/summer summer 
[root@master01 ~]# grep summer /etc/passwd
summer:x:10000:10000:我是修改后的用户注释:/home/summer:/bin/bash
[root@master01 home]# ls /home/
但是需要手动在创建一个文件，修改后，没有自动创建家目录

修改账户有效期时间
[root@master01 home]# chage -l summer
Last password change					: May 14, 2019
Password expires					: never
Password inactive					: never
Account expires						: May 14, 2019
Minimum number of days between password change		: 0
Maximum number of days between password change		: 99999
Number of days of warning before password expires	: 7
[root@master01 home]# usermod -e '2019/05/28' summer 
[root@master01 home]# chage -l summer
Last password change					: May 14, 2019
Password expires					: never
Password inactive					: never
Account expires						: May 28, 2019
Minimum number of days between password change		: 0
Maximum number of days between password change		: 99999
Number of days of warning before password expires	: 7

锁定账户
[root@master01 home]# usermod -L summer
[root@master01 home]# ssh summer@192.168.5.100
summer@192.168.5.100's password: 
Permission denied, please try again.
summer@192.168.5.100's password: 
此时密码就失效了，被禁止登录了。

解锁账户
[root@master01 home]# usermod -U summer
[root@master01 home]# ssh summer@192.168.5.100
summer@192.168.5.100's password: 
Permission denied, please try again.
summer@192.168.5.100's password: 
Last failed login: Wed May 15 00:20:23 CST 2019 from master01 on ssh:notty
There were 6 failed login attempts since the last successful login.
Last login: Wed May 15 00:18:27 2019 from master01
Could not chdir to home directory /home/summer: No such file or directory
-bash-4.2$ 
此时又可以登录了

修改用户uid
[root@master01 home]# grep summer /etc/passwd
summer:x:10000:10000:我是修改后的用户注释:/home/summer:/bin/bash
[root@master01 home]# usermod -u 9999 summer 
[root@master01 home]# grep summer /etc/passwd
summer:x:9999:10000:我是修改后的用户注释:/home/summer:/bin/bash

修改登录shell
[root@master01 home]# grep summer /etc/passwd
summer:x:9999:10000:我是修改后的用户注释:/home/summer:/bin/bash
[root@master01 home]# usermod -s /bin/sh summer
[root@master01 home]# grep summer /etc/passwd
summer:x:9999:10000:我是修改后的用户注释:/home/summer:/bin/sh
```

### 7.3 userdel

&emsp;Linux userdel命令用于删除用户帐号。userdel可删除用户帐号与相关的文件。若不加参数，则仅删除用户帐号，而不删除相关文件。

**语法**

```
userdel [-r][用户帐号]
```

**参数说明**：

- -r 　删除用户登入目录以及目录中所有文件。

```
删除用户，不删除用户家目录
[root@master01 ~]# useradd mm
[root@master01 ~]# ls /home/
mm
[root@master01 ~]# userdel mm
[root@master01 ~]# ls /home/
mm

删除用户时候，删除其家目录 -r
[root@master01 home]# useradd mm1
[root@master01 home]# ls /home/
mm1
[root@master01 home]# userdel -r mm1
[root@master01 home]# ls /home/
[root@master01 home]# 

若是当前系统有登陆的话，删除会有提示，有人在使用即将要被删除的用户
[root@master01 home]# userdel -r mm1
userdel: user mm1 is currently used by process 1533
```

### 7.4 groupadd

&emsp;每个用户都有一个用户组，系统可以对一个用户组中的所有用户进行集中管理。不同Linux 系统对用户组的规定有所不同，如Linux下的用户属于与它同名的用户组，这个用户组在创建用户时同时创建。用户组的管理涉及用户组的添加、删除和修改。组的增加、删除和修改实际上就是对/etc/group文件的更新。

**语法**

```
groupadd 选项 用户组
```

参数

- -g GID 指定新用户组的组标识号（GID）。
- -o 一般与-g选项同时使用，表示新用户组的GID可以与系统已有用户组的GID相同。

```
[root@master01 ~]# tail -1 /etc/group
cmz:x:1002:  
[root@master01 ~]# groupadd caimengzhi
[root@master01 ~]# tail -2 /etc/group
cmz:x:1002:
caimengzhi:x:1003:
```

> 此命令向系统中增加了一个新组caimengzhi，新组的组标识号是在当前已有的最大组标识号的基础上加1。

```
指定gid号
[root@master01 ~]# groupadd -g 1100 caimengzhi2
[root@master01 ~]# tail -2 /etc/group
caimengzhi:x:1003:
caimengzhi2:x:1100:
```

### 7.5 groupdel

&emsp;如果要删除一个已有的用户组，使用groupdel命令

```
groupdel 用户组
```

```
[root@master01 ~]# groupdel caimengzhi2
[root@master01 ~]# grep caimengzhi2 /etc/group
已经删除了
```

> 此命令从系统中删除组caimengzhi2。

### 7.6 groupmod 

&emsp;Linux groupmod命令用于更改群组识别码或名称。需要更改群组的识别码或名称时，可用groupmod指令来完成这项工作。

**语法**

```
groupmod [-g <群组识别码> <-o>][-n <新群组名称>][群组名称]
```

**参数**：

- -g <群组识别码> 　设置欲使用的群组识别码。
- -o 　重复使用群组识别码。
- -n <新群组名称> 　设置欲使用的群组名称。

```
修改组名
[root@master01 ~]# grep caimengzhi /etc/group
caimengzhi:x:1003:
[root@master01 ~]# groupmod -n caimengzhi2 caimengzhi
[root@master01 ~]# grep caimengzhi /etc/group
caimengzhi2:x:1003:
```

### 7.7 passwd

&emsp;Linux passwd命令用来更改使用者的密码

**语法**

```
passwd [-k] [-l] [-u [-f]] [-d] [-S] [username]
```

**必要参数**：

- -d 删除密码
- -f 强制执行
- -k 更新只能发送在过期之后
- -l 停止账号使用
- -S 显示密码信息
- -u 启用已被停止的账户
- -x 设置密码的有效期
- -g 修改群组密码
- -i 过期后停止用户账号

```
[root@master01 ~]# passwd cmz  # 设置cmz用户密码
Changing password for user cmz.
New password:                  # 输入新密码
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:           # 再次输入新密码，两次密码一致
passwd: all authentication tokens updated successfully.

显示账户密码信息
[root@master01 ~]#  passwd -S cmz
cmz PS 2019-05-13 0 99999 7 -1 (Password set, SHA512 crypt.)

删除用户密码
[root@master01 ~]# passwd -d cmz
Removing password for user cmz.
passwd: Success

锁定账户
[root@master01 ~]# passwd -l cmz
Locking password for user cmz.
passwd: Success
[root@master01 ~]# ssh cmz@192.168.5.100
cmz@192.168.5.100's password: 
Permission denied, please try again.

启用之前停用的账号
[root@master01 ~]# passwd -u cmz
Unlocking password for user cmz.
passwd: Success
[root@master01 ~]# ssh cmz@192.168.5.100
cmz@192.168.5.100's password: 
Last failed login: Mon May 13 15:33:35 CST 2019 from master01 on ssh:notty
There were 2 failed login attempts since the last successful login.
Last login: Mon May 13 15:32:50 2019 from master01
[cmz@master01 ~]$ 

设置密码有效期
[root@master01 ~]# passwd -x 1 cmz
Adjusting aging data for user cmz.
passwd: Success
[root@master01 ~]# man passwd^C
[root@master01 ~]# ssh cmz@192.168.5.100
cmz@192.168.5.100's password: 
Warning: your password will expire in 1 day
Last login: Mon May 13 15:33:42 2019 from master01
```

```
管道修改密码
[root@master01 ~]# echo "cc12345" |passwd --stdin cc
Changing password for user cc.
passwd: all authentication tokens updated successfully.
```



### 7.8 chage

&emsp;chage命令用于密码实效管理，该是用来修改帐号和密码的有效期限。它可以修改账号和密码的有效期。

**语法**

```
chage [options] user
```

命令参数：

- -m：密码可更改的最小天数。为零时代表任何时候都可以更改密码。
- -M：密码保持有效的最大天数。
- -w：用户密码到期前，提前收到警告信息的天数。
- -E：帐号到期的日期。过了这天，此帐号将不可用。
- -d：上一次更改的日期。
- -i：停滞时期。如果一个密码已过期这些天，那么此帐号将不可用。
- -l：例出当前的设置。由非特权用户来确定他们的密码或帐号何时过期。

```
修改密码保持最大天数
[root@master01 ~]# chage -l cmz
Last password change					: May 13, 2019
Password expires					: May 14, 2019
Password inactive					: never
Account expires						: never
Minimum number of days between password change		: 0
Maximum number of days between password change		: 1
Number of days of warning before password expires	: 7
[root@master01 ~]# chage -M 60 cmz
[root@master01 ~]# chage -l cmz
Last password change					: May 13, 2019
Password expires					: Jul 12, 2019
Password inactive					: never
Account expires						: never
Minimum number of days between password change		: 0
Maximum number of days between password change		: 60
Number of days of warning before password expires	: 7


[root@master01 ~]# chage -I 5 cmz
[root@master01 ~]# chage -l cmz
Last password change					: May 13, 2019
Password expires					: Jul 12, 2019
Password inactive					: Jul 17, 2019
Account expires						: never
Minimum number of days between password change		: 0
Maximum number of days between password change		: 60
Number of days of warning before password expires	: 7
在密码过期后5天，密码自动失效，这个用户将无法登陆系统了。
```

```
设置cmz用户60天后密码过期，至少7天后才能修改密码，密码过期前7天开始收到告警信息。
[root@master01 ~]#  chage -M 60 -m 7 -W 7 cmz
[root@master01 ~]# chage -l cmz
Last password change					: May 13, 2019
Password expires					: Jul 12, 2019
Password inactive					: Jul 17, 2019
Account expires						: never
Minimum number of days between password change		: 7
Maximum number of days between password change		: 60
Number of days of warning before password expires	: 7
```

```
强制新建用户第一次登陆时修改密码
[root@master01 ~]# useradd leco
[root@master01 ~]# passwd leco
Changing password for user leco.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.
[root@master01 ~]# chage -d 0 leco
[root@master01 ~]# chage -l leco
Last password change					: password must be changed
Password expires					: password must be changed
Password inactive					: password must be changed
Account expires						: never
Minimum number of days between password change		: 0
Maximum number of days between password change		: 99999
Number of days of warning before password expires	: 7
登录验证
[root@master01 ~]# ssh leco@192.168.5.100
leco@192.168.5.100's password: 
You are required to change your password immediately (root enforced)
Last login: Mon May 13 15:50:44 2019 from master01
WARNING: Your password has expired.
You must change your password now and login again!
Changing password for user leco.
Changing password for leco.
(current) UNIX password:    # 输入当前leco用户的密码
New password:               # 设置新密码
Retype new password:        # 设置新密码，两次密码一致
passwd: all authentication tokens updated successfully.
Connection to 192.168.5.100 closed.
```

### 7.9 chpasswd

&emsp;chpasswd从标准输入中读取一定格式的用户名、密码来批量更新用户的密码，其格式为“用户名：密码”。

**语法**

```
chpasswd  option
```

仅 root 用户可以用该命令设置密码。

在缺省情况下，**chpasswd** 命令设置用户的 ADMCHG 标志。**-f** 选项可以结合其他有效标志使用来覆盖缺省值。**-c** 选项清除所有密码标志。

密码字段可以为明文或者是使用加密算法加密的值。**-e** 选项表明密码是加密格式。请注意，批处理中的所有密码必须统一为相同的格式。

通过使用 **chpasswd** 命令并指定 **-R** *LDAP*，可在 ldap_auth 环境中设置 LDAP 用户密码。但是，当指定加密格式的 **-e** 选项时，**chpasswd** 命令的加密格式与 LDAP 服务器的加密格式必须匹配。

参数

- -c  清除所有密码标志
- -e  指定密码为加密格式
- -f flags 指定要设置的密码标志的逗号分隔列表。有效标志值是：ADMIN、ADMCHG 和/或 NOCHECK。有关这些值的详细信息，请参阅 **pwdadm** 命令文档。
- -R load_module 指定用于更改用户密码的可装入 I&A 模块

```
[root@master01 ~]# tail -3 /etc/passwd
cc:x:1001:1001::/home/cc:/bin/bash
cmz:x:1002:1002::/home/cmz:/bin/bash
leco:x:1003:1004::/home/leco:/bin/bash

批量修改密码
[root@master01 ~]# cat passwd.txt 
cc:cmz
cmz:cmz
leco:cmz
[root@master01 ~]# cat passwd.txt | chpasswd

测试
[root@master01 ~]# ssh cc@192.168.5.100
cc@192.168.5.100's password: 
Last failed login: Wed May 15 00:01:35 CST 2019 from master01 on ssh:notty
There was 1 failed login attempt since the last successful login.
Last login: Mon May 13 14:35:48 2019 from master01
[cc@master01 ~]$ logout
Connection to 192.168.5.100 closed.
[root@master01 ~]# ssh cmz@192.168.5.100
cmz@192.168.5.100's password: 
Last login: Mon May 13 15:36:30 2019 from master01
[cmz@master01 ~]$ logout
Connection to 192.168.5.100 closed.
[root@master01 ~]# ssh leco@192.168.5.100
leco@192.168.5.100's password: 
Last login: Mon May 13 15:50:58 2019 from master01
[leco@master01 ~]$ logout
Connection to 192.168.5.100 closed.
```

> **passwd.txt** 必须包含 username:password 对；每行一对



### 7.10 su 

&emsp;Linux su命令用于变更为其他使用者的身份，除 root 外，需要键入该使用者的密码。

使用权限：所有使用者。

**语法**

```
su [-fmp] [-c command] [-s shell] [--help] [--version] [-] [USER [ARG]]
```

**参数说明**：

- -f 或 --fast 不必读启动档（如 csh.cshrc 等），仅用于 csh 或 tcsh
- -m -p 或 --preserve-environment 执行 su 时不改变环境变数
- -c command 或 --command=command 变更为帐号为 USER 的使用者并执行指令（command）后再变回原来使用者
- -s shell 或 --shell=shell 指定要执行的 shell （bash csh tcsh 等），预设值为 /etc/passwd 内的该使用者（USER） shell
- --help 显示说明文件
- --version 显示版本资讯
- \- -l 或 --login 这个参数加了之后，就好像是重新 login 为该使用者一样，大部份环境变数（HOME SHELL USER等等）都是以该使用者（USER）为主，并且工作目录也会改变，如果没有指定 USER ，内定是 root
- USER 欲变更的使用者帐号
- ARG 传入新的 shell 参数

```
[root@master01 ~]# whoami 
root
[root@master01 ~]# su - cmz
Last login: Mon May 13 15:14:54 CST 2019 on pts/1
[cmz@master01 ~]$ whoami
cmz
[cmz@master01 ~]$ logout
[root@master01 ~]# su cmz
[cmz@master01 root]$ whoami 
cmz
```

> 切换用户 中间使用 - [横杆]，表示切换到另一个用户的时候，环境变量也会切换过去，要是没有-，表示虽然用户切换过去了，但是还是使用切换前用户的环境变量。

### 7.11 visudo

**语法**

```
visudo 编辑 sudoers 文件
```

&emsp;sudo的工作过程如下：

1. 当用户执行sudo时，系统会主动寻找/etc/sudoers文件，判断该用户是否有执行sudo的权限

2. 确认用户具有可执行sudo的权限后，让用户输入用户自己的密码确认

3. 若密码输入成功，则开始执行sudo后续的命令

4. root执行sudo时不需要输入密码(eudoers文件中有配置root ALL=(ALL) ALL这样一条规则)

5. 若欲切换的身份与执行者的身份相同，也不需要输入密码

```
检查语法
[root@master01 ~]# visudo -c
/etc/sudoers: parsed OK
```

授权

1. %用户组 机器=（授权使用哪个角色的权限） /usr/sbin/useradd

| 代授权的用户或组 | 机器=（授权角色） | 可以执行的命令    |
| ---------------- | ----------------- | ----------------- |
| user             | MACHINE=          | COMMANDS          |
| cmz              | ALL=（ALL）       | /usr/sbin/useradd |

### 7.12 sudo 

&emsp;Linux sudo命令以系统管理者的身份执行指令，也就是说，经由 sudo 所执行的指令就好像是 root 亲自执行。

使用权限：在 /etc/sudoers 中有出现的使用者。

**语法**

```
sudo -V
sudo -h
sudo -l
sudo -v
sudo -k
sudo -s
sudo -H
sudo [ -b ] [ -p prompt ] [ -u username/#uid] -s
sudo command
```

**参数说明**：

- -V 显示版本编号
- -h 会显示版本编号及指令的使用方式说明
- -l 显示出自己（执行 sudo 的使用者）的权限
- -v 因为 sudo 在第一次执行时或是在 N 分钟内没有执行（N 预设为五）会问密码，这个参数是重新做一次确认，如果超过 N 分钟，也会问密码
- -k 将会强迫使用者在下一次执行 sudo 时问密码（不论有没有超过 N 分钟）
- -b 将要执行的指令放在背景执行
- -p prompt 可以更改问密码的提示语，其中 %u 会代换为使用者的帐号名称， %h 会显示主机名称
- -u username/#uid 不加此参数，代表要以 root 的身份执行指令，而加了此参数，可以以 username 的身份执行指令（#uid 为该 username 的使用者号码）
- -s 执行环境变数中的 SHELL 所指定的 shell ，或是 /etc/passwd 里所指定的 shell
- -H 将环境变数中的 HOME （家目录）指定为要变更身份的使用者家目录（如不加 -u 参数就是系统管理者 root ）
- command 要以系统管理者身份（或以 -u 更改为其他人）执行的指令

```
[root@master01 ~]# useradd cmz
[root@master01 ~]# grep cmz /etc/sudoers
cmz	ALL=(ALL) 	ALL
[root@master01 ~]# su - cmz
[cmz@master01 ~]$ sudo yum install -y lrzsz

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for cmz: 
Loaded plugins: fastestmirror
Determining fastest mirrors
epel/x86_64/metalink                                                                                                                                                  | 6.0 kB  00:00:00     
 * base: mirrors.aliyu.........
 普通用户前面加上sudo就可以使用授权的命令了。
 
 查看该用户有哪些权限
 [cmz@master01 ~]$ sudo -l
Matching Defaults entries for cmz on master01:
    !visiblepw, always_set_home, match_group_by_gid, always_query_group_plugin, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR
    USERNAME LANG LC_ADDRESS LC_CTYPE", env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE",
    env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY", secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

User cmz may run the following commands on master01:
    (ALL) ALL

切换用户操作
[cmz@master01 ~]$ sudo -u cmz vim  /tmp/index.html
data from cmz.
以 cmz 用户身份编辑   /tmp目录下index.html 文件
[cmz@master01 ~]$ ll /tmp/index.html 
-rw-r--r-- 1 cmz cmz 15 May 13 15:05 /tmp/index.html

指定用户执行命令
[cmz@master01 ~]$ sudo -u cmz ls /tmp/
caimengzhi  cmz  epel-release-latest-7.noarch.rpm  hosts  index.html 

显示sudo用法
[cmz@master01 ~]$ sudo -L
sudo: invalid option -- 'L'
usage: sudo -h | -K | -k | -V
usage: sudo -v [-AknS] [-g group] [-h host] [-p prompt] [-u user]
usage: sudo -l [-AknS] [-g group] [-h host] [-p prompt] [-U user] [-u user] [command]
usage: sudo [-AbEHknPS] [-r role] [-t type] [-C num] [-g group] [-h host] [-p prompt] [-T timeout] [-u user] [VAR=value] [-i|-s] [<command>]
usage: sudo -e [-AknS] [-r role] [-t type] [-C num] [-g group] [-h host] [-p prompt] [-T timeout] [-u user] file ...
```



### 7.13 id

&emsp;Linux id命令用于显示用户的ID，以及所属群组的ID。

id会显示用户以及所属群组的实际与有效ID。若两个ID相同，则仅显示实际ID。若仅指定用户名称，则显示目前用户的ID。

**用法**

```
id [-gGnru][--help][--version][用户名称]
```

**参数说明**：

- -g或--group 　显示用户所属群组的ID。
- -G或--groups 　显示用户所属附加群组的ID。
- -n或--name 　显示用户，所属群组或附加群组的名称。
- -r或--real 　显示实际ID。
- -u或--user 　显示用户ID。
- -help 　显示帮助。
- -version 　显示版本信息。

```
显示当前用户信息
[root@master01 ~]# id
uid=0(root) gid=0(root) groups=0(root)

显示当前用户组
[root@master01 ~]# id -g
0

指定用户
[root@master01 ~]# grep cc /etc/passwd
cc:x:1001:1001::/home/cc:/bin/bash
[root@master01 ~]# id cc
uid=1001(cc) gid=1001(cc) groups=1001(cc)
[root@master01 ~]# id cc -g
1001
```

### 7.14 w

Linux w命令用于显示目前登入系统的用户信息。

执行这项指令可得知目前登入系统的用户有哪些人，以及他们正在执行的程序。

单独执行 w 指令会显示所有的用户，您也可指定用户名称，仅显示某位用户的相关信息。

**语法**

```
w [-fhlsuV][用户名称]
```

**参数说明**：

- -f 　开启或关闭显示用户从何处登入系统。
- -h 　不显示各栏位的标题信息列。
- -l 　使用详细格式列表，此为预设值。
- -s 　使用简洁格式列表，不显示用户登入时间，终端机阶段作业和程序所耗费的CPU时间。
- -u 　忽略执行程序的名称，以及该程序耗费CPU时间的信息。
- -V 　显示版本信息。

```
#显示当前用户，不显示登录位置
[root@master01 ~]# w
 14:54:02 up 4 days,  5:23,  3 users,  load average: 0.10, 0.27, 0.31
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0    gateway          14:19   18:18   0.10s  0.04s ssh cc@192.168.5.100
root     pts/1    gateway          00:00     ?     0.50s  0.49s -bash
cc       pts/2    master01         14:35   18:14   0.05s  0.05s -bash

# 不显示登录位置
[root@master01 ~]# w -f
 14:54:14 up 4 days,  5:23,  3 users,  load average: 0.15, 0.27, 0.31
USER     TTY        LOGIN@   IDLE   JCPU   PCPU WHAT
root     pts/0     14:19   18:30   0.10s  0.04s ssh cc@192.168.5.100
root     pts/1     00:00     ?     0.49s  0.49s -bash
cc       pts/2     14:35   18:26   0.05s  0.05s -bash

# 以精简模式显示
[root@master01 ~]# w -s
 14:54:25 up 4 days,  5:23,  3 users,  load average: 0.21, 0.28, 0.31
USER     TTY      FROM              IDLE WHAT
root     pts/0    gateway          18:41  ssh cc@192.168.5.100
root     pts/1    gateway            ?    -bash
cc       pts/2    master01         18:37  -bash
```

### 7.15 who

&emsp;Linux who命令用于显示系统中有哪些使用者正在上面，显示的资料包含了使用者 ID、使用的终端机、从哪边连上来的、上线时间、呆滞时间、CPU 使用量、动作等等。使用权限：所有使用者都可使用。

**语法**

```
who - [husfV] [user]
```

**参数说明**：

- -H 或 --heading：显示各栏位的标题信息列；
- -i 或 -u 或 --idle：显示闲置时间，若该用户在前一分钟之内有进行任何动作，将标示成"."号，如果该用户已超过24小时没有任何动作，则标示出"old"字符串；
- -m：此参数的效果和指定"am i"字符串相同；
- -q 或--count：只显示登入系统的帐号名称和总人数；
- -s：此参数将忽略不予处理，仅负责解决who指令其他版本的兼容性问题；
- -w 或-T或--mesg或--message或--writable：显示用户的信息状态栏；
- --help：在线帮助；
- --version：显示版本信息。

```
[root@master01 ~]# who  # 显示当前登录系统的用户
root     pts/0        2019-05-13 14:19 (gateway)
root     pts/1        2019-06-20 00:00 (gateway)
cc       pts/2        2019-05-13 14:35 (master01)


[root@master01 ~]# who -H # 显示标题栏
NAME     LINE         TIME             COMMENT
root     pts/0        2019-05-13 14:19 (gateway)
root     pts/1        2019-06-20 00:00 (gateway)
cc       pts/2        2019-05-13 14:35 (master01)

显示用户登录来源
[root@master01 ~]# who -l -H
NAME     LINE         TIME             IDLE          PID COMMENT
LOGIN    tty1         2019-05-09 09:29              3461 id=tty1

显示终端属性
[root@master01 ~]# who -T -H
NAME       LINE         TIME             COMMENT
root     + pts/0        2019-05-13 14:19 (gateway)
root     + pts/1        2019-06-20 00:00 (gateway)
cc       + pts/2        2019-05-13 14:35 (master01)

显示当前用户
[root@master01 ~]# who -m -H
NAME     LINE         TIME             COMMENT
root     pts/1        2019-06-20 00:00 (gateway)

精简显示
[root@master01 ~]# who -q
root root cc
# users=3
```

### 7.16 users

&emsp;users命令用于显示当前登录系统所有的用户的用户列表。每个显示的用户名对应一个登录会话。如果一个用户不止一个登录会话，会重复显示。 极少使用。

**语法**

```
user (选项）
```

- –help: 
- –version:

```
[root@master01 ~]# users
cc root root
```

### 7.17 whoami

&emsp;Linux whoami命令用于显示自身用户名称。显示自身的用户名称，本指令相当于执行`id -un`指令。

**语法**

```
whoami [--help][--version]
```

**参数说明**

- -help 　 在线帮助。
- -version 　显示版本信息。

```
[root@master01 ~]# whoami 
root
[root@master01 ~]# id
uid=0(root) gid=0(root) groups=0(root)
[root@master01 ~]# id -un
root
```

### 7.18 last

&emsp;Linux last 命令用于显示用户最近登录信息。使用权限：所有使用者。

**语法**

```
shell>> last [options]
```

**参数说明**：

- -R 省略 hostname 的栏位
- -num 展示前 num 个
- username 展示 username 的登入讯息
- tty 限制登入讯息包含终端机代号

```
[root@master01 home]# last -R -3
cc       pts/2        Mon May 13 14:35   still logged in   
mm1      pts/2        Mon May 13 14:19 - 14:35  (00:15)    
root     pts/0        Mon May 13 14:19   still logged in   

wtmp begins Tue Apr 30 03:26:17 2019
简略显示，并指定显示的个数
[root@master01 home]# last -n 3 -R
cc       pts/2        Mon May 13 14:35   still logged in   
mm1      pts/2        Mon May 13 14:19 - 14:35  (00:15)    
root     pts/0        Mon May 13 14:19   still logged in   

wtmp begins Tue Apr 30 03:26:17 2019

显示最后一列显示主机IP地址
[root@master01 home]# last -n 3 -a -i
cc       pts/2        Mon May 13 14:35   still logged in    192.168.5.100
mm1      pts/2        Mon May 13 14:19 - 14:35  (00:15)     192.168.5.100
root     pts/0        Mon May 13 14:19   still logged in    192.168.5.1

wtmp begins Tue Apr 30 03:26:17 2019
```

### 7.19 lastb

&emsp;Linux lastb命令用于列出登入系统失败的用户相关信息。单独执行lastb指令，它会读取位于/var/log目录下，名称为btmp的文件，并把该文件内容记录的登入失败的用户名单，全部显示出来。

**语法**

```
lastb [-adRx][-f <记录文件>][-n <显示列数>][帐号名称...][终端机编号...]
```

**参数说明**：

- -a 　把从何处登入系统的主机名称或IP地址显示在最后一行。
- -d 　将IP地址转换成主机名称。
- -f   <记录文件> 　指定记录文件。
- -n   <显示列数>或-<显示列数> 　设置列出名单的显示列数。
- -R 　不显示登入系统的主机名称或IP地址。
- -x 　显示系统关机，重新开机，以及执行等级的改变等信息。

```
[root@master01 home]# lastb 
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
mm1      ssh:notty    master01         Mon May 13 14:21 - 14:21  (00:00)    
mm1      ssh:notty    master01         Mon May 13 14:21 - 14:21  (00:00)    
mm1      ssh:notty    master01         Mon May 13 14:21 - 14:21  (00:00)    
summer   ssh:notty    master01         Thu Jun 20 00:00 - 00:00  (00:00)    
summer   ssh:notty    master01         Mon May 20 00:00 - 00:00  (00:00)    
summer   ssh:notty    master01         Wed May 15 00:20 - 00:20  (00:00)    
summer   ssh:notty    master01         Wed May 15 00:20 - 00:20  (00:00)    
summer   ssh:notty    master01         Wed May 15 00:20 - 00:20  (00:00)    
summer   ssh:notty    master01         Wed May 15 00:19 - 00:19  (00:00)    
summer   ssh:notty    node01           Wed May 15 00:19 - 00:19  (00:00)    
summer   ssh:notty    gateway          Wed May 15 00:19 - 00:19  (00:00)    
cc       ssh:notty    master01         Wed May 15 00:01 - 00:01  (00:00)    
cc       ssh:notty    gateway          Mon May 13 13:25 - 13:25  (00:00)    
cc       ssh:notty    gateway          Mon May 13 13:25 - 13:25  (00:00)    
cc       ssh:notty    gateway          Mon May 13 13:25 - 13:25  (00:00)    

btmp begins Mon May 13 13:25:10 2019

显示行数
[root@master01 home]# lastb -n 2
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    master01         Mon May 13 14:35 - 14:35  (00:00)    

btmp begins Mon May 13 13:25:10 2019

不显示登录主机或者IP
[root@master01 home]# lastb -R -n2
cc1      ssh:notty    Mon May 13 14:35 - 14:35  (00:00)    
cc1      ssh:notty    Mon May 13 14:35 - 14:35  (00:00)    

btmp begins Mon May 13 13:25:10 2019

[root@master01 home]# lastb x

btmp begins Mon May 13 13:25:10 2019
```

### 7.20 lastlog

&emsp;检查某用户上次登录时间。

**用法**

```
lastlog [参数] [用户]
```

- -u 数字 ：表示查看第几个用户
- -u 0 ：表示查看系统用户root的最后登录信息

```
查看系统登录时间
[root@master01 home]# grep cc /etc/passwd
cc:x:1001:1001::/home/cc:/bin/bash
[root@master01 home]# lastlog -u 1001
Username         Port     From             Latest
cc               pts/2    master01         Mon May 13 14:35:48 +0800 2019

[root@master01 home]# lastlog -u 0
Username         Port     From             Latest
root             pts/0    gateway          Mon May 13 14:19:32 +0800 2019
```

```
root用户ID是0.从1~499的大多是系统服务或软件厂商自定议的ID。而普通的用户的UID是从500开始往后依次+1
```

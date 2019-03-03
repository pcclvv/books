<center><h1> Python 虚拟环境之virtualenvwrapper </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; virtualenv 的一个最大的缺点就是：每次开启虚拟环境之前要去虚拟环境所在目录下的 bin 目录下 source 一下 activate，这就需要我们记住每个虚拟环境所在的目录。并且还有可能你忘记了虚拟环境放在哪。

&#160; &#160; &#160; &#160;一种可行的解决方案是，将所有的虚拟环境目录全都集中起来，例如/opt/all_venv/，并且针对不同的目录做不同的事。
使用virtualenvwrapper管理你的虚拟环境（virtualenv），其实他就是统一管理虚拟环境的目录，并且省去了source的步骤。

```
列出虚拟环境列表:  workon | lsvirtualenv 
新建虚拟环境:      mkvirtualenv [虚拟环境名称]
启动/切换虚拟环境: workon [虚拟环境名称]
删除虚拟环境:      rmvirtualenv [虚拟环境名称]
```

## 2 virtualenvwrapper 
### 2.1 安装
```
pip install virtualenvwrapper        # linux 使用该命令

pip install virtualenvwrapper-win　　# Windows使用该命令
```
&#160; &#160; &#160; &#160;此时还不能使用virtualenvwrapper，默认virtualenvwrapper安装在/usr/local/bin下面，实际上需要运行virtualenvwrapper.sh文件才行。修改~/.bashrc，添加以下语句

### 2.2 配置环境变量
#### 2.2.1 虚拟环境家目录

```
sudo mkdir -p $WORKON_HOME
```
#### 2.2.2 添加配置
在~/.bashrc中最后添加
```
export WORKON_HOME=$HOME/.virtualenvs             # 所有虚拟环境的家目录
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3  # 指定虚拟环境的python
source /usr/local/bin/virtualenvwrapper.sh    
```

```
root@leco:~/book/books/docs/python/tools# source ~/.bashrc
virtualenvwrapper.user_scripts creating /root/.virtualenvs/premkproject
virtualenvwrapper.user_scripts creating /root/.virtualenvs/postmkproject
virtualenvwrapper.user_scripts creating /root/.virtualenvs/initialize
virtualenvwrapper.user_scripts creating /root/.virtualenvs/premkvirtualenv
virtualenvwrapper.user_scripts creating /root/.virtualenvs/postmkvirtualenv
virtualenvwrapper.user_scripts creating /root/.virtualenvs/prermvirtualenv
virtualenvwrapper.user_scripts creating /root/.virtualenvs/postrmvirtualenv
virtualenvwrapper.user_scripts creating /root/.virtualenvs/predeactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/postdeactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/preactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/postactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/get_env_details
```
此时virtualenvwrapper就可以使用了。


```
root@leco:/home/leco# ls $HOME/.virtualenvs
get_env_details  postactivate    postmkproject     postrmvirtualenv  predeactivate  premkvirtualenv  zqxt
initialize       postdeactivate  postmkvirtualenv  preactivate       premkproject   prermvirtualenv
root@leco:/home/leco#
```


### 2.3 案例

```
# 1. 安装虚拟环境 mkvirtualenv [虚拟环境名称]
root@leco:~/book/books/docs/python/tools# mkvirtualenv cmz
Using base prefix '/usr/local'
New python executable in /root/.virtualenvs/cmz/bin/python3.6
Also creating executable in /root/.virtualenvs/cmz/bin/python
Installing setuptools, pip, wheel...done.
virtualenvwrapper.user_scripts creating /root/.virtualenvs/cmz/bin/predeactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/cmz/bin/postdeactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/cmz/bin/preactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/cmz/bin/postactivate
virtualenvwrapper.user_scripts creating /root/.virtualenvs/cmz/bin/get_env_details

#2. 查看虚拟环境
(cmz) root@leco:~/book/books/docs/python/tools# workon
cmz
zqxt
(cmz) root@leco:~/book/books/docs/python/tools# lsvirtualenv
cmz
===


zqxt
====


# 3. 切换到虚拟环境
root@leco:/home/leco# workon
cmz
zqxt
root@leco:/home/leco# workon cmz
(cmz) root@leco:/home/leco#

# 4. 删除虚拟环境
root@leco:/home/leco# workon # 查看虚拟环境
cmz
zqxt
root@leco:/home/leco# rmvirtualenv cmz  # 删除虚拟环境
Removing cmz...
root@leco:/home/leco# workon
zqxt

# 5. 退出虚拟环境
(cmz) root@leco:/home/leco# deactivate
root@leco:/home/leco#
退出虚拟环境后，前面虚拟环境名字也消失了。
```


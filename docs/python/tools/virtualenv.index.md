<center><h1> Python 虚拟环境之virtualenv </h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160; 为什么要使用虚拟环境？随着你的 Python 项目越来越多，你会发现不同的项目会需要 不同的版本的 Python 库。同一个 Python 库的不同版本可能不兼容。

&#160; &#160; &#160; &#160; 虚拟环境可以为每一个项目安装独立的 Python 库，这样就可以隔离不同项目之间的 Python 库，也可以隔离项目与操作系统之间的 Python 库。

&#160; &#160; &#160; &#160; Python 3 内置了用于创建虚拟环境的 venv 模块。如果你使用的是较新的 Python 版本，那么请接着阅读本文下面的内容。

## 2 virtualenv 
### 2.1 安装
```
# Debian, Ubuntu
sudo apt-get install python-virtualenv

# CentOS, Fedora
sudo yum install python-virtualenv
```

### 2.2 帮助
```
root@leco:~/code/env# virtualenv --help
Usage: virtualenv [OPTIONS] DEST_DIR

Options:
  --version             show program's version number and exit
  -h, --help            show this help message and exit
  -v, --verbose         Increase verbosity.
  -q, --quiet           Decrease verbosity.
  -p PYTHON_EXE, --python=PYTHON_EXE
                        The Python interpreter to use, e.g.,
                        --python=python3.5 will use the python3.5 interpreter
                        to create the new environment.  The default is the
                        interpreter that virtualenv was installed with
                        (/usr/local/bin/python3.6)
  --clear               Clear out the non-root install and start from scratch.
  --no-site-packages    DEPRECATED. Retained only for backward compatibility.
                        Not having access to global site-packages is now the
                        default behavior.
  --system-site-packages
                        Give the virtual environment access to the global
                        site-packages.
  --always-copy         Always copy files rather than symlinking.
  --relocatable         Make an EXISTING virtualenv environment relocatable.
                        This fixes up scripts and makes all .pth files
                        relative.
  --no-setuptools       Do not install setuptools in the new virtualenv.
  --no-pip              Do not install pip in the new virtualenv.
  --no-wheel            Do not install wheel in the new virtualenv.
  --extra-search-dir=DIR
                        Directory to look for setuptools/pip distributions in.
                        This option can be used multiple times.
  --download            Download preinstalled packages from PyPI.
  --no-download, --never-download
                        Do not download preinstalled packages from PyPI.
  --prompt=PROMPT       Provides an alternative prompt prefix for this
                        environment.
  --setuptools          DEPRECATED. Retained only for backward compatibility.
                        This option has no effect.
  --distribute          DEPRECATED. Retained only for backward compatibility.
                        This option has no effect.
  --unzip-setuptools    DEPRECATED.  Retained only for backward compatibility.
                        This option has no effect.
```
### 2.3 案例

```
root@leco:~/code/env# ls

# 1. 安装Python2的虚拟环境
root@leco:~/code/env# virtualenv -p `which python2` env2
Running virtualenv with interpreter /usr/bin/python2
New python executable in /root/code/env/env2/bin/python2
Also creating executable in /root/code/env/env2/bin/python
Installing setuptools, pip, wheel...done.

# 2. 安装python3的虚拟环境
root@leco:~/code/env# virtualenv -p `which python3` env3
Running virtualenv with interpreter /usr/local/bin/python3
Using base prefix '/usr/local'
New python executable in /root/code/env/env3/bin/python3
Also creating executable in /root/code/env/env3/bin/python
Installing setuptools, pip, wheel...done.
root@leco:~/code/env# ls
env2  env3

# 3. 激活
root@leco:~/code/env# source env3/bin/activate

# 4. 安装包[安装后的就在这个当前虚拟环境中]
# 激活好虚拟环境，前面会多个虚拟环境的名字
(env3) root@leco:~/code/env# pip install flask
Collecting flask
  Using cached https://files.pythonhosted.org/packages/7f/e7/08578774ed4536d3242b14dacb4696386634607af824ea997202cd0edb4b/Flask-1.0.2-py2.py3-none-any.whl
Collecting Jinja2>=2.10 (from flask)
  Using cached https://files.pythonhosted.org/packages/7f/ff/ae64bacdfc95f27a016a7bed8e8686763ba4d277a78ca76f32659220a731/Jinja2-2.10-py2.py3-none-any.whl
Collecting click>=5.1 (from flask)
  Using cached https://files.pythonhosted.org/packages/fa/37/45185cb5abbc30d7257104c434fe0b07e5a195a6847506c074527aa599ec/Click-7.0-py2.py3-none-any.whl
Collecting Werkzeug>=0.14 (from flask)
  Using cached https://files.pythonhosted.org/packages/20/c4/12e3e56473e52375aa29c4764e70d1b8f3efa6682bef8d0aae04fe335243/Werkzeug-0.14.1-py2.py3-none-any.whl
Collecting itsdangerous>=0.24 (from flask)
  Using cached https://files.pythonhosted.org/packages/76/ae/44b03b253d6fade317f32c24d100b3b35c2239807046a4c953c7b89fa49e/itsdangerous-1.1.0-py2.py3-none-any.whl
Collecting MarkupSafe>=0.23 (from Jinja2>=2.10->flask)
  Downloading https://files.pythonhosted.org/packages/b2/5f/23e0023be6bb885d00ffbefad2942bc51a620328ee910f64abe5a8d18dd1/MarkupSafe-1.1.1-cp36-cp36m-manylinux1_x86_64.whl
Installing collected packages: MarkupSafe, Jinja2, click, Werkzeug, itsdangerous, flask
Successfully installed Jinja2-2.10 MarkupSafe-1.1.1 Werkzeug-0.14.1 click-7.0 flask-1.0.2 itsdangerous-1.1.0

# 4. 查看当前虚拟环境的安装的包
(env3) root@leco:~/code/env# pip list
Package      Version
------------ -------
Click        7.0
Flask        1.0.2
itsdangerous 1.1.0
Jinja2       2.10
MarkupSafe   1.1.1
pip          19.0.3
setuptools   40.8.0
Werkzeug     0.14.1
wheel        0.33.1

# 5. 导出安装包
(env3) root@leco:~/code/env# pip list >requirements.txt  # 这个文件名随便，默认是这个
有的版本是pip3 freeze > requirements.txt 

(env3) root@leco:~/code/env# cat requirements.txt
Package      Version
------------ -------
Click        7.0
Flask        1.0.2
itsdangerous 1.1.0
Jinja2       2.10
MarkupSafe   1.1.1
pip          19.0.3
setuptools   40.8.0
Werkzeug     0.14.1
wheel        0.33.1
这将会创建一个 requirements.txt 文件，其中包含了当前环境中所有包及 各自的版本的简单列表。
可以使用 “pip list”在不产生requirements文件的情况下， 查看已安装包的列表。

# 6. 还原环境，
pip install -r requirements.txt

# 7. 退出虚拟环境
(env3) root@leco:~/code/env# deactivate
root@leco:~/code/env#
退出虚拟环境后，前面虚拟环境名字也消失了。
```


## 3. 在外部向程序内部传递参数

```
root@leco:~/code/sys# cat demo1.py
import sys

print(sys.argv)      # 参数列表，返回是列表
print(len(sys.argv)) # 参数个数
print(sys.argv[0])   # 脚本名
print(sys.argv[1])   # 第一个参数
root@leco:~/code/sys# python demo1.py 1 2
['demo1.py', '1', '2']
3
demo1.py
1
```

## 4. 退出
&#160; &#160; &#160; &#160;执行到主程序末尾，解释器自动退出，但是如果需要中途退出程序，可以调用sys.exit函数，带有一个可选的整数参数返回给调用它的程序，表示你可以在主程序中捕获对sys.exit的调用。（0是正常退出，其他为异常）

```
In [1]: import sys

In [2]: sys.exit(0)
An exception has occurred, use %tb to see the full traceback.

SystemExit: 0

/usr/local/lib/python3.6/site-packages/IPython/core/interactiveshell.py:2918: UserWarning: To exit: use 'exit', 'quit', or Ctrl-D.
  warn("To exit: use 'exit', 'quit', or Ctrl-D.", stacklevel=1)

In [3]: sys.exit(1)
An exception has occurred, use %tb to see the full traceback.

```

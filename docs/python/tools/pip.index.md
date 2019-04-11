<center><h1>pip 更新源</h1></center>

## 1. 介绍

由于天朝的原因，我们使用pip 安装的时候。联网有时候会比较慢或者直接forbidden。我们此时就需要配置使用国内的源。pip源类似yum源、或者apt-get源

## 2. 优点
国内清华源,豆瓣源。都是很不错的源

## 3. 清华源配置
### 3.1 临时配置
```
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
```
> 注意，simple 不能少, 是 https 而不是 http


### 3.2 永久配置
升级 pip 到最新的版本 (>=10.0.0) 后进行配置：

```
pip install pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```
如果您到 pip 默认源的网络连接较差，临时使用本镜像站来升级 pip：
```
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
```

## 4. 豆瓣源配置
### 4.1 临时配置
```
sudo pip install -i http://pypi.douban.com/simple/ --trusted-host=pypi.douban.com/simple ipython
```
### 4.2 永久配置
linux
```
$HOME/.config/pip/pip.conf
或者
$HOME/.pip/pip.conf
```
mac
```
$HOME/Library/Application Support/pip/pip.conf
或者
$HOME/.pip/pip.conf
```
windows
```
%APPDATA%\pip\pip.ini
或者
%HOME%\pip\pip.ini
```

pip.conf或者pip.ini内容
```
[global]
timeout = 60
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com
```


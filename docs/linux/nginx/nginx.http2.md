<center><h1>Nginx http2协议</h1></center>

## 1. 介绍
&#160; &#160; &#160; &#160;HTTP 2.0 的主要目标是改进传输性能，实现低延迟和高吞吐量。从另一方面看，HTTP 的高层协议语义并不会因为这次版本升级而受影响。所有HTTP 首部、值，以及它们的使用场景都不会变。

&#160; &#160; &#160; &#160;现有的任何网站和应用，无需做任何修改都可以在HTTP 2.0 上跑起来。不用为了利用HTTP 2.0 的好处而修改标记。HTTP 服务器必须运行HTTP 2.0 协议，但大部分用户都不会因此而受到影响

==以下都是基于我的ubuntu16.04上操作，centos的稍微有所不同。==

## 2. 编译安装nginx

```
1.下载安装
root@leco:~# cd /usr/local/src/
root@leco:/usr/local/src# wget http://nginx.org/download/nginx-1.10.3.tar.gz
root@leco:/usr/local/src# tar xf nginx-1.10.3.tar.gz 
root@leco:/usr/local/src# cd nginx-1.10.3

2.编译参数
root@leco:/usr/local/src/nginx-1.10.3# ./configure --user=nginx --group=nginx --prefix=/usr/local/nginx-1.10.3 --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module
root@leco:/usr/local/src/nginx-1.10.3# make && make install
```
--with-http_v2_module 支持http2协议


```
root@leco:/usr/local/src/nginx-1.10.3# /usr/local/nginx/sbin/nginx -V
nginx version: nginx/1.10.3
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) 
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --user=nginx --group=nginx --prefix=/usr/local/nginx-1.10.3 --with-http_stub_status_module --with-http_ssl_module --with-http_v2_module
```

## 3. 生成证书
因为没有真的证书，所以生成一个伪证书

```
root@leco:/usr/local/src/nginx-1.10.3# ln -s /usr/local/nginx-1.10.3/ /usr/local/nginx
root@leco:/usr/local/src/nginx-1.10.3# cd /usr/local/nginx/conf/
root@leco:/usr/local/nginx/conf# mkdir key
root@leco:/usr/local/nginx/conf# cd key/
#自定义密码
root@leco:/usr/local/nginx/conf# openssl genrsa -des3 -out server.key 1024
Generating RSA private key, 1024 bit long modulus
..........++++++
..........++++++
e is 65537 (0x10001)
Enter pass phrase for server.key:
Verifying - Enter pass phrase for server.key:
#签发证书
[root@leco key]# openssl req -new -key server.key -out server.csr
Enter pass phrase for server.key:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:BJ
Locality Name (eg, city) [Default City]:BJ
Organization Name (eg, company) [Default Company Ltd]:SDU
Organizational Unit Name (eg, section) []:SA
Common Name (eg, your name or your server's hostname) []:caimengzhi
Email Address []:123@qq.com

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:123456
An optional company name []:123456
[root@hadoop_node1 key]# cp server.key server.key.ori
[root@hadoop_node1 key]# openssl rsa -in server.key.ori -out server.key
Enter pass phrase for server.key.ori:
writing RSA key
[root@hadoop_node1 key]# openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
Signature ok
subject=/C=CN/ST=BJ/L=BJ/O=SDU/OU=SA/CN=caimengzhi/emailAddress=123@qq.com
Getting Private key
```

## 4. 修改nginx配置

```
root@leco:/usr/local/nginx/conf# cat nginx.conf
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen       70;
        server_name  localhost;
        location / {
            root   html;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
    server {
        listen    8443 ssl http2 default_server;
        server_name  localhost;
        ssl_certificate     key/server.crt;
        ssl_certificate_key key/server.key;
        location / {
            root   html;
            index  index.html index.htm;
        }
        location = /50x.html {
            root   html;
        }
    }
}

```
检查防火墙是否开启，是否开启8443和80端口

```
root@leco:/usr/local/nginx/conf# netstat -anlt|grep 8443
tcp        0      0 0.0.0.0:8443            0.0.0.0:*               LISTEN
tcp        0      0 192.168.5.110:45666     180.96.7.201:8443       TIME_WAIT
tcp        0      0 192.168.5.110:39098     180.96.7.198:8443       TIME_WAIT
```

## 4. curl支持http2
若是支持就直接跳过

```
root@leco:/usr/local/nginx/conf# /usr/local/bin/curl --version
curl 7.46.0 (x86_64-pc-linux-gnu) libcurl/7.46.0 OpenSSL/1.0.2g zlib/1.2.8 libidn/1.32 nghttp2/1.38.0-DEV librtmp/2.3
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp smb smbs smtp smtps telnet tftp
Features: IDN IPv6 Largefile NTLM NTLM_WB SSL libz TLS-SRP HTTP2 UnixSockets
```

> 上面看到支持了HTTP2了

一般我们系统默认是不支持的，效果如下:

```
root@leco:/usr/local/nginx/conf# curl -I https://nghttp2.org
HTTP/1.1 200 OK
Date: Thu, 21 Mar 2019 03:19:59 GMT
Content-Type: text/html
Last-Modified: Fri, 08 Mar 2019 12:33:02 GMT
Etag: "5c8260fe-19d8"
Accept-Ranges: bytes
Content-Length: 6616
X-Backend-Header-Rtt: 0.00384
Strict-Transport-Security: max-age=31536000
Server: nghttpx
Via: 2 nghttpx
x-frame-options: SAMEORIGIN
x-xss-protection: 1; mode=block
x-content-type-options: nosniff

root@leco:/usr/local/nginx/conf# curl --http2 -I https://nghttp2.org
curl: (1) Unsupported protocol

root@leco:/usr/local/nginx/conf# curl --version
curl 7.47.0 (x86_64-pc-linux-gnu) libcurl/7.47.0 GnuTLS/3.4.10 zlib/1.2.8 libidn/1.32 librtmp/2.3
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp smb smbs smtp smtps telnet tftp
Features: AsynchDNS IDN IPv6 Largefile GSS-API Kerberos SPNEGO NTLM NTLM_WB SSL libz TLS-SRP UnixSockets
```
我们可以看到当前 curl 的版本及支持的协议以及功能特性没有支持 HTTP2。

### 4.1 编译安装curl

```
sudo apt-get install git g++ make binutils autoconf automake autotools-dev libtool pkg-config \
  zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev \
  libjemalloc-dev cython python3-dev python-setuptools
  
git clone https://github.com/tatsuhiro-t/nghttp2.git
cd nghttp2
autoreconf -i
automake
autoconf
./configure
make
sudo make install
```

### 4.2 升级curl版本
可以升级的你当前curl的版本

```
cd ~
sudo apt-get build-dep curl

wget http://curl.haxx.se/download/curl-7.46.0.tar.bz2
tar -xvjf curl-7.46.0.tar.bz2
cd curl-7.46.0
./configure --with-nghttp2=/usr/local --with-ssl
sudo make && make install

echo '/usr/local/lib' > /etc/ld.so.conf.d/local.conf
ldconfig
```
检验
```
root@leco:/usr/local/nginx/conf# /usr/local/bin/curl --version
curl 7.46.0 (x86_64-pc-linux-gnu) libcurl/7.46.0 OpenSSL/1.0.2g zlib/1.2.8 libidn/1.32 nghttp2/1.38.0-DEV librtmp/2.3
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp smb smbs smtp smtps telnet tftp
Features: IDN IPv6 Largefile NTLM NTLM_WB SSL libz TLS-SRP HTTP2 UnixSockets

```
!!! note "注意"
    ```python
    一般ubuntu编译安装后的软件命令在/usr/local/bin /usr/local/sbin中
    ```


升级完版本之后，我们再查看 curl 版本时会发布特性中会增加 HTTP2 功能支持。此时 –http2 参数就可以正常使用了：

```
root@leco:/usr/local/nginx/conf# /usr/local/bin/curl --http2 -I https://nghttp2.org
HTTP/2.0 200
date:Thu, 21 Mar 2019 03:24:21 GMT
content-type:text/html
last-modified:Fri, 08 Mar 2019 12:33:02 GMT
etag:"5c8260fe-19d8"
accept-ranges:bytes
content-length:6616
x-backend-header-rtt:0.002634
strict-transport-security:max-age=31536000
server:nghttpx
via:2 nghttpx
x-frame-options:SAMEORIGIN
x-xss-protection:1; mode=block
x-content-type-options:nosniff
```


## 5. 验证

```
root@leco:/usr/local/nginx/html# /usr/local/bin/curl --http2 -k -s  -I https://192.168.5.110:8443/loocha.html
HTTP/2.0 200
server:nginx/1.10.3
date:Thu, 21 Mar 2019 03:04:43 GMT
content-type:text/html
content-length:22
last-modified:Thu, 21 Mar 2019 03:04:27 GMT
etag:"5c92ff3b-16"
accept-ranges:bytes

root@leco:/usr/local/nginx/html# /usr/local/bin/curl --http2 -k -s   https://192.168.5.110:8443/loocha.html
<h1>hello nginx from caimengzhi</h1>
```

完美解决

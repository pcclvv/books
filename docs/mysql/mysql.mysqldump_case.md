<center><h1> MySQLDUMP </h1></center>

## 1. 分库备份

```
root@leco:/opt/bin# cat Store_backup.sh
#!/bin/sh
#author: caimengzhi
#date:2017-01-20
MYUSER=root
MYPASS=root
MYLOGIN="mysql -u$MYUSER -p$MYPASS"
MYDUMP="mysqldump -u$MYUSER -p$MYPASS"
DATABASE="$($MYLOGIN -e "show databases;"|egrep -vi "Data|_schema|mysql")"

[ ! -f /server/backup/ ] && mkdir -p /server/backup/
for dbname in $DATABASE
do
  MYDIR=/server/backup/$dbname
  [ ! -d $MYDIR ] && mkdir -p $MYDIR
  $MYDUMP $dbname|gzip >$MYDIR/${dbname}_$(date +%F).sql.gz
done

```
执行后

```
root@leco:/opt/bin# sh Store_backup.sh
mysql: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: [Warning] Using a password on the command line interface can be insecure.
root@leco:/opt/bin# ls /server/backup/
cmz  db1  leco  prv_app_scbxy  qiushibaike  s12day113  sys
```
可以结合crontab定时备份。

```
root@leco:/opt/bin# crontab -l | grep Store_backup
0    0   *   *   *    /bin/bash  /opt/bin/Store_backup.sh  >/dev/null 2>&1
```


## 2. 分表备份

```
root@leco:/opt/bin# cat mysql_table.sh
#!/bin/sh
#author: caimengzhi
#date:2017-01-20
USER=root
PASSWD=root
MYLOGIN="mysql -u$USER -p$PASSWD"
MYDUMP="mysqldump -u$USER -p$PASSWD"
DATEBASE="$($MYLOGIN -e "show databases;"|egrep -vi "Data|_schema|mysql")"

[ ! -f /server/backup/tables ] && mkdir -p /server/backup
for dbname in $DATEBASE
do
    TABLE="$($MYLOGIN -e "use $dbname;show tables;"|sed '1d')"
    for tname in $TABLE
    do
        MYDIR=/server/backup/$dbname/${dbname}_$(date +%F)
        [ ! -d $MYDIR ] && mkdir -p $MYDIR
        $MYDUMP $dbname $tname |gzip >$MYDIR/${dbname}_${tname}_$(date +%F).sql.gz
    done
done
```

执行后
```
root@leco:/opt/bin# sh mysql_table.sh

root@leco:/opt/bin# ls /server/backup/
cmz/           db1/           leco/          prv_app_scbxy/ qiushibaike/   s12day113/     sys/
root@leco:/opt/bin# ls /server/backup/cmz/
cmz_2019-02-28

```
可以结合crontab定时备份。

```
root@leco:/opt/bin# crontab -l | grep mysql_table
0    0   *   *   *    /bin/bash  /opt/bin/mysql_table.sh  >/dev/null 2>&1
```

## 3. 优缺点

!!! note "比较"
    ```python
    1. 优点：
      恢复简单，可以使用管道将他们输入到mysql
      与存储引擎无关，因为是从MySQL服务器中提取数据而生成的，所以消除了底层数据存储的不同
      有助于避免数据损坏。若磁盘驱动器有故障而要复制原始文件时，此时将得到一个损坏的备份

    2. 缺点：
      必须有数据库服务器完成逻辑工作，需要更多地cpu周期
      逻辑备份还原速度慢：需要MySQL加载和解释语句、转化存储格式、重建引擎
    ```

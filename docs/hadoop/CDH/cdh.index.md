<center><h1>Hadoop</h1></center>

## 1. 介绍
### 1.1 介绍
&#160; &#160; &#160; &#160;Hadoop是一个由Apache基金会所开发的分布式系统基础架构。

&#160; &#160; &#160; &#160;用户可以在不了解分布式底层细节的情况下，开发分布式程序。充分利用集群威力进行高速运算和存储。

&#160; &#160; &#160; &#160;Hadoop实现了一个分布式文件系统（Hadoop Distributed File System），简称HDFS。HDFS有高容错性的特点，并且设计用来部署在低廉的（low-cost）硬件上；而且它提供高吞吐量（high throughput）来访问应用程序的数据，适合那些有着超大数据集（large data set）的应用程序。HDFS放宽了（relax）POSIX的要求，可以以流的形式访问（streaming access）文件系统中的数据。

&#160; &#160; &#160; &#160;Hadoop的框架最核心的设计就是：HDFS和MapReduce。HDFS为海量的数据提供了存储，则MapReduce为海量的数据提供了计算。

> 以上摘自百度百科

### 1.2 对比
&#160; &#160; &#160; &#160; 部署hadoop集群的时候，我们可以自己手动部署各个组件，我们也可以通过其他软件部署hadoop组件，这样的第三方部署hadoop的软件，国内使用最多的clouder公司的cdh软件。

&#160; &#160; &#160; &#160; apache hadoop和cdh hadoop对比

- cdh比原生的Apache发行版本包含了更多的补丁，用于增强稳定性，改善功能，有时候还增加功能特性 
- cdh版本是由cloudera公司开源的，可以使用cm平台进行管理，比原生的Apache版本安装、维护更加省力 
- 但是对技术人员的要求更高，必须对原生apache版本的各个组件理解清晰 
- 在cm管理平台中，cdh的parcel包不包含某些组件，需要自己下载对应的parcel包，比如说kafka 
- 对hdfs部署过程中，对磁盘进行lvm卷轴或者是磁盘目录统一，对于多台机器，否则之后维护成本高- 

### 1.3 CDH能解决哪些问题

- 1000台服务器的集群，最少要花费多长时间来搭建好Hadoop集群，包括Hive、Hbase、Flume、Kafka、Spark等等
- 只给你一天时间，完成以上工作？
- 对于以上集群进行hadoop版本升级，你会选择什么升级方案，最少要花费多长时间？
- 新版本的Hadoop，与Hive、Hbase、Flume、Kafka、Spark等等兼容？

## 2. CDH 介绍
### 2.1 介绍
&#160; &#160; &#160; &#160; hadoop是一个开源项目，所以很多公司在这个基础进行商业化，Cloudera对hadoop做了相应的改变。

&#160; &#160; &#160; &#160; CDH (Cloudera's Distribution, including Apache Hadoop)，是Hadoop众多分支中的一种，由Cloudera维护，基于稳定版本的Apache Hadoop构建，并集成了很多补丁，可直接用于生产环境。

&#160; &#160; &#160; &#160; Cloudera公司的发行版，我们将该版本称为CDH(Cloudera Distribution 
Hadoop)。截至目前为止，CDH共有5个版本，其中，前两个已经不再更新，最近的两个，分别是CDH4，在Apache Hadoop 
2.0.0版本基础上演化而来的，CDH5，它们每隔一段时间便会更新一次。

&#160; &#160; &#160; &#160; Cloudera Manager则是为了便于在集群中进行Hadoop等大数据处理相关的服务安装和监控管理的组件，对集群中主机、Hadoop、Hive、Spark等服务的安装配置管理做了极大简化。

- Cloudera's Distribution, including Apache Hadoop
- 是Hadoop众多分支中的一种，由Cloudera维护，基于稳定版本的Apache Hadoop构建
- 提供了Hadoop的核心
    - 可扩展存储
    - 分布式计算
- 基于Web的用户界面支持大多数Hadoop组件，包括HDFS、MapReduce、Hive、Pig、 Hbase、Zookeeper、Sqoop,简化了大数据平台的安装、使用难度。

![CDH逻辑图](../../pictures/hadoop/CDH/index/CDH.png)

### 2.2 优点

- 版本划分清晰
- 版本更新速度快
- 支持Kerberos安全认证
- 文档清晰
- 支持多种安装方式（Cloudera Manager方式

### 2.3 安装方式

- Cloudera Manager
- Yum
- Rpm
- Tarball

### 2.4 参考文档
[CDH 参考文档](https://www.cloudera.com/downloads/manager/6-1-1.html)

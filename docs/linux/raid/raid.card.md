<center><h1>Raid实战</h1></center>

## 1. 阵列卡
![raid0](../../pictures/linux/raid/raid阵列卡.png)

&#160; &#160; &#160; &#160;简单的说，RAID是一种把多块独立的物理硬盘按不同方式组合起来形成一个逻辑硬盘，从而提供比单个硬盘有着更高的性能和提供数据冗余的技术。

&#160; &#160; &#160; &#160;RAID卡一般分为硬RAID卡和软RAID卡两种，通过用硬件来实现RAID功能的就是硬RAID，独立的RAID卡，主板集成的RAID芯片都是硬RAID。通过软件并使用CPU的RAID卡是指使用CPU来完成RAID的常用计算，软件RAID占用CPU资源较高，绝大部分服务器设备是硬件RAID。


## 2. 阵列卡接口
&#160; &#160; &#160; &#160;接口是指支持的接口，目前主要有四种：IDE接口、SCSI接口、SATA接口和SAS接口。

IDE接口（已被淘汰）

&#160; &#160; &#160; &#160;IDE的英文全称为“Integrated Drive Electronics”，即“电子集成驱动器”，它的本意是指把“硬盘控制器”与“盘体”集成在一起的硬盘驱动器。把盘体与控制器集成在一起的做法减少了硬盘接口的电缆数目与长度，数据传输的可靠性得到了增强，硬盘制造起来变得更容易，因为硬盘生产厂商不需要再担心自己的硬盘是否与其它厂商生产的控制器兼容，对用户而言，硬盘安装起来也更为方便。IDE这一接口技术从诞生至今就一直在不断发展，性能也不断的提高，其拥有的价格低廉、兼容性强的特点，为其造就了其它类型硬盘无法替代的地位。
IDE代表着硬盘的一种类型，但在实际的应用中，人们也习惯用IDE来称呼最早出现IDE类型硬盘ATA-1，这种类型的接口随着接口技术的发展已经被淘汰了，而其后发展分支出更多类型的硬盘接口，比如ATA、Ultra ATA、DMA、Ultra DMA等接口都属于IDE硬盘。此外，由于IDE口属于并行接口，因此为了和SATA口硬盘相区别，IDE口硬盘也叫PATA口硬盘。

SCSI接口

&#160; &#160; &#160; &#160;SCSI的英文全称为“Small Computer System Interface”（小型计算机系统接口），是同IDE完全不同的接口，IDE接口是普通PC的标准接口，而SCSI并不是专门为硬盘设计的接口，是一种广泛应用于小型机上的高速数据传输技术。SCSI接口具有应用范围广、多任务、带宽大、CPU占用率低，以及支持热插拔等优点，但较高的价格使得它很难如IDE硬盘般普及，因此SCSI硬盘主要应用于中、高端和高档工作站中。SCSI硬盘和普通IDE硬盘相比有很多优点：接口速度快，并且由于主要用于服务器，因此硬盘本身的性能也比较高，硬盘转速快，缓存容量大，CPU占用率低，扩展性远优于IDE硬盘，并且支持热插拔。

SATA接口

&#160; &#160; &#160; &#160;使用SATA（Serial ATA）口的硬盘又叫串口硬盘，是目前PC硬盘的主流。2001年，由Intel、APT、Dell、IBM、希捷、迈拓这几大厂商组成的Serial ATA委员会正式确立了Serial ATA 1.0规范，2002年，虽然串行ATA的相关设备还未正式上市，但Serial ATA委员会已抢先确立了Serial ATA 2.0规范。Serial ATA采用串行连接方式，串行ATA总线使用嵌入式时钟信号，具备了更强的纠错能力，与以往相比其最大的区别在于能对传输指令（不仅仅是数据）进行检查，如果发现错误会自动矫正，这在很大程度上提高了数据传输的可靠性。串行接口还具有结构简单、支持热插拔的优点。

&#160; &#160; &#160; &#160;串口硬盘是一种完全不同于并行ATA的硬盘接口类型，由于采用串行方式传输数据而知名。相对于并行ATA来说，就具有非常多的优势。首先，Serial ATA以连续串行的方式传送数据，一次只会传送1位数据。这样能减少SATA接口的针脚数目，使连接电缆数目变少，效率也会更高。实际上，Serial ATA 仅用四支针脚就能完成所有的工作，分别用于连接电缆、连接地线、发送数据和接收数据，同时这样的架构还能降低系统能耗和减小系统复杂性。其次，Serial ATA的起点更高、发展潜力更大，Serial ATA 1.0定义的数据传输率为150MB/s，这比并行ATA（即ATA/133）所能达到133MB/s的最高数据传输率还高，而在Serial ATA 2.0的数据传输率达到300MB/s，SATA Revision 3.0可达到750 MB/s的最高数据传输率。 [1] 

SAS接口

&#160; &#160; &#160; &#160;SAS是新一代的SCSI技术，和现在流行的Serial ATA(SATA)硬盘相同，都是采用串行技术以获得更高的传输速度，并通过缩短连结线改善内部空间等。SAS是并行SCSI接口之后开发出的全新接口。此接口的设计是为了改善存储系统的效能、可用性和扩充性，提供与串行ATA (Serial ATA，缩写为SATA)硬盘的兼容性。
&#160; &#160; &#160; &#160;SAS的接口技术可以向下兼容SATA。SAS系统的背板(Backpanel)既可以连接具有双端口、高性能的SAS驱动器，也可以连接高容量、低成本的SATA驱动器。因为SAS驱动器的端口与SATA驱动器的端口形状看上去类似，所以SAS驱动器和SATA驱动器可以同时存在于一个存储系统之中。但需要注意的是，SATA系统并不兼容SAS，所以SAS驱动器不能连接到SATA背板上。由于SAS系统的兼容性，IT人员能够运用不同接口的硬盘来满足各类应用在容量上或效能上的需求，因此在扩充存储系统时拥有更多的弹性，让存储设备发挥最大的投资效益。


## 3. 生产
&#160; &#160; &#160; &#160;我以生成线上使用的阵列卡为例，来讲述如何使用。我们安装好pcie接口[[PCIE](https://baike.baidu.com/item/pcie/2167538?fr=aladdin)]的阵列卡。然后开机，进入阵列卡配置界面配置[[某阵列卡配置教程](https://m.jb51.net/article/39265.htm)].

&#160; &#160; &#160; &#160;配置完raid卡以后。开机，安装系统。然后部署针对自己raid卡品牌的脚本来监控和检查磁盘阵列里面磁盘的情况。

```
root@root:/opt/3ware/CLI# /opt/3ware/CLI/tw_cli show

Ctl   Model        (V)Ports  Drives   Units   NotOpt  RRate   VRate  BBU
------------------------------------------------------------------------
c0    9750-24i4e   24        24       5       0       1       1      -

root@root:/opt/3ware/CLI# /opt/3ware/CLI/tw_cli /c0 show all
/c0 Driver Version = 3.26.02.000
/c0 Model = 9750-24i4e
/c0 Available Memory = 488MB
/c0 Firmware Version = FH9X 5.12.00.007
/c0 Bios Version = BE9X 5.11.00.006
/c0 Boot Loader Version = BT9X 6.00.00.004
/c0 Serial Number = SV05217695
/c0 PCB Version = Rev 001
/c0 PCHIP Version = B4
/c0 ACHIP Version = 05000e00
/c0 Controller Phys = 28
/c0 Connections = 24 of 128
/c0 Drives = 24 of 127
/c0 Units = 5 of 127
/c0 Active Drives = 24 of 127
/c0 Active Units = 3 of 32
/c0 Max Drives Per Unit = 32
/c0 Total Optimal Units = 5
/c0 Not Optimal Units = 0
/c0 Disk Spinup Policy = 8
/c0 Spinup Stagger Time Policy (sec) = 0
/c0 Auto-Carving Policy = off
/c0 Auto-Carving Size = 2048 GB
/c0 Auto-Rebuild Policy = on
/c0 Rebuild Mode = Adaptive
/c0 Rebuild Rate = 1
/c0 Verify Mode = Adaptive
/c0 Verify Rate = 1
/c0 Controller Bus Type = PCIe
/c0 Controller Bus Width = 8 lanes
/c0 Controller Bus Speed = 5.0 Gbps/lane

Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
------------------------------------------------------------------------------
u0    RAID-1    OK             -       -       -       1862.63   Ri     ON
u1    RAID-10   OK             -       -       256K    3725.27   Ri     ON
u2    RAID-10   OK             -       -       256K    14901.1   Ri     ON
u3    SPARE     OK             -       -       -       1863.01   -      OFF
u4    SPARE     OK             -       -       -       1863.01   -      OFF

VPort Status         Unit Size      Type  Phy Encl-Slot    Model
------------------------------------------------------------------------------
p0    OK             u1   1.82 TB   SATA  0   -            WDC WD2003FYYS-02W0
p1    OK             u1   1.82 TB   SATA  1   -            WDC WD2003FYYS-02W0
p2    OK             u1   1.82 TB   SATA  2   -            WDC WD2003FYYS-02W0
p3    OK             u3   1.82 TB   SATA  3   -            WDC WD2004FBYZ-01YC
p4    OK             u4   1.82 TB   SATA  4   -            WDC WD2004FBYZ-01YC
p5    OK             u2   1.82 TB   SATA  5   -            WDC WD2003FYYS-02W0
p6    OK             u2   1.82 TB   SATA  6   -            WDC WD2003FYYS-02W0
p7    OK             u2   1.82 TB   SATA  7   -            WDC WD2003FYYS-02W0
p8    OK             u2   1.82 TB   SATA  8   -            WDC WD2003FYYS-02W0
p9    OK             u2   1.82 TB   SATA  9   -            WDC WD2003FYYS-02W0
p10   OK             u2   1.82 TB   SATA  10  -            WDC WD2003FYYS-02W0
p11   OK             u2   1.82 TB   SATA  11  -            WDC WD2003FYYS-02W0
p12   OK             u0   1.82 TB   SATA  12  -            WDC WD2003FYYS-02W0
p13   OK             u0   1.82 TB   SATA  13  -            WDC WD2003FYYS-02W0
p14   OK             u2   1.82 TB   SATA  14  -            WDC WD2003FYYS-02W0
p15   OK             u2   1.82 TB   SATA  15  -            WDC WD2003FYYS-02W0
p16   OK             u2   1.82 TB   SATA  16  -            WDC WD2003FYYS-02W0
p17   OK             u2   1.82 TB   SATA  17  -            WDC WD2003FYYS-02W0
p18   OK             u2   1.82 TB   SATA  18  -            WDC WD2003FYYS-02W0
p19   OK             u2   1.82 TB   SATA  19  -            WDC WD2003FYYS-02W0
p20   OK             u2   1.82 TB   SATA  20  -            WDC WD2003FYYS-02W0
p21   OK             u2   1.82 TB   SATA  21  -            WDC WD2003FYYS-02W0
p22   OK             u1   1.82 TB   SATA  22  -            WDC WD2003FYYS-02W0
p23   OK             u2   1.82 TB   SATA  23  -            WDC WD2003FYYS-02W0
```

!!! note "解释"
    ```python
    1. 我们能从上面的命令结果可以看到系统有多少个硬盘，raid的模式，磁盘相关信息
    2. 可以通过该命令编写对应的脚本
    ```

## 4. 脚本

```
#!/bin/bash
# ==============================================================================
# Disk smart and raid   Statistics plugin for Nagios
#
# Written by    :       caimengzhi
# Release       :       1.0
# Description   :       shows detail raid info and checkded smart reeult for all disk
# USAGE         :      ./check_raid_smart.sh
#
# ----------------------------------------------------------------------------------------

# Nagios return codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKOWN=3

#Plugin variable description
PRONAME=$(basename $0)
RELEASE="Version 1.0"
AUTHOR="caimengzhi"

#Tools used in plugin
TW_CLI="/usr/sbin/tw_cli_64"
SMARTCTL="/usr/sbin/smartctl"

#TMP file used in plugin
TMP_DIR="/usr/local/nagios/disk_smart"
TMP_CONTROL="/usr/local/nagios/disk_smart/tmp_control.txt"
TMP_DISK="/usr/local/nagios/disk_smart/tmp_disk.txt"
TMP_VIRTUAL_DISK="/usr/local/nagios/disk_smart/tmp_virtual_disk.txt"
TMP_DISK_RESULT="/usr/local/nagios/disk_smart/tmp_disk_result.txt"
TMP_DISK_HTML_U="/usr/local/nagios/disk_smart/tmp_disk_html_u.txt"
TMP_DISK_HTML_P="/usr/local/nagios/disk_smart/tmp_disk_html_p.txt"

#check tool
if [ ! -f $TW_CLI ] || [ ! -f $SMARTCTL ];then
	echo "can't command tw_cli_64 or smartctl used in script !"
	exit $STATE_UNKOWN
fi

#check dir
if [ ! -d $TMP_DIR ];then
	mkdir $TMP_DIR
fi

u_html(){
	printf "<div>"
	printf "<table border=1>"
	printf "<tr>"
	printf "<th>Unit</th>"
	printf "<th>UnitType</th>"
	printf "<th>Status</th>"
	printf "<th>%%RCmpl</th>"
	printf "<th>%%V/I/M</th>"
	printf "<th>Stripe</th>"
	printf "<th>Size(GB)</th>"
	printf "<th>Cache</th>"
	printf "<th>AVrfy</th>"
	printf "</tr>"

	local unum=`cat $TMP_DISK_HTML_U | wc -l`
	for (( i=1; i<=$unum; i++));do
		uinfo=(`cat $TMP_DISK_HTML_U | sed -n "$i"p`)
		printf "<tr>"
		for ((j=0; j<=8; j++));do
			printf "<td>${uinfo[$j]}</td>"
		done
		printf "</tr>"
	done
	printf "</table>"
	printf "</div>"
}

p_html(){
	printf "<div>"
        printf "<table border=1>"
        printf "<tr>"
        printf "<th>VPort</th>"
        printf "<th>Status</th>"
        printf "<th>Unit</th>"
        printf "<th>Size</th>"
        printf "<th>Type</th>"
        printf "<th>Phy</th>"
        printf "<th>Encl-Slot</th>"
        printf "<th>Model</th>"
	printf "<th>Health</th>"
        printf "</tr>"

	local pnum=`cat $TMP_DISK_HTML_P | wc -l`
        for (( i=1; i<=$pnum; i++));do
                pinfo=(`cat $TMP_DISK_HTML_P | sed -n "$i"p`)
                printf "<tr>"
		content=""
                for ((j=0; j<=10; j++));do
			content=${pinfo[$j]}
			if [ $j -eq 3 ] || [ $j -eq 8 ];then
                        	content=${pinfo[$j]}${pinfo[ $j + 1 ]}
			else if [ $j -eq 4 ] || [ $j -eq 9 ];then
				continue
		             fi
			fi
			printf "<td>$content</td>"
		done
        done
        printf "</tr>"
        printf "</table>"
       	printf "</div>"
}

#start to get raid and smart info
CONTROL_LIST=`$TW_CLI show | grep '^c[0-9].*'|awk '{print $1}' > $TMP_CONTROL`
CONTROL_NUM=`cat $TMP_CONTROL | wc -l`

c=1
while [ $c -le $CONTROL_NUM ]
do
	cname[$c]=`cat $TMP_CONTROL | sed -n "${c}p"| awk '{print $1}'`
	let c++
done

ERRCOUNT=0
declare -a DISK_ERR_ARRAY
ERRFLAG=0
DISK_TOTAL=0
i=1
 while [ $i -le $CONTROL_NUM ]
  do
   RR=`$TW_CLI /${cname[$i]} show | grep '^p[0-9].*' > $TMP_DISK_RESULT`
   PHY_LIST=`$TW_CLI /${cname[$i]} show | grep '^p[0-9].*' |awk '{print $7}' > $TMP_DISK`
   PHY_COUNT=`cat $TMP_DISK | wc -l`
   DISK_TOTAL=$[$DISK_TOTAL + $PHY_COUNT]
   $TW_CLI /${cname[$i]}  show |grep '^u[0-9].*' >> $TMP_DISK_HTML_U
   j=1
   while [ $j -le $PHY_COUNT ]
     do
        PHYS=`cat $TMP_DISK | sed -n "${j}p"`
        if [ "$PHYS" == "-" ]
          then
           DISK_TOTAL=$[$DISK_TOTAL - 1 ]
           let j++
           continue
        fi

	RAID_INFO=`cat $TMP_DISK_RESULT | grep " $PHYS "`
	RAID_HEALTH=`cat $TMP_DISK_RESULT | grep " $PHYS " | awk '{print $2}'`
        SMART_HEALTH=`$SMARTCTL -H -d 3ware,${PHYS} /dev/twl0|sed -n '5p' | awk '{print $6}'`
        if [ "$SMART_HEALTH" != "PASSED" ] || [ "$RAID_HEALTH" != "OK" ];then
              ERR_COUNTROL=`cat $TMP_CONTROL | sed -n "${i}p"| awk '{print $1}'`
              ERRFLAG=1
              DISK_ERR_ARRAY[$ERRCOUNT]="disk ${PHYS} on controller $ERR_COUNTROL "
              let ERRCOUNT++
              attribute=`/usr/sbin/smartctl -H   -d 3ware,${PHYS} /dev/twl0 | sed -n '4,$p'`
              echo -e "$attribute"
         fi
	if [ $ERRFLAG -eq 1 ];then
		RAID_INFO=$RAID_INFO"  FAILED"
	else 	RAID_INFO=$RAID_INFO"  PASSED"
	fi
	echo "$RAID_INFO" >> $TMP_DISK_HTML_P
     let j++
     done
  let i++
done



# get html output
echo "DISK Raid&Smart Statistics"
u_html
p_html

# clear tmp file
echo "" > $TMP_DISK_HTML_U
echo "" > $TMP_DISK_HTML_P

 if [ $ERRFLAG -eq 0 ]
  then
    echo "SMART OK - All disk OK ($DISK_TOTAL checked on $CONTROL_NUM controller) | TotalDisk=$DISK_TOTAL HealthDisk=$DISK_TOTAL FaildDisk=$ERRCOUNT"
    exit $OK
 else
    k=0
    ERR=""
    while [ $k -le  $ERRCOUNT ];do
     	ERR=${ERR}"${DISK_ERR_ARRAY[$k]}"
     	let k++
    done
     echo -e "SMART CRITICAL - $ERRCOUNT of $DISK_TOTAL disk  failed! ($ERR) | TotalDisk=$DISK_TOTAL HealthDisk=$[ $DISK_TOTAL - ERRCOUNT ] FailedDisk=$ERRCOUNT"
    exit $CRITICAL
 fi
```

## 5. nagios图

![raid_nagios](../../pictures/linux/raid/raid_nagios.png):

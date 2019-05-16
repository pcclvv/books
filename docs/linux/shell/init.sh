#!/bin/bash


color_red(){
    echo -e "\\033[0;31m$*\\033[0;39m"
}


color_blue(){
    echo -e "\033[34m[ $* ]\033[0m"
}


VerifyParameter(){
    if [[ $# -ne 2 ]] || [[ "x"$1 == "x" ]] || [[ "x"$2 == "x" ]]; then
        local msg="参数不能为空\n第一个参数为: 主机名\n第二个参数为: ip"
        color_red ${msg}
        exit 1
    fi
}


HostNameModify(){
    local host_name=$1
    color_blue "修改主机名为: ${host_name}"
    echo ${host_name} > /etc/hostname
    hostname ${host_name}
}


NetworkModify(){
    local host_ip=$2
    color_blue "修改机器${host_ip}"
    color_blue "设置DNS为114.114.114.114"
    if [[ $(ls /etc/sysconfig/network-scripts/ifcfg-en* | wc -l) == 1 ]]; then
        NetworkFile=$(ls /etc/sysconfig/network-scripts/ifcfg-en*)
    else
        color_red "network 文件不存在"
        exit 1
    fi

    local old_ip=$(awk -F\" '/IPADDR/{print $2}' ${NetworkFile})
    local old_dns=$(awk -F\" '/DNS/{print $2}' ${NetworkFile})

    color_blue "原ip为: ${old_ip}\t更新为: ${host_ip}"
    if [[ -z $(grep "IPADDR" ${NetworkFile}) ]]; then
        echo -e "IPADDR=\"${host_ip}\"" >> ${NetworkFile}
    else
        sed -i "s#IPADDR.*#IPADDR=\"${host_ip}\"#g" ${NetworkFile}
    fi

    color_blue "DNS更新为: 114.114.114.114"
    if [[ -z $(grep "DNS" ${NetworkFile}) ]]; then
        echo -e "DNS=\"114.114.114.114\"" >> ${NetworkFile}
    else
        sed -i "s#DNS.*#DNS=\"114.114.114.114\"#" ${NetworkFile}
    fi
    color_red "修改文件为："
    cat ${NetworkFile}
    systemctl restart network
}


StopNetworkManager(){
    # 关闭NetworkManager
    color_blue "关闭NetworkManager"
    systemctl stop NetworkManager && systemctl disable NetworkManager;
}


Stopfirewalld(){
    # 关闭默认防火墙(firewalld)
    color_blue "关闭默认防火墙(firewalld)"
    systemctl stop firewalld && systemctl disable firewalld;
}


StopSelinux(){
    # selinux配置文件(关闭并不启用)
    color_blue "修改selinux配置文件(关闭并不启用)"
    sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
}


MaxProcessNofile(){
    color_blue "修改最大进程数/文件数修改系统(system)环境变量"
    sed -i '/^#DefaultLimitNOFILE=/aDefaultLimitNOFILE=655350' /etc/systemd/system.conf
    sed -i '/^#DefaultLimitNPROC=/aDefaultLimitNPROC=655350' /etc/systemd/system.conf
    
    color_blue "修改 最大进程数/文件数配置文件"

    if [[ $(ls /etc/security/limits.d/* | wc -l) == 1 ]]; then
        LimitFile=$(ls /etc/security/limits.d/*)
        echo -e "# Default limit for number of user's processes to prevent\n# accidental fork bombs.\n# See rhbz #432903 for reasoning.\n\n*          soft    noproc    655350\n*          hard    noproc    655350\n*          soft    nofile    655350\n*          hard    nofile    655350\nroot       soft    nproc     unlimited" > ${LimitFile}
        color_red "最大文件数和用户最大进程数已修改\n\n################################\n         需重启生效\n################################"
    else
        echo -e "# Default limit for number of user's processes to prevent\n# accidental fork bombs.\n# See rhbz #432903 for reasoning.\n\n*          soft    noproc    655350\n*          hard    noproc    655350\n*          soft    nofile    655350\n*          hard    nofile    655350\nroot       soft    nproc     unlimited" > /etc/security/limits.d/20-nproc.conf
        color_red "最大文件数和用户最大进程数已修改\n\n################################\n         需重启生效\n################################"
    fi
}


CheckNetwork(){
    # ping www.baidu.com -c 3 -w 2 > /dev/null 2>&1
    ping www.baidu.com -c 1 -w 2
    if [[ $? != 0 ]] || [[ -f /etc/resolv.conf ]]; then
        mv /etc/resolv.conf /etc/resolv.conf_$(date '+%F-%H%M%S')
        echo "nameserver 114.114.114.114" >> /etc/resolv.conf
    else
        color_red "/etc/resolv.conf文件不存在, 创建文件"
        echo "nameserver 114.114.114.114" >> /etc/resolv.conf
    fi
}


Ntpdate(){
    command -v ntpdate >/dev/null 2>&1 || { echo >&2 "I require ntpdate but it's not installed.";}
    color_blue "安装ntpdate"
    CheckNetwork
    if [[ $? != 0 ]]; then
        echo -e "网络无法连通，退出程序"
        exit 1
    fi
    yum install -y ntpdate
    ntpdate -d cn.pool.ntp.org > /dev/null 2>&1
}


main(){
    VerifyParameter $*
    HostNameModify $*
    NetworkModify $*
    StopNetworkManager
    Stopfirewalld
    StopSelinux
    Ntpdate
    MaxProcessNofile
}

main $*

# command -v ntpdate >/dev/null 2>&1 || { echo >&2 "I require ntpdate but it's not installed.  Aborting."; exit 1; }
# type foo >/dev/null 2>&1 || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
# hash foo 2>/dev/null || { echo >&2 "I require foo but it's not installed.  Aborting."; exit 1; }
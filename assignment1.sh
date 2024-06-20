#!/bin/bash
# Gathering data and storing in variables.
HOSTNAME=$(hostname)
UPTIME=$(uptime -p)
source /etc/os-release
OS="$NAME $VERSION"
CPU=$(lscpu | grep 'Model name:' | awk -F ': ' '{print $2}')
CPUSPEED=$(lscpu | grep 'CPU MHz:' | awk -F ': ' '{print $2}')
RAM=$(free -h | grep Mem: | awk '{print $2}')
DISKS=$(lsblk -o NAME,SIZE | grep -v '^loop' | grep -v '^NAME' | awk '{print $1 ": " $2}')
VIDEO=$(lspci | grep VGA | cut -d ":" -f3)
FQDN=$(hostname -f)
IPADDR=$(hostname -I | awk '{print $1}')
GATEWAY=$(ip route | grep default | awk '{print $3}')
DNS=$(cat /etc/resolv.conf | grep 'nameserver' | awk '{print $2}')
NIC=$(ip -o link show | awk -F': ' '{print $2}')
USERS=$(who | awk '{print $1}' | sort | uniq | paste -sd "," -)
DISKSPACE=$(df -h --output=source,fstype,size,used,avail,pcent,target -x tmpfs -x devtmpfs | tail -n +2)
PROCCOUNT=$(ps -e | wc -l)
LOADAVG=$(cat /proc/loadavg | awk '{print $1 ", " $2 ", " $3}')
MEMALLOC=$(free -h)
PORTS=$(ss -tuln | grep LISTEN | awk '{print $5}' | awk -F ':' '{print $NF}' | sort -n | uniq | paste -sd "," -)
UFW=$(sudo ufw status numbered)

# Create the report
echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "\nSystem Report generated by $(whoami), $(date)\n"
echo "System Information"
echo "------------------"
echo "Hostname: $HOSTNAME"
echo "OS: $OS"
echo "Uptime: $UPTIME"
echo
echo "Hardware Information"
echo "--------------------"
echo "CPU: $CPU"
echo "Speed: $CPUSPEED MHz"
echo "RAM: $RAM"
echo "Disk(s):"
echo "$DISKS"
echo "Video: $VIDEO"
echo
echo "Network Information"
echo "-------------------"
echo "FQDN: $FQDN"
echo "Host Address: $IPADDR"
echo "Gateway IP: $GATEWAY"
echo "DNS Server: $DNS"
echo
echo "InterfaceName: $NIC"
echo "IP Address: $IPADDR"
echo
echo "System Status"
echo "-------------"
echo "Users Logged In: $USERS"
echo "Disk Space:"
echo "$DISKSPACE"
echo "Process Count: $PROCCOUNT"
echo "Load Averages: $LOADAVG"
echo "Memory Allocation:"
echo "$MEMALLOC"
echo "Listening Network Ports: $PORTS"
echo "UFW Rules:"
echo "$UFW"
echo -e "\n"
echo "------------------------------------------------------------------------------------------------------------------------"

#!/bin/bash
log_file="/var/log/traffic_monitor/traffic.log"

# 获取系统时区
timezone=$(timedatectl show --property=Timezone --value)

while true; do
    # 使用TZ环境变量来设置时区
    TZ=$timezone date +"%Y-%m-%d %H:%M:%S - Traffic:" >> "$log_file" 2>&1
    iptables -L ALL_TRAFFIC -v -n -x | awk 'NR==3 {print "Received:", $2, "bytes, Sent:", $10, "bytes"}' >> "$log_file" 2>&1
    vnstat -i ens5 -h >> "$log_file" 2>&1
    echo "" >> "$log_file" 2>&1
    sleep 3600 # 每小时
done
#!/bin/bash
log_file="/var/log/traffic_monitor/traffic.log"

while true; do
    echo "$(date) - Traffic:" >> "$log_file" 2>&1
    iptables -L ALL_TRAFFIC -v -n -x | awk 'NR==3 {print "Received:", $2, "bytes, Sent:", $10, "bytes"}' >> "$log_file" 2>&1
    vnstat -i eth0 -h >> "$log_file" 2>&1
    echo "" >> "$log_file" 2>&1
    sleep 3600 # 每小时
done
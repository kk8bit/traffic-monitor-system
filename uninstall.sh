#!/bin/bash
echo "开始卸载流量监控系统..."

# 检查服务是否正在运行
if systemctl is-active --quiet monitor-traffic; then
    sudo systemctl stop monitor-traffic
    sudo systemctl disable monitor-traffic
else
    echo "monitor-traffic服务未运行。"
fi

# 删除systemd服务文件
sudo rm /etc/systemd/system/monitor-traffic.service

# 删除自定义iptables规则
if sudo iptables -L INPUT | grep -q ALL_TRAFFIC; then
    sudo iptables -D INPUT -j ALL_TRAFFIC
fi
if sudo iptables -L OUTPUT | grep -q ALL_TRAFFIC; then
    sudo iptables -D OUTPUT -j ALL_TRAFFIC
fi
sudo iptables -F ALL_TRAFFIC || echo "无法清空ALL_TRAFFIC链。"
sudo iptables -X ALL_TRAFFIC || echo "无法删除ALL_TRAFFIC链。"

# 停止并禁用vnstat
if systemctl is-active --quiet vnstat; then
    sudo systemctl stop vnstat
    sudo systemctl disable vnstat
else
    echo "vnstat服务未运行。"
fi

# 删除安装的脚本
sudo rm /usr/local/bin/monitor_traffic.sh
sudo rm /usr/local/bin/menu.sh
sudo rm /usr/local/bin/uninstall.sh

# 删除菜单的软链接
sudo rm /usr/local/bin/ll

# 删除日志目录
sudo rm -r /var/log/traffic_monitor

echo "流量监控系统已成功卸载。"
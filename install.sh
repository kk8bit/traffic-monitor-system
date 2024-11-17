#!/bin/bash
# 添加这个来确保脚本在遇到错误时立即退出
set -e

# ASCII Art Logo
show_logo() {
    cat << "EOF"

                                            
██╗  ██╗██╗  ██╗ █████╗ ██████╗ ██╗████████╗
██║ ██╔╝██║ ██╔╝██╔══██╗██╔══██╗██║╚══██╔══╝
█████╔╝ █████╔╝ ╚█████╔╝██████╔╝██║   ██║   
██╔═██╗ ██╔═██╗ ██╔══██╗██╔══██╗██║   ██║   
██║  ██╗██║  ██╗╚█████╔╝██████╔╝██║   ██║   
╚═╝  ╚═╝╚═╝  ╚═╝ ╚════╝ ╚═════╝ ╚═╝   ╚═╝   

EOF
}

# GitHub地址提示
show_github_link() {
    echo -e "\e[31mGitHub地址：https://github.com/kk8bit/traffic-monitor-system\e[0m\n\n"
}

# 检查是否是root用户
if [[ $EUID -ne 0 ]]; then
   echo "此脚本必须以root权限运行。请使用sudo运行。" 
   exit 1
fi

show_logo
show_github_link
echo "开始安装流量监控系统..."

# 更新系统包
apt-get update

# 安装所需的工具
apt-get install -y iptables vnstat nload iftop

# 配置iptables
echo "配置iptables用于流量监控..."
iptables -N ALL_TRAFFIC
iptables -A INPUT -j ALL_TRAFFIC
iptables -A OUTPUT -j ALL_TRAFFIC
iptables -A ALL_TRAFFIC -j ACCEPT

# 保存iptables规则到文件
iptables-save > /etc/iptables/rules.v4

# 启动并启用vnstat服务
systemctl start vnstat || echo "vnstat服务启动失败。"
systemctl enable vnstat || echo "vnstat服务启用失败。"

# 创建目录用于存储日志
mkdir -p /var/log/traffic_monitor

# 下载并安装监控脚本
wget -O /usr/local/bin/monitor_traffic.sh "https://raw.githubusercontent.com/kk8bit/traffic-monitor-system/main/monitor_traffic.sh" || echo "无法下载monitor_traffic.sh"
chmod +x /usr/local/bin/monitor_traffic.sh

# 创建交互式菜单脚本
wget -O /usr/local/bin/menu.sh "https://raw.githubusercontent.com/kk8bit/traffic-monitor-system/main/menu.sh" || echo "无法下载menu.sh"
chmod +x /usr/local/bin/menu.sh

# 创建并配置systemd服务文件
cat << EOF > /etc/systemd/system/monitor-traffic.service
[Unit]
Description=Traffic Monitor Service
After=network.target

[Service]
ExecStart=/usr/local/bin/monitor_traffic.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 启动并启用服务
systemctl daemon-reload
systemctl start monitor-traffic || echo "monitor-traffic服务启动失败。"
systemctl enable monitor-traffic || echo "monitor-traffic服务启用失败。"

# 创建monitor命令的软链接
ln -s /usr/local/bin/menu.sh /usr/local/bin/monitor

# 创建并安装卸载脚本
wget -O /usr/local/bin/uninstall.sh "https://raw.githubusercontent.com/kk8bit/traffic-monitor-system/main/uninstall.sh" || echo "无法下载uninstall.sh"
chmod +x /usr/local/bin/uninstall.sh

# 安装完成提示
echo -e "\e[1;32m安装完成！现在可以使用'monitor'命令来调用流量监控菜单。\e[0m"
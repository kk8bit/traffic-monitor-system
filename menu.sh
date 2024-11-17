#!/bin/bash

show_menu() {
    echo -e "\n请选择一个选项:\n"
    echo "1. 查看当前流量"
    echo "2. 查看小时流量统计"
    echo "3. 查看月度流量统计"
    echo "4. 实时监控网络流量"
    echo "5. 实时监控网络连接"
    echo "6. 启动监控服务"
    echo "7. 停止监控服务"
    echo "8. 重启监控服务"
    echo "9. 查看监控服务状态"
    echo "10. 卸载流量监控系统"
    echo "0. 退出"
    echo -n "请输入选项 [0-10]: "
}

while true; do
    show_menu
    read option

    case $option in
        1) iptables -L ALL_TRAFFIC -v -n -x | awk 'NR==3 {print "Received:", $2, "bytes, Sent:", $10, "bytes"}' ;;
        2) vnstat -i eth0 -h || echo "无法获取小时流量统计。请检查vnstat服务是否已安装并运行。" ;;
        3) vnstat -m || echo "无法获取月度流量统计。请检查vnstat服务是否已安装并运行。" ;;
        4) nload -u H -m eth0 ;;
        5) iftop -i eth0 ;;
        6) sudo systemctl start monitor-traffic || echo "无法启动监控服务。" ;;
        7) sudo systemctl stop monitor-traffic || echo "无法停止监控服务。" ;;
        8) sudo systemctl restart monitor-traffic || echo "无法重启监控服务。" ;;
        9) sudo systemctl status monitor-traffic ;;
        10) sudo /usr/local/bin/uninstall.sh ;;
        0) echo "退出菜单"; exit 0 ;;
        *) echo "无效选项，请重新选择" ;;
    esac
    echo -e "\n按任意键继续..."
    read -n 1 -s -r
done
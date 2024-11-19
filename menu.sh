#!/bin/bash
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
format_bytes() {
    local size=$1
    local units=("B" "KB" "MB" "GB" "TB")
    local i=0
    local precision=2
    # 将size转换为整数以进行比较
    local int_size=${size%.*}
    while (( int_size >= 1024 )) && [ $i -lt $((${#units[@]}-1)) ]; do
        size=$(echo "scale=$precision; $size / 1024" | bc)
        int_size=${size%.*}  # 再次更新int_size为整数部分
        ((i++))
    done
    # 使用printf来格式化输出
    printf "%.${precision}f %s\n" "$size" "${units[$i]}"
}
show_menu() {
    echo -e "\n选择序号:\n"
    echo "1. 实时流量"
    echo "2. 实时连接"
    echo "3. 小时流量"
    echo "4. 7日流量"
    echo "5. 月度流量"
    echo "6. 启动服务"
    echo "7. 停止服务"
    echo "8. 重启服务"
    echo "9. 服务状态"
    echo "10. 卸载"
    echo "0. 退出"
    echo -n "输入序号 [0-10]: "
}
# 在脚本开始时显示logo和GitHub地址
if [ -z "$first_run" ]; then
    show_logo
    show_github_link
    export first_run=1
fi
# 获取系统时区
timezone=$(timedatectl show --property=Timezone --value)
export TZ=$timezone
while true; do
    show_menu
    read option
    case $option in
        1) 
            nload -u H -m ens5 ;;
        2) 
            iftop -i ens5 || {
                echo -e "\e[33m注意：实时连接需要root权限。使用sudo再次尝试。\e[0m"
                echo -e "\n按任意键继续..."
                read -n 1 -s -r
                continue
            } ;;
        3) vnstat -i ens5 -h || echo "无法获取小时流量。检查vnstat服务是否已安装并运行。" ;;
        4)
            # 获取今日日期
            today=$(date +%Y-%m-%d)
            # 获取7天前的日期
            seven_days_ago=$(date -d "$today -6 days" +%Y-%m-%d)
            # 使用vnstat7天内的流量
            vnstat -i ens5 -d --begin "$seven_days_ago" --end "$today" || echo "无法获取7日流量。检查vnstat服务是否已安装并运行。" ;;
        5) 
            vnstat -i ens5 -m || echo "无法获取月度流量。检查vnstat服务是否已安装并运行。" ;;
        6) sudo systemctl start monitor-traffic || echo "无法启动服务。" ;;
        7) sudo systemctl stop monitor-traffic || echo "无法停止服务。" ;;
        8) sudo systemctl restart monitor-traffic || echo "无法重启服务。" ;;
        9) sudo systemctl status monitor-traffic ;;
        10) sudo /usr/local/bin/uninstall.sh ;;
        0) echo "退出菜单"; exit 0 ;;
        *) echo "无效选项，重新选择" ;;
    esac
    echo -e "\n按任意键继续..."
    read -n 1 -s -r
done
# 流量监控系统

一个简单的命令行工具，用于监控服务器的网络流量，并提供交互式菜单进行流量查看和系统管理

## 安装

使用以下命令一键安装此系统：

```bash
bash <(wget -qO- https://raw.githubusercontent.com/kk8bit/traffic-monitor-system/main/install.sh)
```
### 注意 ：

- 安装过程中需要root权限，请确保以sudo权限运行命令。
- 如果之前已经安装了此系统，建议先运行卸载脚本以确保安装环境干净：

```bash
sudo /usr/local/bin/uninstall.sh
```

## 使用

安装完成后，你可以使用以下命令来调用流量监控菜单：
```bash
monitor
```

## 菜单选项

1. 查看当前流量 ：显示当前服务器的进出站流量
2. 查看小时流量统计 ：查看过去一小时的流量统计数据
3. 查看月度流量统计 ：查看本月的流量统计数据
4. 实时监控网络流量 ：实时监控网络接口的流量
5. 实时监控网络连接 ：查看实时的网络连接和流量
6. 启动监控服务 ：启动流量监控服务
7. 停止监控服务 ：停止流量监控服务
8. 重启监控服务 ：重启流量监控服务
9. 查看监控服务状态 ：检查监控服务的运行状态
10. 卸载流量监控系统 ：卸载此系统
11. 退出 ：退出菜单

## 卸载

如果你想卸载此系统，可以在菜单中选择选项10，或者直接运行卸载脚本：

```bash
sudo /usr/local/bin/uninstall.sh
```

## 注意事项

- 此系统依赖于`iptables`、`vnstat`、`nload`和`iftop`。这些工具必须在系统上可用
- 流量监控服务每小时记录一次数据，日志存储在`/var/log/traffic_monitor/traffic.log`
- 确保你的服务器有足够的权限来执行`iptables`和`systemd`相关命令
- 安装过程中会创建一个`monitor-traffic`的systemd服务，用于定时记录流量

## 许可证

此软件使用不可修改许可证（No Modification License）。你可以免费分发此软件，但不得对源代码进行任何修改

## 贡献
欢迎贡献！如果有任何问题或改进建议，请在GitHub上创建Issue或Pull Request
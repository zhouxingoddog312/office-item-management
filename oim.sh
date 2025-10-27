#!/bin/env bash
SCRIPT_DIR=$(dirname "$0")
############引入oim.config中定义的环境变量
#优先加载用户自定义配置文件，其次加载系统配置文件，最后加载本地配置文件
HOME_CONFIG="$HOME/oim.config"
SYSTEM_CONFIG="/usr/local/etc/oim/oim.config"
LOCAL_CONFIG="$SCRIPT_DIR/oim.config"
if [ -f "$HOME_CONFIG" ]
then
	source "$HOME_CONFIG"
elif [ -f "$SYSTEM_CONFIG" ]
then
	source "$SYSTEM_CONFIG"
elif [ -f "$LOCAL_CONFIG" ]
then
	source "$LOCAL_CONFIG"
else
	echo "错误：未找到配置文件！" >&2
	echo "请确保配置文件存在于以下路径之一：" >&2
	echo "1. 系统路径：$HOME_CONFIG（用户自定义配置文件）" >&2
	echo "2. 系统路径：$SYSTEM_CONFIG（安装后默认配置文件）" >&2
	echo "3. 脚本路径：$LOCAL_CONFIG（开发时配置文件）" >&2
	exit 1
fi
############引入库函数
LIB_PATH="$SCRIPT_DIR/functions"
############函数库
if [ ! -f "$LIB_PATH" ]
then
	echo "错误：函数库文件$LIB_PATH不存在！" >&2
	exit 1
fi
source "$LIB_PATH"
############

###########创建工作目录
check_dir "$WORK_DIR"
check_dir "$METADATA_DIR"
check_dir "$BACKUP_DIR"
###########

############创建log文件，输出重定向
exec 7<>"$LIST_FILE"
exec 8>>"$LOG"
############
#注册退出时备份的函数
trap 'backup' EXIT
#调用启动备份函数
init_startup_backup
#记录脚本启动信息
echo "$(date +'%Y-%m-%d %H:%M:%S') - 物品管理脚本启动，工作目录$WORK_DIR" >&8


############
help
version
############
echo "$(date +'%Y-%m-%d %H:%M:%S') - 开始检查依赖工具……" >&8
install_dependency "sed" >&8
install_dependency "gawk" >&8
install_dependency "zenity" >&8
install_dependency "python3" >&8
install_dependency "lpstat" "cups-client" >&8
install_dependency "fc-list" "fontconfig" >&8
#install_dependency "python3-reportlab" "python3-reportlab" >&8
echo "$(date +'%Y-%m-%d %H:%M:%S') - 依赖工具检查完成" >&8
############
function main_menu()
{
#一级菜单选择（模块）
	local main_choice
#二级菜单选择（具体功能）
	local sub_choice
	while true
	do
		log_rotate
#一级菜单：仅展示模块选项
		main_choice=$(zenity --list --print-column=1 --width=$WIDTH --height=$HEIGHT --title="物品管理系统(V$(version 2>/dev/null))" --text="请选择操作模块" --column="序号" --column="模块名称" 1 "人员管理" 2 "库存管理" 3 "操作记录查询" 4 "存档数据管理" 5 "回撤本次运行期间所有操作" 6 "退出系统" 7 "清空所有数据及备份" 2>/dev/null)
#处理一级菜单取消/空选择
		if [ $? -ne 0 ] || [ -z "$main_choice" ]
		then
			zenity --question --width=$WIDTH --height=$HEIGHT --title="确认退出" --text="是否确认退出系统？" 2>/dev/null
			if [ $? -eq 0 ]
			then
    				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户确认退出系统" >&8
    				break
			else
				continue
			fi
		fi
#二级菜单：根据一级模块展示具体功能
		case "$main_choice" in
#人员管理模块 → 二级功能
		1)
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 进入【人员管理】模块" >&8
			sub_choice=$(zenity --list --print-column=1 --width=$WIDTH --height=$HEIGHT --title="人员管理" --text="请选择人员管理操作" --column="序号" --column="操作功能" 1 "查看职工名单" 2 "添加工作人员" 3 "删除工作人员" 0 "返回主菜单" 2>/dev/null)
#检查取消或空选择
			if [ $? -ne 0 ] || [ -z "$sub_choice" ]
			then
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户取消【人员管理】二级操作，返回主菜单" >&8
				continue
			fi
#处理人员管理二级菜单
			case "$sub_choice" in
			1)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【查看职工名单】" >&8
				show_employee
				;;
			2)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【添加工作人员】" >&8
				add_employee
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【添加工作人员】完成" >&8
				;;
			3)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【删除工作人员】" >&8
				del_employee
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【删除工作人员】完成" >&8
				;;
			0)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 从【人员管理】返回主菜单" >&8
				;;
			*)
				zenity --warning --width=$WIDTH --height=$HEIGHT --title="无效选择" --text="请选择正确的序号（0-3）！" 2>/dev/null
				;;
			esac
			;;

#库存管理模块 → 二级功能
		2)
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 进入【库存管理】模块" >&8
			sub_choice=$(zenity --list --print-column=1 --width=$WIDTH --height=$HEIGHT --title="库存管理" --text="请选择库存管理操作" --column="序号" --column="操作功能" 1 "查看当前库存" 2 "添加物品种类" 3 "删除物品种类" 4 "物品入库" 5 "物品出库" 0 "返回主菜单" 2>/dev/null)
#检查取消或空选择
			if [ $? -ne 0 ] || [ -z "$sub_choice" ]
			then
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户取消【库存管理】二级操作，返回主菜单" >&8
				continue
			fi
#处理库存管理二级菜单
			case "$sub_choice" in
			1)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【查看当前库存】" >&8
				show_inventory
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【查看当前库存】完成" >&8
				;;
			2)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【添加物品种类】" >&8
				add_item
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【添加物品种类】完成" >&8
				;;
			3)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【删除物品种类】" >&8
				del_item
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【删除物品种类】完成" >&8
				;;
			4)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【物品入库】" >&8
				inbound
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【物品入库】完成" >&8
				;;
			5)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【物品出库】" >&8
				outbound
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【物品出库】完成" >&8
				;;
			0)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 从【库存管理】返回主菜单" >&8
				;;
			*)
				zenity --warning --width=$WIDTH --height=$HEIGHT --title="无效选择" --text="请选择正确的序号（0-5）！" 2>/dev/null
				;;
			esac
			;;
#操作记录查询模块 → 二级功能（仅1项）
		3)
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【操作记录查询】" >&8
			query_records
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 【操作记录查询】完成" >&8
			;;
#存档数据管理模块 → 二级功能
		4)
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 进入【存档数据管理】模块" >&8
			sub_choice=$(zenity --list --print-column=1 --width=$WIDTH --height=$HEIGHT --title="存档数据管理" --text="请选择存档数据管理操作" --column="序号" --column="操作功能" 1 "导出数据（打包tar.gz）" 2 "导入数据（覆盖现有）" 0 "返回主菜单" 2>/dev/null)
#检查取消或空选择
			if [ $? -ne 0 ] || [ -z "$sub_choice" ]
			then
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户取消【存档数据管理】二级操作，返回主菜单" >&8
				continue
			fi
#处理数据管理二级菜单
			case "$sub_choice" in
			1)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【导出数据】" >&8
				export_data
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【导出数据】操作完成" >&8
				;;
			2)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【导入数据】" >&8
				import_data
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【导入数据】操作完成" >&8
				;;
			0)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 从【存档数据管理】返回主菜单" >&8
				;;
			*)
				zenity --warning --width=$WIDTH --height=$HEIGHT --title="无效选择" --text="请选择正确的序号（0-2）！" 2>/dev/null
				;;
			esac
			;;
#回撤所有操作（无二级菜单，直接执行）
		5)
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【回撤本次运行期间所有操作】" >&8
			rollback_operations
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 【回撤本次运行期间所有操作】完成" >&8
			;;
#退出系统（无二级菜单，直接退出）
		6)
			zenity --info --width=$WIDTH --height=$HEIGHT --title="退出系统" --text="即将退出物品管理系统。" 2>/dev/null
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户选择【退出系统】，退出脚本" >&8
			break
			;;
#清空所有数据及备份（无二级菜单，直接执行）
		7)
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 进入【清空所有数据及备份】模块" >&8
			clear_all_data
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 【清空所有数据及备份】操作完成" >&8
			;;
#无效一级选项
		*)
			zenity --warning --width=$WIDTH --height=$HEIGHT --title="无效选择" --text="请选择正确的模块序号（1-7）！" 2>/dev/null
			echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户选择无效模块序号：$main_choice" >&8
			;;
		esac
		sleep 1
	done
}
main_menu
############
echo "$(date +'%Y-%m-%d %H:%M:%S') - 物品管理脚本结束运行" >&8
###########
exit 0

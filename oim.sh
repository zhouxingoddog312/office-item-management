#!/bin/env bash
############环境变量
SCRIPT_DIR=$(dirname "$0")
LIB_PATH="$SCRIPT_DIR/functions"

WORK_DIR="$HOME/oim"
LOG="$WORK_DIR/oim.log"
METADATA_DIR="$WORK_DIR/data"
BACKUP_DIR="$WORK_DIR/backup"
ITEM_FILE="$METADATA_DIR/item"
EMPLOYEE_FILE="$METADATA_DIR/employee"
LIST_FILE="$METADATA_DIR/list"
ITEM_FILE_BACKUP="$BACKUP_DIR/item.backup"
EMPLOYEE_FILE_BACKUP="$BACKUP_DIR/employee.backup"
LIST_FILE_BACKUP="$BACKUP_DIR/list.backup"

WIDTH=800
HEIGHT=600
############

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
echo "$(date +'%Y-%m-%d %H:%M:%S') - 依赖工具检查完成" >&8
############
function main_menu()
{
	local choice
	local opt
	while true
	do
		choice=$(zenity --list --print-column=1 --width=$WIDTH --height=$HEIGHT --title="物品管理系统(V$(version 2>/dev/null))" --text="请选择操作类型" --column="序号" --column="操作类型" 1 "添加工作人员" 2 "删除工作人员" 3 "添加物品种类" 4 "删除物品种类" 5 "物品入库" 6 "物品出库" 7 "查询操作记录" 8 "退出系统" 2>/dev/null)
#用户点击取消
		if [ $? -ne 0 ] || [ -z "$choice" ]
		then
			zenity --question --width=$WIDTH --height=$HEIGHT --title="确认退出" --text="是否确认退出系统？" 2>/dev/null
			if [ $? -eq 0 ]
			then
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户点击取消主菜单，确认退出系统" >&8
				break
			else
				continue
			fi
		fi
		case "$choice" in
			1)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【添加工作人员】" >&8
				add_employee
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【添加工作人员】完成" >&8
				;;
			2)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【删除工作人员】" >&8
				del_employee
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【删除工作人员】完成" >&8
				;;
			3)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【添加物品种类】" >&8
				add_item
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【添加物品种类】完成" >&8
				;;
			4)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【删除物品种类】" >&8
				del_item
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【删除物品种类】完成" >&8
				;;
			5)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【入库】" >&8
				inbound
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【入库】完成" >&8
				;;
			6)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【出库】" >&8
				outbound
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【出库】完成" >&8
				;;
			7)
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 选择【查询操作记录】" >&8
				query_records
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 【查询操作记录】完成" >&8
				;;
			8)
				zenity --info --width=$WIDTH --height=$HEIGHT --title="退出系统" --text="即将退出物品管理系统。" 2>/dev/null
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户选择【退出系统】，退出脚本" >&8
				break
				;;
			*)
				zenity --warning --width=$WIDTH --height=$HEIGHT -title="无效选择" --text="请选择正确的操作序号（1-8）！" 2>/dev/null
				echo "$(date +'%Y-%m-%d %H:%M:%S') - 用户选择无效序号：$choice" >&8
				;;
		esac
		sleep 1
	done
}
main_menu
############关闭输出重定向
echo "$(date +'%Y-%m-%d %H:%M:%S') - 物品管理脚本结束运行" >&8
exec 7>&-
exec 8>&-
###########
exit 0

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
############

############函数库
source "$LIB_PATH"
############

###########创建工作目录
check_dir "$WORK_DIR"
check_dir "$METADATA_DIR"
check_dir "$BACKUP_DIR"
###########

############创建log文件，输出重定向
exec 7<>"$LIST_FILE"
#将LIST_FILE的文件指针移动到文件末尾，防止从开头写入内容，覆盖原有内容
dd if=/dev/null of>&7 bs=1 seek=$(stat -c %s "$LIST_FILE") 2>/dev/null
exec 8>>"$LOG"
############



############
help
version
install_sed >&8
install_gawk >&8
install_zenity >&8
add_employee
del_employee
add_item
del_item
############




############关闭输出重定向
exec 7>&-
exec 8>&-
###########

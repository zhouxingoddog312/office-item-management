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
############

############函数库
source "$LIB_PATH"
############

###########创建工作目录
check_dir "$WORK_DIR"
###########

############创建log文件，输出重定向
exec 8>>"$LOG"
############



############
help
version
install_sed >&8
install_zenity >&8
check_dir "$METADATA_DIR" >&8
check_dir "$BACKUP_DIR" >&8
add_employee
############




############关闭输出重定向
exec 8>&-
###########

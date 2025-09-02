#!/bin/env bash
############环境变量
SCRIPT_DIR=$(dirname "$0")
LIB_PATH="$SCRIPT_DIR/functions"

WORK_DIR="$home/oim"
LOG="$WORK_DIR/oim.log"
METADATA_DIR="$WORK_DIR/data"
ITEM_FILE="$METADATA_DIR/item"
EMPLOYEE_FILE="$METADATA_DIR/employee"
LIST_FILE="$METADATA_DIR/list"
############

############创建log文件，输出重定向

############

############函数库
source "$LIB_PATH"
version
############




############关闭输出重定向

############

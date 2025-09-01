#!/bin/env bash
############环境变量
SCRIPT_DIR=$(dirname "$0")
LIB_PATH="$SCRIPT_DIR/functions"

WORK_DIR="$home/oim"
LOG="$WORK_DIR/oim.log"
METADATA_DIR="$WORK_DIR/"
############

############函数库
source "$LIB_PATH"
version
############

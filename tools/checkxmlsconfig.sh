#!/bin/bash - 
#===============================================================================
#
#          FILE: checkxmlsconfig.sh
# 
#         USAGE: ./checkxmlsconfig.sh 
# 
#   DESCRIPTION: check overlay xml configs valuable ok or not.
#                检查 overlay 中的XML配置文件中的变量是否可用
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2014年05月18日 12时40分57秒 CST
#      REVISION:  ---
#===============================================================================

# self: get location
self=$(readlink -f $0)
self_dir=$(dirname $self)

# 输出提示
tip(){
    echo -e "\e[0;35m==> ${@}\e[0m"
}

# 次级错误信息
errsub(){
    echo -e "\e[0;31m  --> ${@}\e[0m"
}

overlay_dir=${self_dir%/tools}/overlay

cd $overlay_dir
find -type f -name "*.xml" | while read file; do
    tip "Processing ${file#./}"
    egrep -o 'name=".*"' $file | awk '{print $1}' | while read line; do
            grep -q $line ../../../../$file || errsub "  Failed valuable: $line"
        done
    echo
done

#!/bin/bash - 
#===============================================================================
#
#          FILE: get_android_built_filelist.sh
# 
#         USAGE: ./get_android_built_filelist.sh 
# 
#   DESCRIPTION: get what stuffs android built, 获取Android编译生成的文件列表
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2014年05月20日 13时34分18秒 CST
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

filelist_all=${1:-'i9300_filelist.txt'}
filelist_prop=${2:-'i9300_propfiles.txt'}
filelist_android=${3:-'i9300_android.txt'}

> $filelist_android
for i in $(cat $filelist_all); do
    grep -q -F --max-count=1 "$i" $filelist_prop || echo $i >> $filelist_android
done
echo "done, pls check $filelist_android"

#!/bin/bash - 
#===============================================================================
#
#          FILE: pull2here.sh
# 
#         USAGE: ./pull2here.sh 
# 
#   DESCRIPTION: 用于从tmp.txt中把文件从手机上pull至本地PC
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#       CREATED: 2013年06月05日 13时57分49秒 HKT
#     COPYRIGHT: Copyright (c) 2013, linkscue
#      REVISION: 0.1
#  ORGANIZATION: ATX风雅组
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

file=tmp.txt                                    # specify ref file

pull_one_file(){
    cmd="adb pull $2 ${1//device\/lenovo\/stuttgart\//}"
    echo -n "$cmd -- " && $cmd
}

cat $file | sed "/^$/d;/root/d;s/:/ /g;s/\\\//g" | while read line
do 
    pull_one_file $line
done

#!/bin/bash - 
#===============================================================================
#
#          FILE: checkprops.sh
# 
#         USAGE: ./checkprops.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2014年05月20日 13时42分19秒 CST
#      REVISION:  ---
#===============================================================================

# 输出次级信息
infosub(){
    echo -e "\e[0;36m  --> ${@}\e[0m"
}

# 次级错误信息
errsub(){
    echo -e "\e[0;31m  --> ${@}\e[0m"
}

proprietary_file=${1:-'../../proprietary-files.txt'}
filelist_android=${2:-'i9300_android.txt'}

for i in $(cat $proprietary_file); do
    grep -q -F --max-count=1 "$i" $filelist_android&&errsub "$i"||infosub "$i"
done
echo
echo " RED: these files can be built from Android Source Tree"
echo " CYAN: these file should be reversed"
echo

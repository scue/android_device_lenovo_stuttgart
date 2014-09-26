#!/bin/bash - 
#===============================================================================
#
#          FILE: getliblist.sh
# 
#         USAGE: ./getliblist.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2014年05月09日 12时03分47秒 CST
#      REVISION:  ---
#===============================================================================

# fun: usage
usage(){
    echo -en "\e[0;31m" # color: red
    echo "==> Usage: $(basename $0) getlist|libname."
    echo "==> $(basename $0) getlist system_dir # 获取/system的apk中的lib列表"
    echo "==> $(basename $0) libname            # 获取一个lib在哪个apk中包含有"
    echo "==> $(basename $0) libdir             # 获取目录中所有lib都位于哪个apk中"
    echo "==> 通常输出文件 libslist_notfound.txt 便是我们需要的"
    echo -en "\e[0m"
    exit
}
# detect: help
if [[ ${1} != "" ]]; then
    case ${1} in
        "-h" | "--help" | "-help" )
            usage
            ;;
    esac
fi
test -z $1 && usage

system_dir=${2:-system_out}
libs_list=libslist.txt
libs_notfound=libslist_notfound.txt

# 获取 apk 文件中的 lib 列表
list(){
    for i in $system_dir/app/*.apk ; do
        echo " -> processing $i" 1>&2
        unzip -l $i | grep lib |\
            awk -va=$(basename $i) '{printf("%-32s %-32s\n", a,$NF)}'
    done > $libs_list
    echo "==> get libs list done"
}
# 检查单独一个lib*.so文件是否在 apk 中
search(){
    grep -F "$(basename $1)" $libs_list ||
        echo "lib/$(basename $1)" > $libs_notfound
}
# 检查目录中的libs文件是否在 apk 中
search_dir(){
    for i in $1/*; do
        search $i
    done
}
case $1 in
    getlist )
        list
        ;;
    *)
        if [[ -d $1 ]]; then
            search_dir $1
        else
            search $1
        fi
        ;;
esac

#!/bin/bash - 
#===============================================================================
#
#          FILE: build.sh
# 
#         USAGE: ./build.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2014年05月21日 10时34分04秒 CST
#      REVISION:  ---
#===============================================================================

# ./quick_build.sh c # 清除$OUT并编译
# ./quick_build.sh n # 正常编译（只清理$OUT/system $OUT/boot）
# ./quick_build.sh t # 不清除，只测试 boot 和 system

# 输出提示
tip(){
    echo -e "\e[0;35m==> ${@}\e[0m"
}

tstart=$(date +%s);
build_mod=${1:-normal}

tip "Init environment"
. build/envsetup.sh

tip "lunch stuttgart"
lunch cm_stuttgart-eng

tip "get-prebuilts"
if [[ ! -e vendor/cm/proprietary/Term.apk ]]; then
    (cd vendor/cm; ./get-prebuilts)
fi

case $build_mod in
    c|clear|Clear )
        tip "clear out"
        rm -rf $OUT
        tip "make systemimage bootimage"
        mka bootimage systemimage;
        ;;
    n|normal|Normal )
        tip "clear vendor"
        (rm -rf vendor/lenovo/stuttgart/; cd device/lenovo/stuttgart; ./extract-files.sh)
        tip "make systemimage bootimage"
        mka bootimage systemimage;
        ;;
    t|test|Test )
        : 不清除任何东西
        ;;
esac

tip "flash boot system"
adb -s 0123456789ABCDEF reboot-bootloader;
fastboot flash boot;
fastboot flash system;
fastboot -w;
fastboot reboot; 
date -u -d @$(($(date +%s)-$tstart)) +"%Hh %Mm %Ss"

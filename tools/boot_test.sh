#!/bin/bash - 
#===============================================================================
#
#          FILE: boot_test.sh
# 
#         USAGE: ./boot_test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue(scue),
#  ORGANIZATION: 
#       CREATED: 2013年08月05日 03时04分29秒 HKT
#      REVISION:  ---
#===============================================================================

cd $OUT
if [[ "$(adb devices | grep 0123456789ABCDEF)" != "" ]]; then
    adb -s 0123456789ABCDEF reboot bootloader
fi
mkbootfs root | minigzip > ramdisk.img.cpio
mkimage -A ARM -O Linux -T ramdisk -C none -a 0x40800000 -e 0x40800000 -n ramdisk -d ramdisk.img.cpio ramdisk.img.cpio.gz
mkbootimg --kernel kernel --ramdisk ramdisk.img.cpio.gz --cmdline "" --base 0x10000000 --pagesize 2048 --output boot.img.test
fastboot flash boot boot.img.test
fastboot reboot

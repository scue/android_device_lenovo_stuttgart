#!/bin/bash - 
#===============================================================================
#
#          FILE: szbtool_repack.sh
# 
#         USAGE:$ . build/envsetup.sh
#               $ breakfast stuttgart
#               $ cd device/lenovo/stuttgart/tools/
#               $ ./repackszb.sh [szbname]
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2013年08月22日 15时00分37秒 HKT
#      REVISION:  ---
#===============================================================================

local_dir=$(dirname $(readlink -f $0))

#release
if [[ "$1" != "" ]]; then
    szbname="$1"
else
    szbname=stuttgart_cm10.1_release.szb
fi

#images
bootloader=$local_dir/uboot.bin
bootimage=$OUT/boot.img
systemimage=$OUT/system.img
cpimage=$local_dir/cpimage.img
preload=$OUT/preload.img

# info
echo "local_dir=$local_dir"
echo "cpimage=$cpimage"

# szb
cd $local_dir
if [[ -f $szbname ]]; then
    rm -f $szbname
fi

szbtool=$local_dir/szbtool
echo "make szb .."
$szbtool \
    -b $bootloader \
    -k $bootimage \
    -s $systemimage \
    -c $cpimage \
    -p $preload \
    -e -v $szbname

# zip
if [[ -f $local_dir/$szbname.zip ]]; then
    rm -f $local_dir/$szbname.zip
fi
echo "make zip .."
zip $local_dir/$szbname.zip $local_dir/$szbname

# md5sum
if [[ -f $local_dir/$szbname.zip ]]; then
    md5sum $szbname.zip > $local_dir/$szbname.zip.md5sum
    echo "md5sum of zip:"
    cat $local_dir/$szbname.zip.md5sum
fi

# move
mv $szbname $OUT/$szbname
mv $szbname.zip $OUT/$szbname.zip
mv $szbname.zip.md5sum $OUT/$szbname.zip.md5sum

# goback
cd - >/dev/null

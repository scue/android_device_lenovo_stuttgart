#!/bin/bash - 
#===============================================================================
#
#          FILE: img2dir.sh
# 
#         USAGE: $ . build/envsetup
#                $ cd device/lenovo/stuttgart/tools
#                $ ./img2dir.sh [system.img | preload.img] [output_dir]
# 
#   DESCRIPTION: A tool to unpack system.img or preload.img to a directory.
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: >> to unpack a szb file, just ./szbtool x /path/to/szbfile. <<
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#       CREATED: 2013年05月13日 00时03分02秒 HKT
#     COPYRIGHT: Copyright (c) 2013, linkscue
#      REVISION: 0.1
#  ORGANIZATION:
#===============================================================================

local_dir=$(dirname $(readlink -f $0))

if [[ $# == 0 ]]; then
    echo "usage: $0 [system.img | preload.img] [output dir]"
    exit 0
fi

if [[ "$(echo $1 | egrep 'cpimage|preload')" ]]; then
    alias simg2img="$local_dir/ics_ext4_utils/simg2img"
fi

#output dir 
if [[ "$2" != "" ]]; then
    output=$2
else
    output=${1//.img/}
fi

if [[ -f "$1" ]]; then
    sudo ls > /dev/null
    if [[ "$(file $1 | grep data)" != "" ]]; then
        img_out=${1//.img/}_out.img
        echo "unpack $1 > $img_out"
        simg2img $1 $img_out
        FLAG_OUT=1
    else
        img_out=$1
    fi
    tmp_dir=${1}_tmp_$$
    mkdir -p $tmp_dir 2> /dev/null
    sudo mount $img_out $tmp_dir
    sudo chown -R 1000:1000 $tmp_dir
    sudo chmod -R u+rw $tmp_dir
    if [[ -d ${1//.img/} ]]; then
        echo "backup ${1//.img/} ${1//.img/}_bak"
        if [[ -d ${1//.img/}_bak ]]; then
            rm -rf ${1//.img/}_bak
        fi
        mv ${1//.img/} ${1//.img/}_bak
    fi
    echo "cp file to ${1//.img/}"
    cp -af $tmp_dir ${1//.img/}
    sudo umount $tmp_dir
    rm -rf $tmp_dir
    if [[ $FLAG_OUT == 1 ]]; then
        echo "rm -f $img_out"
        rm -f $img_out
    fi
fi

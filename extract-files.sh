#!/bin/bash - 
#===============================================================================
#
#          FILE: extract-files.sh
# 
#         USAGE: ./extract-files.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#       CREATED: 2013年06月04日 01时18分05秒 HKT
#     COPYRIGHT: Copyright (c) 2013, linkscue
#      REVISION: 0.1
#  ORGANIZATION: 
#===============================================================================


# add by linkscue, start, for extract file
tmp_system=../../../device/lenovo/stuttgart/tmp/system

if [[ ! -d "$tmp_system" ]]; then
    mkdir -p $tmp_system
fi

if [[ "$(ls "$tmp_system")" == "" ]]; then
    cat proprietary-files.txt | while read line; do adb pull /system/$line tmp/system/$line;done
fi
# add by linkscue, end

BASE=../../../vendor/lenovo/stuttgart/proprietary
rm -rf $BASE/*

for FILE in `egrep -v '(^#|^$)' proprietary-files.txt`; do
  DIR=`dirname $FILE`
  if [ ! -d $BASE/$DIR ]; then
    mkdir -p $BASE/$DIR
  fi
  cp $tmp_system/$FILE $BASE/$FILE
done

./setup-makefiles.sh

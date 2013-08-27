#!/bin/bash - 
#===============================================================================
#
#          FILE: supercam_update.sh
# 
#         USAGE: ./supercam_update.sh 
# 
#   DESCRIPTION: $ ./supercam_update.sh      # update lib/ LeGA/ only
#                $ ./supercam_update.sh info # update lib/ LeGA/ and show info
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2013年08月27日 15时18分28秒 HKT
#      REVISION:  ---
#===============================================================================

local_dir=$(dirname $(readlink -f $0))
supercam_apk=$local_dir/SCG_arm_hd.apk

cd $local_dir

# remove old dirs
if [[ -e lib ]]; then
    echo "<<< remove lib/"
    rm -rf lib
fi
if [[ -e LeGA ]]; then
    echo "<<< remove LeGA/"
    rm -rf LeGA
fi

# unzip
tmp_dir=$(mktemp -d tmp.XXX)
echo ">>> unzip $supercam_apk .."
unzip -q $supercam_apk -d $tmp_dir

# move
echo ">>> move new stuff form apk .."
mv $tmp_dir/lib/armeabi-v7a lib
mv $tmp_dir/assets/LeGA LeGA

# info 
if [[ "$1" == info ]]; then
    echo ">>> lib/:"
    for n in $(ls lib/); do
        echo "device/lenovo/stuttgart/supercam/lib/$n:system/lib/$n \\"
    done
    echo ""
    echo ">>> LeGA/:"
    for n in $(ls LeGA/); do
        echo "device/lenovo/stuttgart/supercam/LeGA/$n:system/LeGA/$n \\"
    done
    echo ""
    echo "<<< add the output above to stuttgart.mk, if you need."
    echo ""
fi

# finish
echo "<<< remove $tmp_dir/ .."
rm -rf $tmp_dir
cd - >/dev/null
echo ">>> all done."

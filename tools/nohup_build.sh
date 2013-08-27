#!/bin/bash - 
#===============================================================================
#
#          FILE: remote_build.sh
# 
#         USAGE: # Login your machine via another client.
#                $ ssh -qX user@local_machine_ip
#                $ cd /path/to/src
#                $ ./device/lenovo/stuttgart/tools/remote_build.sh
#                $ tail -f out.txt
# 
#   DESCRIPTION:
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2013年08月27日 10时30分51秒 HKT
#      REVISION:  ---
#===============================================================================

cd $(dirname $0)
top_dir=${PWD%/device/lenovo/stuttgart/tools}
cd $top_dir

tmp_cmd=/tmp/build_cmd_$$
cat << EOF > $tmp_cmd
#!/bin/bash
. build/envsetup.sh
breakfast stuttgart
make -j4 bootimage systemimage >out.txt 2>&1 &
EOF

chmod 755 $tmp_cmd
nohup $tmp_cmd >/dev/null 2>&1 &

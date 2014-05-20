#!/bin/bash - 
#===============================================================================
#
#          FILE: android_mk_analysis.sh
# 
#         USAGE: ./android_mk_analysis.sh 
# 
#   DESCRIPTION: 分析Android系统指定目录中的Android.mk都编译了什么系统文件
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: linkscue (scue), linkscue@gmail.com
#  ORGANIZATION: 
#       CREATED: 2014年03月11日 18时59分39秒 CST
#      REVISION:  ---
#===============================================================================

if [[ $# == 0 ]] || [[ ! -d ${1} ]]; then
    echo "Usage: $(basename $0) dir"
    exit
fi

tmp_mod=/tmp/mk_tmp_mod.txt
tmp_build=/tmp/mk_tmp_build.txt
output_mod=unkown
output_type=unkown
path=unkown
find ${1} -name Android.mk | while read line; do
    #echo -e "\e[0;36m${line%/Android.mk}:\e[0m" # cyan
    path=${line%/Android.mk}
    echo "=> ${path#./}:"
    > $tmp_mod
    > $tmp_build
    grep -w '^LOCAL_MODULE\|^LOCAL_PACKAGE_NAME' $line > $tmp_mod
    grep '^include $(BUILD_' $line > $tmp_build
    paste -d "|" $tmp_mod $tmp_build |\
        sed 's/ //g;s/LOCAL_PACKAGE_NAME//;s/LOCAL_MODULE//;' |\
        sed 's/=//;s/://;s/include//;s/\$(//;s/)//;' |\
        while read l;do
            output_mod=$(echo $l | awk -F'|' '{print $1}')
            output_type=$(echo $l | awk -F'|' '{print $2}')
            
            case $output_type in
                "BUILD_HOST_STATIC_LIBRARY")
                    echo "   ${output_mod}.so (host,static)"
                    ;;
                "BUILD_HOST_SHARED_LIBRARY")
                    echo "   ${output_mod}.so (host,share)"
                    ;;
                "BUILD_STATIC_LIBRARY")
                    echo "   system/lib/${output_mod}.so (static)"
                    ;;
                "BUILD_RAW_STATIC_LIBRARY")
                    echo "   system/lib/${output_mod}.so (raw)"
                    ;;
                "BUILD_SHARED_LIBRARY")
                    echo "   system/lib/${output_mod}.so (share)"
                    ;;
                "BUILD_EXECUTABLE")
                    echo "   system/bin/$output_mod"
                    ;;
                "BUILD_RAW_EXECUTABLE")
                    echo "   system/bin/${output_mod} (raw)"
                    ;;
                "BUILD_HOST_EXECUTABLE")
                    echo "   out/host/linux-x86/bin/${output_mod} (host)"
                    ;;
                "BUILD_PACKAGE")
                    echo "   ${output_mod}.apk"
                    ;;
                "BUILD_PHONY_PACKAGE")
                    echo "   ${output_mod}.apk (phony)"
                    ;;
                "BUILD_HOST_PREBUILT")
                    echo "   ${output_mod} (host,prebult)"
                    ;;
                "BUILD_PREBUILT")
                    echo "   ${output_mod} (prebult)"
                    ;;
                "BUILD_MULTI_PREBUILT")
                    echo "   ${output_mod} (multi,prebult)"
                    ;;
                "BUILD_JAVA_LIBRARY")
                    echo "   ${output_mod}.jar (android)"
                    ;;
                "BUILD_STATIC_JAVA_LIBRARY")
                    echo "   ${output_mod}.jar (android,static)"
                    ;;
                "BUILD_HOST_JAVA_LIBRARY")
                    echo "   ${output_mod}.jar (host,share)"
                    ;;
                "BUILD_DROIDDOC")
                    echo "   ${output_mod} (droid,doc)"
                    ;;
                "BUILD_COPY_HEADERS")
                    echo "   ${output_mod} (copy headers)"
                    ;;
                "BUILD_NATIVE_TEST")
                    echo "   ${output_mod} (native test)"
                    ;;
                "BUILD_HOST_NATIVE_TEST")
                    echo "   ${output_mod} (host,native test)"
                    ;;
                *)
                    echo "   ${output_mod}|$output_type"
                    ;;

            esac    # --- end of case ---
        done
        echo
done

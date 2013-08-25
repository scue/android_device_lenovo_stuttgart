#!/system/bin/sh

# setup log service
if [ -e /local/log/aplog/aplogsetting.enable ]; then
for svc in dmesglog tcplog mainlog radiolog; do
    if [ -e /local/log/aplog/${svc}.enable ]; then
        setprop ctl.start $svc
    else
        setprop ctl.stop $svc
    fi
done
elif [ $(getprop ro.debuggable) = 1 ]; then
    setprop ctl.start dmesglog
    setprop ctl.start tcplog
    setprop ctl.start mainlog
    setprop ctl.start radiolog
fi

rm -r /data/lost+found

#fix su
busybox chmod 755 /system/xbin/su
busybox chmod ug+s /system/xbin/su

#for preload SuperCam & other
preload_app_sh=/preload/LeApps/leapp_init.sh
if [[ -f "$preload_app_sh" ]]; then
    busybox chmod 755 $preload_app_sh && $preload_app_sh
fi

#for /system/etc/init.d
initd_dir=/system/etc/init.d
if [[ -d "$initd_dir" ]]; then
    busybox chmod -R 775 $initd_dir && busybox run-parts $initd_dir
fi

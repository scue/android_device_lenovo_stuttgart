package com.cyanogenmod.settings.device;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.util.AttributeSet;
import android.widget.Toast;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceManager;

import java.io.File;

public class Sdcard extends ListPreference implements OnPreferenceChangeListener {

    private static final String FILE = "/system/etc/vold.primary.fstab";
    private Context mCtx;

    public Sdcard(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.setOnPreferenceChangeListener(this);
        mCtx = context;
    }

    public static boolean isSupported() {
        return Utils.fileExists(FILE);
    }

    /**
     * Restore hspa setting from SharedPreferences. (Write to kernel.)
     * @param context       The context to read the SharedPreferences from
     */
    public static void restore(Context context) { //重置时，它的默认操作
        if (!isSupported()) {
            return;
        }

//        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
    }

    public boolean onPreferenceChange(Preference preference, Object newValue) { //当它有变化时，它的操作
        String fstab_file = "/system/etc/vold.fstab";
        String fstab_primary = "/system/etc/vold.primary.fstab";
        String fstab_extra = "/system/etc/vold.extra_sd_as_primary.fstab";
        String sysrw = "mount -o remount,rw /system";
        String sysro = "mount -o remount,ro /system";
        if (((String)newValue).compareTo("24") == 0 ) {
            Toast.makeText(mCtx, R.string.fstab_do_nothing, Toast.LENGTH_SHORT).show();
        }
        if (((String)newValue).compareTo("25") == 0 ) {
            RootCmd.execRootCmdSilent(sysrw);
            RootCmd.execRootCmdSilent("cp "+fstab_primary+" "+fstab_file);
            RootCmd.execRootCmdSilent(sysro);
            Toast.makeText(mCtx, R.string.toast_reboot_tip, Toast.LENGTH_SHORT).show();
            Toast.makeText(mCtx, R.string.fstab_internal_success, Toast.LENGTH_SHORT).show();
        }
        if (((String)newValue).compareTo("26") == 0 ) {
            RootCmd.execRootCmdSilent(sysrw);
            RootCmd.execRootCmdSilent("cp "+fstab_extra+" "+fstab_file);
            RootCmd.execRootCmdSilent(sysro);
            Toast.makeText(mCtx, R.string.toast_reboot_tip, Toast.LENGTH_SHORT).show();
            Toast.makeText(mCtx, R.string.fstab_external_success, Toast.LENGTH_SHORT).show();
        }
        return true;
    }
}

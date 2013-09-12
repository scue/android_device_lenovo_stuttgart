/*
 * Copyright (C) 2012 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

public class Gapps extends ListPreference implements OnPreferenceChangeListener {

    private static final String FILE = "/preload/gms/gms_install_d.sh";
    private Context mCtx;

    public Gapps(Context context, AttributeSet attrs) {
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
//        sendIntent(context, sharedPrefs.getString(DeviceSettings.KEY_HSPA, "21"));
    }

    public boolean onPreferenceChange(Preference preference, Object newValue) { //当它有变化时，它的操作
        if (((String)newValue).compareTo("21") == 0 ) {
            Toast.makeText(mCtx, R.string.gapps_do_nothing, Toast.LENGTH_SHORT).show();
        }
        if (((String)newValue).compareTo("22") == 0 ) {
            String intsall_f = "sh /preload/gms/gms_install_d.sh";
            Toast.makeText(mCtx, RootCmd.execRootCmdSilent(intsall_f), Toast.LENGTH_SHORT).show();
            Toast.makeText(mCtx, R.string.toast_reboot_tip, Toast.LENGTH_SHORT).show();
            Toast.makeText(mCtx, R.string.gapps_install_success, Toast.LENGTH_SHORT).show();
        }
        if (((String)newValue).compareTo("23") == 0 ) {
            String remove_f = "sh /preload/gms/gms_remove_d.sh";
            Toast.makeText(mCtx, RootCmd.execRootCmdSilent(remove_f), Toast.LENGTH_SHORT).show();
            Toast.makeText(mCtx, R.string.toast_reboot_tip, Toast.LENGTH_SHORT).show();
            Toast.makeText(mCtx, R.string.gapps_remove_success, Toast.LENGTH_SHORT).show();
        }
        return true;
    }
}

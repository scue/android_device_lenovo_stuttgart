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
import android.content.res.Resources;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.CheckBoxPreference;
import android.preference.EditTextPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.util.Log;
import android.widget.Toast;

import com.cyanogenmod.settings.device.R;

import java.io.File;

public class LenovoFragmentActivity extends PreferenceFragment {

    private static final String PREF_ENABLED = "1";
    private static final String TAG = "DeviceSettings_Radio";
    private Gapps gapps;
    private Sdcard sdcard;
    
    /* mac */
    private CheckBoxPreference mac_lock;
    private EditTextPreference mac_edit;
    private String mac_addr_location = "/data/misc/wifi/wifi_mac.txt";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        addPreferencesFromResource(R.xml.lenovo_preferences);
        PreferenceScreen prefSet = getPreferenceScreen();
        Resources res = getResources();
        
        gapps = (Gapps)findPreference(DeviceSettings.KEY_GAPPS );
        gapps.setEnabled((new File("/preload/gms/gms_install_d.sh")).exists());
        
        sdcard = (Sdcard)findPreference(DeviceSettings.KEY_SDCARD);
        sdcard.setEnabled((new File("/system/etc/vold.primary.fstab").exists()));
        
        /* MAC */
        
        mac_edit = (EditTextPreference)prefSet.findPreference(DeviceSettings.KEY_MAC_EDIT);
        mac_lock = (CheckBoxPreference)prefSet.findPreference(DeviceSettings.KEY_MAC_LOCK);

    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {

        String key = preference.getKey();

        Log.w(TAG, "key: " + key);
        if ((key.compareTo(DeviceSettings.KEY_MAC_EDIT) == 0)) {
            Toast.makeText(getActivity(), R.string.toast_mac_change_tip, 10).show();
        }         
        if (key.compareTo(DeviceSettings.KEY_MAC_LOCK) == 0) {
            if (((CheckBoxPreference)preference).isChecked()) {
//                Toast.makeText(getActivity(), "您锁定了MAC地址 "+mac_edit.getText(), 10).show();
                mac_lock.setSummary(R.string.mac_lock_summary1);
                String cmd1="chmod 664 "+mac_addr_location;
                String cmd2="echo "+mac_edit.getText()+" > "+mac_addr_location;
                String cmd3="chmod 444 "+mac_addr_location;
                RootCmd.execRootCmdSilent(cmd1);
                RootCmd.execRootCmdSilent(cmd2);
                RootCmd.execRootCmdSilent(cmd3);
//                Toast.makeText(getActivity(),cmd1, 10).show();
//                Toast.makeText(getActivity(),cmd2, 10).show();
//                Toast.makeText(getActivity(),cmd3, 10).show();
            } else {
//                Toast.makeText(getActivity(), "您解锁了MAC地址"+mac_edit.getText(), 10).show();
                mac_lock.setSummary(R.string.mac_lock_summary2);
                RootCmd.execRootCmdSilent("chmod 664 "+mac_addr_location);
                RootCmd.execRootCmdSilent("rm -f "+mac_addr_location);
            }
        }
        
        return true;
    }

    public static boolean isSupported(String FILE) {
        return Utils.fileExists(FILE);
    }

    public static void restore(Context context) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
    }
}

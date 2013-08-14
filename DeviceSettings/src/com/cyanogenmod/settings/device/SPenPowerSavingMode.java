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
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceManager;

public class SPenPowerSavingMode extends CheckBoxPreference implements OnPreferenceChangeListener {

    private static String FILE_PATH = null;

    public SPenPowerSavingMode(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.setOnPreferenceChangeListener(this);
        FILE_PATH = context.getResources().getString(R.string.spen_powersaving_sysfs_file);
    }

    public static boolean isSupported(String filePath) {
        return Utils.fileExists(filePath);
    }

    /**
     * Restore s-pen setting from SharedPreferences. (Write to kernel.)
     * @param context       The context to read the SharedPreferences from
     */
    public static void restore(Context context) {
        FILE_PATH = context.getResources().getString(R.string.spen_powersaving_sysfs_file);

        if (!isSupported(FILE_PATH)) {
            return;
        }

        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
        Utils.writeValue(FILE_PATH, sharedPrefs.getBoolean(DeviceSettings.KEY_SPEN_POWER_SAVING_MODE, false) ? "1" : "0");
    }

    public boolean onPreferenceChange(Preference preference, Object newValue) {
        Utils.writeValue(FILE_PATH, ((Boolean) newValue) ? "1" : "0");
        return true;
    }
}

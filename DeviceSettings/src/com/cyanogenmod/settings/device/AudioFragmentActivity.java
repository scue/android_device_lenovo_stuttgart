/*
* Copyright (C) 2012 The CyanogenMod Project
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package com.cyanogenmod.settings.device;

import android.app.ActivityManagerNative;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.UserHandle;
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceFragment;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.util.Log;

import com.cyanogenmod.settings.device.R;

public class AudioFragmentActivity extends PreferenceFragment {

    private static final String PREF_ENABLED = "1";
    private static final String TAG = "DeviceSettings_Audio";
    public static final String KEY_INCALL_TUNING = "incall_tuning";
    public static final String KEY_AUDIOOUT_TUNING = "audioout_tuning";

    private static boolean sIncallTuning;
    private static boolean sAudioOutTuning;
    private static boolean mEnableIncall = false;
    private static boolean mEnableAudioOut = false;
    private IncallAudio mIncallTuning;
    private AudioOut mAudioOutTuning;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        addPreferencesFromResource(R.xml.audio_preferences);
        PreferenceScreen prefSet = getPreferenceScreen();

        Resources res = getResources();
        sIncallTuning = res.getBoolean(R.bool.has_incall_audio_tuning);
        sAudioOutTuning = res.getBoolean(R.bool.has_output_audio_tuning);

        mIncallTuning = (IncallAudio) findPreference(KEY_INCALL_TUNING);
        mAudioOutTuning = (AudioOut) findPreference(KEY_AUDIOOUT_TUNING);

        if(sIncallTuning){
             if(mIncallTuning.isSupported("earpiece") || mIncallTuning.isSupported("headphone") ||
               mIncallTuning.isSupported("speaker") || mIncallTuning.isSupported("bt"))
                  mEnableIncall = true;
        }

        if(sAudioOutTuning){
             if(mAudioOutTuning.isSupported("headphone") || mAudioOutTuning.isSupported("speaker"))
                 mEnableAudioOut = true;
        }

        mIncallTuning.setEnabled(mEnableIncall);
        mAudioOutTuning.setEnabled(mEnableAudioOut);
    }

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {

        String boxValue;
        String key = preference.getKey();

        Log.w(TAG, "key: " + key);

        if (key.compareTo(DeviceSettings.KEY_USE_DOCK_AUDIO) == 0) {
            boxValue = (((CheckBoxPreference)preference).isChecked() ? "1" : "0");
            Intent i = new Intent("com.cyanogenmod.settings.SamsungDock");
            i.putExtra("data", boxValue);
            ActivityManagerNative.broadcastStickyIntent(i, null, UserHandle.USER_ALL);
        }
        return true;
    }

    public static void restore(Context context) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
        boolean dockAudio = sharedPrefs.getBoolean(DeviceSettings.KEY_USE_DOCK_AUDIO, false);
        Intent i = new Intent("com.cyanogenmod.settings.SamsungDock");
        i.putExtra("data", (dockAudio? "1" : "0"));
        ActivityManagerNative.broadcastStickyIntent(i, null, UserHandle.USER_ALL);
    }
}

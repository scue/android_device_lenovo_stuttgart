/*
 * Copyright (C) 2013 The CyanogenMod Project
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

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Color;
import android.graphics.LightingColorFilter;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.os.Bundle;
import android.os.Vibrator;
import android.preference.DialogPreference;
import android.preference.PreferenceManager;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Button;

import java.lang.Math;
import java.text.DecimalFormat;

/**
 * Special preference type that allows configuration of audio out volume on some smdk4412
 * Devices
 */
public class AudioOut extends DialogPreference implements SeekBar.OnSeekBarChangeListener {
    private static final String TAG = "DeviceSettings_AudioOut";

    private static String AUDIOOUT_HEADPHONE_FILE = "/data/local/audio/out_headphone";
    private static String AUDIOOUT_SPEAKER_FILE = "/data/local/audio/out_speaker";
    private static int MAX_VALUE;
    private static int WARNING_THRESHOLD;
    private static int DEFAULT_VALUE;
    private static int MIN_VALUE;

    private SeekBar mHeadphoneSeekBar;
    private SeekBar mSpeakerSeekBar;
    private TextView mHeadphoneValue;
    private TextView mSpeakerValue;
    private TextView mWarning;

    private String mHeadphoneOgValue;
    private String mSpeakerOgValue;
    private int mHeadphoneOgPercent;
    private int mSpeakerOgPercent;

    private Drawable mHeadphoneProgressDrawable;
    private Drawable mSpeakerProgressDrawable;
    private Drawable mHeadphoneProgressThumb;
    private Drawable mSpeakerProgressThumb;
    private LightingColorFilter mRedFilter;

    private enum Device {
        headphone,
        speaker
    }

    public AudioOut(Context context, AttributeSet attrs) {
        super(context, attrs);

        MAX_VALUE = Integer.valueOf(context.getResources().getString(R.string.audioout_max_value));
        WARNING_THRESHOLD = Integer.valueOf(context.getResources().getString(R.string.audioout_warning_threshold));
        DEFAULT_VALUE = Integer.valueOf(context.getResources().getString(R.string.audioout_default_value));
        MIN_VALUE = Integer.valueOf(context.getResources().getString(R.string.audioout_min_value));

        setDialogLayoutResource(R.layout.preference_dialog_output_audio_tuning);
    }

    @Override
    protected void onPrepareDialogBuilder(AlertDialog.Builder builder) {
        builder.setNeutralButton(R.string.defaults_button, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
            }
        });
    }

    @Override
    protected void onBindDialogView(View view) {
        super.onBindDialogView(view);

        mHeadphoneSeekBar = (SeekBar) view.findViewById(R.id.audioout_headphone_seekbar);
        mHeadphoneValue = (TextView) view.findViewById(R.id.audioout_headphone_value);
        mSpeakerSeekBar = (SeekBar) view.findViewById(R.id.audioout_speaker_seekbar);
        mSpeakerValue = (TextView) view.findViewById(R.id.audioout_speaker_value);
        mWarning = (TextView) view.findViewById(R.id.audioout_textWarn);

        String strWarnMsg = getContext().getResources().getString(R.string.audioout_warning, volumeToPercent(WARNING_THRESHOLD));
        mWarning.setText(strWarnMsg);

        Drawable progressDrawableHeadphone = mHeadphoneSeekBar.getProgressDrawable();
        if (progressDrawableHeadphone instanceof LayerDrawable) {
            LayerDrawable ldHeadphone = (LayerDrawable) progressDrawableHeadphone;
            mHeadphoneProgressDrawable = ldHeadphone.findDrawableByLayerId(android.R.id.progress);
        }
        Drawable progressDrawableSpeaker = mSpeakerSeekBar.getProgressDrawable();
        if (progressDrawableSpeaker instanceof LayerDrawable) {
            LayerDrawable ldSpeaker = (LayerDrawable) progressDrawableSpeaker;
            mSpeakerProgressDrawable = ldSpeaker.findDrawableByLayerId(android.R.id.progress);
        }

        mHeadphoneProgressThumb = mHeadphoneSeekBar.getThumb();
        mSpeakerProgressThumb = mSpeakerSeekBar.getThumb();

        mRedFilter = new LightingColorFilter(Color.BLACK,
                getContext().getResources().getColor(android.R.color.holo_red_light));

        mHeadphoneOgValue = Utils.readOneLine(AUDIOOUT_HEADPHONE_FILE);
        mHeadphoneOgPercent = volumeToPercent(Integer.parseInt(mHeadphoneOgValue));

        mHeadphoneSeekBar.setOnSeekBarChangeListener(this);
        mHeadphoneSeekBar.setProgress(Integer.valueOf(mHeadphoneOgPercent));

        mSpeakerOgValue = Utils.readOneLine(AUDIOOUT_SPEAKER_FILE);
        mSpeakerOgPercent = volumeToPercent(Integer.parseInt(mSpeakerOgValue));

        mSpeakerSeekBar.setOnSeekBarChangeListener(this);
        mSpeakerSeekBar.setProgress(Integer.valueOf(mSpeakerOgPercent));
    }

    @Override
    protected void showDialog(Bundle state) {
        super.showDialog(state);

        // can't use onPrepareDialogBuilder for this as we want the dialog
        // to be kept open on click
        AlertDialog d = (AlertDialog) getDialog();
        Button defaultsButton = d.getButton(DialogInterface.BUTTON_NEUTRAL);
        defaultsButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mHeadphoneSeekBar.setProgress(volumeToPercent(DEFAULT_VALUE));
                mSpeakerSeekBar.setProgress(volumeToPercent(DEFAULT_VALUE));
            }
        });
    }

    @Override
    protected void onDialogClosed(boolean positiveResult) {
        super.onDialogClosed(positiveResult);
        int volumeHeadphone, volumeSpeaker;

        if (positiveResult) {
            Editor editor = getEditor();

            volumeHeadphone = percentToVolume(mHeadphoneSeekBar.getProgress());
            editor.putString(AUDIOOUT_HEADPHONE_FILE, String.valueOf(volumeHeadphone));
            volumeSpeaker = percentToVolume(mSpeakerSeekBar.getProgress());
            editor.putString(AUDIOOUT_SPEAKER_FILE, String.valueOf(volumeSpeaker));
            editor.commit();
        } else {
            Utils.writeValue(AUDIOOUT_HEADPHONE_FILE, String.valueOf(mHeadphoneOgValue));
            Utils.writeValue(AUDIOOUT_SPEAKER_FILE, String.valueOf(mSpeakerOgValue));
        }
    }

    public static void restore(Context context) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);

        if (isSupported("headphone"))
            Utils.writeValue(AUDIOOUT_HEADPHONE_FILE, sharedPrefs.getString(AUDIOOUT_HEADPHONE_FILE, "50"));
        if (isSupported("speaker"))
            Utils.writeValue(AUDIOOUT_SPEAKER_FILE, sharedPrefs.getString(AUDIOOUT_SPEAKER_FILE, "50"));
    }

    public static boolean isSupported(String output) {
        String FILE = null;
        Device outputDevice = Device.valueOf(output);

        switch(outputDevice) {
            case headphone:
                FILE = AUDIOOUT_HEADPHONE_FILE;
            case speaker:
                FILE = AUDIOOUT_SPEAKER_FILE;
        }
        return Utils.fileExists(FILE);
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        boolean shouldWarn = progress >= volumeToPercent(WARNING_THRESHOLD);
        int stepSize = 1;
        progress = Math.round(progress/stepSize)*stepSize;

        if(seekBar == mHeadphoneSeekBar){
            if (mHeadphoneProgressDrawable != null) {
                mHeadphoneProgressDrawable.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            if (mHeadphoneProgressThumb != null) {
                mHeadphoneProgressThumb.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            mHeadphoneSeekBar.setProgress(progress);
            Utils.writeValue(AUDIOOUT_HEADPHONE_FILE, String.valueOf(percentToVolume(progress)));
            mHeadphoneValue.setText(String.format("%d%%", progress));
        }else if(seekBar == mSpeakerSeekBar){
            if (mSpeakerProgressDrawable != null) {
                mSpeakerProgressDrawable.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            if (mSpeakerProgressThumb != null) {
                mSpeakerProgressThumb.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            mSpeakerSeekBar.setProgress(progress);
            Utils.writeValue(AUDIOOUT_SPEAKER_FILE, String.valueOf(percentToVolume(progress)));
            mSpeakerValue.setText(String.format("%d%%", progress));
        }
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
        // Do nothing
    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
        //Vibrator vib = (Vibrator) getContext().getSystemService(Context.VIBRATOR_SERVICE);
        //vib.vibrate(200);
    }

    /**
    * Convert volume to percent
    */
    public static int volumeToPercent(int volume) {
        double maxValue = MAX_VALUE;
        double minValue = MIN_VALUE;

        double percent = Math.round((volume - minValue) * (100 / (maxValue - minValue)));

        if (percent > 100)
            percent = 100;
        else if (percent < 0)
            percent = 0;

        return (int) percent;
    }

    /**
    * Convert percent to volume
    */
    public static int percentToVolume(int percent) {
        int volume = Math.round((((MAX_VALUE - MIN_VALUE) * percent) / 100) + MIN_VALUE);

        if (volume > MAX_VALUE)
            volume = MAX_VALUE;
        else if (volume < MIN_VALUE)
            volume = MIN_VALUE;

        return volume;
    }
}

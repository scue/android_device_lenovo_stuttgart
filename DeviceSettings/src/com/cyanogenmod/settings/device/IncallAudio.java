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
 * Special preference type that allows configuration of incall volume on some smdk4412
 * Devices
 */
public class IncallAudio extends DialogPreference implements SeekBar.OnSeekBarChangeListener {
    private static final String TAG = "DeviceSettings_IncallAudio";

    private static String INCALL_EARPIECE_FILE = "/data/local/audio/incall_earpiece";
    private static String INCALL_HEADPHONE_FILE = "/data/local/audio/incall_headphone";
    private static String INCALL_SPEAKER_FILE = "/data/local/audio/incall_speaker";
    private static String INCALL_BT_FILE = "/data/local/audio/incall_bt";
    private static int MAX_VALUE;
    private static int WARNING_THRESHOLD;
    private static int DEFAULT_VALUE;
    private static int MIN_VALUE;

    private SeekBar mEarpieceSeekBar;
    private SeekBar mHeadphoneSeekBar;
    private SeekBar mSpeakerSeekBar;
    private SeekBar mBtSeekBar;
    private TextView mEarpieceValue;
    private TextView mHeadphoneValue;
    private TextView mSpeakerValue;
    private TextView mBtValue;
    private TextView mWarning;

    private String mEarpieceOgValue;
    private String mHeadphoneOgValue;
    private String mSpeakerOgValue;
    private String mBtOgValue;
    private int mEarpieceOgPercent;
    private int mHeadphoneOgPercent;
    private int mSpeakerOgPercent;
    private int mBtOgPercent;

    private Drawable mEarpieceProgressDrawable;
    private Drawable mHeadphoneProgressDrawable;
    private Drawable mSpeakerProgressDrawable;
    private Drawable mBtProgressDrawable;
    private Drawable mEarpieceProgressThumb;
    private Drawable mHeadphoneProgressThumb;
    private Drawable mSpeakerProgressThumb;
    private Drawable mBtProgressThumb;
    private LightingColorFilter mRedFilter;

    private enum Device {
        earpiece,
        headphone,
        speaker,
        bt
    }

    public IncallAudio(Context context, AttributeSet attrs) {
        super(context, attrs);

        MAX_VALUE = Integer.valueOf(context.getResources().getString(R.string.incall_max_value));
        WARNING_THRESHOLD = Integer.valueOf(context.getResources().getString(R.string.incall_warning_threshold));
        DEFAULT_VALUE = Integer.valueOf(context.getResources().getString(R.string.incall_default_value));
        MIN_VALUE = Integer.valueOf(context.getResources().getString(R.string.incall_min_value));

        setDialogLayoutResource(R.layout.preference_dialog_incall_audio_tuning);
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

        mEarpieceSeekBar = (SeekBar) view.findViewById(R.id.earpiece_seekbar);
        mEarpieceValue = (TextView) view.findViewById(R.id.earpiece_value);
        mHeadphoneSeekBar = (SeekBar) view.findViewById(R.id.headphone_seekbar);
        mHeadphoneValue = (TextView) view.findViewById(R.id.headphone_value);
        mSpeakerSeekBar = (SeekBar) view.findViewById(R.id.speaker_seekbar);
        mSpeakerValue = (TextView) view.findViewById(R.id.speaker_value);
        mBtSeekBar = (SeekBar) view.findViewById(R.id.bt_seekbar);
        mBtValue = (TextView) view.findViewById(R.id.bt_value);
        mWarning = (TextView) view.findViewById(R.id.incall_textWarn);

        String strWarnMsg = getContext().getResources().getString(R.string.incall_warning, volumeToPercent(WARNING_THRESHOLD));
        mWarning.setText(strWarnMsg);

        Drawable progressDrawableEarpiece = mEarpieceSeekBar.getProgressDrawable();
        if (progressDrawableEarpiece instanceof LayerDrawable) {
            LayerDrawable ldEarpiece = (LayerDrawable) progressDrawableEarpiece;
            mEarpieceProgressDrawable = ldEarpiece.findDrawableByLayerId(android.R.id.progress);
        }
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
        Drawable progressDrawableBt = mBtSeekBar.getProgressDrawable();
        if (progressDrawableBt instanceof LayerDrawable) {
            LayerDrawable ldBt = (LayerDrawable) progressDrawableBt;
            mBtProgressDrawable = ldBt.findDrawableByLayerId(android.R.id.progress);
        }
        mEarpieceProgressThumb = mEarpieceSeekBar.getThumb();
        mHeadphoneProgressThumb = mHeadphoneSeekBar.getThumb();
        mSpeakerProgressThumb = mSpeakerSeekBar.getThumb();
        mBtProgressThumb = mBtSeekBar.getThumb();
        mRedFilter = new LightingColorFilter(Color.BLACK,
                getContext().getResources().getColor(android.R.color.holo_red_light));

        mEarpieceOgValue = Utils.readOneLine(INCALL_EARPIECE_FILE);
        mEarpieceOgPercent = volumeToPercent(Integer.parseInt(mEarpieceOgValue));

        mEarpieceSeekBar.setOnSeekBarChangeListener(this);
        mEarpieceSeekBar.setProgress(Integer.valueOf(mEarpieceOgPercent));

        mHeadphoneOgValue = Utils.readOneLine(INCALL_HEADPHONE_FILE);
        mHeadphoneOgPercent = volumeToPercent(Integer.parseInt(mHeadphoneOgValue));

        mHeadphoneSeekBar.setOnSeekBarChangeListener(this);
        mHeadphoneSeekBar.setProgress(Integer.valueOf(mHeadphoneOgPercent));

        mSpeakerOgValue = Utils.readOneLine(INCALL_SPEAKER_FILE);
        mSpeakerOgPercent = volumeToPercent(Integer.parseInt(mSpeakerOgValue));

        mSpeakerSeekBar.setOnSeekBarChangeListener(this);
        mSpeakerSeekBar.setProgress(Integer.valueOf(mSpeakerOgPercent));

        mBtOgValue = Utils.readOneLine(INCALL_BT_FILE);
        mBtOgPercent = volumeToPercent(Integer.parseInt(mBtOgValue));

        mBtSeekBar.setOnSeekBarChangeListener(this);
        mBtSeekBar.setProgress(Integer.valueOf(mBtOgPercent));
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
                mEarpieceSeekBar.setProgress(volumeToPercent(DEFAULT_VALUE));
                mHeadphoneSeekBar.setProgress(volumeToPercent(DEFAULT_VALUE));
                mSpeakerSeekBar.setProgress(volumeToPercent(DEFAULT_VALUE));
                mBtSeekBar.setProgress(volumeToPercent(DEFAULT_VALUE));
            }
        });
    }

    @Override
    protected void onDialogClosed(boolean positiveResult) {
        super.onDialogClosed(positiveResult);
        int volumeEarpiece, volumeHeadphone, volumeSpeaker, volumeBt;

        if (positiveResult) {
            Editor editor = getEditor();

            volumeEarpiece = percentToVolume(mEarpieceSeekBar.getProgress());
            editor.putString(INCALL_EARPIECE_FILE, String.valueOf(volumeEarpiece));
            volumeHeadphone = percentToVolume(mHeadphoneSeekBar.getProgress());
            editor.putString(INCALL_HEADPHONE_FILE, String.valueOf(volumeHeadphone));
            volumeSpeaker = percentToVolume(mSpeakerSeekBar.getProgress());
            editor.putString(INCALL_SPEAKER_FILE, String.valueOf(volumeSpeaker));
            volumeBt = percentToVolume(mBtSeekBar.getProgress());
            editor.putString(INCALL_BT_FILE, String.valueOf(volumeBt));
            editor.commit();
        } else {
            Utils.writeValue(INCALL_EARPIECE_FILE, String.valueOf(mEarpieceOgValue));
            Utils.writeValue(INCALL_HEADPHONE_FILE, String.valueOf(mHeadphoneOgValue));
            Utils.writeValue(INCALL_SPEAKER_FILE, String.valueOf(mSpeakerOgValue));
            Utils.writeValue(INCALL_BT_FILE, String.valueOf(mBtOgValue));
        }
    }

    public static void restore(Context context) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);

        if (isSupported("earpiece"))
            Utils.writeValue(INCALL_EARPIECE_FILE, sharedPrefs.getString(INCALL_EARPIECE_FILE, "5"));
        if (isSupported("headphone"))
            Utils.writeValue(INCALL_HEADPHONE_FILE, sharedPrefs.getString(INCALL_HEADPHONE_FILE, "5"));
        if (isSupported("speaker"))
            Utils.writeValue(INCALL_SPEAKER_FILE, sharedPrefs.getString(INCALL_SPEAKER_FILE, "5"));
        if (isSupported("bt"))
            Utils.writeValue(INCALL_BT_FILE, sharedPrefs.getString(INCALL_BT_FILE, "5"));
    }

    public static boolean isSupported(String output) {
        String FILE = null;
        Device outputDevice = Device.valueOf(output);

        switch(outputDevice) {
            case earpiece:
                FILE = INCALL_EARPIECE_FILE;
            case headphone:
                FILE = INCALL_HEADPHONE_FILE;
            case speaker:
                FILE = INCALL_SPEAKER_FILE;
            case bt:
                FILE = INCALL_BT_FILE;
        }
        return Utils.fileExists(FILE);
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        boolean shouldWarn = progress >= volumeToPercent(WARNING_THRESHOLD);
        int stepSize = 10;
        progress = Math.round(progress/stepSize)*stepSize;

        if(seekBar == mEarpieceSeekBar){
            if (mEarpieceProgressDrawable != null) {
                mEarpieceProgressDrawable.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            if (mEarpieceProgressThumb != null) {
                mEarpieceProgressThumb.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            mEarpieceSeekBar.setProgress(progress);
            Utils.writeValue(INCALL_EARPIECE_FILE, String.valueOf(percentToVolume(progress)));
            mEarpieceValue.setText(String.format("%d%%", progress));
        }else if(seekBar == mHeadphoneSeekBar){
            if (mHeadphoneProgressDrawable != null) {
                mHeadphoneProgressDrawable.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            if (mHeadphoneProgressThumb != null) {
                mHeadphoneProgressThumb.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            mHeadphoneSeekBar.setProgress(progress);
            Utils.writeValue(INCALL_HEADPHONE_FILE, String.valueOf(percentToVolume(progress)));
            mHeadphoneValue.setText(String.format("%d%%", progress));
        }else if(seekBar == mSpeakerSeekBar){
            if (mSpeakerProgressDrawable != null) {
                mSpeakerProgressDrawable.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            if (mSpeakerProgressThumb != null) {
                mSpeakerProgressThumb.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            mSpeakerSeekBar.setProgress(progress);
            Utils.writeValue(INCALL_SPEAKER_FILE, String.valueOf(percentToVolume(progress)));
            mSpeakerValue.setText(String.format("%d%%", progress));
        }else if(seekBar == mBtSeekBar){
            if (mBtProgressThumb != null) {
                mBtProgressThumb.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            if (mBtProgressDrawable != null) {
                mBtProgressDrawable.setColorFilter(shouldWarn ? mRedFilter : null);
            }
            mBtSeekBar.setProgress(progress);
            Utils.writeValue(INCALL_BT_FILE, String.valueOf(percentToVolume(progress)));
            mBtValue.setText(String.format("%d%%", progress));
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

        double percent = volume * 10;

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
        int volume = Math.round(percent / 10);

        if (volume > MAX_VALUE)
            volume = MAX_VALUE;
        else if (volume < MIN_VALUE)
            volume = MIN_VALUE;

        return volume;
    }
}

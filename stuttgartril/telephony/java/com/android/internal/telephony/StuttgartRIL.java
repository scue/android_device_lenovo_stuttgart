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

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;
import static android.telephony.TelephonyManager.NETWORK_TYPE_UNKNOWN;
import static android.telephony.TelephonyManager.NETWORK_TYPE_EDGE;
import static android.telephony.TelephonyManager.NETWORK_TYPE_GPRS;
import static android.telephony.TelephonyManager.NETWORK_TYPE_UMTS;
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSDPA;
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSUPA;
import static android.telephony.TelephonyManager.NETWORK_TYPE_HSPA;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.media.AudioManager;
import android.net.ConnectivityManager;
import android.net.LocalSocket;
import android.net.LocalSocketAddress;
import android.net.NetworkInfo;
import android.os.AsyncResult;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.os.Parcel;
import android.os.PowerManager;
import android.os.SystemProperties;
import android.os.PowerManager.WakeLock;
import android.telephony.NeighboringCellInfo;
import android.telephony.PhoneNumberUtils;
//import android.telephony.SmsManager;
//import android.telephony.SmsMessage;
import android.text.TextUtils;
import android.util.Log;

//import com.android.internal.telephony.gsm.SmsBroadcastConfigInfo;
//import com.android.internal.telephony.gsm.SuppServiceNotification;
//import com.android.internal.telephony.cdma.CdmaCallWaitingNotification;
//import com.android.internal.telephony.cdma.CdmaInformationRecords;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.Runtime;
import java.util.ArrayList;
import java.util.Collections;



/**
* {@hide}
*/
public class StuttgartRIL extends Smdk4210RIL implements CommandsInterface {
    public StuttgartRIL(Context context, int networkMode, int cdmaSubscription) {
        super(context, networkMode, cdmaSubscription);
    }

   @Override
    protected Object
    responseCallList(Parcel p) {
        int num;
        boolean isVideo;
        ArrayList<DriverCall> response;
        DriverCall dc;
        int dataAvail = p.dataAvail();
        int pos = p.dataPosition();
        int size = p.dataSize();

        Log.d(LOG_TAG, "Parcel size = " + size);
        Log.d(LOG_TAG, "Parcel pos = " + pos);
        Log.d(LOG_TAG, "Parcel dataAvail = " + dataAvail);

        //Samsung changes
        num = p.readInt();

        Log.d(LOG_TAG, "num = " + num);
        response = new ArrayList<DriverCall>(num);

        for (int i = 0 ; i < num ; i++) {

            dc                      = new DriverCall();
            dc.state                = DriverCall.stateFromCLCC(p.readInt());
            dc.index                = p.readInt();
            dc.TOA                  = p.readInt();
            dc.isMpty               = (0 != p.readInt());
            dc.isMT                 = (0 != p.readInt());
            dc.als                  = p.readInt();
            dc.isVoice              = (0 != p.readInt());
            dc.isVoicePrivacy       = (0 != p.readInt());
            dc.number               = p.readString();
            int np                  = p.readInt();
            dc.numberPresentation   = DriverCall.presentationFromCLIP(np);
            dc.name                 = p.readString();
            dc.namePresentation     = p.readInt();
            int uusInfoPresent      = p.readInt();

            Log.d(LOG_TAG, "state = " + dc.state);
            Log.d(LOG_TAG, "index = " + dc.index);
            Log.d(LOG_TAG, "state = " + dc.TOA);
            Log.d(LOG_TAG, "isMpty = " + dc.isMpty);
            Log.d(LOG_TAG, "isMT = " + dc.isMT);
            Log.d(LOG_TAG, "als = " + dc.als);
            Log.d(LOG_TAG, "isVoice = " + dc.isVoice);
            Log.d(LOG_TAG, "number = " + dc.number);
            Log.d(LOG_TAG, "np = " + np);
            Log.d(LOG_TAG, "name = " + dc.name);
            Log.d(LOG_TAG, "namePresentation = " + dc.namePresentation);
            Log.d(LOG_TAG, "uusInfoPresent = " + uusInfoPresent);

            if (uusInfoPresent == 1) {
                dc.uusInfo = new UUSInfo();
                dc.uusInfo.setType(p.readInt());
                dc.uusInfo.setDcs(p.readInt());
                byte[] userData = p.createByteArray();
                dc.uusInfo.setUserData(userData);
                Log
                .v(LOG_TAG, String.format("Incoming UUS : type=%d, dcs=%d, length=%d",
                        dc.uusInfo.getType(), dc.uusInfo.getDcs(),
                        dc.uusInfo.getUserData().length));
                Log.v(LOG_TAG, "Incoming UUS : data (string)="
                        + new String(dc.uusInfo.getUserData()));
                Log.v(LOG_TAG, "Incoming UUS : data (hex): "
                        + IccUtils.bytesToHexString(dc.uusInfo.getUserData()));
            } else {
                Log.v(LOG_TAG, "Incoming UUS : NOT present!");
            }

            // Make sure there's a leading + on addresses with a TOA of 145
            dc.number = PhoneNumberUtils.stringFromStringAndTOA(dc.number, dc.TOA);

            response.add(dc);

            if (dc.isVoicePrivacy) {
                mVoicePrivacyOnRegistrants.notifyRegistrants();
                Log.d(LOG_TAG, "InCall VoicePrivacy is enabled");
            } else {
                mVoicePrivacyOffRegistrants.notifyRegistrants();
                Log.d(LOG_TAG, "InCall VoicePrivacy is disabled");
            }
        }

        Collections.sort(response);

        return response;
    }

   @Override
    protected Object
    responseSignalStrength(Parcel p) {
        int numInts = 12;
        int response[];

        boolean oldRil = true ;
        /* TODO: Add SignalStrength class to match RIL_SignalStrength */
        response = new int[numInts];
        for (int i = 0 ; i < numInts ; i++) {
            if (oldRil && i > 6 && i < 12) {
                response[i] = -1;
            } else {
                response[i] = p.readInt();
            }
        }
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm0=" + response[0]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm1=" + response[1]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm2=" + response[2]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm3=" + response[3]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm4=" + response[4]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm5=" + response[5]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm6=" + response[6]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm7=" + response[7]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm8=" + response[8]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm9=" + response[9]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm10=" + response[10]);
        Log.d(LOG_TAG, "responseSignalStength AFTER: gsmDbm11=" + response[11]);


        return response;
    }



 }

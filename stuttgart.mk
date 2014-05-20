#
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_BASEDIR)/overlay
LOCAL_BASEDIR=device/lenovo/stuttgart

# overlay
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_BASEDIR)/overlay

# UTC
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# languages
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

# Gps
PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/configs/gpsconfig.xml:system/etc/gpsconfig.xml

# This device is xhdpi.  However the platform doesn't
# currently contain all of the bitmaps at xhdpi density so
# we do this little trick to fall back to the hdpi version
# if the xhdpi doesn't exist.
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi
# Boot: root dir
PRODUCT_COPY_FILES := \
    $(LOCAL_BASEDIR)/rootdir/fstab.stuttgart:root/sbin/fstab.stuttgart \
    $(LOCAL_BASEDIR)/rootdir/gpio:root/sbin/gpio \
    $(LOCAL_BASEDIR)/rootdir/init.stuttgart.rc:root/init.stuttgart.rc \
    $(LOCAL_BASEDIR)/rootdir/init.testmode.rc:root/init.testmode.rc \
    $(LOCAL_BASEDIR)/rootdir/init.cp_update.rc:root/init.cp_update.rc \
    $(LOCAL_BASEDIR)/rootdir/ueventd.stuttgart.rc:root/ueventd.stuttgart.rc

# Boot: vendor firmware
PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/rootdir/vendor/firmware/fimc_is_fw.bin:root/vendor/firmware/fimc_is_fw.bin \
    $(LOCAL_BASEDIR)/rootdir/vendor/firmware/mfc_fw.bin:root/vendor/firmware/mfc_fw.bin \
    $(LOCAL_BASEDIR)/rootdir/vendor/firmware/setfile.bin:root/vendor/firmware/setfile.bin \
    $(LOCAL_BASEDIR)/rootdir/vendor/firmware/setfile_S5K3H7.bin:root/vendor/firmware/setfile_S5K3H7.bin

# Boot: yma
PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/0_2MIC_HS_NB.dat:root/ymc/param/0_2MIC_HS_NB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/0_2MICNSOFF_HS_NB.dat:root/ymc/param/0_2MICNSOFF_HS_NB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/1_1MIC_HF_NB.dat:root/ymc/param/1_1MIC_HF_NB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/2_2MIC_REC_WB.dat:root/ymc/param/2_2MIC_REC_WB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/3_1MIC_REC_NB.dat:root/ymc/param/3_1MIC_REC_NB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/3_1MIC_REC_WB.dat:root/ymc/param/3_1MIC_REC_WB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/4_1MIC_HES_NB.dat:root/ymc/param/4_1MIC_HES_NB.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/agc_off.dat:root/ymc/param/agc_off.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/dng_off.dat:root/ymc/param/dng_off.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/dsp_off.dat:root/ymc/param/dsp_off.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/dsp_through.dat:root/ymc/param/dsp_through.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/handsfree_1.dat:root/ymc/param/handsfree_1.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/handsfree_2.dat:root/ymc/param/handsfree_2.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/handsfree_off.dat:root/ymc/param/handsfree_off.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/Lenovo_S3_HP_effect.dat:root/ymc/param/Lenovo_S3_HP_effect.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/Lenovo_S3_SP_effect.dat:root/ymc/param/Lenovo_S3_SP_effect.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_0_HS_2MIC_NB_adc_agc.dat:root/ymc/param/YMach2_0_HS_2MIC_NB_adc_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_0_HS_2MIC_NB_dng.dat:root/ymc/param/YMach2_0_HS_2MIC_NB_dng.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_0_HS_2MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_0_HS_2MIC_NB_pdm_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_1_HF_1MIC_NB_adc_agc.dat:root/ymc/param/YMach2_1_HF_1MIC_NB_adc_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_1_HF_1MIC_NB_dng.dat:root/ymc/param/YMach2_1_HF_1MIC_NB_dng.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_1_HF_1MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_1_HF_1MIC_NB_pdm_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_2_REC_2MIC_WB_adc_agc.dat:root/ymc/param/YMach2_2_REC_2MIC_WB_adc_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_2_REC_2MIC_WB_dng.dat:root/ymc/param/YMach2_2_REC_2MIC_WB_dng.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_2_REC_2MIC_WB_pdm_agc.dat:root/ymc/param/YMach2_2_REC_2MIC_WB_pdm_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_3_REC_1MIC_NB_adc_agc.dat:root/ymc/param/YMach2_3_REC_1MIC_NB_adc_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_3_REC_1MIC_NB_dng.dat:root/ymc/param/YMach2_3_REC_1MIC_NB_dng.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_3_REC_1MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_3_REC_1MIC_NB_pdm_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_4_HES_1MIC_NB_adc_agc.dat:root/ymc/param/YMach2_4_HES_1MIC_NB_adc_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_4_HES_1MIC_NB_dng.dat:root/ymc/param/YMach2_4_HES_1MIC_NB_dng.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/YMach2_4_HES_1MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_4_HES_1MIC_NB_pdm_agc.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/dsp_through.dat:root/ymc/param/post_process/output/dsp_through.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/HP_Dance.dat:root/ymc/param/post_process/output/HP_Dance.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/HP_JazzBar.dat:root/ymc/param/post_process/output/HP_JazzBar.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/HP_Pop.dat:root/ymc/param/post_process/output/HP_Pop.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/output.xml:root/ymc/param/post_process/output/output.xml \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/SP_Dance.dat:root/ymc/param/post_process/output/SP_Dance.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/SP_JazzBar.dat:root/ymc/param/post_process/output/SP_JazzBar.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/post_process/output/SP_Pop.dat:root/ymc/param/post_process/output/SP_Pop.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/voice_process/1mic_off.dat:root/ymc/param/voice_process/1mic_off.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/voice_process/1mic_sample.dat:root/ymc/param/voice_process/1mic_sample.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/voice_process/2mic_off.dat:root/ymc/param/voice_process/2mic_off.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/voice_process/2mic_sample.dat:root/ymc/param/voice_process/2mic_sample.dat \
    $(LOCAL_BASEDIR)/rootdir/ymc/param/voice_process/voice_process.xml:root/ymc/param/voice_process/voice_process.xml

# Boot: default properties
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.allow.mock.location=1 \
    ro.adb.secure=0 \
    ro.debuggable=1

# System: rril
PRODUCT_COPY_FILES += \
	$(LOCAL_BASEDIR)/rril/repository.txt:system/etc/rril/repository.txt \
	$(LOCAL_BASEDIR)/rril/stmd.conf:system/etc/rril/stmd.conf

# System: Audio
PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/configs/asound.conf:system/etc/asound.conf \
	device/lenovo/stuttgart/configs/audio_policy.conf:system/etc/audio_policy.conf \
	device/lenovo/stuttgart/alsa/alsa.conf:system/usr/share/alsa/alsa.conf \
	device/lenovo/stuttgart/alsa/cards/aliases.conf:system/usr/share/alsa/cards/aliases.conf \
	device/lenovo/stuttgart/alsa/pcm/center_lfe.conf:system/usr/share/alsa/pcm/center_lfe.conf \
	device/lenovo/stuttgart/alsa/pcm/default.conf:system/usr/share/alsa/pcm/default.conf \
	device/lenovo/stuttgart/alsa/pcm/dmix.conf:system/usr/share/alsa/pcm/dmix.conf \
	device/lenovo/stuttgart/alsa/pcm/dpl.conf:system/usr/share/alsa/pcm/dpl.conf \
	device/lenovo/stuttgart/alsa/pcm/dsnoop.conf:system/usr/share/alsa/pcm/dsnoop.conf \
	device/lenovo/stuttgart/alsa/pcm/front.conf:system/usr/share/alsa/pcm/front.conf \
	device/lenovo/stuttgart/alsa/pcm/iec958.conf:system/usr/share/alsa/pcm/iec958.conf \
	device/lenovo/stuttgart/alsa/pcm/modem.conf:system/usr/share/alsa/pcm/modem.conf \
	device/lenovo/stuttgart/alsa/pcm/rear.conf:system/usr/share/alsa/pcm/rear.conf \
	device/lenovo/stuttgart/alsa/pcm/side.conf:system/usr/share/alsa/pcm/side.conf \
	device/lenovo/stuttgart/alsa/pcm/surround40.conf:system/usr/share/alsa/pcm/surround40.conf \
	device/lenovo/stuttgart/alsa/pcm/surround41.conf:system/usr/share/alsa/pcm/surround41.conf \
	device/lenovo/stuttgart/alsa/pcm/surround50.conf:system/usr/share/alsa/pcm/surround50.conf \
	device/lenovo/stuttgart/alsa/pcm/surround51.conf:system/usr/share/alsa/pcm/surround51.conf \
	device/lenovo/stuttgart/alsa/pcm/surround71.conf:system/usr/share/alsa/pcm/surround71.conf

# System: vold
PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/configs/vold.fstab:system/etc/vold.fstab

# System: Wifi
PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/configs/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

#
# PACKAGE
#
# TODO: preload
PRODUCT_PACKAGES += \
	hcitool

# TODO: DeviceSettings
PRODUCT_PACKAGES += \
	com.android.future.usb.accessory \
	Torch

PRODUCT_PACKAGES += \
	audio.a2dp.default \
	audio.primary.smdk4x12 \
	audio.usb.default \
	libaudiohw_legacy \
	Camera

PRODUCT_PACKAGES += \
    sdcard

PRODUCT_PACKAGES += \
    libsecmfcdecapi \
    libsecmfcencapi

# Live Wallpapers
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers \
    librs_jni

# FS management tools
PRODUCT_PACKAGES += \
    static_busybox \
    make_ext4fs \
    e2fsck \
    setup_fs

# WLAN
PRODUCT_PACKAGES += \
	libnetcmdiface

# OMX
PRODUCT_PACKAGES += \
    libstagefrighthw \
    libSEC_OMX_Resourcemanager \
    libSEC_OMX_Core \
    libOMX.SEC.AVC.Decoder \
    libOMX.SEC.M4V.Decoder \
    libOMX.SEC.WMV.Decoder \
    libOMX.SEC.AVC.Encoder \
    libOMX.SEC.M4V.Encoder \
    libOMX.SEC.M2V.Decoder
#   libOMX.SEC.VP8.Decoder

PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_BASEDIR)/configs/media_codecs.xml:system/etc/media_codecs.xml

# Bluetooth
PRODUCT_COPY_FILES += \
    $(LOCAL_BASEDIR)/bluetooth/libbt-vendor.so:system/lib/libbt-vendor.so

#
# TODO: SuperCAM
#

#
# TODO: mkshrc
#

# RIL
BOARD_PROVIDES_LIBRIL := true

# System: build.prop
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.strictmode.disable=1 \
    mobiledata.interfaces=pdp0,wlan0,gprs,ppp0,rmnet0 \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    persist.sys.timezone=Asia/Shanghai \
    persist.sys.language=zh \
    persist.sys.country=CN \
    ro.config.ringtone=Salt_water.ogg \
    ro.config.notification_sound=Heaven_nearby.ogg \
    ro.config.alarm_alert=Dreamland.ogg

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072 \
    hwui.render_dirty_regions=false

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mass_storage \
    ro.build.display.id=lephone.cc_linkscue_cm10.1

#
# HAL
#
# MARK: 2014年05月16日
# rm lights.exynos4 libhdmi libhdmiclient libasan_preload
PRODUCT_PACKAGES += \
	camera.stuttgart \
	hwcomposer.exynos4
#	libsecril-client
#   libgralloc_ump \
#   libhwconverter \
#   libfimg \
#	libTVOut \
#	libhwjpeg \
#	libfimc
#  	libcec \
#   libddc \
#   libedid \
#   libtinyalsa \

# COMMON: These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml \
    $(LOCAL_BASEDIR)/prebuilt/com.yamaha.android.media.xml:system/etc/permissions/com.yamaha.android.media.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml


# TODO: pls fix wifi,bluetooth..
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

# Include exynos4 platform specific parts
TARGET_HAL_PATH := hardware/samsung/exynos4/hal
TARGET_OMX_PATH := hardware/samsung/exynos/multimedia/openmax
#$(call inherit-product, hardware/samsung/exynos4x12.mk)
#$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)
$(call inherit-product-if-exists, vendor/lenovo/stuttgart/stuttgart-vendor.mk)
#$(call inherit-product-if-exists, vendor/le/packages.mk)

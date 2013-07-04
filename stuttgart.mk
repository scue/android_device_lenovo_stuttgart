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

DEVICE_PACKAGE_OVERLAYS += device/lenovo/stuttgart/overlay

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

# This device is xhdpi.  However the platform doesn't
# currently contain all of the bitmaps at xhdpi density so
# we do this little trick to fall back to the hdpi version
# if the xhdpi doesn't exist.
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi

#Fix can not hang the Calls

# FRAMEWORKS_BASE_SUBDIRS += ../../$(LOCAL_PATH)/stuttgartril/


# Init files
#

# busybox
PRODUCT_COPY_FILES := \
    device/lenovo/stuttgart/ramdisk/busybox:root/sbin/busybox

# ramdisk
PRODUCT_COPY_FILES := \
   device/lenovo/stuttgart/ramdisk/fstab.stuttgart:root/fstab.stuttgart \
   device/lenovo/stuttgart/ramdisk/lpm.rc:root/lpm.rc \
   device/lenovo/stuttgart/ramdisk/lpm.rc:recovery/root/lpm.rc \
   device/lenovo/stuttgart/ramdisk/init.cp_update.rc:root/init.cp_update.rc \
   device/lenovo/stuttgart/ramdisk/init.stuttgart.rc:root/init.stuttgart.rc \
   device/lenovo/stuttgart/ramdisk/init.stuttgart.usb.rc:root/init.stuttgart.usb.rc \
   device/lenovo/stuttgart/ramdisk/init.testmode.rc:root/init.testmode.rc \
   device/lenovo/stuttgart/ramdisk/ueventd.rc:root/ueventd.rc \
   device/lenovo/stuttgart/ramdisk/init.rc:root/init.rc \
   device/lenovo/stuttgart/ramdisk/initlogo.rle:recovery/root/initlogo.rle \
   device/lenovo/stuttgart/ramdisk/initlogo.rle:root/initlogo.rle \
   device/lenovo/stuttgart/prebuilt/gpio:root/sbin/gpio \
   device/lenovo/stuttgart/ramdisk/ueventd.stuttgart.rc:root/ueventd.stuttgart.rc 

# charger
PRODUCT_COPY_FILES += \
   device/lenovo/stuttgart/res/charger/battery_0.png:root/res/images/charger/battery_0.png \
   device/lenovo/stuttgart/res/charger/battery_1.png:root/res/images/charger/battery_1.png \
   device/lenovo/stuttgart/res/charger/battery_2.png:root/res/images/charger/battery_2.png \
   device/lenovo/stuttgart/res/charger/battery_3.png:root/res/images/charger/battery_3.png \
   device/lenovo/stuttgart/res/charger/battery_4.png:root/res/images/charger/battery_4.png \
   device/lenovo/stuttgart/res/charger/battery_5.png:root/res/images/charger/battery_5.png \
   device/lenovo/stuttgart/res/charger/battery_charge.png:root/res/images/charger/battery_charge.png \
   device/lenovo/stuttgart/res/charger/battery_fail.png:root/res/images/charger/battery_fail.png

PRODUCT_PACKAGE += \
		   charger \
		   charger_res_images

# firmware
PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/firmware/fw_bcmdhd_apsta.bin:system/etc/firmware/fw_bcmdhd_apsta.bin \
	device/lenovo/stuttgart/firmware/fw_bcmdhd.bin:system/etc/firmware/fw_bcmdhd.bin \
	device/lenovo/stuttgart/firmware/fw_bcmdhd_p2p.bin:system/etc/firmware/fw_bcmdhd_p2p.bin \
	device/lenovo/stuttgart/firmware/sdio-g-mfgtest.bin:system/etc/firmware/sdio-g-mfgtest.bin


# rril
PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/rril/repository.txt:system/etc/rril/repository.txt \
	device/lenovo/stuttgart/rril/stmd.conf:system/etc/rril/stmd.conf


#YMC AUDIO
PRODUCT_COPY_FILES += \
    device/lenovo/stuttgart/ymc/param/0_2MIC_HS_NB.dat:root/ymc/param/0_2MIC_HS_NB.dat \
    device/lenovo/stuttgart/ymc/param/0_2MICNSOFF_HS_NB.dat:root/ymc/param/0_2MICNSOFF_HS_NB.dat \
    device/lenovo/stuttgart/ymc/param/1_1MIC_HF_NB.dat:root/ymc/param/1_1MIC_HF_NB.dat \
    device/lenovo/stuttgart/ymc/param/2_2MIC_REC_WB.dat:root/ymc/param/2_2MIC_REC_WB.dat \
    device/lenovo/stuttgart/ymc/param/3_1MIC_REC_NB.dat:root/ymc/param/3_1MIC_REC_NB.dat \
    device/lenovo/stuttgart/ymc/param/3_1MIC_REC_WB.dat:root/ymc/param/3_1MIC_REC_WB.dat \
    device/lenovo/stuttgart/ymc/param/4_1MIC_HES_NB.dat:root/ymc/param/4_1MIC_HES_NB.dat \
    device/lenovo/stuttgart/ymc/param/agc_off.dat:root/ymc/param/agc_off.dat \
    device/lenovo/stuttgart/ymc/param/dng_off.dat:root/ymc/param/dng_off.dat \
    device/lenovo/stuttgart/ymc/param/dsp_off.dat:root/ymc/param/dsp_off.dat \
    device/lenovo/stuttgart/ymc/param/dsp_through.dat:root/ymc/param/dsp_through.dat \
    device/lenovo/stuttgart/ymc/param/handsfree_1.dat:root/ymc/param/handsfree_1.dat \
    device/lenovo/stuttgart/ymc/param/handsfree_2.dat:root/ymc/param/handsfree_2.dat \
    device/lenovo/stuttgart/ymc/param/handsfree_off.dat:root/ymc/param/handsfree_off.dat \
    device/lenovo/stuttgart/ymc/param/Lenovo_S3_HP_effect.dat:root/ymc/param/Lenovo_S3_HP_effect.dat \
    device/lenovo/stuttgart/ymc/param/Lenovo_S3_SP_effect.dat:root/ymc/param/Lenovo_S3_SP_effect.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_0_HS_2MIC_NB_adc_agc.dat:root/ymc/param/YMach2_0_HS_2MIC_NB_adc_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_0_HS_2MIC_NB_dng.dat:root/ymc/param/YMach2_0_HS_2MIC_NB_dng.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_0_HS_2MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_0_HS_2MIC_NB_pdm_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_1_HF_1MIC_NB_adc_agc.dat:root/ymc/param/YMach2_1_HF_1MIC_NB_adc_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_1_HF_1MIC_NB_dng.dat:root/ymc/param/YMach2_1_HF_1MIC_NB_dng.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_1_HF_1MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_1_HF_1MIC_NB_pdm_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_2_REC_2MIC_WB_adc_agc.dat:root/ymc/param/YMach2_2_REC_2MIC_WB_adc_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_2_REC_2MIC_WB_dng.dat:root/ymc/param/YMach2_2_REC_2MIC_WB_dng.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_2_REC_2MIC_WB_pdm_agc.dat:root/ymc/param/YMach2_2_REC_2MIC_WB_pdm_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_3_REC_1MIC_NB_adc_agc.dat:root/ymc/param/YMach2_3_REC_1MIC_NB_adc_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_3_REC_1MIC_NB_dng.dat:root/ymc/param/YMach2_3_REC_1MIC_NB_dng.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_3_REC_1MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_3_REC_1MIC_NB_pdm_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_4_HES_1MIC_NB_adc_agc.dat:root/ymc/param/YMach2_4_HES_1MIC_NB_adc_agc.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_4_HES_1MIC_NB_dng.dat:root/ymc/param/YMach2_4_HES_1MIC_NB_dng.dat \
    device/lenovo/stuttgart/ymc/param/YMach2_4_HES_1MIC_NB_pdm_agc.dat:root/ymc/param/YMach2_4_HES_1MIC_NB_pdm_agc.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/dsp_through.dat:root/ymc/param/post_process/output/dsp_through.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/HP_Dance.dat:root/ymc/param/post_process/output/HP_Dance.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/HP_JazzBar.dat:root/ymc/param/post_process/output/HP_JazzBar.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/HP_Pop.dat:root/ymc/param/post_process/output/HP_Pop.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/output.xml:root/ymc/param/post_process/output/output.xml \
    device/lenovo/stuttgart/ymc/param/post_process/output/SP_Dance.dat:root/ymc/param/post_process/output/SP_Dance.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/SP_JazzBar.dat:root/ymc/param/post_process/output/SP_JazzBar.dat \
    device/lenovo/stuttgart/ymc/param/post_process/output/SP_Pop.dat:root/ymc/param/post_process/output/SP_Pop.dat \
    device/lenovo/stuttgart/ymc/param/voice_process/1mic_off.dat:root/ymc/param/voice_process/1mic_off.dat \
    device/lenovo/stuttgart/ymc/param/voice_process/1mic_sample.dat:root/ymc/param/voice_process/1mic_sample.dat \
    device/lenovo/stuttgart/ymc/param/voice_process/2mic_off.dat:root/ymc/param/voice_process/2mic_off.dat \
    device/lenovo/stuttgart/ymc/param/voice_process/2mic_sample.dat:root/ymc/param/voice_process/2mic_sample.dat \
    device/lenovo/stuttgart/ymc/param/voice_process/voice_process.xml:root/ymc/param/voice_process/voice_process.xml

# vendor firmware
PRODUCT_COPY_FILES += \
    device/lenovo/stuttgart/vendor/firmware/fimc_is_fw.bin:root/vendor/firmware/fimc_is_fw.bin \
    device/lenovo/stuttgart/vendor/firmware/mfc_fw.bin:root/vendor/firmware/mfc_fw.bin \
    device/lenovo/stuttgart/vendor/firmware/setfile.bin:root/vendor/firmware/setfile.bin \
    device/lenovo/stuttgart/vendor/firmware/setfile_S5K3H7.bin:root/vendor/firmware/setfile_S5K3H7.bin

# Audio etc
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

# Vold and Storage
PRODUCT_COPY_FILES += \
    device/lenovo/stuttgart/configs/vold.fstab:system/etc/vold.fstab
#PRODUCT_COPY_FILES += \
    device/lenovo/stuttgart/configs/vold.fstab:system/etc/vold.extra_sd_as_primary.fstab

# Bluetooth configuration files
# PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.conf:system/etc/bluetooth/main.conf

PRODUCT_PACKAGES += \
		    hcitool \
		    charger

# Wifi
PRODUCT_COPY_FILES += \
    device/lenovo/stuttgart/configs/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

# Gps
PRODUCT_COPY_FILES += \
    device/lenovo/stuttgart/configs/gpsconfig.xml:system/etc/gpsconfig.xml 

# Packages
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory \
    Torch 
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.smdk4x12 \
    audio.usb.default \
    Camera

# HAL
PRODUCT_PACKAGES += \
    lights.exynos4 \
    camera.stuttgart
#    libgralloc_ump \
#    libhwconverter \
#    libfimg \
#    hwcomposer.exynos4 \
    libhwjpeg \
    libhdmi \
    libfimc 
#    libcec \
#    libddc \
#    libedid \
#    libhdmiclient \
#    libTVOut
#    libtinyalsa \


# MFC API
PRODUCT_PACKAGES += \
    sdcard

PRODUCT_PACKAGES += \
    libsecmfcdecapi \
    libsecmfcencapi

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
    device/lenovo/stuttgart/configs/media_profiles.xml:system/etc/media_profiles.xml \
    device/lenovo/stuttgart/configs/media_codecs.xml:system/etc/media_codecs.xml

PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/configs/mkshrc:system/etc/mkshrc

PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/supercam/SCG_arm_hd.apk:system/app/SCG_arm_hd.apk \
	device/lenovo/stuttgart/supercam/lib/libarcsoft_dlsd.so:system/lib/libarcsoft_dlsd.so \
	device/lenovo/stuttgart/supercam/lib/libLeConvertDataToTexture.so:system/lib/libLeConvertDataToTexture.so \
	device/lenovo/stuttgart/supercam/lib/libLeCSCJni.so:system/lib/libLeCSCJni.so \
	device/lenovo/stuttgart/supercam/lib/libLeCSC.so:system/lib/libLeCSC.so \
	device/lenovo/stuttgart/supercam/lib/libLeGaJavaInterface.so:system/lib/libLeGaJavaInterface.so \
	device/lenovo/stuttgart/supercam/lib/libLeGraphicAlgorithm.so:system/lib/libLeGraphicAlgorithm.so \
	device/lenovo/stuttgart/supercam/lib/libLeImageJI.so:system/lib/libLeImageJI.so \
	device/lenovo/stuttgart/supercam/lib/libLeImage.so:system/lib/libLeImage.so \
	device/lenovo/stuttgart/supercam/lib/liblenovo_liveeffect_library.so:system/lib/liblenovo_liveeffect_library.so \
	device/lenovo/stuttgart/supercam/lib/liblenovo_nightpreview.so:system/lib/liblenovo_nightpreview.so \
	device/lenovo/stuttgart/supercam/lib/liblenovo_nightscene.so:system/lib/liblenovo_nightscene.so \
	device/lenovo/stuttgart/supercam/lib/libLeskia.so:system/lib/libLeskia.so \
	device/lenovo/stuttgart/supercam/lib/liblocSDK3.so:system/lib/liblocSDK3.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_cinema_graph.so:system/lib/libmorpho_cinema_graph.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_groupshot.so:system/lib/libmorpho_groupshot.so \
	device/lenovo/stuttgart/supercam/lib/libmorphoimageconverter.so:system/lib/libmorphoimageconverter.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_jpeg_io.so:system/lib/libmorpho_jpeg_io.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_memory_allocator.so:system/lib/libmorpho_memory_allocator.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_object_remover_jni.so:system/lib/libmorpho_object_remover_jni.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_panorama_gp.so:system/lib/libmorpho_panorama_gp.so \
	device/lenovo/stuttgart/supercam/lib/libmorpho_SmartSelect.so:system/lib/libmorpho_SmartSelect.so

PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/prebuilt/hwcomposer.exynos4.so:system/lib/hw/hwcomposer.exynos4.so

#PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/prebuilt/bootanimation.zip:system/media/bootanimation.zip

#PRODUCT_COPY_FILES += \
	device/lenovo/stuttgart/prebuilt/apps/CMFileManager.apk:system/app/CMFileManager.apk \
	device/lenovo/stuttgart/prebuilt/apps/CMUpdater.apk:system/app/CMUpdater.apk \
	device/lenovo/stuttgart/prebuilt/apps/CMWallpapers.apk:system/app/CMWallpapers.apk \
	device/lenovo/stuttgart/prebuilt/apps/ThemeChooser.apk:system/app/ThemeChooser.apk \
	device/lenovo/stuttgart/prebuilt/apps/ThemeManager.apk:system/app/ThemeManager.apk

# RIL
BOARD_PROVIDES_LIBRIL := true
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
#    ro.telephony.ril_class=StuttgartRIL \
# Filesystem management tools
PRODUCT_PACKAGES += \
    static_busybox \
    make_ext4fs \
    e2fsck \
    setup_fs

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

# These are the hardware-specific features
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
    device/lenovo/stuttgart/prebuilt/com.yamaha.android.media.xml:system/etc/permissions/com.yamaha.android.media.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

# Feature live wallpaper
# PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072 \
    hwui.render_dirty_regions=false

PRODUCT_TAGS += dalvik.gc.type-precise

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mass_storage,adb \
    ro.build.display.id=lephone.cc_linkscue_cm10.1 
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.allow.mock.location=1 \
    ro.debuggable=1 

$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)

# Include exynos4 platform specific parts
TARGET_HAL_PATH := hardware/samsung/exynos4/hal
TARGET_OMX_PATH := hardware/samsung/exynos/multimedia/openmax
#$(call inherit-product, hardware/samsung/exynos4x12.mk)
#$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4330/device-bcm.mk)
$(call inherit-product-if-exists, vendor/lenovo/stuttgart/stuttgart-vendor.mk)
#$(call inherit-product-if-exists, vendor/le/packages.mk)

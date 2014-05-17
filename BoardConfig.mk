USE_CAMERA_STUB := true
BOARD_USES_GENERIC_AUDIO := false

# inherit from the proprietary version
-include vendor/lenovo/stuttgart/BoardConfigVendor.mk
TARGET_BOOTANIMATION_PRELOAD := true
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := cortex-a9
TARGET_CPU_VARIANT := cortex-a9
ARCH_ARM_HAVE_NEON := true
ARCH_ARM_HAVE_TLS_REGISTER := true
TARGET_GLOBAL_CFLAGS += -mtune=cortex-a9 -mfpu=neon -mfloat-abi=softfp #mark add
TARGET_GLOBAL_CPPFLAGS += -mtune=cortex-a9 -mfpu=neon -mfloat-abi=softfp #mark add
#COMMON_GLOBAL_CFLAGS += -D__ARM_USE_PLD -D__ARM_CACHE_LINE_SIZE=64
TARGET_UBOOT_RAMDISK := true
TARGET_UBOOT_RAMDISK_LOADADDR := 0x40800000
BOARD_LEGACY_NL80211_STA_EVENTS := true

EXYNOS4X12_ENHANCEMENTS := true
EXYNOS4_ENHANCEMENTS := true

ifdef EXYNOS4X12_ENHANCEMENTS
COMMON_GLOBAL_CFLAGS += -DEXYNOS4210_ENHANCEMENTS
COMMON_GLOBAL_CFLAGS += -DEXYNOS4X12_ENHANCEMENTS
COMMON_GLOBAL_CFLAGS += -DEXYNOS4_ENHANCEMENTS
COMMON_GLOBAL_CFLAGS += -DDISABLE_HW_ID_MATCH_CHECK
endif

#BOARD_VENDOR := samsung #mark cm10.2 add
TARGET_BOARD_PLATFORM := exynos4
TARGET_SOC := exynos4x12
TARGET_BOOTLOADER_BOARD_NAME := stuttgart
TARGET_BOARD_INFO_FILE := device/lenovo/stuttgart/board-info.txt

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_PROVIDES_INIT_RC := true
TARGET_PROVIDES_INIT := true
TARGET_PROVIDES_INIT_TARGET_RC := true
TARGET_RECOVERY_INITRC := device/lenovo/stuttgart/recovery/recovery.rc
BOARD_USES_DEPRECATED_TOOLCHAIN := true
BOARD_KERNEL_CMDLINE :=
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_CUSTOM_BOOTIMG_MK := device/lenovo/stuttgart/shbootimg.mk
#TARGET_KERNEL_SOURCE        := kernel/samsung/stuttgart
#TARGET_KERNEL_CONFIG	    := stuttgart_android_defconfig

# head file
TARGET_SPECIFIC_HEADER_PATH := device/lenovo/stuttgart/overlay/include

# fix this up by examining /proc/mtd on a running device
BOARD_USES_UBOOT := true
TARGET_PREBUILT_KERNEL := device/lenovo/stuttgart/kernel

# Filesystem
BOARD_BOOTIMAGE_PARTITION_SIZE := 20940800
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 20940800
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 419430400
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2621440000
BOARD_FLASH_BLOCK_SIZE := 4096
TARGET_USERIMAGES_USE_EXT4 := true

# Graphics
BOARD_EGL_CFG := device/lenovo/stuttgart/configs/egl.cfg
USE_OPENGL_RENDERER := true
BOARD_USES_SKIAHWJPEG := true
COMMON_GLOBAL_CFLAGS += -DSEC_HWJPEG_G2D
#COMMON_GLOBAL_CFLAGS += -DSEC_HWJPEG_G2D -DGL_EXT_discard_framebuffer
#BOARD_USES_HDMI := true #mark del
# Enable WEBGL in WebKit
ENABLE_WEBGL := true
BOARD_USE_SKIA_LCDTEXT := true

# FIMG Acceleration
#BOARD_USES_SKIA_FIMGAPI := true #mark add

# TVOut & HDMI
#BOARD_USE_SECTVOUT := true
#BOARD_USES_SKTEXTBOX := true

# OMX /* 硬件解码相关 */
BOARD_HAVE_CODEC_SUPPORT := SAMSUNG_CODEC_SUPPORT
COMMON_GLOBAL_CFLAGS += -DSAMSUNG_CODEC_SUPPORT
BOARD_USES_PROPRIETARY_OMX := SAMSUNG
COMMON_GLOBAL_CFLAGS += -DSAMSUNG_OMX
BOARD_NONBLOCK_MODE_PROCESS := true
BOARD_USE_STOREMETADATA := true
BOARD_USE_METADATABUFFERTYPE := true
BOARD_USES_MFC_FPS := true
BOARD_USE_S3D_SUPPORT := true
BOARD_USE_CSC_FIMC := false

# RIL /* Radio Interface Layer */
BOARD_MOBILEDATA_INTERFACE_NAME := "rmnet0"

# Wifi /* Wifi模块相关 */
WIFI_BAND                        	:= 802_11_ABG
BOARD_WLAN_DEVICE_REV 				:= bcm4329
WPA_SUPPLICANT_VERSION      		:= VER_0_8_X
BOARD_HOSTAPD_DRIVER        		:= NL80211
BOARD_WPA_SUPPLICANT_DRIVER 		:= NL80211
BOARD_HOSTAPD_PRIVATE_LIB   		:= lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB 	:= lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           		:= bcmdhd
WIFI_DRIVER_MODULE_NAME     		:= "bcmdhd"
WIFI_DRIVER_MODULE_ARG      		:= "firmware_path=/system/etc/firmware/fw_bcmdhd.bin nvram_path=/system/etc/wifi/bcmdhd.cal iface_name=wlan0"
WIFI_DRIVER_MODULE_APARG    		:= "firmware_path=/system/etc/firmware/fw_bcmdhd_apsta.bin nvram_path=/system/etc/wifi/bcmdhd.cal iface_name=wlan0"
WIFI_DRIVER_FW_PATH_PARAM   		:= "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_MODULE_PATH     		:= "/system/lib/modules/bcmdhd.ko"
WIFI_DRIVER_FW_PATH_STA     		:= "/system/etc/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P     		:= "/system/etc/firmware/fw_bcmdhd_p2p.bin"
WIFI_DRIVER_FW_PATH_AP      		:= "/system/etc/firmware/fw_bcmdhd_apsta.bin"

# Audio
#BOARD_USES_LIBMEDIA_WITH_AUDIOPARAMETER := true
#BOARD_USE_YAMAHAPLAYER := true
#BOARD_USE_SAMSUNG_SEPARATEDSTREAM := true
#BOARD_HAS_SAMSUNG_VOLUME_BUG := true

# HWComposer
BOARD_USES_HWCOMPOSER := true
#BOARD_USE_SECTVOUT := true
BOARD_USES_FIMGAPI := true
#BOARD_USE_SAMSUNG_COLORFORMAT := true
#BOARD_FIX_NATIVE_COLOR_FORMAT := true

# Camera
BOARD_USES_PROPRIETARY_LIBCAMERA := true
BOARD_USES_PROPRIETARY_LIBFIMC := true
COMMON_GLOBAL_CFLAGS += -DSAMSUNG_CAMERA_HARDWARE
COMMON_GLOBAL_CFLAGS += -DSTUTTGART_CAMERA
COMMON_GLOBAL_CFLAGS += -DICS_AUDIO_BLOB #mark cm10.1 add
COMMON_GLOBAL_CFLAGS += -DSTUTTGART_FM
COMMON_GLOBAL_CFLAGS += -DICS_CAMERA_BLOB
#BOARD_USES_PROPRIETARY_LIBCAMERA := true
BOARD_USES_PROPRIETARY_LIBFIMC := true

# Enable JIT
WITH_JIT := true

# fix maps
BOARD_USE_LEGACY_SENSORS_FUSION := false

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
TARGET_NEEDS_BLUETOOTH_INIT_DELAY := true
BT_ALT_STACK := true
BRCM_BT_USE_BTL_IF := true
BRCM_BTL_INCLUDE_A2DP := true
TARGET_CUSTOM_BLUEDROID := ../../../device/lenovo/stuttgart/bluetooth/bluetooth.c
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/lenovo/stuttgart/bluetooth/include

#DDC
BOARD_HDMI_DDC_CH := DDC_CH_I2C_7

# Vold
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/platform/s3c-usbgadget/gadget/lun%d/file"

# Recovery
BOARD_CUSTOM_GRAPHICS := ../../../device/lenovo/stuttgart/recovery/griphics.c
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
BOARD_UMS_LUNFILE := "/sys/devices/platform/s3c-usbgadget/gadget/lun%d/file"
BOARD_USES_MMCUTILS := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_SELECT_BUTTON := true

#
# TODO: Charging mode
#

# assert
TARGET_OTA_ASSERT_DEVICE := stuttgart,K860,K860i
#BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS := true

-include hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/device-bcm.mk
BOARD_VOLD_MAX_PARTITIONS := 29
-include vendor/lenovo/stuttgart/BoardConfigVendor.mk
WITH_DEXPREOPT := false

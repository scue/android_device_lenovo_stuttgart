ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),stuttgart)

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_PRELOAD_CMD := $(shell ( \
	$(LOCAL_PATH)/../tools/ics_ext4_utils/repackpreload \
	$(LOCAL_PATH)/preload.img \
	$(LOCAL_PATH)/preload/ \
	> /dev/null 2>&1) \
	)
LOCAL_MODULE := preload
LOCAL_MODULE_OWNER := lenovo
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_PATH  := $(OUT)
LOCAL_MODULE_SUFFIX := .img
LOCAL_MODULE_CLASS := NONE
LOCAL_SRC_FILES    := preload.img
include $(BUILD_PREBUILT)

endif

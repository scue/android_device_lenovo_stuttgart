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

LOCAL_PATH := $(call my-dir)

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(MKIMAGE)
	$(call pretty,"Target Stuttgart boot image: $@")
	$(hide) $(MKIMAGE) -A ARM -O Linux -T ramdisk -C none -a 0x40800000 -e 0x40800000 -n ramdisk -d $(INSTALLED_RAMDISK_TARGET) $(INSTALLED_RAMDISK_TARGET).uboot
	$(hide) $(MKBOOTIMG) --kernel $(INSTALLED_KERNEL_TARGET) --ramdisk $(INSTALLED_RAMDISK_TARGET).uboot $(addprefix --second ,$(INSTALLED_2NDBOOTLOADER_TARGET)) \
		--cmdline "$(strip $(BOARD_KERNEL_CMDLINE))" --base $(strip $(BOARD_KERNEL_BASE)) --pagesize $(strip $(BOARD_KERNEL_PAGESIZE)) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(MKIMAGE) \
		$(recovery_ramdisk) \
		$(recovery_kernel)
	@echo -e ${CL_CYN}"----- Making Stuttgart recovery image ------"${CL_RST}
	$(MKIMAGE) -A ARM -O Linux -T ramdisk -C none -a 0x40800000 -e 0x40800000 -n ramdisk -d $(recovery_ramdisk) $(recovery_ramdisk).uboot
	$(MKBOOTIMG) --kernel $(recovery_kernel) --ramdisk $(recovery_ramdisk).uboot $(addprefix --second ,$(INSTALLED_2NDBOOTLOADER_TARGET)) \
		--cmdline "$(strip $(BOARD_KERNEL_CMDLINE))" --base $(strip $(BOARD_KERNEL_BASE)) --pagesize $(strip $(BOARD_KERNEL_PAGESIZE)) --output $@
	@echo -e ${CL_CYN}"Made Stuttgart recovery image: $@"${CL_RST}
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)

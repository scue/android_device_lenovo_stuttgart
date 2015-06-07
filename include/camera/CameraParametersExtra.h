// Overload this file in your device specific config if you need
// to add extra camera parameters.
// A typical file would look like this:
/*
 * Copyright (C) 2014 The CyanogenMod Project
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

#define CAMERA_PARAMETERS_EXTRA_C \
const char CameraParameters::KEY_SCF_CAPTURE_PANORAMA[] = "panorama"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_TOTAL[] = "total"; \
const char CameraParameters::KEY_SCF_CAPTURE_ISO[] = "auto"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_EXPOSURES_SUPPORT[] = "capture-burst-exposures-values"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_EXPOSURES[] = "capture-burst-exposure"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_INTERVAL[] = "capture-burst-interval"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_INTERVAL_SUPPORT[] = "capture-burst-interval-values"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_RETROACTIVE[] = "capture-burst-retroactive"; \
const char CameraParameters::KEY_SCF_CAPTURE_BURST_CAPTURES_SUPPORT[] = "capture-burst-captures-values"; \
const char CameraParameters::KEY_SCF_CAPTURE_ZSL_SUPPORT[] = "capture-zsl-values"; \
const char CameraParameters::KEY_SHARPNESS_STEP[] = "sharpness-step"; \
const char CameraParameters::KEY_MIN_SHARPNESS[] = "min-sharpness"; \
const char CameraParameters::KEY_MAX_SHARPNESS[] = "max-sharpness"; \
const char CameraParameters::KEY_SHARPNESS[] = "sharpness"; \
const char CameraParameters::KEY_SATURATION_STEP[] = "saturation-step"; \
const char CameraParameters::KEY_MIN_SATURATION[] = "min-saturation"; \
const char CameraParameters::KEY_MAX_SATURATION[] = "max-saturation"; \
const char CameraParameters::KEY_SATURATION[] = "saturation"; \
const char CameraParameters::KEY_BRIGHTNESS_STEP[] = "brightness-step"; \
const char CameraParameters::KEY_MIN_BRIGHTNESS[] = "max-brightness"; \
const char CameraParameters::KEY_MAX_BRIGHTNESS[] = "min-brightness"; \
const char CameraParameters::KEY_BRIGHTNESS[] = "brightness"; \
const char CameraParameters::KEY_METERING_MODE[] = "metering-mode"; \
const char CameraParameters::KEY_SUPPORTED_METERING_MODES[] = "metering-mode-values"; \
const char CameraParameters::KEY_ISO[] = "iso"; \
const char CameraParameters::CONTRAST_ENHANCE_OFF[] = "off"; \
const char CameraParameters::CONTRAST_ENHANCE_ON[] = "on"; \
const char CameraParameters::KEY_CONTRAST_ENHANCE[] = "contrast-enhance"; \
const char CameraParameters::KEY_CONTRAST_STEP[] = "contras-step"; \
const char CameraParameters::KEY_MIN_CONTRAST[] = "min-contrast"; \
const char CameraParameters::KEY_MAX_CONTRAST[] = "max-contrast"; \
const char CameraParameters::KEY_CONTRAST[] = "contrast"; \
const char CameraParameters::SCENE_MODE_DUSK[] = "dusk"; \
const char CameraParameters::SCENE_MODE_DAWN[] = "dawn"; \
const char CameraParameters::SCENE_MODE_INDOOR[] = "indoor"; \
const char CameraParameters::SCENE_MODE_TEXT[] = "text"; \
const char CameraParameters::SCENE_MODE_BACK_LIGHT[] = "backlight"; \
const char CameraParameters::SCENE_MODE_FALL_COLOR[] = "fallcolor";

#define CAMERA_PARAMETERS_EXTRA_H \
    static const char KEY_SCF_CAPTURE_PANORAMA[]; \
    static const char KEY_SCF_CAPTURE_BURST_TOTAL[]; \
    static const char KEY_SCF_CAPTURE_ISO[]; \
    static const char KEY_SCF_CAPTURE_BURST_EXPOSURES_SUPPORT[]; \
    static const char KEY_SCF_CAPTURE_BURST_EXPOSURES[]; \
    static const char KEY_SCF_CAPTURE_BURST_INTERVAL[]; \
    static const char KEY_SCF_CAPTURE_BURST_INTERVAL_SUPPORT[]; \
    static const char KEY_SCF_CAPTURE_BURST_RETROACTIVE[]; \
    static const char KEY_SCF_CAPTURE_BURST_CAPTURES_SUPPORT[]; \
    static const char KEY_SCF_CAPTURE_ZSL_SUPPORT[]; \
    static const char KEY_SHARPNESS_STEP[]; \
    static const char KEY_MIN_SHARPNESS[]; \
    static const char KEY_MAX_SHARPNESS[]; \
    static const char KEY_SHARPNESS[]; \
    static const char KEY_SATURATION_STEP[]; \
    static const char KEY_MIN_SATURATION[]; \
    static const char KEY_MAX_SATURATION[]; \
    static const char KEY_SATURATION[]; \
    static const char KEY_BRIGHTNESS_STEP[]; \
    static const char KEY_MIN_BRIGHTNESS[]; \
    static const char KEY_MAX_BRIGHTNESS[]; \
    static const char KEY_BRIGHTNESS[]; \
    static const char KEY_METERING_MODE[]; \
    static const char KEY_SUPPORTED_METERING_MODES[]; \
    static const char KEY_ISO[]; \
    static const char CONTRAST_ENHANCE_OFF[]; \
    static const char CONTRAST_ENHANCE_ON[]; \
    static const char KEY_CONTRAST_ENHANCE[]; \
    static const char KEY_CONTRAST_STEP[]; \
    static const char KEY_MIN_CONTRAST[]; \
    static const char KEY_MAX_CONTRAST[]; \
    static const char KEY_CONTRAST[]; \
    static const char SCENE_MODE_DUSK[]; \
    static const char SCENE_MODE_DAWN[]; \
    static const char SCENE_MODE_INDOOR[]; \
    static const char SCENE_MODE_TEXT[]; \
    static const char SCENE_MODE_BACK_LIGHT[]; \
    static const char SCENE_MODE_FALL_COLOR[];


/*
 * Copyright (C) 2008 The Android Open Source Project
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

#define LOG_TAG "bluedroid"

#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <cutils/log.h>
#include <cutils/properties.h>

#include <bluetooth/bluetooth.h>
#include <bluedroid/bluetooth.h>
#include "private/android_filesystem_config.h"
#include "../../../device/lenovo/stuttgart/bluetooth/include/hci.h"
#include "../../../device/lenovo/stuttgart/bluetooth/include/hci_lib.h"
/* signal to trigger on/off action depending on internal/external state.
 * It is required by soft on/off and bt on/off when fm is already on.
 * WARNING SIGUSR1 is used for kernel driver io signalling! */
#ifndef BTL_FM_BT_ON_OFF_SIGNAL
#define BTL_BT_FM_ON_OFF_SIGNAL SIGUSR2
#endif

#ifndef HCI_DEV_ID
#define HCI_DEV_ID 0
#endif

#define HCID_STOP_DELAY_USEC 500000
// Added this to check the time taken for a Bluetooth enable/disable
#define BT_ONOFF_PROFILE_ENABLED 1

#define MIN(x,y) (((x)<(y))?(x):(y))

#define BRCM_PROPERTY_BT_ACTIVATION  "service.brcm.bt.activation"
#define DTUN_PROPERTY_SERVER_ACTIVE  "service.brcm.bt.srv_active"
#define DTUN_PROPERTY_HCID_ACTIVE    "service.brcm.bt.hcid_active"
#define BRCM_PROPERTY_BTLD_PID      "service.brcm.bt.btld_pid" // PID of the btld process. This is needed to send the signal in the case of soft_onoff
#define BRCM_PROPERTY_SOFT_ONOFF_ENABLE "service.brcm.bt.soft_onoff" //Property to test if soft_onoff is enabled

#define START_DAEMON_PROPERTY_CHECK_DELAY_US 500000
#define START_DAEMON_PROPERTY_CHECK_TIMEOUT_SECS 10
#define START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT ((START_DAEMON_PROPERTY_CHECK_TIMEOUT_SECS*1000000)/START_DAEMON_PROPERTY_CHECK_DELAY_US)

#define STOP_DAEMON_PROPERTY_CHECK_DELAY_US 200000
#define STOP_DAEMON_PROPERTY_CHECK_TIMEOUT_SECS 10
#define STOP_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT ((STOP_DAEMON_PROPERTY_CHECK_TIMEOUT_SECS*1000000)/STOP_DAEMON_PROPERTY_CHECK_DELAY_US)


static int retry_cnt = 0;
static int rfkill_id = -1;
static char *rfkill_state_path = NULL;
static const char BT_MAC_TEMPLATE[]   = "/system/etc/bluetooth/bdaddr_mac";
static const char BT_MAC_FILE[]       = "/data/misc/bluetoothd/bdaddr_mac";

char bt_mac_addr[13]; 
//  /system/etc/bluetooth/bdaddr_mac
// START - FM & BT ON/OFF handling
//
// Implementation of new methods of enable/disable for BT and FM
//
typedef enum {
	BTOFF_FMOFF,
	BTON_FMOFF,
	BTOFF_FMON,
	BTON_FMON
} eBT_FM_STATE;

// FM and BT state action
typedef enum {
	BT_OFF,
	BT_ON,
	FM_OFF,
	FM_ON
} eBT_FM_STATE_ACTION;

/* TODO: maybe use end state instead */
typedef enum {
    BTLD_CTRL,          /* start/stop btld daemon unconditionally */
    BTLD_CTRL_NO_SW,    /* start/stop control depending if soft on/off disabled */
    BTLD_SIG,           /* signal start/stop of BT. btld is already running */
    BTLD_SIG_NO_SW      /* btld core stack and bta fm already running */
} BTLD_CONTROL_ACTION_t;

// forward declaration of state machine routines
extern int BTOFF_FMOFF_handling(eBT_FM_STATE_ACTION st);
extern int BTON_FMOFF_handling(eBT_FM_STATE_ACTION st);
extern int BTOFF_FMON_handling(eBT_FM_STATE_ACTION st);
extern int BTON_FMON_handling(eBT_FM_STATE_ACTION st);

static int dtun_property_is_active(char *property);
static int is_bluetoothd_stopped(void);
static int is_bluetoothd_stopped();

// Mutex to handle concurrent access to the state machine
static pthread_mutex_t bt_on_off_state_mutex;
static int bt_on_off_mutex_initialized = 0;
static volatile eBT_FM_STATE bt_current_state = BTOFF_FMOFF;
#define BT_LOCK_MUTEX() { \
				if (!bt_on_off_mutex_initialized) \
				{ \
					bt_on_off_mutex_initialized = 1; \
					pthread_mutex_init(&bt_on_off_state_mutex, NULL); \
				} \
				pthread_mutex_lock(&bt_on_off_state_mutex); \
			}


#define BT_UNLOCK_MUTEX() { \
				pthread_mutex_unlock(&bt_on_off_state_mutex); \
			  }

// use to enable/disable BT functionality when btld is loaded for FM
#define CFG_BT_ACTIVE_STATUS "bluedroid.active"

typedef int (*pFunct_ON_OFF_handling) (eBT_FM_STATE_ACTION st);
// State machine function pointer, default state BT and FM are OFF
const pFunct_ON_OFF_handling BT_FM_state_handling[] = {
	BTOFF_FMOFF_handling,
	BTON_FMOFF_handling,
	BTOFF_FMON_handling,
	BTON_FMON_handling
};

//
// END - FM & BT ON/OFF handling
//



//////////////////////////////////////////////////////////////////
//
/* TODO: Remove this once legacy hciattach is removed */
static const char * get_hciattach_script() {
    if (access("/dev/ttyHS0", F_OK)) {
        ALOGD("Using legacy uart driver (115200 bps)");
        return "hciattach_legacy";
    } else {
        ALOGD("Using high speed uart driver (4 Mbps)");
        return "hciattach";
    }
}

static pid_t btld_get_pid()
{
    char value[PROPERTY_VALUE_MAX];
	pid_t pid;

    /* default if not set it 0 */
    property_get(BRCM_PROPERTY_BTLD_PID, value, "0");
    ALOGV("btl_get_pid : %s = %s\n", BRCM_PROPERTY_BTLD_PID, value);

    sscanf(value, "%d", &pid);
    return pid;
}

static int btld_is_soft_onoff_enabled()
{
    char value[PROPERTY_VALUE_MAX];
	int enabled=0;

    /* default if not set it 0 */
    property_get(BRCM_PROPERTY_SOFT_ONOFF_ENABLE, value, "0");
    ALOGV("btl_get_soft_onoff_enabled : %s = %s\n", BRCM_PROPERTY_SOFT_ONOFF_ENABLE, value);

	sscanf(value, "%d", &enabled);
    return enabled;
}

/* sends sig to btld for on or off */
/* returns: 0: success, negative: failed */
static int btl_send_on_off_signal( int sig )
{
    int ret_val = 0;
    pid_t pid = btld_get_pid();
    ALOGI("btl_send_on_off_signal():Sending signal %d to bt daemon %d ", sig , pid );

    if (pid > 0)
    {
        kill(pid, sig);
    }
    else
    {
        ret_val = -1;
    }
    return ret_val;
} /* btl_send_on_off_signal() */


///////////////////////////////////////////////////////////////////
//
static void bt_start_daemons( const BTLD_CONTROL_ACTION_t ctl_act )
{
    int soft_on_off = btld_is_soft_onoff_enabled();

    ALOGI( "bt_start_daemons( ctl_act: %d ), soft_on_off: %d:Starting daemons...", ctl_act, soft_on_off );

    if ( (1==soft_on_off) && (ctl_act==BTLD_CTRL_NO_SW) )
    {
        ALOGI( "soft_on_off enabled, ignore ctrl" );
        return;
    }
	if ( (0==soft_on_off) && (ctl_act==BTLD_SIG_NO_SW) )
    {
        ALOGI( "soft_on_off is not enabled, ignore signal" );
        return;
    }
    /* BT power is controlled by btld */

    if (is_hciattach_enabled())
    {
        // if running on target make sure we initialize HW chip using hciattach
        if (!is_emulator_context("hciattach"))
        {
            ALOGI("Starting hciattach daemon");

            if (property_set("ctl.start", "hciattach") < 0) {
                ALOGE("Failed to start hciattach");
                return;
            }

            sleep(2);

            // once initialized we need to make sure that the serial port is freed up
            ALOGI("Now stopping hciattach daemon");
            if (property_set("ctl.stop", "hciattach") < 0) {
                ALOGE("Failed to start hciattach");
                return;
            }

            sleep(1);
        }
    }

    /* Check to see if soft_onoff is enabled, then send the signal */
    if ( (ctl_act==BTLD_SIG) || (ctl_act==BTLD_SIG_NO_SW) )
    {
        if ( 0 > btl_send_on_off_signal( BTL_BT_FM_ON_OFF_SIGNAL ) )
        {
            ALOGE( "Fail: Invalid BTLD PID. Unable to send BT ENABLE signal " );
            return;
        }
        // Commented out: In the case where soft on/off is enabled and BT was turned on
        // after FM was turned on, we still need to fall-through to start bluetoothd.
        //if (ctl_act==BTLD_SIG_NO_SW)
        //{
        //    /* soft on/off is off belows daemons should already be running */
        //    LOGI( "signalling btld only!" );
        //    return;
        //}
    }
    else
    {
        ALOGI("Starting btld...");
        if (property_set("ctl.start", "btld") < 0) {
           ALOGE("Failed to start btld");
           return;
        }
    }

    retry_cnt=START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT;
    while (--retry_cnt && (dtun_property_is_active(DTUN_PROPERTY_SERVER_ACTIVE)==0))
        usleep(START_DAEMON_PROPERTY_CHECK_DELAY_US);

    ALOGI("BTLD start retry count %d/%d", 
         START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT-retry_cnt, 
         START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT);

    if (retry_cnt == 0) {
        ALOGE("btld start timed out");
        return;
    }

    ALOGI("Starting bluetoothd deamon");
    if (property_set("ctl.start", "bluetoothd") < 0) {
        ALOGE("Failed to start bluetoothd");
        return;
    }

    retry_cnt=START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT;
    while (--retry_cnt && (dtun_property_is_active(DTUN_PROPERTY_HCID_ACTIVE)==0) )
        usleep(START_DAEMON_PROPERTY_CHECK_DELAY_US);

    ALOGI("bluetoothd start retry count %d/%d",
         START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT-retry_cnt,
         START_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT);

    if (retry_cnt == 0) {
        ALOGE("bluetoothd start timed out");
        return;
    }

    ALOGI("bt_start_daemons(): Starting daemons... Done!");
}

/*
 * Function:    bt_stop_daemons
 *              stop daemons depending on input params
 * params:
 *  ctl_act:    BTLD_CTRL : kill btld and related process
 *              BTLD_SIG  : only send a signal (E.g. FM is still running)
 *              _NO_SW : take soft/on off state into account
 */
static void bt_stop_daemons( const BTLD_CONTROL_ACTION_t ctl_act )
{
    int bluetoothd_stopped = 0;
    int btld_stopped = 0;
    int soft_on_off = btld_is_soft_onoff_enabled();

    ALOGI(" bt_stop_daemons( ctl_act: %d ), soft_on_off: %d: Stopping daemons...", ctl_act, soft_on_off );

    if ( (1==soft_on_off) && (ctl_act==BTLD_CTRL_NO_SW) )
    {
        ALOGI( "bt_stop_daemons(): soft on_off enabled ignore ctrl off" );
        return;
    }

	if ( (0==soft_on_off) && (ctl_act==BTLD_SIG_NO_SW) )
    {
        ALOGI( "bt_stop_daemons(): soft on_off is not enabled ignore signal off" );
        return;
    }
    ALOGI("Stopping bluetoothd...");
    if (property_set("ctl.stop", "bluetoothd") < 0) {
        ALOGE("Failed to stop bluetoothd");
        return;
    }

    if (ctl_act==BTLD_SIG || ctl_act==BTLD_SIG_NO_SW) {
        if ( 0 > btl_send_on_off_signal( BTL_BT_FM_ON_OFF_SIGNAL ) )
        {
            ALOGE( "Fail: Invalid BTLD PID. Unable to send BT DISABLE signal " );
            return;
        }
        //Also, in this case, we do not have to specifically wait for btld to stop
        if ( 0==soft_on_off )
        {
            /* in case of BTLD_SIG, we just want to disable BT with FM leaving up and running. so just
             * return to callee */
            return;
        }
        /*  so just the flag to true: TODO: maybe even in soft on/off we can just jump out? */
        btld_stopped = 1;
    } else {
        ALOGI("Stopping btld...");
        if (property_set("ctl.stop", "btld") < 0) {
            ALOGE("Failed to stop btld");
            return;
        }
    }

    // Wait until both bluetoothd and btld daemons are down
    ALOGI("Wait until all daemons are stopped, or timed out...");
    retry_cnt = STOP_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT;
    while ((bluetoothd_stopped == 0 || btld_stopped == 0) && --retry_cnt) {

#if 0
		if (bluetoothd_stopped == 0 && dtun_property_is_active(DTUN_PROPERTY_HCID_ACTIVE) == 0) {
                property_set(DTUN_PROPERTY_HCID_ACTIVE, "0");
            }
			bluetoothd_stopped = 1;
		}
#else
		if (bluetoothd_stopped == 0 && is_bluetoothd_stopped() == 1) {
						ALOGI("bluetoothd has stopped");
				if (dtun_property_is_active(DTUN_PROPERTY_HCID_ACTIVE) == 1) {
								ALOGI("But dtun_property_hcid_active is still 1. So clearing it...");
								property_set(DTUN_PROPERTY_HCID_ACTIVE, "0");
				}
						bluetoothd_stopped = 1;
		}
#endif	

        if (btld_stopped == 0 && dtun_property_is_active(DTUN_PROPERTY_SERVER_ACTIVE) == 0) {
            btld_stopped = 1;
        }

        if (bluetoothd_stopped == 0 || btld_stopped == 0) {
            usleep(STOP_DAEMON_PROPERTY_CHECK_DELAY_US);
        }
    }

    ALOGW("Daemon stop waiting count %d/%d",
         STOP_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT-retry_cnt,
         STOP_DAEMON_PROPERTY_CHECK_TIMEOUT_RETRY_COUNT);

    if (retry_cnt == 0 && (bluetoothd_stopped == 0 || btld_stopped == 0)) {
        if (bluetoothd_stopped == 0) {
            ALOGW("bluetoothd stop timed out");
            property_set(DTUN_PROPERTY_HCID_ACTIVE, "0");
        }
        if (btld_stopped == 0) {
            ALOGW("btld stop timed out");
            property_set(DTUN_PROPERTY_SERVER_ACTIVE, "0");
        }
    }


    /* BT chip power is controleled by btld */

    ALOGI("Stopping daemons... Done!");
}


///////////////////////////////////////////////////////////////////
// BTOFF_FMOFF_handling
//
// On entry the current state is BT_OFF and FM_OFF
int BTOFF_FMOFF_handling(eBT_FM_STATE_ACTION st)
{
    // Only BT_ON and FM_ON are handled in this state
    ALOGI("BTOFF_FMOFF_handling");
	BT_LOCK_MUTEX()
	switch(st)
	{
	case BT_ON:
        // load btld for BT
	    ALOGI("BTOFF_FMOFF_handling : receiving BT_ON");
	    // Ask btld to activate BT functionality 
        property_set(BRCM_PROPERTY_BT_ACTIVATION, "1");
        /* Start the daemons irrespective of soft_onoff status
        * but we need to send the right signal BTLD_CTRL or BTLD_SIG
        * depending on whether on/off is enabled or not. */
        bt_start_daemons( (btld_is_soft_onoff_enabled() == 1) ? BTLD_SIG : BTLD_CTRL );
		bt_current_state = BTON_FMOFF;
	    ALOGI("New state is BTON_FMOFF_handling");
		break;
	case FM_ON:
        // load btld for FM
        ALOGI("BTOFF_FMOFF_handling : receiving FM_ON");
        property_set(BRCM_PROPERTY_BT_ACTIVATION, "0");
        /* if soft_onoff is enabled, btld is already preloaded and no need to start it for FM which
         * already is ready to be used. If btld soft on off is not enabled, it will just start the btld */			
        bt_start_daemons( BTLD_CTRL_NO_SW );
		bt_current_state = BTOFF_FMON;
	    ALOGI("New state is BTOFF_FMON_handling");
		break;
	default: break;
	}
	BT_UNLOCK_MUTEX()
	return 0;
}


///////////////////////////////////////////////////////////////////
// BTON_FMOFF_handling
//
// On entry the current state is BT_ON and FM_OFF
int BTON_FMOFF_handling(eBT_FM_STATE_ACTION st)
{
// Only BT_OFF and FM_ON are handled in this state
    ALOGI("BTON_FMOFF_handling");

	BT_LOCK_MUTEX()
	switch(st)
	{
	case BT_OFF:
        // FM is off so unload btld
	    ALOGI("BTON_FMOFF_handling : receiving BT_OFF");
        property_set(BRCM_PROPERTY_BT_ACTIVATION, "0");
       /* Killed btld and all associated daemons independent of soft on/off
        * but we need to send the right signal BTLD_CTRL or BTLD_SIG
        * depending on whether on/off is enabled or not. */
        bt_stop_daemons( (btld_is_soft_onoff_enabled() == 1) ? BTLD_SIG : BTLD_CTRL );
		bt_current_state = BTOFF_FMOFF;
	    ALOGI("New state is BTOFF_FMOFF_handling");
		break;
	case FM_ON:
        // as BT is on so btld is already loaded
	    ALOGI("TON_FMOFF_handling : receiving FM_ON");
		// btld has been loaded, just update the state machine state;
		bt_current_state = BTON_FMON;
	    ALOGI("New state is BTON_FMON_handling");
		break;
	default: break;
	}
	BT_UNLOCK_MUTEX()
	return 0;
}

///////////////////////////////////////////////////////////////////
// BTOFF_FMON_handling
//
// On entry the current state is BT_OFF and FM_ON
int BTOFF_FMON_handling(eBT_FM_STATE_ACTION st)
{
// Only BT_ON and FM_OFF are handled in this state
    ALOGI("BTOFF_FMON_handling");
	BT_LOCK_MUTEX()
	switch(st)
	{
	case BT_ON:
        // As FM is on and btld is already loaded, so just initialize BT
	    ALOGI("BTOFF_FMON_handling : receiving BT_ON");
        property_set(BRCM_PROPERTY_BT_ACTIVATION, "1");
		/* btld is already loaded, just need to initiate the  BT
		*
		*/        
        bt_start_daemons( BTLD_SIG_NO_SW );        
		bt_current_state = BTON_FMON;
	    ALOGI("$#$#$#$# New state is BTON_FMON_handling");
		break;
	case FM_OFF:
		// as BT is off so stop bt dameons
	    ALOGI("BTOFF_FMON_handling : receiving FM_OFF");
		/*
		btld is running but BT is already off, just send the control
		*/
        bt_stop_daemons( BTLD_CTRL_NO_SW );

        property_set(BRCM_PROPERTY_BT_ACTIVATION, "0");
		bt_current_state = BTOFF_FMOFF;
	    ALOGI("New state is BTOFF_FMOFF_handling");
		break;
	default: break;
	}
	BT_UNLOCK_MUTEX()
	return 0;
}

///////////////////////////////////////////////////////////////////
// BTON_FMON_handling
//
// On entry the current state is BT_ON and FM_ON
int BTON_FMON_handling(eBT_FM_STATE_ACTION st)
{
	// Only BT_OFF and FM_OFF are handled in this state
    ALOGI("BTON_FMON_handling");
	BT_LOCK_MUTEX()
	switch(st)
	{
	case BT_OFF:
        // as FM is still on, so keep btld loaded
	    ALOGI("BTON_FMON_handling : receiving BT_OFF");
		bt_current_state = BTOFF_FMON;
        property_set(BRCM_PROPERTY_BT_ACTIVATION, "0");
		/* btld is already running & both BT & FM are running
		*/		
        bt_stop_daemons( BTLD_SIG_NO_SW);
	    ALOGI("New state is BTOFF_FMON_handling");
		break;
	case FM_OFF:
        // As BT is still on, so keep btld loaded
	    ALOGI("BTON_FMON_handling : receiving FM_OFF");
		// BT is still on so just update the state machine state
		bt_current_state = BTON_FMOFF;
	    ALOGI("New state is BTON_FMOFF_handling");
		break;
	default: break;
	}
	BT_UNLOCK_MUTEX()
	return 0;
}

#ifdef BT_ALT_STACK

static int bt_emul_enable = 0;
int is_emulator_context(char *msg) {
    char value[PROPERTY_VALUE_MAX];
    property_get("ro.kernel.qemu", value, "0");
    ALOGV("[%s] is_emulator_context : %s\n", msg, value);   
    if (strcmp(value, "1") == 0) {
        return 1;
    }
    return 0;
}

int is_rfkill_disabled(void) {
    char value[PROPERTY_VALUE_MAX];
    property_get("ro.rfkilldisabled", value, "0");
    ALOGV("is_rfkill_disabled ? [%s]\n", value);   
    if (strcmp(value, "1") == 0) {
        return 1;
    }
    return 0;
}

int is_hciattach_enabled(void) {
    char value[PROPERTY_VALUE_MAX];
    property_get("ro.hciattach_enabled", value, "0");
    ALOGV("is_hciattach_enabled ? [%s]\n", value);
    if (strcmp(value, "1") == 0) {
        return 1;
    }
    return 0;
}

#else

int is_emulator_context(char *msg) {return 0;}
int is_rfkill_disabled(void) { return 0;}
int is_hciattach_enabled(void) {return 0;}


#endif

int is_bluetoothd_stopped() {
    char value[PROPERTY_VALUE_MAX];

    /* default if not set it 0 */
    property_get("init.svc.bluetoothd", value, "running");

    ALOGV("is_bluetooth_stopped : %s\n", value);

    if (strcmp(value, "stopped") == 0) {
        return 1;
    }
    return 0;
}

int dtun_property_is_active(char *property) {
    char value[PROPERTY_VALUE_MAX];

    /* default if not set it 0 */
    property_get(property, value, "0");

    ALOGV("dtun_property_is_active : %s=%s\n", property, value);

    if (strcmp(value, "1") == 0) {
        return 1;
    }
    return 0;
}

static int init_rfkill() {
    char path[64];
    char buf[16];
    int fd;
    int sz;
    int id;

    if (is_rfkill_disabled())
        return 0;

    for (id = 0; ; id++) {
        snprintf(path, sizeof(path), "/sys/class/rfkill/rfkill%d/type", id);
        fd = open(path, O_RDONLY);
        if (fd < 0) {
            ALOGW("open(%s) failed: %s (%d)\n", path, strerror(errno), errno);
            return -1;
        }
        sz = read(fd, &buf, sizeof(buf));
        close(fd);
        if (sz >= 9 && memcmp(buf, "bluetooth", 9) == 0) {
            rfkill_id = id;
            break;
        }
    }

    asprintf(&rfkill_state_path, "/sys/class/rfkill/rfkill%d/state", rfkill_id);
    return 0;
}

static int check_bluetooth_power() {
    int sz;
    int fd = -1;
    int ret = -1;
    char buffer;

    /* notify always on if no rfkill support */
    if (is_rfkill_disabled())
       return 1;

    if (rfkill_id == -1) {
        if (init_rfkill()) goto out;
    }

    fd = open(rfkill_state_path, O_RDONLY);
    if (fd < 0) {
        ALOGE("open(%s) failed: %s (%d)", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }
    sz = read(fd, &buffer, 1);
    if (sz != 1) {
        ALOGE("read(%s) failed: %s (%d)", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }

    switch (buffer) {
    case '1':
        ret = 1;
        break;
    case '0':
        ret = 0;
        break;
    }

out:
    if (fd >= 0) close(fd);
    return ret;
}

static int set_bluetooth_power(int on) {
    int sz;
    int fd = -1;
    int ret = -1;
    const char buffer = (on ? '1' : '0');
    /* check if we have rfkill interface */
    if (is_rfkill_disabled())
       return 0;

    if (rfkill_id == -1) {
        if (init_rfkill()) goto out;
    }

    fd = open(rfkill_state_path, O_WRONLY);
    if (fd < 0) {
        ALOGE("open(%s) for write failed: %s (%d)", rfkill_state_path,
             strerror(errno), errno);
        goto out;
    }
    sz = write(fd, &buffer, 1);
    if (sz < 0) {
        ALOGE("write(%s) failed: %s (%d)", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }
    ret = 0;

out:
    if (fd >= 0) close(fd);
    return ret;
}

static inline int create_hci_sock() {
    int sk = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
    if (sk < 0) {
        ALOGE("Failed to create bluetooth hci socket: %s (%d)",
             strerror(errno), errno);
    }
    return sk;
}

static double
timediff(t1, t2)
	struct timeval *t1, *t2;
{
	if (t2->tv_usec >= t1->tv_usec)
		return t2->tv_sec - t1->tv_sec +
			(double)(t2->tv_usec - t1->tv_usec) / 1000000;

	return t2->tv_sec - t1->tv_sec - 1 +
		(double)(1000000 + t2->tv_usec - t1->tv_usec) / 1000000;
}

int ensure_bt_mac_file_exists()
{
    char buf[2048];
    int srcfd, destfd;
    int nread;

    if (access(BT_MAC_FILE, R_OK|W_OK) == 0) {
        return 0;
    } else if (errno != ENOENT) {
        ALOGE("Cannot access \"%s\": %s", BT_MAC_FILE, strerror(errno));
        return -1;
    }

    srcfd = open(BT_MAC_TEMPLATE, O_RDONLY);
    if (srcfd < 0) {
        ALOGE("Cannot open \"%s\": %s", BT_MAC_TEMPLATE, strerror(errno));
        return -1;
    }

    destfd = open(BT_MAC_FILE, O_CREAT|O_WRONLY, 0660);
    if (destfd < 0) {
        close(srcfd);
        ALOGE("Cannot create \"%s\": %s", BT_MAC_FILE, strerror(errno));
        return -1;
    }

    while ((nread = read(srcfd, buf, sizeof(buf))) != 0) {
        if (nread < 0) {
            ALOGE("Error reading \"%s\": %s", BT_MAC_TEMPLATE, strerror(errno));
            close(srcfd);
            close(destfd);
            unlink(BT_MAC_FILE);
            return -1;
        }
        write(destfd, buf, nread);
    }

    close(destfd);
    close(srcfd);

    if (chown(BT_MAC_FILE, AID_SYSTEM, AID_BLUETOOTH) < 0) {
        ALOGE("Error changing group ownership of %s to %d: %s",
             BT_MAC_FILE, AID_BLUETOOTH, strerror(errno));
        unlink(BT_MAC_FILE);
        return -1;
    }
    return 0;
}

static int get_bt_mac(void) {
    char driver_status[PROPERTY_VALUE_MAX];
    FILE *bt_mac_addr_handle;
    char bt_addr[13];
    int i=0;
   // char mac_addr[sizeof(COMP_CODE_TAG)+4];  

    if (ensure_bt_mac_file_exists() < 0) {
         ALOGE("Could not get bt_mac file");
        return 0;
    }
    if ((bt_mac_addr_handle = fopen(BT_MAC_FILE, "r+")) == NULL) {
        ALOGD("imei_get:Could not open %s: %s", BT_MAC_FILE, strerror(errno));
        return 0;
    }

    if((fgets(bt_addr, sizeof(bt_addr), bt_mac_addr_handle)) == NULL)
     {
              ALOGE("imei_get:not get bt address  " ); 
              fclose(bt_mac_addr_handle);
              return 0;
     }
    else
     {
            ALOGE("imei_get:bt_addr = %s:", bt_addr);
            memcpy(bt_mac_addr,bt_addr,sizeof(bt_addr));
            ALOGE("imei_get:bt_mac_addr = %s:", bt_addr);
            fclose(bt_mac_addr_handle);
            return 1;
    }
}

int bt_enable() {
    ALOGI("bt_enable...");
//davied add
        char value[13]; 
        int bt_mac_len;
        ALOGE("imei_get: bt_enable() ");      
        bt_mac_len = property_get("service.brcm.bt.mac", value, NULL);
        if(bt_mac_len <= 0)
        { 
 
            if (get_bt_mac()) 
             {      
                  property_set("service.brcm.bt.mac",bt_mac_addr);            
                  ALOGE("imei_get: bt_mac  = %s ",bt_mac_addr);     
             } 
            else  
             {
                  ALOGE("imei_get: get_bt_mac fail");
                  system("imei_get");
             }
            
            
            ALOGE("imei_get: bt_mac= %s ",bt_mac_addr);   
         }
        else
        {
               ALOGE("imei_get: value= %s ",value);      
        }
//--

#ifdef BT_ONOFF_PROFILE_ENABLED
    {
        struct timeval start_time, end_time;
        int ret;
        gettimeofday(&start_time, NULL);
        ret = BT_FM_state_handling[bt_current_state](BT_ON);
        gettimeofday(&end_time, NULL);
        ALOGI("PROFILE:bt_enable: Turnaround time: %f seconds", timediff(&start_time, &end_time));
        return ret;
     }
#else
    return BT_FM_state_handling[bt_current_state](BT_ON);
#endif
}

int bt_disable() {
    int ret;

    ALOGI("bt_disable...");
#ifdef BT_ONOFF_PROFILE_ENABLED
    {
        struct timeval start_time, end_time;
        int ret;
        gettimeofday(&start_time, NULL);
        ret = BT_FM_state_handling[bt_current_state](BT_OFF);
		sleep( 1 ); //Start-up was being allowed before shut-down was complete so...
        gettimeofday(&end_time, NULL);
        ALOGI("PROFILE:bt_disable: Turnaround time: %f seconds", timediff(&start_time, &end_time));
        return ret;
    }
#else
    ret = BT_FM_state_handling[bt_current_state](BT_OFF);

    sleep( 1 ); //Start-up was being allowed before shut-down was complete so...

    return ret;
#endif
}

int bt_is_enabled() {
    ALOGV(__FUNCTION__);

    int hci_sock = -1;
    int ret = -1;
    struct hci_dev_info dev_info;


    // Check power first
    ret = check_bluetooth_power();
    if (ret == -1 || ret == 0) goto out;

    ret = -1;

    // Power is on, now check if the HCI interface is up
    hci_sock = create_hci_sock();
    if (hci_sock < 0) goto out;

    dev_info.dev_id = HCI_DEV_ID;
    if (ioctl(hci_sock, HCIGETDEVINFO, (void *)&dev_info) < 0) {
        ret = 0;
        goto out;
    }

    ret = hci_test_bit(HCI_UP, &dev_info.flags);

out:
    if (hci_sock >= 0) close(hci_sock);
    return ret;
}

int fm_enable() {

    ALOGI(__FUNCTION__);
	return BT_FM_state_handling[bt_current_state](FM_ON);
}

int fm_disable() {

    ALOGI(__FUNCTION__);
    return BT_FM_state_handling[bt_current_state](FM_OFF);
}

int get_current_state(){
	ALOGI(__FUNCTION__);
	return bt_current_state;
}

int ba2str(const bdaddr_t *ba, char *str) {
    return sprintf(str, "%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X",
                ba->b[5], ba->b[4], ba->b[3], ba->b[2], ba->b[1], ba->b[0]);
}

int str2ba(const char *str, bdaddr_t *ba) {
    int i;
    for (i = 5; i >= 0; i--) {
        ba->b[i] = (uint8_t) strtoul(str, (char **) &str, 16);
        str++;
    }
    return 0;
}

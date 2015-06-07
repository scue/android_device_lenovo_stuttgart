/* linux/drivers/media/video/samsung/fimc/fimc.h
 *
 * Copyright (c) 2010 Samsung Electronics Co., Ltd.
 *		http://www.samsung.com/
 *
 * Header file for Samsung Camera Interface (FIMC) driver
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
*/


#ifndef __FIMC_H
#define __FIMC_H __FILE__

typedef unsigned int dma_addr_t;
typedef __u32  u32;
typedef __s32  s32;

#ifdef __KERNEL__
#include <linux/wait.h>
#include <linux/mutex.h>
#include <linux/i2c.h>
#include <linux/fb.h>
#include <linux/videodev2.h>
#include <linux/platform_device.h>
#include <media/v4l2-common.h>
#include <media/v4l2-device.h>
#include <media/v4l2-ioctl.h>
#include <media/videobuf-core.h>
#include <media/v4l2-mediabus.h>
#if defined(CONFIG_BUSFREQ_OPP) || defined(CONFIG_BUSFREQ_LOCK_WRAPPER)
#include <mach/dev.h>
#endif
#include <plat/media.h>
#include <plat/fimc.h>
#include <plat/cpu.h>
#endif

#ifdef CONFIG_PM_RUNTIME
#include <linux/pm_runtime.h>
#endif

#define FIMC_NAME		"s3c-fimc"
#define FIMC_CMA_NAME		"fimc"

#define FIMC_CORE_CLK		"sclk_fimc"
#define FIMC_CLK_RATE		166750000
#define EXYNOS_BUSFREQ_NAME	"exynos-busfreq"

#if defined(CONFIG_ARCH_EXYNOS4)
#define FIMC_DEVICES		4
#define FIMC_PHYBUFS		32
#define FIMC_MAXCAMS		7
#else
#define FIMC_DEVICES		3
#define FIMC_PHYBUFS		4
#define FIMC_MAXCAMS		5
#endif

#define FIMC_SUBDEVS		3
#define FIMC_OUTBUFS		3
#define FIMC_INQUEUES		10
#define FIMC_MAX_CTXS		4
#define FIMC_TPID		3
#define FIMC_CAPBUFS		32
#define FIMC_ONESHOT_TIMEOUT	200
#define FIMC_DQUEUE_TIMEOUT	1000

#define FIMC_FIFOOFF_CNT	1000000 /* Sufficiently big value for stop */

#define FORMAT_FLAGS_PACKED	0x1
#define FORMAT_FLAGS_PLANAR	0x2

#define FIMC_ADDR_Y		0
#define FIMC_ADDR_CB		1
#define FIMC_ADDR_CR		2

#define FIMC_HD_WIDTH		1280
#define FIMC_HD_HEIGHT		720

#define FIMC_FHD_WIDTH		1920
#define FIMC_FHD_HEIGHT		1080

#define FIMC_MMAP_IDX		-1
#define FIMC_USERPTR_IDX	-2

#define FIMC_HCLK		0
#define FIMC_SCLK		1
#define CSI_CH_0		0
#define CSI_CH_1		1
#if defined(CONFIG_VIDEO_FIMC_FIFO)
#define FIMC_OVLY_MODE FIMC_OVLY_FIFO
#elif defined(CONFIG_VIDEO_FIMC_DMA_AUTO)
#define FIMC_OVLY_MODE FIMC_OVLY_DMA_AUTO
#endif

#define PINGPONG_2ADDR_MODE
#if defined(PINGPONG_2ADDR_MODE)
#define FIMC_PINGPONG 2
#endif

#define check_bit(data, loc)	((data) & (0x1<<(loc)))
#define FRAME_SEQ		0xf

#define fimc_cam_use		((pdata->use_cam) ? 1 : 0)

#define L2_FLUSH_ALL	SZ_1M
#define L1_FLUSH_ALL	SZ_64K

/*
 * ENUMERATIONS
*/
enum fimc_status {
	FIMC_READY_OFF		= 0x00,
	FIMC_STREAMOFF		= 0x01,
	FIMC_READY_ON		= 0x02,
	FIMC_STREAMON		= 0x03,
	FIMC_STREAMON_IDLE	= 0x04, /* oneshot mode */
	FIMC_OFF_SLEEP		= 0x05,
	FIMC_ON_SLEEP		= 0x06,
	FIMC_ON_IDLE_SLEEP	= 0x07, /* oneshot mode */
	FIMC_READY_RESUME	= 0x08,
	FIMC_BUFFER_STOP	= 0x09,
	FIMC_BUFFER_START	= 0x0A,
};

enum fimc_fifo_state {
	FIFO_CLOSE,
	FIFO_SLEEP,
};

enum fimc_fimd_state {
	FIMD_OFF,
	FIMD_ON,
};

enum fimc_rot_flip {
	FIMC_XFLIP	= 0x01,
	FIMC_YFLIP	= 0x02,
	FIMC_ROT	= 0x10,
};

enum fimc_input {
	FIMC_SRC_CAM,
	FIMC_SRC_MSDMA,
};

enum fimc_overlay_mode {
	FIMC_OVLY_NOT_FIXED		= 0x0,	/* Overlay mode isn't fixed. */
	FIMC_OVLY_FIFO			= 0x1,	/* Non-destructive Overlay with FIFO */
	FIMC_OVLY_DMA_AUTO		= 0x2,	/* Non-destructive Overlay with DMA */
	FIMC_OVLY_DMA_MANUAL		= 0x3,	/* Non-destructive Overlay with DMA */
	FIMC_OVLY_NONE_SINGLE_BUF	= 0x4,	/* Destructive Overlay with DMA single destination buffer */
	FIMC_OVLY_NONE_MULTI_BUF	= 0x5,	/* Destructive Overlay with DMA multiple dstination buffer */
};

enum fimc_autoload {
	FIMC_AUTO_LOAD,
	FIMC_ONE_SHOT,
};

enum fimc_log {
	FIMC_LOG_DEBUG		= 0x1000,
	FIMC_LOG_INFO_L2	= 0x0200,
	FIMC_LOG_INFO_L1	= 0x0100,
	FIMC_LOG_WARN		= 0x0010,
	FIMC_LOG_ERR		= 0x0001,
};

enum fimc_range {
	FIMC_RANGE_NARROW	= 0x0,
	FIMC_RANGE_WIDE		= 0x1,
};

enum fimc_pixel_format_type{
	FIMC_RGB,
	FIMC_YUV420,
	FIMC_YUV422,
	FIMC_YUV444,
};

enum fimc_framecnt_seq {
	FIMC_FRAMECNT_SEQ_DISABLE,
	FIMC_FRAMECNT_SEQ_ENABLE,
};

enum fimc_sysmmu_flag {
	FIMC_SYSMMU_OFF,
	FIMC_SYSMMU_ON,
};

enum fimc_id {
	FIMC0 = 0x0,
	FIMC1 = 0x1,
	FIMC2 = 0x2,
	FIMC3 = 0x3,
};

enum fimc_power_status {
	FIMC_POWER_OFF,
	FIMC_POWER_ON,
	FIMC_POWER_SUSPEND,
};

enum cam_mclk_status {
	CAM_MCLK_OFF,
	CAM_MCLK_ON,
};

/*
 * STRUCTURES
*/

/* for reserved memory */
struct fimc_meminfo {
	dma_addr_t	base;		/* buffer base */
	size_t		size;		/* total length */
	dma_addr_t	curr;		/* current addr */
	dma_addr_t	vaddr_base;		/* buffer base */
	dma_addr_t	vaddr_curr;		/* current addr */
};

struct fimc_buf {
	dma_addr_t	base[3];
	size_t		length[3];
};

struct fimc_overlay_buf {
	u32 vir_addr[3];
	size_t size[3];
	u32 phy_addr[3];
};

struct fimc_overlay {
	enum fimc_overlay_mode mode;
	struct fimc_overlay_buf buf;
	s32 req_idx;
};

/* for output overlay device */
struct fimc_idx {
	int ctx;
	int idx;
};

struct fimc_ctx_idx {
	struct fimc_idx prev;
	struct fimc_idx active;
	struct fimc_idx next;
};

/* scaler abstraction: local use recommended */
struct fimc_scaler {
	u32 bypass;
	u32 hfactor;
	u32 vfactor;
	u32 pre_hratio;
	u32 pre_vratio;
	u32 pre_dst_width;
	u32 pre_dst_height;
	u32 scaleup_h;
	u32 scaleup_v;
	u32 main_hratio;
	u32 main_vratio;
	u32 real_width;
	u32 real_height;
	u32 shfactor;
	u32 skipline;
};

struct s3cfb_user_window {
	int x;
	int y;
};

enum s3cfb_data_path_t {
	DATA_PATH_FIFO	= 0,
	DATA_PATH_DMA	= 1,
	DATA_PATH_IPC	= 2,
};

enum s3cfb_mem_owner_t {
	DMA_MEM_NONE	= 0,
	DMA_MEM_FIMD	= 1,
	DMA_MEM_OTHER	= 2,
};
#define S3CFB_WIN_OFF_ALL	_IO('F', 202)
#define S3CFB_WIN_POSITION	_IOW('F', 203, struct s3cfb_user_window)
#define S3CFB_GET_LCD_WIDTH	_IOR('F', 302, int)
#define S3CFB_GET_LCD_HEIGHT	_IOR('F', 303, int)
#define S3CFB_SET_WRITEBACK	_IOW('F', 304, u32)
#define S3CFB_SET_WIN_ON	_IOW('F', 305, u32)
#define S3CFB_SET_WIN_OFF	_IOW('F', 306, u32)
#define S3CFB_SET_WIN_PATH	_IOW('F', 307, enum s3cfb_data_path_t)
#define S3CFB_SET_WIN_ADDR	_IOW('F', 308, unsigned long)
#define S3CFB_SET_WIN_MEM	_IOW('F', 309, enum s3cfb_mem_owner_t)
/* ------------------------------------------------------------------------ */

struct fimc_fbinfo {
	struct fb_fix_screeninfo	*fix;
	struct fb_var_screeninfo	*var;
	int				lcd_hres;
	int				lcd_vres;
	u32				is_enable;
	/* lcd fifo control */

	int (*open_fifo)(int id, int ch, int (*do_priv)(void *), void *param);
	int (*close_fifo)(int id, int (*do_priv)(void *), void *param);
};

struct fimc_limit {
	u32 pre_dst_w;
	u32 bypass_w;
	u32 trg_h_no_rot;
	u32 trg_h_rot;
	u32 real_w_no_rot;
	u32 real_h_rot;
};

enum FIMC_EFFECT_FIN {
	FIMC_EFFECT_FIN_BYPASS = 0,
	FIMC_EFFECT_FIN_ARBITRARY_CBCR,
	FIMC_EFFECT_FIN_NEGATIVE,
	FIMC_EFFECT_FIN_ART_FREEZE,
	FIMC_EFFECT_FIN_EMBOSSING,
	FIMC_EFFECT_FIN_SILHOUETTE,
};


struct fimc_effect {
	int ie_on;
	int ie_after_sc;
	enum FIMC_EFFECT_FIN fin;
	int pat_cb;
	int pat_cr;
};

/* debug macro */
#define FIMC_LOG_DEFAULT	(FIMC_LOG_WARN | FIMC_LOG_ERR)

#define FIMC_DEBUG(fmt, ...)						\
	do {								\
			printk(KERN_DEBUG FIMC_NAME "%d: "		\
				fmt, ctrl->id, ##__VA_ARGS__);			\
	} while (0)

#define FIMC_INFO_L2(fmt, ...)						\
	do {								\
			printk(KERN_INFO FIMC_NAME "%d: "		\
				fmt, ctrl->id, ##__VA_ARGS__);			\
	} while (0)

#define FIMC_INFO_L1(fmt, ...)						\
	do {								\
			printk(KERN_INFO FIMC_NAME "%d: "		\
				fmt, ctrl->id, ##__VA_ARGS__);			\
	} while (0)

#define FIMC_WARN(fmt, ...)						\
	do {								\
			printk(KERN_WARNING FIMC_NAME "%d: "		\
				fmt, ctrl->id, ##__VA_ARGS__);			\
	} while (0)


#define FIMC_ERROR(fmt, ...)						\
	do {								\
			printk(KERN_ERR FIMC_NAME "%d: "		\
				fmt, ctrl->id, ##__VA_ARGS__);			\
	} while (0)


#define fimc_dbg(fmt, ...)		FIMC_DEBUG(fmt, ##__VA_ARGS__)
#define fimc_info2(fmt, ...)		FIMC_INFO_L2(fmt, ##__VA_ARGS__)
#define fimc_info1(fmt, ...)		FIMC_INFO_L1(fmt, ##__VA_ARGS__)
#define fimc_warn(fmt, ...)		FIMC_WARN(fmt, ##__VA_ARGS__)
#define fimc_err(fmt, ...)		FIMC_ERROR(fmt, ##__VA_ARGS__)

#endif /* __FIMC_H */

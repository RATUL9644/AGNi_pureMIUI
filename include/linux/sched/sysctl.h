#ifndef _SCHED_SYSCTL_H
#define _SCHED_SYSCTL_H

#ifdef CONFIG_DETECT_HUNG_TASK
extern int	     sysctl_hung_task_check_count;
extern unsigned int  sysctl_hung_task_panic;
extern unsigned long sysctl_hung_task_timeout_secs;
extern int sysctl_hung_task_warnings;
extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
					 void __user *buffer,
					 size_t *lenp, loff_t *ppos);
#else
/* Avoid need for ifdefs elsewhere in the code */
enum { sysctl_hung_task_timeout_secs = 0 };
#endif

/*
 * Default maximum number of active map areas, this limits the number of vmas
 * per mm struct. Users can overwrite this number by sysctl but there is a
 * problem.
 *
 * When a program's coredump is generated as ELF format, a section is created
 * per a vma. In ELF, the number of sections is represented in unsigned short.
 * This means the number of sections should be smaller than 65535 at coredump.
 * Because the kernel adds some informative sections to a image of program at
 * generating coredump, we need some margin. The number of extra sections is
 * 1-3 now and depends on arch. We use "5" as safe margin, here.
 *
 * ELF extended numbering allows more than 65535 sections, so 16-bit bound is
 * not a hard limit any more. Although some userspace tools can be surprised by
 * that.
 */
#define MAPCOUNT_ELF_CORE_MARGIN	(5)
#define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)

extern int sysctl_max_map_count;

extern unsigned int sysctl_sched_latency;
extern unsigned int sysctl_sched_min_granularity;
extern unsigned int sysctl_sched_wakeup_granularity;
extern unsigned int sysctl_sched_child_runs_first;
extern unsigned int sysctl_sched_sync_hint_enable;
extern unsigned int sysctl_sched_cstate_aware;
#ifdef CONFIG_SCHED_WALT
extern unsigned int sysctl_sched_use_walt_cpu_util;
extern unsigned int sysctl_sched_use_walt_task_util;
extern unsigned int sysctl_sched_walt_init_task_load_pct;
extern unsigned int sysctl_sched_walt_cpu_high_irqload;
#endif

enum sched_tunable_scaling {
	SCHED_TUNABLESCALING_NONE,
	SCHED_TUNABLESCALING_LOG,
	SCHED_TUNABLESCALING_LINEAR,
	SCHED_TUNABLESCALING_END,
};
extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;

extern unsigned int sysctl_numa_balancing_scan_delay;
extern unsigned int sysctl_numa_balancing_scan_period_min;
extern unsigned int sysctl_numa_balancing_scan_period_max;
extern unsigned int sysctl_numa_balancing_scan_size;

#ifdef CONFIG_SCHED_SYSCTL
extern __read_mostly unsigned int sysctl_sched_migration_cost;
extern __read_mostly unsigned int sysctl_sched_nr_migrate;
extern __read_mostly unsigned int sysctl_sched_time_avg;
extern unsigned int sysctl_sched_shares_window;

int sched_proc_update_handler(struct ctl_table *table, int write,
		void __user *buffer, size_t *length,
		loff_t *ppos);
#endif

/*
 *  control realtime throttling:
 *
 *  /proc/sys/kernel/sched_rt_period_us
 *  /proc/sys/kernel/sched_rt_runtime_us
 */
extern unsigned int sysctl_sched_rt_period;
extern int sysctl_sched_rt_runtime;

#ifdef CONFIG_UCLAMP_TASK
extern unsigned int sysctl_sched_uclamp_util_min;
extern unsigned int sysctl_sched_uclamp_util_max;
extern unsigned int sysctl_sched_uclamp_util_min_rt_default;
#endif

#ifdef CONFIG_CFS_BANDWIDTH
extern unsigned int sysctl_sched_cfs_bandwidth_slice;
#endif

#ifdef CONFIG_SCHED_TUNE
extern unsigned int sysctl_sched_cfs_boost;
int sysctl_sched_cfs_boost_handler(struct ctl_table *table, int write,
				   void __user *buffer, size_t *length,
				   loff_t *ppos);
static inline unsigned int get_sysctl_sched_cfs_boost(void)
{
	return sysctl_sched_cfs_boost;
}
#else
static inline unsigned int get_sysctl_sched_cfs_boost(void)
{
	return 0;
}
#endif

#ifdef CONFIG_SCHED_AUTOGROUP
extern unsigned int sysctl_sched_autogroup_enabled;
#endif

extern int sysctl_sched_rr_timeslice;
extern int sched_rr_timeslice;

extern int sched_rr_handler(struct ctl_table *table, int write,
		void __user *buffer, size_t *lenp,
		loff_t *ppos);

extern int sched_rt_handler(struct ctl_table *table, int write,
		void __user *buffer, size_t *lenp,
		loff_t *ppos);

#ifdef CONFIG_UCLAMP_TASK
extern int sysctl_sched_uclamp_handler(struct ctl_table *table, int write,
				       void __user *buffer, size_t *lenp,
				       loff_t *ppos);
#endif

extern int sysctl_numa_balancing(struct ctl_table *table, int write,
				 void __user *buffer, size_t *lenp,
				 loff_t *ppos);

extern unsigned int sysctl_sched_boost;

extern int sched_boost_handler(struct ctl_table *table, int write,
			       void __user *buffer, size_t *lenp, loff_t *ppos);

#endif /* _SCHED_SYSCTL_H */

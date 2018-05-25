create or replace force view logger_logs_5_min 
as
	select /*+ qb_name(logger_logs_5_min) */
    ll.* 
	from logger_logs ll
	where 1=1
    and ll.time_stamp > cast(systimestamp as timestamp) - (5/1440)
/
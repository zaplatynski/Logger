create or replace force view logger_logs_60_min 
as
	select /*+ qb_name(logger_logs_60_min) */
    ll.id,
    ll.logger_level,
    ll.scope,
    ll.text,
    ll.time_stamp,
    ll.module,
    ll.action,
    ll.user_name,
    ll.client_identifier,
    ll.call_stack,
    ll.unit_name,
    ll.line_no,
    ll.scn,
    ll.extra,
    ll.sid,
    ll.client_info
  from logger_logs ll
  where 1=1
    and ll.time_stamp > cast(systimestamp as timestamp) - (1/24)
/

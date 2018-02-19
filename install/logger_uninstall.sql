prompt *** UNINSTALLING LOGGER ***

whenever sqlerror continue

prompt dropping: logger
drop package logger;

prompt dropping: logger_configure
drop procedure logger_configure;

prompt dropping: logger_logs_apex_items
drop table logger_logs_apex_items cascade constraints;

prompt dropping: logger_prefs
drop table logger_prefs cascade constraints;

prompt dropping: logger_logs
drop table logger_logs cascade constraints;

prompt dropping: logger_prefs_by_client_id
drop table logger_prefs_by_client_id cascade constraints;

prompt dropping: logger_logs_seq
drop sequence logger_logs_seq;

prompt dropping: logger_apx_items_seq
drop sequence logger_apx_items_seq;

prompt dropping: logger_purge_job
exec dbms_scheduler.drop_job('LOGGER_PURGE_JOB');

prompt dropping: logger_unset_prefs_by_client
exec dbms_scheduler.drop_job('LOGGER_UNSET_PREFS_BY_CLIENT');

prompt dropping: logger_logs_5_min
drop view logger_logs_5_min;

prompt dropping: logger_logs_60_min
drop view logger_logs_60_min;

prompt dropping: logger_logs_terse
drop view logger_logs_terse;


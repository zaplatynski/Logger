-- Creates public synonyms from defined user for Logger objects


set define '&'
set verify off

-- Parameters
define from_user=LOGGER_USER
accept from_user char default &from_user prompt 'Name of the logger schema [&from_user] :'


whenever sqlerror exit sql.sqlcode

create or replace public synonym logger for &from_user..logger;
create or replace public synonym logger_logs for &from_user..logger_logs;
create or replace public synonym logger_logs_apex_items for &from_user..logger_logs_apex_items;
create or replace public synonym logger_prefs for &from_user..logger_prefs;
create or replace public synonym logger_prefs_by_client_id for &from_user..logger_prefs_by_client_id;
create or replace public synonym logger_logs_5_min for &from_user..logger_logs_5_min;
create or replace public synonym logger_logs_60_min for &from_user..logger_logs_60_min;
create or replace public synonym logger_logs_terse for &from_user..logger_logs_terse;
-- PBA/MNU 3.1.2
create or replace public synonym logger_prefs_by_scope for &from_user..logger_prefs_by_scope;

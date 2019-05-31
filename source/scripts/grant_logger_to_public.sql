-- Grants privileges for logger objects from current user to public


-- Parameters
-- none

whenever sqlerror exit sql.sqlcode

grant execute on logger to public;
grant select, delete on logger_logs to public;
grant select on logger_logs_apex_items to public;
grant select, update on logger_prefs to public;
grant select on logger_prefs_by_client_id to public;
grant select on logger_logs_5_min to public;
grant select on logger_logs_60_min to public;
grant select on logger_logs_terse to public;
-- PBA/MNU 3.1.2
grant select, insert, update, delete on logger_prefs_by_scope to public;

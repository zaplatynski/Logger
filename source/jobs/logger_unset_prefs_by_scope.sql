declare
  l_count pls_integer;
  l_job_name user_scheduler_jobs.job_name%type := 'LOGGER_UNSET_PREFS_BY_SCOPE';
begin
  
  select count(1)
  into l_count
  from user_scheduler_jobs
  where job_name = l_job_name;
  
  if l_count = 0 then
    dbms_scheduler.create_job(
       job_name => l_job_name,
       job_type => 'PLSQL_BLOCK',
       job_action => 'begin logger.unset_scope_level; end; ',
       start_date => systimestamp,
       repeat_interval => 'FREQ=HOURLY; BYHOUR=1',
       enabled => TRUE,
       comments => 'Clears expired logger prefs by scope');
  end if;
end;
/

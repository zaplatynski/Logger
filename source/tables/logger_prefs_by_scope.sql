-- Initial table script built from 3.1.2
declare
  l_count pls_integer;

begin
  -- Create Table
  select count(1)
  into l_count
  from user_tables
  where table_name = 'LOGGER_PREFS_BY_SCOPE';

  if l_count = 0 then
    execute immediate q'!
create table logger_prefs_by_scope(
  logger_scope      varchar2(512) not null,
  logger_level      varchar2(20) not null,
  created_date      date default sysdate not null,
  expiry_date       date default sysdate+1/24 not null,
  constraint logger_prefs_by_scope_pk primary key (logger_scope) enable,
  constraint logger_prefs_by_scope_ck1 check (logger_level in ('OFF','PERMANENT','ERROR','WARNING','INFORMATION','DEBUG','TIMING', 'APEX', 'SYS_CONTEXT')),
  constraint logger_prefs_by_scope_ck2 check (expiry_date >= created_date)
)!';
  end if;

-- Add comments to the table 
  execute immediate q'!comment on table LOGGER_PREFS_BY_SCOPE is 'Scope specific logger levels. Only active scopes/logger_levels will be maintained in this table'!';
-- Add comments to the columns 
  execute immediate q'!comment on column LOGGER_PREFS_BY_SCOPE.LOGGER_SCOPE is 'Scope. Wildcards allowed. Interpreted as LIKE pattern'!';
  execute immediate q'!comment on column LOGGER_PREFS_BY_SCOPE.LOGGER_LEVEL is 'Logger level. Must be OFF, PERMANENT, ERROR, WARNING, INFORMATION, DEBUG, TIMING'!';
  execute immediate q'!comment on column LOGGER_PREFS_BY_SCOPE.CREATED_DATE is 'Date that entry was created on'!';
  execute immediate q'!comment on column LOGGER_PREFS_BY_SCOPE.expiry_date is 'After the given expiry date the logger_level will be disabled for the specific client_id. Unless sepcifically removed from this table a job will clean up old entries'!';
end;
/
create or replace trigger biu_logger_prefs_by_scope
  before insert or update on logger_prefs_by_scope 
  for each row
begin
  $if $$logger_no_op_install $then
    null;
  $else
    :new.logger_scope := lower(:new.logger_scope);
  $end
end biu_logger_prefs_by_scope;
/

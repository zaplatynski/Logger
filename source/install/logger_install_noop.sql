
-- This file installs a NO-OP version of the logger package that has all of the same procedures and functions
-- but does not actually write to any tables. Additionally, it has no other object dependencies
-- You can review the documentation at https://github.com/OraOpenSource/Logger for more information
alter session set plsql_ccflags='logger_no_op_install:true'



prompt *** PREREQS ***



prompt logger_install_prereqs

-- This file contains the start and pre installation requirements for Logger
whenever sqlerror exit
set serveroutput on

-- SESSION PRIVILEGES
declare
  type t_sess_privs is table of pls_integer index by varchar2(50);
  l_sess_privs t_sess_privs;
  l_req_privs t_sess_privs;
  l_priv varchar2(50);
  l_dummy pls_integer;
  l_priv_error  boolean := false;
begin
  l_req_privs('CREATE SESSION') := 1;            
  l_req_privs('CREATE TABLE') := 1;
  l_req_privs('CREATE VIEW') := 1;
  l_req_privs('CREATE SEQUENCE') := 1;
  l_req_privs('CREATE PROCEDURE') := 1;
  l_req_privs('CREATE TRIGGER') := 1;
  l_req_privs('CREATE ANY CONTEXT') := 1;
  l_req_privs('CREATE JOB') := 1;

  for c1 in (select privilege from session_privs) loop
    l_sess_privs(c1.privilege) := 1;
  end loop;  --c1

  dbms_output.put_line('_____________________________________________________________________________');
  
  l_priv := l_req_privs.first;
  loop
  exit when l_priv is null;
    begin
      l_dummy := l_sess_privs(l_priv);
    exception 
      when no_data_found then
        -- #82
        if l_priv = 'CREATE ANY CONTEXT' then
          dbms_output.put_line('');
          dbms_output.put_line('*** Warning: the current schema does not have CREATE ANY CONTEXT privlege.');
          dbms_output.put_line('*** Logger will still work but is recommended to have this.');
          dbms_output.put_line('');
        else
          dbms_output.put_line('Error, the current schema is missing the following privilege: '||l_priv);
          l_priv_error := true;
        end if;
    end;
    
    l_priv := l_req_privs.next(l_priv);
  end loop;
    
  if not l_priv_error then
    dbms_output.put_line('User has all required privileges, installation will continue.');
  end if;
  
  dbms_output.put_line('_____________________________________________________________________________');

  if l_priv_error then
    raise_application_error (-20000, 'One or more required privileges are missing.');
  end if;
end;
/

whenever sqlerror continue




prompt *** TABLES ***



prompt logger_logs

-- Initial table script built from 1.4.0
declare
  l_count pls_integer;
  l_nullable user_tab_columns.nullable%type;

  type typ_required_columns is table of varchar2(30) index by pls_integer;
  l_required_columns typ_required_columns;


  type typ_tab_col is record (
    column_name varchar2(30),
    data_type varchar2(100));
  type typ_arr_tab_col is table of typ_tab_col index by pls_integer;

  l_new_col typ_tab_col;
  l_new_cols typ_arr_tab_col;

begin
  -- Create Table
  select count(1)
  into l_count
  from user_tables
  where table_name = 'LOGGER_LOGS';

  if l_count = 0 then
    execute immediate '
create table logger_logs(
  id number,
  logger_level number,
  text varchar2(4000),
  time_stamp timestamp,
  scope varchar2(1000),
  module varchar2(100),
  action varchar2(100),
  user_name varchar2(255),
  client_identifier varchar2(255),
  call_stack varchar2(4000),
  unit_name varchar2(255),
  line_no varchar2(100),
  scn number,
  extra clob,
  constraint logger_logs_pk primary key (id) enable,
  constraint logger_logs_lvl_ck check(logger_level in (1,2,4,8,16,32,64,128))
)
    ';
  end if;

  -- 2.0.0
  l_required_columns(l_required_columns.count+1) := 'LOGGER_LEVEL';
  l_required_columns(l_required_columns.count+1) := 'TIME_STAMP';

  for i in l_required_columns.first .. l_required_columns.last loop

    select nullable
    into l_nullable
    from user_tab_columns
    where table_name = 'LOGGER_LOGS'
      and column_name = upper(l_required_columns(i));

    if l_nullable = 'Y' then
      execute immediate 'alter table logger_logs modify ' || l_required_columns(i) || ' not null';
    end if;
  end loop;


  -- 2.2.0
  -- Add additional columns
  -- #51
  l_new_col.column_name := 'SID';
  l_new_col.data_type := 'NUMBER';
  l_new_cols(l_new_cols.count+1) := l_new_col;

  -- #25
  l_new_col.column_name := 'CLIENT_INFO';
  l_new_col.data_type := 'VARCHAR2(64)'; -- taken from v$session.client_info
  l_new_cols(l_new_cols.count+1) := l_new_col;


  for i in 1 .. l_new_cols.count loop
    select count(1)
    into l_count
    from user_tab_columns
    where 1=1
      and table_name = 'LOGGER_LOGS'
      and column_name = l_new_cols(i).column_name;

    if l_count = 0 then
      execute immediate 'alter table LOGGER_LOGS add (' || l_new_cols(i).column_name || ' ' || l_new_cols(i).data_type || ')';
    end if;
  end loop;


  $if $$logger_no_op_install $then
    null;
  $else
    -- INDEXES
    select count(1)
    into l_count
    from user_indexes
    where index_name = 'LOGGER_LOGS_IDX1';

    if l_count = 0 then
      execute immediate 'create index logger_logs_idx1 on logger_logs(time_stamp,logger_level)';
    end if;
  $end

end;
/


-- TRIGGER (removed as part of 2.1.0 release)
-- Drop trigger if still exists (from pre-2.1.0 releases) - Issue #31
declare
  l_count pls_integer;
  l_trigger_name user_triggers.trigger_name%type := 'BI_LOGGER_LOGS';
begin
  select count(1)
  into l_count
  from user_triggers
  where 1=1
    and trigger_name = l_trigger_name;

  if l_count > 0 then
    execute immediate 'drop trigger ' || l_trigger_name;
  end if;
end;
/


prompt logger_prefs

-- Initial table script built from 1.4.0
declare
  l_count pls_integer;
  l_nullable user_tab_columns.nullable%type;

  type typ_required_columns is table of varchar2(30) index by pls_integer;
  l_required_columns typ_required_columns;

begin
  -- Create Table
  select count(1)
  into l_count
  from user_tables
  where table_name = 'LOGGER_PREFS';

  if l_count = 0 then
    execute immediate '
create table logger_prefs(
  pref_name	varchar2(255),
  pref_value	varchar2(255) not null,
  constraint logger_prefs_pk primary key (pref_name) enable
)
    ';
  end if;

end;
/


-- #TODO:130 mdsouza: logger 3.1.1 fix. Removed currently_installing
-- Append existing PLSQL_CCFLAGS
-- Since may be set with existing flags (specifically no_op)
-- var cur_plsql_ccflags varchar2(500);
--
-- declare
--   parnam varchar2(256);
--   intval binary_integer;
--   strval varchar2(500);
--   partyp binary_integer;
-- begin
--   partyp := dbms_utility.get_parameter_value('plsql_ccflags',intval, strval);
--
--   if strval is not null then
--     strval := ',' || strval;
--   end if;
--   :cur_plsql_ccflags := strval;
-- end;
-- /
--
-- -- Convert bind variable to substitution string
-- -- https://blogs.oracle.com/opal/entry/sqlplus_101_substitution_varia
-- column cur_plsql_ccflags new_value cur_plsql_ccflags
-- select :cur_plsql_ccflags cur_plsql_ccflags from dual;
--
-- alter session set plsql_ccflags='currently_installing:true&cur_plsql_ccflags'
-- /

create or replace trigger biu_logger_prefs
  before insert or update on logger_prefs
  for each row
begin
  $if $$logger_no_op_install $then
    null;
  $else

    -- #184 this table should only be updated by logger_prefs
    if not logger.g_can_update_logger_prefs then
      raise_application_error(-20001, 'Can not update logger_prefs from SQL. Use logger.set_pref instead');
    end if;

    :new.pref_name := upper(:new.pref_name);
    :new.pref_type := upper(:new.pref_type);

    if 1=1
      and :new.pref_type = logger.g_pref_type_logger
      and :new.pref_name = 'LEVEL' then
      :new.pref_value := upper(:new.pref_value);
    end if;

    -- #TODO:50 mdsouza: 3.1.1
    -- #TODO:100 mdsouza: if removing then decrease indent
    -- $if $$currently_installing is null or not $$currently_installing $then
      -- Since logger.pks may not be installed when this trigger is compiled, need to move some code here
      if 1=1
        and :new.pref_type = logger.g_pref_type_logger
        and :new.pref_name = 'LEVEL'
        and upper(:new.pref_value) not in (logger.g_off_name, logger.g_permanent_name, logger.g_error_name, logger.g_warning_name, logger.g_information_name, logger.g_debug_name, logger.g_timing_name, logger.g_sys_context_name, logger.g_apex_name) then
        raise_application_error(-20000, '"LEVEL" must be one of the following values: ' ||
          logger.g_off_name || ', ' || logger.g_permanent_name || ', ' || logger.g_error_name || ', ' ||
          logger.g_warning_name || ', ' || logger.g_information_name || ', ' || logger.g_debug_name || ', ' ||
          logger.g_timing_name || ', ' || logger.g_sys_context_name || ', ' || logger.g_apex_name);
      end if;

      -- Allow for null to be used for Plugins, then default to NONE
      if 1=1
        and :new.pref_type = logger.g_pref_type_logger
        and :new.pref_name like 'PLUGIN_FN%'
        and :new.pref_value is null then
        :new.pref_value := 'NONE';
      end if;

      -- #103
      -- Only predefined preferences and Custom Preferences are allowed
      -- Custom Preferences must be prefixed with CUST_
      if 1=1
        and :new.pref_type = logger.g_pref_type_logger
        and :new.pref_name not in (
          'GLOBAL_CONTEXT_NAME'
          ,'INCLUDE_CALL_STACK'
          ,'INSTALL_SCHEMA'
          ,'LEVEL'
          ,'LOGGER_DEBUG'
          ,'LOGGER_VERSION'
          ,'PLUGIN_FN_ERROR'
          ,'PREF_BY_CLIENT_ID_EXPIRE_HOURS'
          ,'PROTECT_ADMIN_PROCS'
          ,'PURGE_AFTER_DAYS'
          ,'PURGE_MIN_LEVEL'
        )
      then
        raise_application_error (-20000, 'Setting system level preferences are restricted to a set list.');
      end if;

      -- this is because the logger package is not installed yet.  We enable it in logger_configure
      logger.null_global_contexts;
    -- #TODO:60 mdsouza: 3.1.1
    -- $end
  $end -- $$logger_no_op_install
end;
/

alter trigger biu_logger_prefs disable;

declare
begin
  $if $$logger_no_op_install $then
    null;
  $else
    -- Configure Data
    merge into logger_prefs p
    using (
      select 'PURGE_AFTER_DAYS' pref_name, '7' pref_value from dual union
      select 'PURGE_MIN_LEVEL' pref_name, 'DEBUG' pref_value from dual union
      select 'LOGGER_VERSION' pref_name, 'x.x.x' pref_value from dual union -- x.x.x will be replaced when running the build script
      select 'LEVEL' pref_name, 'DEBUG' pref_value from dual union
      select 'PROTECT_ADMIN_PROCS' pref_name, 'FALSE' pref_value from dual union
      select 'INCLUDE_CALL_STACK' pref_name, 'TRUE' pref_value from dual union
      select 'PREF_BY_CLIENT_ID_EXPIRE_HOURS' pref_name, '12' pref_value from dual union
      select 'INSTALL_SCHEMA' pref_name, sys_context('USERENV','CURRENT_SCHEMA') pref_value from dual union
      -- #46
      select 'PLUGIN_FN_ERROR' pref_name, 'NONE' pref_value from dual union
      -- #64
      select 'LOGGER_DEBUG' pref_name, 'FALSE' pref_value from dual union
      -- #82: By default if we can't create a context we wont
      select 'GLOBAL_CONTEXT_NAME' pref_name, 'NONE' pref_value from dual
      ) d
      on (p.pref_name = d.pref_name)
    when matched then
      update set p.pref_value =
        case
          -- Only LOGGER_VERSION should be updated during an update
          when p.pref_name = 'LOGGER_VERSION' then d.pref_value
          else p.pref_value
        end
    when not matched then
      insert (p.pref_name,p.pref_value)
      values (d.pref_name,d.pref_value);
  $end
end;
/




-- #127: Add pref_type
declare
  type typ_tab_col is record (
    column_name varchar2(30),
    data_type varchar2(100));
  type typ_arr_tab_col is table of typ_tab_col index by pls_integer;

  l_count pls_integer;
  l_new_col typ_tab_col;
  l_new_cols typ_arr_tab_col;
begin

  l_new_col.column_name := 'PREF_TYPE';
  l_new_col.data_type := 'VARCHAR2(30)';
  l_new_cols(l_new_cols.count+1) := l_new_col;

  for i in 1 .. l_new_cols.count loop
    select count(1)
    into l_count
    from user_tab_columns
    where 1=1
      and upper(table_name) = upper('logger_prefs')
      and column_name = l_new_cols(i).column_name;

    if l_count = 0 then
      execute immediate 'alter table logger_prefs add (' || l_new_cols(i).column_name || ' ' || l_new_cols(i).data_type || ')';

      -- Custom post-add columns

      -- #127
      if lower(l_new_cols(i).column_name) = 'pref_type' then
        -- If "LOGGER" is changed then modify logger.pks g_logger_prefs_pref_type value
        execute immediate q'!update logger_prefs set pref_type = 'LOGGER'!';
        execute immediate q'!alter table logger_prefs modify pref_type not null!';
      end if;

    end if; -- l_count = 0
  end loop;

end;
/


-- #127 If old PK, then drop it
declare
  l_count pls_integer;
begin
  select count(*)
  into l_count
  from user_cons_columns
  where 1=1
    and constraint_name = 'LOGGER_PREFS_PK'
    and column_name != 'PREF_NAME';

  if l_count = 0 then
    -- PK only has one column, drop it and it will be rebuilt below
    execute immediate 'alter table logger_prefs drop constraint logger_prefs_pk';
  end if;

end;
/


-- Ensure that pref_name is upper
declare
  type typ_constraint is record(
    name user_constraints.constraint_name%type,
    condition varchar(500)
  );

  type typ_tab_constraint is table of typ_constraint index by pls_integer;

  l_constraint typ_constraint;
  l_constraints typ_tab_constraint;
  l_count pls_integer;
  l_sql varchar2(500);
begin
  l_constraint.name := 'LOGGER_PREFS_PK';
  l_constraint.condition := 'primary key (pref_type, pref_name)';
  l_constraints(l_constraints.count+1) := l_constraint;

  l_constraint.name := 'LOGGER_PREFS_CK1';
  l_constraint.condition := 'check (pref_name = upper(pref_name))';
  l_constraints(l_constraints.count+1) := l_constraint;

  l_constraint.name := 'LOGGER_PREFS_CK2';
  l_constraint.condition := 'check (pref_type = upper(pref_type))';
  l_constraints(l_constraints.count+1) := l_constraint;


  -- All pref names/types should be upper
  update logger_prefs
  set
    pref_name = upper(pref_name),
    pref_type = upper(pref_type)
  where 1=1
    or pref_name != upper(pref_name)
    or pref_type != upper(pref_type);

  for i in l_constraints.first .. l_constraints.last loop
    select count(1)
    into l_count
    from user_constraints
    where 1=1
      and table_name = 'LOGGER_PREFS'
      and constraint_name = l_constraints(i).name;

    if l_count = 0 then
      l_sql := 'alter table logger_prefs add constraint %CONSTRAINT_NAME% %CONSTRAINT_CONDITION%';
      l_sql := replace(l_sql, '%CONSTRAINT_NAME%', l_constraints(i).name);
      l_sql := replace(l_sql, '%CONSTRAINT_CONDITION%', l_constraints(i).condition);

      execute immediate l_sql;
    end if;
  end loop; -- l_constraints

end;
/

alter trigger biu_logger_prefs enable;


prompt logger_logs_apex_items

-- Initial table script built from 1.4.0
declare
  l_count pls_integer;
  l_nullable user_tab_columns.nullable%type;

  type typ_required_columns is table of varchar2(30) index by pls_integer;
  l_required_columns typ_required_columns;

begin

  -- Create Table
  select count(1)
  into l_count
  from user_tables
  where table_name = 'LOGGER_LOGS_APEX_ITEMS';

  if l_count = 0 then
    execute immediate '
create table logger_logs_apex_items(
    id				number not null,
    log_id          number not null,
    app_session     number not null,
    item_name       varchar2(1000) not null,
    item_value      clob,
    constraint logger_logs_apx_itms_pk primary key (id) enable,
    constraint logger_logs_apx_itms_fk foreign key (log_id) references logger_logs(id) ON DELETE CASCADE
)
    ';
  end if;


  $if $$logger_no_op_install $then
    null;
  $else
    -- INDEXES
    select count(1)
    into l_count
    from user_indexes
    where index_name = 'LOGGER_APEX_ITEMS_IDX1';

    if l_count = 0 then
      execute immediate 'create index logger_apex_items_idx1 on logger_logs_apex_items(log_id)';
    end if;
  $end -- $$logger_no_op_install
end;
/


create or replace trigger biu_logger_apex_items
  before insert or update on logger_logs_apex_items
for each row
begin
  $if $$logger_no_op_install $then
    null;
  $else
    :new.id := logger_apx_items_seq.nextval;
  $end
end;
/


prompt logger_prefs_by_client_id

declare
  l_count pls_integer;
  l_nullable user_tab_columns.nullable%type;

  type typ_required_columns is table of varchar2(30) index by pls_integer;
  l_required_columns typ_required_columns;

  l_sql varchar2(2000);

begin
  -- Create Table
  select count(1)
  into l_count
  from user_tables
  where table_name = 'LOGGER_PREFS_BY_CLIENT_ID';

  if l_count = 0 then
    execute immediate q'!
create table logger_prefs_by_client_id(
  client_id varchar2(64) not null,
  logger_level varchar2(20) not null,
  include_call_stack varchar2(5) not null,
  created_date date default sysdate not null,
  expiry_date date not null,
  constraint logger_prefs_by_client_id_pk primary key (client_id) enable,
  constraint logger_prefs_by_client_id_ck1 check (logger_level in ('OFF','PERMANENT','ERROR','WARNING','INFORMATION','DEBUG','TIMING')),
  constraint logger_prefs_by_client_id_ck2 check (expiry_date >= created_date),
  constraint logger_prefs_by_client_id_ck3 check (include_call_stack in ('TRUE', 'FALSE'))
)
    !';
  end if;

  -- COMMENTS
  execute immediate q'!comment on table logger_prefs_by_client_id is 'Client specific logger levels. Only active client_ids/logger_levels will be maintained in this table'!';
  execute immediate q'!comment on column logger_prefs_by_client_id.client_id is 'Client identifier'!';
  execute immediate q'!comment on column logger_prefs_by_client_id.logger_level is 'Logger level. Must be OFF, PERMANENT, ERROR, WARNING, INFORMATION, DEBUG, TIMING'!';
  execute immediate q'!comment on column logger_prefs_by_client_id.include_call_stack is 'Include call stack in logging'!';
  execute immediate q'!comment on column logger_prefs_by_client_id.created_date is 'Date that entry was created on'!';
  execute immediate q'!comment on column logger_prefs_by_client_id.expiry_date is 'After the given expiry date the logger_level will be disabled for the specific client_id. Unless sepcifically removed from this table a job will clean up old entries'!';


  -- 92: Missing APEX and SYS_CONTEXT support
  l_sql := 'alter table logger_prefs_by_client_id drop constraint logger_prefs_by_client_id_ck1';
  execute immediate l_sql;

  -- Rebuild constraint
  l_sql := q'!alter table logger_prefs_by_client_id
    add constraint logger_prefs_by_client_id_ck1
    check (logger_level in ('OFF','PERMANENT','ERROR','WARNING','INFORMATION','DEBUG','TIMING', 'APEX', 'SYS_CONTEXT'))!';
  execute immediate l_sql;

end;
/



prompt *** VIEWS ***



prompt logger_logs_5_min

create or replace force view logger_logs_5_min 
as
  select /*+ qb_name(logger_logs_5_min) */
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
    and ll.time_stamp > cast(systimestamp as timestamp) - (5/1440)
/

prompt logger_logs_60_min

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


prompt logger_logs_terse

set termout off
-- setting termout off as this view will install with an error as it depends on logger.date_text_format
create or replace force view logger_logs_terse as
  select 
    id,
    logger_level, 
    substr(logger.date_text_format(time_stamp),1,20) time_ago,
    substr(text,1,200) text
  from logger_logs
  where 1=1
    and time_stamp > systimestamp - (5/1440)
  order by id asc
/

set termout on


%%%LOGGER_PACAKGE_NOOP%5%



prompt *** PROCEDURES ***



prompt logger_configure

create or replace procedure logger_configure
is
  -- Note: The license is defined in the package specification of the logger package
	--
	l_rac_lt_11_2 varchar2(50) := 'FALSE';  -- is this a RAC instance less than 11.2, no GAC support

  l_apex varchar2(50) := 'FALSE';
  tbl_not_exist exception;
  pls_pkg_not_exist exception;

  l_text_data_length user_tab_columns.data_length%type;
  l_large_text_column varchar2(50);

  l_sql varchar2(32767);
  l_variables varchar2(1000);
  l_dummy number;
  l_flashback varchar2(50) := 'FALSE';
  l_utl_lms varchar2(5) := 'FALSE';

  pragma exception_init(tbl_not_exist, -942);
  pragma exception_init(pls_pkg_not_exist, -06550);

	l_version constant number  := dbms_db_version.version + (dbms_db_version.release / 10);
  l_pref_value logger_prefs.pref_Value%type;
  l_logger_debug boolean;

	l_pref_type_logger logger_prefs.pref_type%type;

  procedure add_variable(
    p_name in varchar2,
    p_value in varchar2
  )
  as
  begin
    if l_variables is not null then
      l_variables := l_variables || ',';
    end if;
    l_variables := l_variables || p_name || ':' || p_value;
  end add_variable;
begin

  -- Check to see if we are in a RAC Database, 11.1 or lower.
  --
  -- Tyler to check if this works
  if dbms_utility.is_cluster_database then
    l_rac_lt_11_2 := 'TRUE';
  else
    l_rac_lt_11_2 := 'FALSE';
  end if;

  if l_version >= 11.2 then
    l_rac_lt_11_2 := 'FALSE';
  end if;
  add_variable(p_name => 'RAC_LT_11_2', p_value => l_rac_lt_11_2);


  -- Check lenth of TEXT size (this is for future 12c 32767 integration
  -- In support of Issue #17 and future proofing for #30
  select data_length
  into l_text_data_length
  from user_tab_columns
  where 1=1
    and table_name = 'LOGGER_LOGS'
    and column_name = 'TEXT';

  if l_text_data_length > 4000 then
    l_large_text_column := 'TRUE';
  else
    l_large_text_column := 'FALSE';
  end if;
  add_variable(p_name => 'LARGE_TEXT_COLUMN', p_value => l_large_text_column);


  -- Is APEX installed ?
  --
  begin
    execute immediate 'select 1 from apex_application_items where rownum = 1' into l_dummy;

    l_apex := 'TRUE';
  exception
    when tbl_not_exist then
      l_apex := 'FALSE';
    when no_data_found then
      l_apex := 'TRUE';
  end;
  add_variable(p_name => 'APEX', p_value => l_apex);


  -- Can we call dbms_flashback to get the currect System Commit Number?
  --
  begin
    execute immediate 'begin :d := dbms_flashback.get_system_change_number; end; ' using out l_dummy;

    l_flashback := 'TRUE';
  exception when pls_pkg_not_exist then
    l_flashback := 'FALSE';
  end;
  add_variable(p_name => 'FLASHBACK_ENABLED', p_value => l_flashback);

  -- #64: Support to run Logger in debug mode
	-- #127
	-- Since this procedure will recompile Logger, if it directly references a variable in Logger
	-- It will lock itself while trying to recompile
	-- Work around is to pre-store the variable using execute immediate
	execute immediate 'begin :x := logger.g_pref_type_logger; end;' using out l_pref_type_logger;

  select lp.pref_value
  into l_pref_value
  from logger_prefs lp
  where 1=1
		and lp.pref_type = upper(l_pref_type_logger)
    and lp.pref_name = 'LOGGER_DEBUG';
  add_variable(p_name => 'LOGGER_DEBUG', p_value => l_pref_value);

  l_logger_debug := false;
  if upper(l_pref_value) = 'TRUE' then
    l_logger_debug := true;
  end if;

  -- TODO mdsouza: delete
  l_logger_debug := true;
  
  -- #46
  -- Handle plugin settings
  -- Set for each plugin type
  for x in (
    select
      'LOGGER_' ||
        regexp_replace(lp.pref_name, '^PLUGIN_FN_', 'PLUGIN_') name,
      decode(nvl(upper(lp.pref_value), 'NONE'), 'NONE', 'FALSE', 'TRUE') value
    from logger_prefs lp
    where 1=1
			and lp.pref_type = l_pref_type_logger
      and lp.pref_name like 'PLUGIN_FN%'
  ) loop
    add_variable(p_name => x.name, p_value => x.value);
  end loop;

  -- #82: Determine if we have a context set
  select decode(lp.pref_value, 'NONE', 'FALSE', 'TRUE')
  into l_pref_value
  from logger_prefs lp
  where 1=1
		and lp.pref_type = upper(l_pref_type_logger)
    and lp.pref_name = 'GLOBAL_CONTEXT_NAME';
  add_variable(p_name => 'LOGGER_CONTEXT', p_value => l_pref_value);


  if l_logger_debug then
    dbms_output.put_line('l_variables: ' || l_variables);
  end if;


	-- Recompile Logger
  -- #82: Need to recompile spec and body
 	l_sql := q'!alter package logger compile PLSQL_CCFLAGS='%VARIABLES%' reuse settings!';
 	l_sql := q'!alter package logger compile body PLSQL_CCFLAGS='%VARIABLES%' reuse settings!';
	l_sql := replace(l_sql, '%VARIABLES%', l_variables);
	execute immediate l_sql;

  -- #31: Dropped trigger
	-- l_sql := q'[alter trigger BI_LOGGER_LOGS compile PLSQL_CCFLAGS=']'||l_variables||q'[' reuse settings]';
	-- execute immediate l_sql;

  -- -- TODO mdsouza: 3.1.1 org l_sql := q'!alter trigger biu_logger_prefs compile PLSQL_CCFLAGS='CURRENTLY_INSTALLING:FALSE'!';
  l_sql := q'!alter trigger biu_logger_prefs compile!';
  execute immediate l_sql;

  -- just in case this is a re-install / upgrade, the global contexts will persist so reset them
  logger.null_global_contexts;

end logger_configure;
/



prompt *** POSTINSTALL ***



prompt post_install_configuration

-- Post installation configuration tasks
PROMPT Calling logger_configure
begin
  logger_configure;
end;
/


-- Only set level if not in DEBUG mode
PROMPT Setting Logger Level
declare
  l_current_level logger_prefs.pref_value%type;
begin

  select pref_value
  into l_current_level
  from logger_prefs
  where 1=1
    and pref_type = logger.g_pref_type_logger
    and pref_name = 'LEVEL';

  -- Note: Probably not necessary but pre 1.4.0 code had this in place
  logger.set_level(l_current_level);
end;
/

prompt
prompt *************************************************
prompt Now executing LOGGER.STATUS...
prompt

begin
	logger.status;
end;
/

prompt *************************************************
begin
	logger.log_permanent('Logger version '||logger.get_pref('LOGGER_VERSION')||' installed.');
end;
/


prompt Recompile logger_logs_terse since it depends on logger 

alter view logger_logs_terse compile;


declare
	-- the following line is also used in a constant declaration in logger.pkb
	-- l_ctx_name varchar2(35) := substr(sys_context('USERENV','CURRENT_SCHEMA'),1,23)||'_LOGCTX';
	l_sql varchar2(500);
	l_count pls_integer;
begin
	-- #82: determine if you can create any context first
	select count(1)
	into l_count
	from session_privs sp
	where 1=1
		and sp.privilege = 'CREATE ANY CONTEXT';
	
	if l_count = 0 then
		dbms_output.put_line('Do not have access to create context; skipping');
	else

		l_sql := 'create or replace context %s1 using logger accessed globally';
		execute immediate logger.sprintf(l_sql, logger.g_context_name);

		-- #184: hack to allow for setting GLOBAL_CONTEXT_NAME
		logger.g_can_update_logger_prefs := true;
		merge into logger_prefs p
		using (select 'GLOBAL_CONTEXT_NAME' pref_name, logger.g_context_name pref_value, logger.g_pref_type_logger pref_type from dual) d
			on (1=1
				and p.pref_type = d.pref_type
				and p.pref_name = d.pref_name)
		when matched then
			update set p.pref_value = d.pref_value
		when not matched then
			insert (p.pref_name, p.pref_value, p.pref_type)
			values (d.pref_name, d.pref_value, d.pref_type);
		logger.g_can_update_logger_prefs := false;
	end if;
end;
/

create or replace package logger
  authid definer
as
  -- This project uses the following MIT License:
  --
  -- The MIT License (MIT)
  --
  -- Copyright (c) 2015 OraOpenSource
  --
  -- Permission is hereby granted, free of charge, to any person obtaining a copy
  -- of this software and associated documentation files (the "Software"), to deal
  -- in the Software without restriction, including without limitation the rights
  -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  -- copies of the Software, and to permit persons to whom the Software is
  -- furnished to do so, subject to the following conditions:
  --
  -- The above copyright notice and this permission notice shall be included in all
  -- copies or substantial portions of the Software.
  --
  -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  -- SOFTWARE.

  -- TYPES
  /**
  * @type rec_param `name`/`val` pair
  * @type tab_param Array of `rec_param`
  * @type rec_logger_log See [Logger Plugins](TODO LinkPlugins.md)
  */
  type rec_param is record(
    name varchar2(255),
    val varchar2(32767));

  type tab_param is table of rec_param index by binary_integer;

  type rec_logger_log is record(
    id logger_logs.id%type,
    logger_level logger_logs.logger_level%type
  );


  -- CONSTANTS
  -- TODO see the old API docs for breakdown of constants
  /**
  * @constant g_logger_version Version of Logger as a string (`major.minor.patch`)
  * @constant g_logger_version_major Version (major) as number. Can be used for conditional compilation
  * @constant g_logger_version_minor Version (minor) as number. Can be used for conditional compilation
  * @constant g_logger_version_patch Version (patch) as number. Can be used for conditional compilation
  * @constant g_context_name Context Logger uses for storing attributes.
  *
  * @constant g_off Logger level `off`
  * @constant g_permanent Logger level `permanent`
  * @constant g_error Logger level `error`
  * @constant g_warning Logger level `warning`
  * @constant g_information Logger level `information`
  * @constant g_debug Logger level `debug`
  * @constant g_timing Logger level `timing`
  * @constant g_sys_context Logger level `sys_context`
  * @constant g_apex Logger level `apex`
  *
  * @constant g_off_name Logger level `off` (name)
  * @constant g_permanent_name Logger level `permanent` (name)
  * @constant g_error_name Logger level `error` (name)
  * @constant g_warning_name Logger level `warning` (name)
  * @constant g_information_name Logger level `information` (name)
  * @constant g_debug_name Logger level `debug` (name)
  * @constant g_timing_name Logger level `timing` (name)
  * @constant g_sys_context_name Logger level `sys_context` (name)
  * @constant g_apex_name Logger level `apex` (name)
  *
  * @constant gc_empty_tab_param Empty param used for default value in logger main procedures.
  *
  * @constant g_apex_item_type_all `log_apex_items` takes in an optional variable `p_item_scope`. This determines which items to log in APEX. Log both application and page level items
  * @constant g_apex_item_type_app Only application level items
  * @constant g_apex_item_type_page Only page level items
  */
  -- Don't change any version numbers as build script will replace with right version number
  -- #129 Don't mondify ANYTHING for the version information below as it's expect to be exactly as is
	g_logger_version constant varchar2(10) := 'x.x.x'; 
  g_logger_version_major constant pls_integer := 0;
  g_logger_version_minor constant pls_integer := 0;
  g_logger_version_patch constant pls_integer := 0;

	g_context_name constant varchar2(35) := substr(sys_context('USERENV','CURRENT_SCHEMA'),1,23)||'_LOGCTX';

  g_off constant number := 0;
  g_permanent constant number := 1;
	g_error constant number := 2;
	g_warning constant number := 4;
	g_information constant number := 8;
  g_debug constant number := 16;
	g_timing constant number := 32;
  g_sys_context constant number := 64;
  g_apex constant number := 128;

  -- #44
  g_off_name constant varchar2(30) := 'OFF';
  g_permanent_name constant varchar2(30) := 'PERMANENT';
  g_error_name constant varchar2(30) := 'ERROR';
  g_warning_name constant varchar2(30) := 'WARNING';
  g_information_name constant varchar2(30) := 'INFORMATION';
  g_debug_name constant varchar2(30) := 'DEBUG';
  g_timing_name constant varchar2(30) := 'TIMING';
  g_sys_context_name constant varchar2(30) := 'SYS_CONTEXT';
  g_apex_name constant varchar2(30) := 'APEX';

  gc_empty_tab_param tab_param;

  -- #54: Types for log_apex_items
  g_apex_item_type_all constant varchar2(30) := 'ALL'; -- Application items and page items
  g_apex_item_type_app constant varchar2(30) := 'APP'; -- All application items
  g_apex_item_type_page constant varchar2(30) := 'PAGE'; -- All page items
  -- To log items on a particular page, just enter the page number

  -- #127
  -- Note to developers: This is only for internal Logger code. Do not use this as part of your code.
  g_pref_type_logger constant logger_prefs.pref_type%type := 'LOGGER'; -- If this changes need to modify logger_prefs.sql as it has a dependancy.


  -- #184 Determines if setting logger_prefs from Logger rather than a SQL statement
  -- This is NOT a documented variable and should not be used by other applications
  -- Storing in pks as no use protecting it internally since anyone can disable the trigger if they want
  -- This is not fool proof but should help encourage people not to set logger_prefs via SQL
  g_can_update_logger_prefs boolean := false;

  -- Expose private functions only for testing during development
  $if $$logger_debug $then
    function is_number(p_str in varchar2)
      return boolean;

    procedure assert(
      p_condition in boolean,
      p_message in varchar2);

    function get_param_clob(p_params in logger.tab_param)
      return clob;

    procedure save_global_context(
      p_attribute in varchar2,
      p_value in varchar2,
      p_client_id in varchar2 default null);

    function set_extra_with_params(
      p_extra in logger_logs.extra%type,
      p_params in tab_param)
      return logger_logs.extra%type;

    function get_sys_context(
      p_detail_level in varchar2 default 'USER', -- ALL, NLS, USER, INSTANCE
      p_vertical in boolean default false,
      p_show_null in boolean default false)
      return clob;

    function admin_security_check
      return boolean;

    function get_level_number
      return number
      $if $$rac_lt_11_2 or not $$logger_context $then  -- TODO mdsouza: I think we can remove this as all we care about is db_version
        $if not dbms_db_version.ver_le_10_2 $then
          result_cache
        $end
      $end
    ;

    function include_call_stack
      return boolean
      $if 1=1
        and ($$rac_lt_11_2 or not $$logger_context)
        and not dbms_db_version.ver_le_10_2
        and ($$no_op is null or not $$no_op) $then
          result_cache
      $end
      ;

    function date_text_format_base (
      p_date_start in date,
      p_date_stop  in date)
      return varchar2;

    procedure log_internal(
      p_text in varchar2,
      p_log_level in number,
      p_scope in varchar2,
      p_extra in clob default null,
      p_callstack in varchar2 default null,
      p_params in tab_param default logger.gc_empty_tab_param);
  $end

  -- PROCEDURES and FUNCTIONS

  procedure null_global_contexts;

  function convert_level_char_to_num(
    p_level in varchar2)
    return number;

  function convert_level_num_to_char(
    p_level in number)
    return varchar2;

  function date_text_format (p_date in date)
    return varchar2;

	function get_character_codes(
		p_string 				in varchar2,
		p_show_common_codes 	in boolean default true)
    return varchar2;

  procedure log_error(
    p_text          in varchar2 default null,
    p_scope         in varchar2 default null,
    p_extra         in clob default null,
    p_params        in tab_param default logger.gc_empty_tab_param);

  procedure log_permanent(
    p_text    in varchar2,
    p_scope   in varchar2 default null,
    p_extra   in clob default null,
    p_params  in tab_param default logger.gc_empty_tab_param);

  procedure log_warning(
    p_text    in varchar2,
    p_scope   in varchar2 default null,
    p_extra   in clob default null,
    p_params  in tab_param default logger.gc_empty_tab_param);

  procedure log_warn(
    p_text in varchar2,
    p_scope in varchar2 default null,
    p_extra in clob default null,
    p_params in tab_param default logger.gc_empty_tab_param);

  procedure log_information(
    p_text    in varchar2,
    p_scope   in varchar2 default null,
    p_extra   in clob default null,
    p_params  in tab_param default logger.gc_empty_tab_param);

  procedure log_info(
    p_text in varchar2,
    p_scope in varchar2 default null,
    p_extra in clob default null,
    p_params in tab_param default logger.gc_empty_tab_param);

  procedure log(
    p_text    in varchar2,
    p_scope   in varchar2 default null,
    p_extra   in clob default null,
    p_params  in tab_param default logger.gc_empty_tab_param);

  function get_cgi_env(
    p_show_null		in boolean default false)
  	return clob;

  procedure log_userenv(
    p_detail_level in varchar2 default 'USER',-- ALL, NLS, USER, INSTANCE,
    p_show_null in boolean default false,
    p_scope in logger_logs.scope%type default null,
    p_level in logger_logs.logger_level%type default null);

  procedure log_cgi_env(
    p_show_null in boolean default false,
    p_scope in logger_logs.scope%type default null,
    p_level in logger_logs.logger_level%type default null);

  procedure log_character_codes(
    p_text in varchar2,
    p_scope in logger_logs.scope%type default null,
    p_show_common_codes in boolean default true,
    p_level in logger_logs.logger_level%type default null);

  procedure log_apex_items(
    p_text in varchar2 default 'Logged APEX Items: select * from logger_logs_apex_items where log_id = %s1',
    p_scope in logger_logs.scope%type default null,
    p_item_type in varchar2 default logger.g_apex_item_type_all,
    p_log_null_items in boolean default true,
    p_level in logger_logs.logger_level%type default null);

	procedure time_start(
		p_unit in varchar2,
    p_log_in_table in boolean default true);

	procedure time_stop(
		p_unit in varchar2,
    p_scope in varchar2 default null);

  function time_stop(
    p_unit in varchar2,
    p_scope in varchar2 default null,
    p_log_in_table in boolean default true)
    return varchar2;

  function time_stop_seconds(
    p_unit in varchar2,
    p_scope in varchar2 default null,
    p_log_in_table in boolean default true)
    return number;

  procedure time_reset;

  function get_pref(
    p_pref_name in logger_prefs.pref_name%type,
    p_pref_type in logger_prefs.pref_type%type default logger.g_pref_type_logger)
    return varchar2
    $if not dbms_db_version.ver_le_10_2  $then
      result_cache
    $end;

  -- #103
  procedure set_pref(
    p_pref_type in logger_prefs.pref_type%type,
    p_pref_name in logger_prefs.pref_name%type,
    p_pref_value in logger_prefs.pref_value%type);

  -- #103
  procedure del_pref(
    p_pref_type in logger_prefs.pref_type%type,
    p_pref_name in logger_prefs.pref_name%type);

	procedure purge(
		p_purge_after_days in varchar2 default null,
		p_purge_min_level	in varchar2	default null);

  procedure purge(
    p_purge_after_days in number default null,
    p_purge_min_level in number);

	procedure purge_all;

	procedure status(
		p_output_format	in varchar2 default null); -- SQL-DEVELOPER | HTML | DBMS_OUPUT

  procedure sqlplus_format;

  procedure set_level(
    p_level in varchar2 default logger.g_debug_name,
    p_client_id in varchar2 default null,
    p_include_call_stack in varchar2 default null,
    p_client_id_expire_hours in number default null
  );

  procedure unset_client_level(p_client_id in varchar2);

  procedure unset_client_level;

  procedure unset_client_level_all;


  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in varchar2);

  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in number);

  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in date);

  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in timestamp);

  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in timestamp with time zone);

  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in timestamp with local time zone);

  procedure append_param(
    p_params in out nocopy logger.tab_param,
    p_name in varchar2,
    p_val in boolean);

  function ok_to_log(p_level in number)
    return boolean
    -- TODO mdsouza: having issue with overloading and result cache in pks
    -- $if 1=1
    --   and ($$rac_lt_11_2 or not $$logger_context)
    --   and not dbms_db_version.ver_le_10_2
    --   and ($$no_op is null or not $$no_op) $then
    --     result_cache
    -- $end
    ;

  function ok_to_log(p_level in varchar2)
    return boolean;

  function tochar(
    p_val in number)
    return varchar2;

  function tochar(
    p_val in date)
    return varchar2;

  function tochar(
    p_val in timestamp)
    return varchar2;

  function tochar(
    p_val in timestamp with time zone)
    return varchar2;

  function tochar(
    p_val in timestamp with local time zone)
    return varchar2;

  function tochar(
    p_val in boolean)
    return varchar2;

  procedure ins_logger_logs(
    p_logger_level in logger_logs.logger_level%type,
    p_text in varchar2 default null, -- Not using type since want to be able to pass in 32767 characters
    p_scope in logger_logs.scope%type default null,
    p_call_stack in logger_logs.call_stack%type default null,
    p_unit_name in logger_logs.unit_name%type default null,
    p_line_no in logger_logs.line_no%type default null,
    p_extra in logger_logs.extra%type default null,
    po_id out nocopy logger_logs.id%type
  );


  function sprintf(
    p_str in varchar2,
    p_s1 in varchar2 default null,
    p_s2 in varchar2 default null,
    p_s3 in varchar2 default null,
    p_s4 in varchar2 default null,
    p_s5 in varchar2 default null,
    p_s6 in varchar2 default null,
    p_s7 in varchar2 default null,
    p_s8 in varchar2 default null,
    p_s9 in varchar2 default null,
    p_s10 in varchar2 default null)
    return varchar2;

  function get_plugin_rec(
    p_logger_level in logger_logs.logger_level%type)
    return logger.rec_logger_log;
end logger;
/

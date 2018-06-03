# LOGGER


- [Data Types](#types)

- [Constants](#constants)



 
- [LOG Procedure](#log)
 
- [LOG_INFORMATION Procedure](#log_information)
 
- [LOG_INFO Procedure](#log_info)
 
- [LOG_WARNING Procedure](#log_warning)
 
- [LOG_WARN Procedure](#log_warn)
 
- [LOG_ERROR Procedure](#log_error)
 
- [LOG_PERMANENT Procedure](#log_permanent)
 
- [LOG_USERENV Procedure](#log_userenv)
 
- [LOG_CGI_ENV Procedure](#log_cgi_env)
 
- [LOG_CHARACTER_CODES Procedure](#log_character_codes)
 
- [LOG_APEX_ITEMS Procedure](#log_apex_items)
 
- [TOCHAR Function](#tochar)
 
- [TOCHAR-1 Function](#tochar-1)
 
- [TOCHAR-2 Function](#tochar-2)
 
- [TOCHAR-3 Function](#tochar-3)
 
- [TOCHAR-4 Function](#tochar-4)
 
- [TOCHAR-5 Function](#tochar-5)
 
- [SPRINTF Function](#sprintf)
 
- [GET_CGI_ENV Function](#get_cgi_env)
 
- [GET_PREF Function](#get_pref)
 
- [SET_PREF Procedure](#set_pref)
 
- [DEL_PREF Procedure](#del_pref)
 
- [PURGE Procedure](#purge)
 
- [PURGE-1 Procedure](#purge-1)
 
- [PURGE_ALL Procedure](#purge_all)
 
- [STATUS Procedure](#status)
 
- [CONVERT_LEVEL_CHAR_TO_NUM Function](#convert_level_char_to_num)
 
- [DATE_TEXT_FORMAT Function](#date_text_format)
 
- [GET_CHARACTER_CODES Function](#get_character_codes)
 
- [APPEND_PARAM Procedure](#append_param)
 
- [APPEND_PARAM-1 Procedure](#append_param-1)
 
- [APPEND_PARAM-2 Procedure](#append_param-2)
 
- [APPEND_PARAM-3 Procedure](#append_param-3)
 
- [APPEND_PARAM-4 Procedure](#append_param-4)
 
- [APPEND_PARAM-5 Procedure](#append_param-5)
 
- [APPEND_PARAM-6 Procedure](#append_param-6)
 
- [OK_TO_LOG Function](#ok_to_log)
 
- [OK_TO_LOG-1 Function](#ok_to_log-1)
 
- [INS_LOGGER_LOGS Procedure](#ins_logger_logs)
 
- [SET_LEVEL Procedure](#set_level)
 
- [UNSET_CLIENT_LEVEL Procedure](#unset_client_level)
 
- [UNSET_CLIENT_LEVEL-1 Procedure](#unset_client_level-1)
 
- [UNSET_CLIENT_LEVEL_ALL Procedure](#unset_client_level_all)
 
- [TIME_START Procedure](#time_start)
 
- [TIME_STOP Procedure](#time_stop)
 
- [TIME_STOP-1 Function](#time_stop-1)
 
- [TIME_STOP_SECONDS Function](#time_stop_seconds)
 
- [TIME_RESET Procedure](#time_reset)
 
- [CONVERT_LEVEL_NUM_TO_CHAR Function](#convert_level_num_to_char)

## Types<a name="types"></a>

Name | Code | Description
--- | --- | ---
rec_param | <pre>type rec_param is record(<br />  name varchar2(255),<br />  val varchar2(32767));</pre> | `name`/`val` pair
tab_param | <pre>type tab_param is table of rec_param index by binary_integer;</pre> | Array of `rec_param`
rec_logger_log | <pre>type rec_logger_log is record(<br />  id logger_logs.id%type,<br />  logger_level logger_logs.logger_level%type<br />);</pre> | See [Logger Plugins](TODO LinkPlugins.md)



## Constants<a name="constants"></a>

Name | Code | Description
--- | --- | ---
g_logger_version | <pre>	g_logger_version constant varchar2(10) := 'x.x.x';</pre> | Version of Logger as a string (&#x60;major.minor.patch&#x60;)
g_logger_version_major | <pre> <br />g_logger_version_major constant pls_integer := 0;</pre> | Version (major) as number. Can be used for conditional compilation
g_logger_version_minor | <pre>g_logger_version_minor constant pls_integer := 0;</pre> | Version (minor) as number. Can be used for conditional compilation
g_logger_version_patch | <pre>g_logger_version_patch constant pls_integer := 0;</pre> | Version (patch) as number. Can be used for conditional compilation
g_context_name | <pre>	g_context_name constant varchar2(35) := substr(sys_context('USERENV','CURRENT_SCHEMA'),1,23)||'_LOGCTX';</pre> | Context Logger uses for storing attributes.
g_off | <pre>g_off constant number := 0;</pre> | Logger level &#x60;off&#x60;
g_permanent | <pre>g_permanent constant number := 1;</pre> | Logger level &#x60;permanent&#x60;
g_error | <pre>	g_error constant number := 2;</pre> | Logger level &#x60;error&#x60;
g_warning | <pre>	g_warning constant number := 4;</pre> | Logger level &#x60;warning&#x60;
g_information | <pre>	g_information constant number := 8;</pre> | Logger level &#x60;information&#x60;
g_debug | <pre>g_debug constant number := 16;</pre> | Logger level &#x60;debug&#x60;
g_timing | <pre>	g_timing constant number := 32;</pre> | Logger level &#x60;timing&#x60;
g_sys_context | <pre>g_sys_context constant number := 64;</pre> | Logger level &#x60;sys_context&#x60;
g_apex | <pre>g_apex constant number := 128;</pre> | Logger level &#x60;apex&#x60;
g_off_name | <pre>g_off_name constant varchar2(30) := 'OFF';</pre> | Logger level &#x60;off&#x60; (name)
g_permanent_name | <pre>g_permanent_name constant varchar2(30) := 'PERMANENT';</pre> | Logger level &#x60;permanent&#x60; (name)
g_error_name | <pre>g_error_name constant varchar2(30) := 'ERROR';</pre> | Logger level &#x60;error&#x60; (name)
g_warning_name | <pre>g_warning_name constant varchar2(30) := 'WARNING';</pre> | Logger level &#x60;warning&#x60; (name)
g_information_name | <pre>g_information_name constant varchar2(30) := 'INFORMATION';</pre> | Logger level &#x60;information&#x60; (name)
g_debug_name | <pre>g_debug_name constant varchar2(30) := 'DEBUG';</pre> | Logger level &#x60;debug&#x60; (name)
g_timing_name | <pre>g_timing_name constant varchar2(30) := 'TIMING';</pre> | Logger level &#x60;timing&#x60; (name)
g_sys_context_name | <pre>g_sys_context_name constant varchar2(30) := 'SYS_CONTEXT';</pre> | Logger level &#x60;sys_context&#x60; (name)
g_apex_name | <pre>g_apex_name constant varchar2(30) := 'APEX';</pre> | Logger level &#x60;apex&#x60; (name)
g_apex_item_type_all | <pre>g_apex_item_type_all constant varchar2(30) := 'ALL';</pre> | &#x60;log_apex_items&#x60; takes in an optional variable &#x60;p_item_scope&#x60;. This determines which items to log in APEX. Log both application and page level items






 
## LOG Procedure<a name="log"></a>


<p>
<p>Since the main Logger procedures all have the same syntax and behavior (except for the procedure names) the documentation has been combined to avoid replication.</p>
</p>

### Syntax
```plsql
procedure log(
  p_text in varchar2,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | Maps to the <code>text</code> column in <code>logger_logs</code>. It can handle up to 32767 characters. If <code>p_text</code> exceeds 4000 characters its content will be appended to the <code>extra</code> column. If you need to store large blocks of text (i.e. clobs) use the <code>p_extra</code> (<code>clob</code>) parameter.
`p_scope` | Optional but highly recommend. The idea behind <code>scope</code> is to give some context to the log message, such as the application, <code>package.procedure</code> where it was called from. Logger captures the call stack, as well as module and action which are great for APEX logging as they are app number / page number. However none of these options gives you a clean and consistent way to group messages. The <code>p_scope</code> parameter performs a <code>lower()</code> on the input and stores it in the <code>scope</code> column. It is recommended to use <code>package.procedure</code> in most cases.
`p_extra` | Use for logging large (over 4000 characters or <code>clob</code>s) blocks of text.
`p_params` | Stores the parameters object. The goal of this parameter is to allow for a simple and consistent method to log the parameters to a given function. The values are explicitly converted to a string so there is no need to convert them when appending a parameter.  </br></br>The data from the parameters array will be appended to the <code>extra</code> column.<br /> </br>Since most production instances set the logging level to error, it is highly recommended that you leverage this 4th parameter when calling logger.log_error so that developers know the input that triggered the error.
 
 


### Example
```plsql

-- The following code snippet highlights the main Logger procedures. Since they all have the same parameters, this will serve as the general example for all the main Logger procedures.
begin
  logger.log('This is a debug message. (level = DEBUG)');
  logger.log_information('This is an informational message. (level = INFORMATION)');
  logger.log_warning('This is a warning message. (level = WARNING)');
  logger.log_error('This is an error message (level = ERROR)');
  logger.log_permanent('This is a permanent message, good for upgrades and milestones. (level = PERMANENT)');
end;
/

select id, logger_level, text
from logger_logs_5_min
order by id;

  ID LOGGER_LEVEL TEXT
---- ------------ ------------------------------------------------------------------------------------------
  10	       16 This is a debug message. (level = DEBUG)
  11		8 This is an informational message. (level = INFORMATION)
  12	4 This is a warning message. (level = WARNING)
  13		2 This is an error message (level = ERROR)
  14		1 This is a permanent message, good for upgrades and milestones. (level = PERMANENT)


-- The following example shows how to use the p_params parameter. 
-- The parameter values are stored in the EXTRA column.

create or replace procedure p_demo_procedure(
  p_empno in emp.empno%type,
  p_ename in emp.ename%type)
as
  l_scope logger_logs.scope%type := 'p_demo_function';
  l_params logger.tab_param;
begin
  logger.append_param(l_params, 'p_empno', p_empno); -- Parameter name and value just stored in PL/SQL array and not logged yet
  logger.append_param(l_params, 'p_ename', p_ename); -- Parameter name and value just stored in PL/SQL array and not logged yet
  logger.log('START', l_scope, null, l_params); -- All parameters are logged at this point
  -- ...
exception
  when others then
    logger.log_error('Unhandled Exception', l_scope, null, l_params);
end p_demo_procedure;
/
```



 
## LOG_INFORMATION Procedure<a name="log_information"></a>


<p>
<p>See <a href="#log"><code>logger.log</code></a> documentation</p>
</p>

### Syntax
```plsql
procedure log_information(
  p_text in varchar2,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | 
`p_scope` | 
`p_extra` | 
`p_params` | 
 
 





 
## LOG_INFO Procedure<a name="log_info"></a>


<p>
<p>Shortcut to <a href="#log_information"><code>log_information</code></a></p>
</p>

### Syntax
```plsql
procedure log_info(
  p_text in varchar2,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | 
`p_scope` | 
`p_extra` | 
`p_params` | 
 
 





 
## LOG_WARNING Procedure<a name="log_warning"></a>


<p>
<p>See <a href="#log"><code>logger.log</code></a> documentation</p>
</p>

### Syntax
```plsql
procedure log_warning(
  p_text in varchar2,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | 
`p_scope` | 
`p_extra` | 
`p_params` | 
 
 





 
## LOG_WARN Procedure<a name="log_warn"></a>


<p>
<p>Shortcut to <a href="#log_warning"><code>log_warning</code></a></p>
</p>

### Syntax
```plsql
procedure log_warn(
  p_text in varchar2,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | 
`p_scope` | 
`p_extra` | 
`p_params` | 
 
 





 
## LOG_ERROR Procedure<a name="log_error"></a>


<p>
<p>See <a href="#log"><code>logger.log</code></a> documentation</p>
</p>

### Syntax
```plsql
procedure log_error(
  p_text in varchar2 default null,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | 
`p_scope` | 
`p_extra` | 
`p_params` | 
 
 





 
## LOG_PERMANENT Procedure<a name="log_permanent"></a>


<p>
<p>See <a href="#log"><code>logger.log</code></a> documentation</p>
</p>

### Syntax
```plsql
procedure log_permanent(
  p_text in varchar2,
  p_scope in varchar2 default null,
  p_extra in clob default null,
  p_params in tab_param default logger.gc_empty_tab_param)
```

### Parameters
Name | Description
--- | ---
`p_text` | 
`p_scope` | 
`p_extra` | 
`p_params` | 
 
 





 
## LOG_USERENV Procedure<a name="log_userenv"></a>


<p>
<p>Logs system environment variables</p><p>There are many occasions when the value of one of the <code>userenv</code> session variables helps to debug a problem.<br /><code>logger.log_userenv</code>  will log <code>userenv</code> session variables variables and their values in the <code>extra</code> column.</p><p>Note: <code>log_userenv</code> will be logged using the <code>g_sys_context</code> (i.e. the current logger level).</p>
</p>

### Syntax
```plsql
procedure log_userenv(
  p_detail_level in varchar2 default 'USER',-- ALL, NLS, USER, INSTANCE,
  p_show_null in boolean default false,
  p_scope in logger_logs.scope%type default null,
  p_level in logger_logs.logger_level%type default null)
```

### Parameters
Name | Description
--- | ---
`p_detail_level` | Level of <code>user_env</code> variables to log. Values: <code>USER</code>, <code>ALL</code>, <code>NLS</code>, <code>INSTANCE</code>
`p_show_null` | If <code>true</code>, then variables that have no value will still be displayed.
`p_scope` | <code>scope</code> to use when logging values.
`p_level` | Highest level to run at (default <code>logger.g_debug</code>).  Example: If set to <code>logger.g_error</code> it will work when both in <code>debug</code> and <code>error</code> modes. However if set to <code>logger.g_debug</code>(default) will not store values when <code>level</code> is set to <code>error</code>.
 
 


### Example
```plsql

exec logger.log_userenv('NLS');

select text,extra from logger_logs_5_min;

TEXT                                           EXTRA
---------------------------------------------- -----------------------------------------------------------------
USERENV values stored in the EXTRA column      NLS_CALENDAR                  : GREGORIAN
                                               NLS_CURRENCY                  : $
                                               NLS_DATE_FORMAT               : DD-MON-RR
                                               NLS_DATE_LANGUAGE             : AMERICAN
                                               NLS_SORT                      : BINARY
                                               NLS_TERRITORY                 : AMERICA
                                               LANG                          : US
                                               LANGUAGE                      : AMERICAN_AMERICA.WE8MSWIN1252
exec logger.log_userenv('USER');

select text,extra from logger_logs_5_min;
TEXT                                               EXTRA
-------------------------------------------------- -------------------------------------------------------
USERENV values stored in the EXTRA column          CURRENT_SCHEMA                : LOGGER
                                                   SESSION_USER                  : LOGGER
                                                   OS_USER                       : tmuth
                                                   IP_ADDRESS                    : 192.168.1.7
                                                   HOST                          : WORKGROUP\TMUTH-LAP
                                                   TERMINAL                      : TMUTH-LAP
                                                   AUTHENTICATED_IDENTITY        : logger
                                                   AUTHENTICATION_METHOD         : PASSWORD
```



 
## LOG_CGI_ENV Procedure<a name="log_cgi_env"></a>


<p>
<p>Logs CGI environment variables<br />Note: This option only works within a web session</p>
</p>

### Syntax
```plsql
procedure log_cgi_env(
  p_show_null in boolean default false,
  p_scope in logger_logs.scope%type default null,
  p_level in logger_logs.logger_level%type default null)
```

### Parameters
Name | Description
--- | ---
`p_show_null` | If <code>true</code>, then variables that have no value will still be displayed.
`p_scope` | <code>scope</code> to log CGI variables under.
`p_level` | Highest level to run at (default <code>logger.g_debug</code>).  Example: If set to <code>logger.g_error</code> it will work when both in <code>debug</code> and <code>error</code> modes. However if set to <code>logger.g_debug</code>(default) will not store values when <code>level</code> is set to <code>error</code>.
 
 


### Example
```plsql

exec logger.log_cgi_env;

select extra from logger_logs where text like '%CGI%';
TEXT                                               EXTRA
-------------------------------------------------- -------------------------------------------------------
 ...
SERVER_SOFTWARE               : Oracle-Application-Server-10g/10.1.3.1.0 Oracle-HTTP-Server
GATEWAY_INTERFACE             : CGI/1.1
SERVER_PORT                   : 80
SERVER_NAME                   : 11g
REQUEST_METHOD                : POST
PATH_INFO                     : /wwv_flow.show
SCRIPT_NAME                   : /pls/apex
REMOTE_ADDR                   : 192.168.1.7
...
```



 
## LOG_CHARACTER_CODES Procedure<a name="log_character_codes"></a>


<p>
<p>Logs character codes for given string. See <a href="#get_character_codes"><code>get_character_codes</code></a> for detailed information</p>
</p>

### Syntax
```plsql
procedure log_character_codes(
  p_text in varchar2,
  p_scope in logger_logs.scope%type default null,
  p_show_common_codes in boolean default true,
  p_level in logger_logs.logger_level%type default null)
```

### Parameters
Name | Description
--- | ---
`p_text` | Text to retrieve character codes for.
`p_scope` | <code>scope</code> to log text under.
`p_show_common_codes` | Provides legend of common character codes in output.
`p_level` | Highest level to run at (default <code>logger.g_debug</code>).  Example: If set to <code>logger.g_error</code> it will work when both in <code>debug</code> and <code>error</code> modes. However if set to <code>logger.g_debug</code>(default) will not store values when <code>level</code> is set to <code>error</code>.
 
 





 
## LOG_APEX_ITEMS Procedure<a name="log_apex_items"></a>


<p>
<p>Logs APEX items<br />This feature is useful in debugging issues in an APEX application that are related session state.<br />The <code>developers toolbar</code> in APEX provides a place to view session state, but it won&#39;t tell you the value of items midway through page rendering or right before or after an AJAX call.</p>
</p>

### Syntax
```plsql
procedure log_apex_items(
  p_text in varchar2 default 'Log APEX Items. Query logger_logs_apex_items and filter on log_id',
  p_scope in logger_logs.scope%type default null,
  p_item_type in varchar2 default logger.g_apex_item_type_all,
  p_log_null_items in boolean default true,
  p_level in logger_logs.logger_level%type default null)
```

### Parameters
Name | Description
--- | ---
`p_text` | Text to be added to <code>text</code> column.
`p_scope` | Scope to use
`p_item_type` | Determines what type of APEX items are logged (<code>g_apex_item_type_...</code> &gt; all, application, page). Alternatively it can reference a page_id which will then only log items on the defined page.
`p_log_null_items` | If set to <code>false</code>, null values won&#39;t be logged
`p_level` | Highest level to run at (default <code>logger.g_debug</code>).  Example: If set to <code>logger.g_error</code> it will work when both in <code>debug</code> and <code>error</code> modes. However if set to <code>logger.g_debug</code>(default) will not store values when <code>level</code> is set to <code>error</code>.
 
 


### Example
```plsql

-- Include in your APEX code
begin
  logger.log_apex_items('Debug Edit Customer');
end;


-- To see the logged values
select id,logger_level,text,module,action,client_identifier
from logger_logs
where logger_level = 128;

 ID     LOGGER_LEVEL TEXT                 MODULE                 ACTION    CLIENT_IDENTIFIER
------- ------------ -------------------- ---------------------- --------- --------------------
     47          128 Debug Edit Customer  APEX:APPLICATION 100   PAGE 7    ADMIN:45588554040361

select *
from logger_logs_apex_items
where log_id = 47; --log_id relates to logger_logs.id

ID      LOG_ID  APP_SESSION    ITEM_NAME                 ITEM_VALUE
------- ------- ---------------- ------------------------- ---------------------------------------------
    136      47   45588554040361 P1_QUOTA
    137      47   45588554040361 P1_TOTAL_SALES
    138      47   45588554040361 P6_PRODUCT_NAME           3.2 GHz Desktop PC
    139      47   45588554040361 P6_PRODUCT_DESCRIPTION    All the options, this machine is loaded!
    140      47   45588554040361 P6_CATEGORY               Computer
    ...
```



 
## TOCHAR Function<a name="tochar"></a>


<p>
<p><code>tochar</code> will convert the value to a string (<code>varchar2</code>). It is useful when logging items such as booleans without having to explicitly convert them.</p><p>Note: <code>tochar</code> does not use the <code>no_op</code> conditional compilation so it will always execute. This means that you can use outside of Logger (i.e. within your own application business logic).<br />Note: Need to call this tochar instead of to_char since there will be a conflict when calling it</p>
</p>

### Syntax
```plsql
function tochar(
  p_val in number)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_value` | Value (in original data type)
*return* | varchar2 String for p_value
 
 


### Example
```plsql

select logger.tochar(sysdate)
from dual;

LOGGER.TOCHAR(SYSDATE)
-----------------------
13-JUN-2014 21:20:34


-- In PL/SQL highlighting conversion from boolean to varchar2
SQL> exec dbms_output.put_line(logger.tochar(true));
TRUE

PL/SQL procedure successfully completed.
```



 
## TOCHAR-1 Function<a name="tochar-1"></a>


<p>
<p>See <a href="#tochar"><code>tochar (p_val number)</code></a></p>
</p>

### Syntax
```plsql
function tochar(
  p_val in date)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_val` | Date
*return* | String for p_val (format &#x60;DD-MON-YYYY HH24:MI:SS&#x60;)
 
 





 
## TOCHAR-2 Function<a name="tochar-2"></a>


<p>
<p>See <a href="#tochar"><code>tochar (p_val number)</code></a></p>
</p>

### Syntax
```plsql
function tochar(
  p_val in timestamp)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_val` | Timestamp
*return* | String for p_val (format &#x60;DD-MON-YYYY HH24:MI:SS:FF&#x60;)
 
 





 
## TOCHAR-3 Function<a name="tochar-3"></a>


<p>
<p>See <a href="#tochar"><code>tochar (p_val number)</code></a></p>
</p>

### Syntax
```plsql
function tochar(
  p_val in timestamp with time zone)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_val` | Timestamp with time zone
*return* | String for p_val (format &#x60;DD-MON-YYYY HH24:MI:SS:FF TZR&#x60;)
 
 





 
## TOCHAR-4 Function<a name="tochar-4"></a>


<p>
<p>See <a href="#tochar"><code>tochar (p_val number)</code></a></p>
</p>

### Syntax
```plsql
function tochar(
  p_val in timestamp with local time zone)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_val` | Timestamp with local time zone
*return* | String for p_val (format &#x60;DD-MON-YYYY HH24:MI:SS:FF TZR&#x60;)
 
 





 
## TOCHAR-5 Function<a name="tochar-5"></a>


<p>
<p>See <a href="#tochar"><code>tochar (p_val number)</code></a></p>
</p>

### Syntax
```plsql
function tochar(
  p_val in boolean)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_val` | Boolean
*return* | String for p_val (&#x60;TRUE&#x60; or &#x60;FALSE&#x60;)
 
 





 
## SPRINTF Function<a name="sprintf"></a>


<p>
<p><code>sprintf</code> is similar to the common procedure <code>printf</code> found in many programming languages. It replaces substitution strings for a given string. Substitution strings can be either <code>%s</code> or <code>%s&lt;n&gt;</code> where <code>&lt;n&gt;</code> is a number 1~10.</p><p>The following rules are used to handle substitution strings (in order):</p><ul>
<li>Replaces <code>%s&lt;n&gt;</code> with <code>p_s&lt;n&gt;</code>, regardless of order that they appear in <code>p_str</code></li>
<li>Occurrences of <code>%s</code> (no number) are replaced with <code>p_s1..p_s10</code> in order that they appear in <code>p_str</code></li>
<li><code>%%</code> is escaped to <code>%</code></li>
</ul>
<p>Note: <code>sprintf</code> does not use the <code>no_op</code> conditional compilation so it will always execute. This means that you can use outside of Logger (i.e. within your own application business logic).</p>
</p>

### Syntax
```plsql
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
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_str` | String to apply substitution strings to
`p_s1` | Substitution strings (same for <code>2-10</code>)
`p_s2` | 
`p_s3` | 
`p_s4` | 
`p_s5` | 
`p_s6` | 
`p_s7` | 
`p_s8` | 
`p_s9` | 
`p_s10` | 
*return* | p_msg with strings replaced
 
 


### Example
```plsql

select logger.sprintf('hello %s, how are you %s', 'martin', 'today') msg
from dual;

MSG
-------------------------------
hello martin, how are you today   

-- Advance features

-- Escaping %
select logger.sprintf('hello, %% (escape) %s1', 'martin') msg
from dual;

MSG
-------------------------
hello, % (escape) martin

-- %s<n> replacement
select logger.sprintf('%s1, %s2, %s', 'one', 'two') msg
from dual;

MSG
-------------------------
one, two, one
```



 
## GET_CGI_ENV Function<a name="get_cgi_env"></a>


<p>
<p>Get list of CGI values as name/value padded string</p>
</p>

### Syntax
```plsql
function get_cgi_env(
  p_show_null in boolean default false)
  return clob
```

### Parameters
Name | Description
--- | ---
`p_show_null` | If true will show CGI values even if they&#39;re null
*return* | CGI values (clob)
 
 





 
## GET_PREF Function<a name="get_pref"></a>


<p>
<p>Returns the preference from <code>logger_prefs</code>. If p_pref_type is not defined then the system level preferences will be returned.</p><p>Returns Global or User preference depending on current <code>client_identifier</code> (user preferences take precedence over global preferences)<br />User preference is only valid for <code>level</code> and <code>include_call_stack</code></p><ul>
<li>If a user setting exists, it will be returned, if not the system level preference will be return</li>
</ul>
<p>Updates</p><ul>
<li>2.0.0: Added user preference support</li>
<li>2.1.2: Fixed issue when calling set_level with the same client_id multiple times</li>
</ul>

</p>

### Syntax
```plsql
function get_pref(
  p_pref_name in logger_prefs.pref_name%type,
  p_pref_type in logger_prefs.pref_type%type default logger.g_pref_type_logger)
  return varchar2
  $if not dbms_db_version.ver_le_10_2  $then
    result_cache
    $if $$no_op
```

### Parameters
Name | Description
--- | ---
`p_pref_name` | Preference to get value for
`p_pref_type` | Namespace for preference
*return* | Prefence value
 
 


### Example
```plsql

dbms_output.put_line('Logger level: ' || logger.get_pref('LEVEL'));
```



 
## SET_PREF Procedure<a name="set_pref"></a>


<p>
<p>Sets a preference both custom and application (<code>LOGGER</code>) based preferences.</p><p>For application sttings use `p_pref_type =&gt; &#39;LOGGER&#39;.</p><p>In some cases you may want to store custom preferences in the <code>logger_prefs</code> table. A use case for this would be when creating a plugin that needs to reference some parameters.</p><p>This procedure allows you to leverage the <code>logger_prefs</code> table to store your custom preferences. To avoid any naming conflicts with Logger, you must use a type (defined in <code>p_pref_type</code>). You can not use the type <code>LOGGER</code> as it is reserved for Logger system preferences.</p><p><code>set_pref</code> will either create or udpate a value. Values must contain data. If not, use DEL_PREF to delete unused preferences.</p>
</p>

### Syntax
```plsql
procedure set_pref(
  p_pref_type in logger_prefs.pref_type%type,
  p_pref_name in logger_prefs.pref_name%type,
  p_pref_value in logger_prefs.pref_value%type)
```

### Parameters
Name | Description
--- | ---
`p_pref_type` | Type of preference. Use your own name space to avoid conflicts with Logger. Types will automatically be converted to uppercase
`p_pref_name` | Preference to get value for. Must be prefixed with <code>CUST_</code>. Value will be created or updated. <code>pref_name</code> will be stored as uppercase.
`p_pref_value` | Prefence value
 
 


### Example
```plsql

exec logger.set_pref(
  p_pref_type => 'CUSTOM',
  p_pref_name => 'MY_PREF',
  p_pref_value => 'some value');
```



 
## DEL_PREF Procedure<a name="del_pref"></a>


<p>
<p>Removes a Preference </p><p>Notes: Does not support removing system preferences</p>
</p>

### Syntax
```plsql
procedure del_pref(
  p_pref_type in logger_prefs.pref_type%type,
  p_pref_name in logger_prefs.pref_name%type)
```

### Parameters
Name | Description
--- | ---
`p_pref_type` | Namepsace / type of preference.
`p_pref_name` | Custom preference to delete.
 
 


### Example
```plsql

exec logger.del_pref(
  p_pref_type => 'CUSTOM'
  p_pref_name => 'MY_PREF');
```



 
## PURGE Procedure<a name="purge"></a>


<p>
<p>Purges logger_logs data except based on <code>p_purge_min_level</code></p>
</p>

### Syntax
```plsql
procedure purge(
  p_purge_after_days in number default null,
  p_purge_min_level in number)
```

### Parameters
Name | Description
--- | ---
`p_purge_after_days` | Purge entries older than <code>n</code> days. If <code>null</code> preference <code>gc_pref_purge_after_days</code> will be used
`p_purge_min_level` | Minimum level to purge entries. For example if set to <code>logger.g_information</code> then <code>information</code>, <code>debug</code>, <code>timing</code>, <code>sys_context</code>, and <code>apex</code> logs will be deleted.
 
 





 
## PURGE-1 Procedure<a name="purge-1"></a>


<p>
<p>Wrapper for <code>purge</code> (to accept number for purge_min_level)</p>
</p>

### Syntax
```plsql
procedure purge(
  p_purge_after_days in varchar2 default null,
  p_purge_min_level in varchar2 default null)
```

### Parameters
Name | Description
--- | ---
`p_purge_after_days` | 
`p_purge_min_level` | 
 
 





 
## PURGE_ALL Procedure<a name="purge_all"></a>


<p>
<p>Purges all records that aren&#39;t marked as <code>permanent</code></p>
</p>

### Syntax
```plsql
procedure purge_all
```

 


### Example
```plsql

exec logger.purge_all;
```



 
## STATUS Procedure<a name="status"></a>


<p>
<p>Displays Logger&#39;s current status and configuration settings<br />If run in SQLPlus <code>dbms_output</code> will be used.<br />If run in a web session (ex: APEX) <code>htp.p</code> will be used</p>
</p>

### Syntax
```plsql
procedure status(
  p_output_format in varchar2 default null) -- SQL-DEVELOPER | HTML | DBMS_OUPUT
```

### Parameters
Name | Description
--- | ---
`p_output_format` | <code>SQL-DEVELOPER</code>, <code>HTML</code>, or <code>DBMS_OUPUT</code>
 
 


### Example
```plsql

set serveroutput on
exec logger.status

Project Home Page    : https://github.com/oraopensource/logger/
Logger Version       : 2.0.0.a01
Debug Level          : DEBUG
Capture Call Stack     : TRUE
Protect Admin Procedures : TRUE
APEX Tracing       : Disabled
SCN Capture        : Disabled
Min. Purge Level     : DEBUG
Purge Older Than     : 7 days
Pref by client_id expire : 12 hours
For all client info see  : logger_prefs_by_client_id

PL/SQL procedure successfully completed.
```



 
## CONVERT_LEVEL_CHAR_TO_NUM Function<a name="convert_level_char_to_num"></a>


<p>
<p>Converts string names to text value</p><p>Changes</p><ul>
<li>2.1.0: Start to use global variables and correct numbers</li>
</ul>

</p>

### Syntax
```plsql
function convert_level_char_to_num(
  p_level in varchar2) 
  return number
```

### Parameters
Name | Description
--- | ---
`p_level` | String representation of level
*return* | Returns the number representing the given level (string). &#x60;-1&#x60; if not found
 
 





 
## DATE_TEXT_FORMAT Function<a name="date_text_format"></a>


<p>
<p>Returns the time difference (in nicely formatted string) of p_date compared to now (sysdate).</p>
</p>

### Syntax
```plsql
function date_text_format (p_date in date)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_date` | 
*return* | formatting string
 
 





 
## GET_CHARACTER_CODES Function<a name="get_character_codes"></a>


<p>
<p>Debugging issues with a string that contains control characters such as carriage returns, line feeds and tabs that can be very difficult.<br />The sql <code>dump()</code> function is great for this, but the output is a bit hard to read as it outputs the character codes for each character.<br />You end up comparing the character code to an ascii table to figure out what it is. </p><p>This function and the procedure <code>log_character_codes</code> makes it easier as it lines up the characters in the original string under the corresponding character codes from dump.<br />Additionally, all tabs are replaced with <code>^</code> and all other control characters such as <code>carriage returns</code> and <code>line feeds</code> are replaced with <code>~</code>. </p>
</p>

### Syntax
```plsql
function get_character_codes(
  p_string in varchar2,
  p_show_common_codes in boolean default true)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_string` | String to retrieve character codes for.
`p_show_common_codes` | Display legend of common character codes.
*return* | String with character codes.
 
 


### Example
```plsql

select logger.get_character_codes('Hello World'||chr(9)||'Foo'||chr(13)||chr(10)||'Bar') char_codes
from dual;

CHAR_CODES
----------------------------------------------------------------------------------
Common Codes: 13=Line Feed, 10=Carriage Return, 32=Space, 9=Tab
  72,101,108,108,111, 32, 87,111,114,108,100,  9, 70,111,111, 13, 10, 66, 97,114
   H,  e,  l,  l,  o,   ,  W,  o,  r,  l,  d,  ^,  F,  o,  o,  ~,  ~,  B,  a,  r
```



 
## APPEND_PARAM Procedure<a name="append_param"></a>


<p>
<p>Logger has wrapper functions to quickly and easily log parameters. All primary <code>log</code> procedures take in a fourth parameter (<code>p_params</code>) to support logging a parameter array. The values are explicitly converted to strings so you don&#39;t need to convert them. The parameter values will be stored in the extra column.</p><p>Note: Append parameter to table of parameters<br />Note: Nothing is actually logged in this procedure</p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in varchar2
)
```

### Parameters
Name | Description
--- | ---
`p_params` | Table of parameters (param will be appended to this)
`p_name` | Name of the parameter
`p_val` | Value (in original data type / will be converted to string).
 
 


### Example
```plsql

create or replace procedure p_demo_function(
  p_empno in emp.empno%type,
  p_ename in emp.ename%type)
as
  l_scope logger_logs.scope%type := 'p_demo_function';
  l_params logger.tab_param;
begin
  logger.append_param(l_params, 'p_empno', p_empno); -- Parameter name and value just stored in PL/SQL array and not logged yet
  logger.append_param(l_params, 'p_ename', p_ename); -- Parameter name and value just stored in PL/SQL array and not logged yet
  logger.log('START', l_scope, null, l_params); -- All parameters are logged at this point  
  -- ...
exception
  when others then
    logger.log_error('Unhandled Exception', l_scope, null, l_params);
end p_demo_function;
/
```



 
## APPEND_PARAM-1 Procedure<a name="append_param-1"></a>


<p>
<p>See <a href="#append_param"><code>append_param (varchar2)</code></a></p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in number)
```

### Parameters
Name | Description
--- | ---
`p_params` | 
`p_name` | 
`p_val` | 
 
 





 
## APPEND_PARAM-2 Procedure<a name="append_param-2"></a>


<p>
<p>See <a href="#append_param"><code>append_param (varchar2)</code></a></p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in date)
```

### Parameters
Name | Description
--- | ---
`p_params` | 
`p_name` | 
`p_val` | 
 
 





 
## APPEND_PARAM-3 Procedure<a name="append_param-3"></a>


<p>
<p>See <a href="#append_param"><code>append_param (varchar2)</code></a></p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in timestamp)
```

### Parameters
Name | Description
--- | ---
`p_params` | 
`p_name` | 
`p_val` | 
 
 





 
## APPEND_PARAM-4 Procedure<a name="append_param-4"></a>


<p>
<p>See <a href="#append_param"><code>append_param (varchar2)</code></a></p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in timestamp with time zone)
```

### Parameters
Name | Description
--- | ---
`p_params` | 
`p_name` | 
`p_val` | 
 
 





 
## APPEND_PARAM-5 Procedure<a name="append_param-5"></a>


<p>
<p>See <a href="#append_param"><code>append_param (varchar2)</code></a></p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in timestamp with local time zone)
```

### Parameters
Name | Description
--- | ---
`p_params` | 
`p_name` | 
`p_val` | 
 
 





 
## APPEND_PARAM-6 Procedure<a name="append_param-6"></a>


<p>
<p>See <a href="#append_param"><code>append_param (varchar2)</code></a></p>
</p>

### Syntax
```plsql
procedure append_param(
  p_params in out nocopy logger.tab_param,
  p_name in varchar2,
  p_val in boolean)
```

### Parameters
Name | Description
--- | ---
`p_params` | 
`p_name` | 
`p_val` | 
 
 





 
## OK_TO_LOG Function<a name="ok_to_log"></a>


<p>
<p>Determines if the statement can be stored in LOGGER_LOGS</p><p>Though Logger internally handles when a statement is stored in the <code>logger_logs</code> table there may be situations where you need to know if <code>logger</code> will log a statement before calling <code>logger</code>. This is useful when doing an expensive operation just to log the data.</p><p>A classic example is looping over an array for the sole purpose of logging the data. In this case, there&#39;s no reason why the code should perform the additional computations when logging is disabled for a certain level.</p><p><code>ok_to_log</code> will also factor in client specific logging settings.</p><p>Note: <code>ok_to_log</code> is not something that should be used frequently as all calls to <code>logger</code> run this command internally.<br />Note: <code>ok_to_log</code> should not be used for one-off log commands. This defeats the whole purpose of having the various log commands. For example ok_to_log should not be used in the following way:</p>
</p>

### Syntax
```plsql
function ok_to_log(p_level in number)
  return boolean
  $if 1=1
    and $$rac_lt_11_2
    and not dbms_db_version.ver_le_10_2
    and ($$no_op
```

### Parameters
Name | Description
--- | ---
`p_level` | Level (number)
*return* | True of statement can be logged to LOGGER_LOGS
 
 


### Example
```plsql
declare
  type typ_array is table of number index by pls_integer;
  l_array typ_array;
begin
  -- Load test data
  for x in 1..100 loop
    l_array(x) := x;
  end loop;

  -- Only log if logging is enabled
  if logger.ok_to_log(logger.g_debug) then
    for x in 1..l_array.count loop
      logger.log(l_array(x));
    end loop;
  end if;
 end;
 /

-- ok_to_log should not be used for one-off log commands. 
-- This defeats the whole purpose of having the various log commands. 
-- For example ok_to_log should NOT be used in the following way:
...
if logger.ok_to_log(logger.g_debug) then
 logger.log('test');
end if;
...
```



 
## OK_TO_LOG-1 Function<a name="ok_to_log-1"></a>


<p>
<p>See previous <code>ok_to_log</code> example</p>
</p>

### Syntax
```plsql
function ok_to_log(p_level in varchar2)
  return boolean
```

### Parameters
Name | Description
--- | ---
`p_level` | Level (Name)
*return* | True of log statements for that level or below will be logged
 
 





 
## INS_LOGGER_LOGS Procedure<a name="ins_logger_logs"></a>


<p>
<p>Similar to <code>ok_to_log</code>, this procedure should be used very infrequently as the main Logger procedures should handle everything that is required for quickly logging information.</p><p>As part of the <code>2.1.0</code> release, the trigger on <code>logger_logs</code> was removed for both performance and other issues. Though inserting directly to the <code>logger_logs</code> table is not a supported feature of Logger, you may have some code that does a direct insert. The primary reason that a manual insert into <code>logger_logs</code> was done was to obtain the <code>id</code> column for the log entry.</p><p>To help prevent any issues with backwards compatibility, <code>ins_logger_logs</code> has been made publicly accessible to handle any inserts into <code>logger_logs</code>. This is a supported procedure and any manual insert statements will need to be modified to use this procedure instead.</p><p>In most situations you should <strong>not</strong> be calling this procedure and use the <code>logger.log</code> procedures instead</p><p>Important things to know about <code>ins_logger_logs</code>:</p><ul>
<li>It does not check the Logger <code>level</code>. This means it will always insert into <code>logger_logs</code>. It is also an <code>autonomous transaction</code> procedure so a commit is always performed, however it will not affect the current session.</li>
<li>Plugins will not be executed when calling this procedure. If you have critical processes which leverage plugin support you should use the proper <code>log</code> function instead.</li>
</ul>

</p>

### Syntax
```plsql
procedure ins_logger_logs(
  p_logger_level in logger_logs.logger_level%type,
  p_text in varchar2 default null, -- Not using type since want to be able to pass in 32767 characters
  p_scope in logger_logs.scope%type default null,
  p_call_stack in logger_logs.call_stack%type default null,
  p_unit_name in logger_logs.unit_name%type default null,
  p_line_no in logger_logs.line_no%type default null,
  p_extra in logger_logs.extra%type default null,
  po_id out nocopy logger_logs.id%type
  )
```

### Parameters
Name | Description
--- | ---
`p_logger_level` | Logger level. See Constants section for list of variables to chose from.
`p_text` | 
`p_scope` | 
`p_call_stack` | PL/SQL call stack
`p_unit_name` | Unit name (this is usually the calling procedure)
`p_line_no` | Line number
`p_extra` | <code>clob</code>
`po_id` | <code>id</code> entered into <code>logger_logs</code> for this record
 
 


### Example
```plsql

set serveroutput on

declare
  l_id logger_logs.id%type;
begin
  -- Note: Commented out parameters not used for this demo (but still accessible via API)
  logger.ins_logger_logs(
    p_logger_level => logger.g_debug,
    p_text => 'Custom Insert',
    p_scope => 'demo.logger.custom_insert',
--    p_call_stack => ''
    p_unit_name => 'Dynamic PL/SQL',
--    p_line_no => ,
--    p_extra => ,
    po_id => l_id
  );

  dbms_output.put_line('ID: ' || l_id);
end;
/

ID: 2930650
```



 
## SET_LEVEL Procedure<a name="set_level"></a>


<p>
<p>Sets the logger level (for bboth system and client logging levels.)</p><p>Logger allows you to configure both system logging levels and client specific logging levels. If a client specific logging level is defined, it will override the system level configuration. If no client level is defined Logger will defautl to the system level configuration.</p><p>Prior to version 2.0.0 Logger only supported a &quot;global&quot; logger level. The primary goal of this approach was to enable Logger at <code>debug</code> level for development environments, then change it to <code>error</code> level in production environments so the logs did not slow down the system. Over time developers start to find that in some situations they needed to see what a particular user / session was doing in production. Their only option was to enable Logger for the entire system which could potentially slow everyone down.</p><p>Starting in version 2.0.0 you can now specify the logger level (along with call stack setting) by specifying the <code>client_identifier</code>. If not explicitly unset, client specific configurations will expire after a set period of time.</p><p>The following query shows all the current client specific log configurations:</p><pre><code class="lang-sql">select *
from logger_prefs_by_client_id;

CLIENT_ID           LOGGER_LEVEL  INCLUDE_CALL_STACK CREATED_DATE         EXPIRY_DATE
------------------- ------------- ------------------ -------------------- --------------------
logger_demo_session ERROR         TRUE               24-APR-2013 02:48:13 24-APR-2013 14:48:13
</code></pre>

</p>

### Syntax
```plsql
procedure set_level(
  p_level in varchar2 default logger.g_debug_name,
  p_client_id in varchar2 default null,
  p_include_call_stack in varchar2 default null,
  p_client_id_expire_hours in number default null
)
```

### Parameters
Name | Description
--- | ---
`p_level` | Use <code>logger.g_&lt;level&gt;_name</code> constants. If the level is deprecated it will automatically be set to <code>debug</code>.
`p_client_id` | Optional: If defined, will set the level for the given client identifier. If <code>null</code> will set global settings.  In APEX the <code>client_identifier</code> is <code>:APP_USER || &#39;:&#39; || :APP_SESSION</code>
`p_include_call_stack` | Optional: Only valid if <code>p_client_id</code> is defined. Valid values: <code>TRUE</code>, <code>FALSE</code>. If not set will use the default system pref in <code>logger_prefs</code>.
`p_client_id_expire_hours` | Optiona: If <code>p_client_id</code> is defined , expire after number of hours. If not defined, will default to system preference <code>PREF_BY_CLIENT_ID_EXPIRE_HOURS</code>
 
 


### Example
```plsql

-- Set system level logging level:
exec logger.set_level(logger.g_debug_name);

-- Client Specific Configuration:
-- In Oracle Session-1
exec logger.set_level(logger.g_debug_name);

exec logger.log('Session-1: this should show up');

select id, logger_level, text, client_identifier, call_stack
from logger_logs_5_min
order by id;

  ID LOGGER_LEVEL TEXT                      CLIENT_IDENTIFIER CALL_STACK
---- ------------ ----------------------------------- ----------------- ----------------------------
  31         16 Session-1: this should show up              object      line  object

exec logger.set_level (logger.g_error_name);

exec logger.log('Session-1: this should NOT show up');

-- The previous line does not get logged since the logger level is set to ERROR and it made a .log call


-- In Oracle Session-2 (i.e. a different session)
exec dbms_session.set_identifier('my_identifier');

-- This sets the logger level for current identifier
exec logger.set_level(logger.g_debug_name, sys_context('userenv','client_identifier'));

exec logger.log('Session-2: this should show up');

select id, logger_level, text, client_identifier, call_stack
from logger_logs_5_min
order by id;

  ID LOGGER_LEVEL TEXT                      CLIENT_IDENTIFIER CALL_STACK
---- ------------ ----------------------------------- ----------------- ----------------------------
  31         16 Session-1: this should show up                  object      line  object
  32         16 Session-2: this should show up    my_identifier   object      line  object

-- Notice how the CLIENT_IDENTIFIER field also contains the current client_identifer
-- In APEX the client_identifier is
:APP_USER || ':' || :APP_SESSION
```



 
## UNSET_CLIENT_LEVEL Procedure<a name="unset_client_level"></a>


<p>
<p>Unsets a logger level for a given <code>p_client_id</code><br />This will only unset for client specific logger levels</p>
</p>

### Syntax
```plsql
procedure unset_client_level(p_client_id in varchar2)
```

### Parameters
Name | Description
--- | ---
`p_client_id` | Client identifier (case sensitive) to unset logging level
 
 


### Example
```plsql

exec logger.unset_client_level('my_client_id');
```



 
## UNSET_CLIENT_LEVEL-1 Procedure<a name="unset_client_level-1"></a>


<p>
<p>Unsets client_level that are stale (i.e. past thier expiry date)</p><p>Note: this run automatically each hour by the <code>logger_unset_prefs_by_client</code> job</p>
</p>

### Syntax
```plsql
procedure unset_client_level
```

### Parameters
Name | Description
--- | ---
`p_unset_after_hours` | If null then preference UNSET_CLIENT_ID_LEVEL_AFTER_HOURS
 
 


### Example
```plsql

exec logger.unset_client_level;
```



 
## UNSET_CLIENT_LEVEL_ALL Procedure<a name="unset_client_level_all"></a>


<p>
<p>Unsets all client specific preferences (regardless of expiry time)<br />Note: An implicit commit (<code>pragma autonomous_transaction</code>) will occur as <code>unset_client_level</code> makes a commit</p>
</p>

### Syntax
```plsql
procedure unset_client_level_all
```

 


### Example
```plsql

exec logger.unset_client_level_all;
```



 
## TIME_START Procedure<a name="time_start"></a>


<p>
<p>Since all the timing procedures are tightly coupled, the following example will be used to cover all of them:</p>
</p>

### Syntax
```plsql
procedure time_start(
  p_unit in varchar2,
  p_log_in_table in boolean default true)
```

### Parameters
Name | Description
--- | ---
`p_unit` | Unique &quot;code&quot; to identify timer. Allows for nesting (see example)
`p_log_in_table` | If true will log timer in <code>logger_logs</code>
 
 


### Example
```plsql

declare
    l_number number;
begin
    logger.time_reset;
    logger.time_start('foo');
    logger.time_start('bar');
    for i in 1..500000 loop
        l_number := power(i,15);
        l_number := sqrt(1333);
    end loop; --i
    logger.time_stop('bar');
    for i in 1..500000 loop
        l_number := power(i,15);
        l_number := sqrt(1333);
    end loop; --i
    logger.time_stop('foo');
end;
/

select text from logger_logs_5_min;

TEXT
---------------------------------
START: foo
>  START: bar
>  STOP : bar - 1.000843 seconds
STOP : foo - 2.015953 seconds
```



 
## TIME_STOP Procedure<a name="time_stop"></a>


<p>
<p>Stops a timing event and logs in <code>logger_logs</code> using <code>level = logger.g_timing</code>.</p><p>See <a href="#time_start"><code>time_start</code></a> for example</p>
</p>

### Syntax
```plsql
procedure time_stop(
  p_unit in varchar2,
  p_scope in varchar2 default null)
```

### Parameters
Name | Description
--- | ---
`p_unit` | Timer to stop
`p_scope` | <code>scope</code> to store in <code>logger_logs</code>
 
 





 
## TIME_STOP-1 Function<a name="time_stop-1"></a>


<p>
<p>Similar to <a href="#time_stop"><code>time_stop</code></a> (above). This function will stop a timer.<br />Logging into <code>logger_logs</code> is configurable via <code>p_log_in_table</code>.<br />Returns the stop time string.</p><p>See <code>time_start</code> for example</p>
</p>

### Syntax
```plsql
function time_stop(
  p_unit in varchar2,
  p_scope in varchar2 default null,
  p_log_in_table IN boolean default true)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_unit` | Timer to stop.
`p_scope` | <code>scope</code> to log timer under.
`p_log_in_table` | Store result in <code>logger_logs</code>
*return* | Timer results
 
 





 
## TIME_STOP_SECONDS Function<a name="time_stop_seconds"></a>


<p>
<p>See <a href="#time_stop"><code>time_stop</code></a>.<br />Only difference is that time is logged in seconds</p>
</p>

### Syntax
```plsql
function time_stop_seconds(
  p_unit in varchar2,
  p_scope in varchar2 default null,
  p_log_in_table in boolean default true
  )
  return number
```

### Parameters
Name | Description
--- | ---
`p_unit` | 
`p_scope` | 
`p_log_in_table` | 
*return* | Timer in seconds
 
 





 
## TIME_RESET Procedure<a name="time_reset"></a>


<p>
<p>Resets all timers</p><p>See <a href="#time_start"><code>time_start</code></a> for example</p>
</p>

### Syntax
```plsql
procedure time_reset
```

 





 
## CONVERT_LEVEL_NUM_TO_CHAR Function<a name="convert_level_num_to_char"></a>


<p>
<p>Converts the logger level num to char format</p>
</p>

### Syntax
```plsql
function convert_level_num_to_char(
  p_level in number)
  return varchar2
```

### Parameters
Name | Description
--- | ---
`p_level` | 
*return* | Logger level string format. &#x60;null&#x60; if &#x60;p_level&#x60; not found
 
 





 

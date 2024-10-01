/*
This plugin logs all logger errors to a remote syslog server.

Neil Barsema 2015

neil@barsema.og

There are three preferences that can be set:

PLUGIN_SYSLOG_HOST     : The hostname of the syslog server (default localhost)
PLUGIN_SYSLOG_PORT     : The portnumber of the syslog deamon (default 514)
PLUGIN_SYSLOG_FACILITY : The facility under witch the item should be logged. (default 3 deamon, see Syslog documentation for more info)

This script should be run as sys

 */

-- install syslog plugin
begin
execute immediate 'alter session set current_schema =  '||logger.get_pref('INSTALL_SCHEMA');
end;
/
-- java class to send udp packets PL/SQL does not support UDP natively

create or replace and compile java source named log_java_syslog as

import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.net.InetAddress;

public class log_java_syslog {

/*
Syslog facilties and parameters
FACILITY = {
    'kern': 0, 'user': 1, 'mail': 2, 'daemon': 3,
    'auth': 4, 'syslog': 5, 'lpr': 6, 'news': 7,
    'uucp': 8, 'cron': 9, 'authpriv': 10, 'ftp': 11,
    'local0': 16, 'local1': 17, 'local2': 18, 'local3': 19,
    'local4': 20, 'local5': 21, 'local6': 22, 'local7': 23,
}

LEVEL = {
    'emerg': 0, 'alert':1, 'crit': 2, 'err': 3,
    'warning': 4, 'notice': 5, 'info': 6, 'debug': 7
}
   */

    public static void send (String host,int port, int facility, int level,String message)
        throws java.net.SocketException, java.io.IOException {

        int pri = level + facility*8;
        String data = String.format("<%d> %s",pri, message);
        DatagramSocket s = new DatagramSocket();
        DatagramPacket p = new DatagramPacket(new byte[data.length()], data.length(), InetAddress.getByName(host), port);

        p.setData(data.getBytes());
        s.send(p);

    }

};

/

-- create the pl/sql wrapper
create or replace
    procedure log_syslog( p_host in varchar2,
                      p_port in number,
                      p_facility number, 
                      p_level number, 
                      p_message varchar2)
    as language java
    name 'log_java_syslog.send( java.lang.String,int,int,int,java.lang.String )';
    /


-- the plugin
-- Some preferences


merge into logger_prefs p
using (
  select 'PLUGIN_SYSLOG_VERSION' pref_name, '1.0.0' pref_value from dual union -- will be replaced when running the build script
  select 'PLUGIN_SYSLOG_HOST' pref_name, 'localhost' pref_value from dual union
  select 'PLUGIN_SYSLOG_PORT' pref_name, '514' pref_value from dual union
  select 'PLUGIN_SYSLOG_FACILITY' pref_name, '3' pref_value from dual
  ) d
  on (p.pref_name = d.pref_name)
when matched then
  update set p.pref_value =
    case
      -- Only LOGGER_VERSION should be updated during an update
      when p.pref_name = 'PLUGIN_SYSLOG_VERSION' then d.pref_value
      else p.pref_value
    end
when not matched then
  insert (p.pref_name,p.pref_value)
  values (d.pref_name,d.pref_value);

-- the plugin procedure

create or replace procedure log_syslog_err_plugin(
p_rec in logger.rec_logger_log)
as
  l_logrec logger_logs%rowtype;

begin

   select
    *
  into
    l_logrec
  from
    logger_logs
  where
    id = p_rec.id; 
    
   log_syslog(logger.get_pref('PLUGIN_SYSLOG_HOST')
          ,logger.get_pref('PLUGIN_SYSLOG_PORT')
          ,logger.get_pref('PLUGIN_SYSLOG_FACILITY')
          ,3 -- err
          , l_logrec.id                ||'|'||
            l_logrec.logger_level      ||'|'||      
            l_logrec.text              ||'|'||        
            l_logrec.time_stamp        ||'|'||   
            l_logrec.scope             ||'|'||              
            l_logrec.module            ||'|'||             
            l_logrec.action            ||'|'||             
            l_logrec.user_name         ||'|'||              
            l_logrec.client_identifier ||'|'||          
            l_logrec.call_stack        ||'|'||        
            l_logrec.unit_name         ||'|'||           
            l_logrec.line_no           ||'|'||         
            l_logrec.scn               ||'|'||                 
            l_logrec.extra             ||'|'||                 
            l_logrec.sid               ||'|'||             
            l_logrec.client_info            );
end;
/  

-- socket permissions
exec dbms_java.grant_permission( logger.get_pref('INSTALL_SCHEMA'), 'SYS:java.net.SocketPermission', 'localhost:1024-', 'listen,resolve' );
exec dbms_java.grant_permission( logger.get_pref('INSTALL_SCHEMA'), 'SYS:java.net.SocketPermission', logger.get_pref('PLUGIN_SYSLOG_HOST')||':'||logger.get_pref('PLUGIN_SYSLOG_PORT'), 'connect,resolve' )



update logger_prefs
  set pref_value = 'LOG_SYSLOG_ERR_PLUGIN'
  where pref_name = 'PLUGIN_FN_ERROR';

-- Configure with Logger

exec logger_configure;

